#!/usr/bin/env python3
"""coverage_gate.py — read the UV coverage sensor and persist a verdict.

Runs on the Klipper/Moonraker host (Raspberry Pi). Reads the AMS AS7341
spectral sensor over I2C, computes a coverage percentage from the green
(~520 nm) photoluminescence of the strontium-aluminate glue under 365 nm UV,
and pushes the result back into Klipper via Moonraker's SAVE_VARIABLE so the
PRINT_START gate can read it.

Install on the Pi:
    pip3 install adafruit-circuitpython-as7341 adafruit-blinka
    sudo raspi-config   # enable I2C
Place at: /home/pi/printer_data/scripts/coverage_gate.py

Two-point calibration is mandatory: measure BARE (clean bed -> 0%) and GLUED
(fully glued bed -> 100%) under print-time lighting with the toolhead/LED
parked at a fixed position, then set the constants below.
"""
import sys
import time
import json
import urllib.request
import urllib.parse

MOONRAKER = "http://127.0.0.1:7125"

# --- calibration (REQUIRED — replace with your own measured values) ---------
BARE = 1200.0   # AS7341 clear-channel reading over clean bed
GLUED = 4800.0  # AS7341 clear-channel reading over fully glued bed


def save_var(name, value):
    """Push a value into Klipper's persisted store via the Moonraker gcode API."""
    script = f"SAVE_VARIABLE VARIABLE={name} VALUE={value}"
    url = f"{MOONRAKER}/printer/gcode/script?" + urllib.parse.urlencode({"script": script})
    urllib.request.urlopen(urllib.request.Request(url, method="POST"), timeout=5).read()


def read_coverage():
    """Read the AS7341 and map the green emission to a 0–100% coverage metric."""
    import board
    from adafruit_as7341 import AS7341

    i2c = board.I2C()  # board.SCL / board.SDA -> /dev/i2c-1
    sensor = AS7341(i2c)
    channels = sensor.all_channels  # (415,445,480,515,555,590,630,680 nm)
    clear = sensor.channel_clear
    nir = sensor.channel_nir

    raw = float(clear)
    pct = max(0.0, min(100.0, (raw - BARE) / (GLUED - BARE) * 100.0))
    return pct, list(channels), clear, nir


def main():
    min_cov = float(sys.argv[1]) if len(sys.argv) > 1 else 70.0
    try:
        pct, channels, clear, nir = read_coverage()
        save_var("coverage_pct", round(pct, 2))
        save_var("coverage_status", '"OK"')  # quotes -> stored as string
        save_var("coverage_ts", round(time.time(), 1))
        save_var("coverage_raw", f'"{json.dumps(channels)}"')
        print(f"coverage={pct:.1f}% threshold={min_cov:.1f}% clear={clear} nir={nir}")
        sys.exit(0 if pct >= min_cov else 2)
    except Exception as e:  # noqa: BLE001 — persist failure so the gate can distinguish it
        try:
            save_var("coverage_status", '"ERROR"')
            save_var("coverage_pct", -1)
        except Exception:
            pass
        print(f"coverage_gate ERROR: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
