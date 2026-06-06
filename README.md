# tinyland-goo

UV-reactive, strontium-aluminate-infused 3D-printer **bed glue** that is stronger
than [Frank's "Instagoo"](https://goo.by.frank.af/) — plus an off-the-shelf UV
**coverage sensor** and a **Klipper pre-print gate** that won't print on a
bare bed.

A static SvelteKit SPA (built from the Tinyland
[site.scaffold](https://github.com/tinyland-inc/site.scaffold)), published to
GitHub Pages at **https://jesssullivan.github.io/tinyland-goo/**. The page carries
an interactive, weight-based batch scaler; this README is the source-of-record for
hardware and citations.

## Quick start

```sh
just setup     # npm install
just dev       # dev server
just build     # static build into ./build  (BASE_PATH=/tinyland-goo)
just preview   # local root preview
```

`just` is the single entrypoint — see `just --list`.

## What's here

| Path | What |
| --- | --- |
| `src/routes/+page.svelte` | The article (recipe, BOM, gate, safety) |
| `src/lib/components/GlueScaler.svelte` | Weight-based batch scaler (by-weight, 0.01 g) |
| `klipper/coverage_gate.cfg` | `PRINT_START` + `_COVERAGE_GATE` macros |
| `klipper/coverage_gate.py` | Host script: AS7341 → Moonraker `SAVE_VARIABLE` |

## The recipe (4 oz)

By weight, for a 0.01 g scale. 1× ≈ 2 oz is the smallest worthwhile batch; **2× ≈ 4 oz
is the recommended minimum** (the scaler defaults to it).

| Ingredient | 4 oz (g) | Role |
| --- | ---: | --- |
| PVP-K90 | 8.00 | Film former — K90 (MW ~1.3M) beats Frank's K30 |
| PVA, 88% hydrolyzed | 2.40 | Toughness; pins a minimum water fraction |
| PEG-400 | 2.00 | Tackifier (highest-leverage bond knob) |
| 1% boric-acid stock | 1.70 | Trace PVA crosslink (~0.7% of PVA) |
| Coated SrAl₂O₄:Eu,Dy, 35–50 µm | 4.00 | UV coverage indicator (**waterproof grade required**) |
| Ethanol (≥95%) | 53.00 | Co-solvent; flashes off |
| Distilled water (free) | 41.72 | Dissolves PVA; carrier ≈ 55:45 EtOH:water |

**Stronger than Frank's** via three levers: PVP-**K90** (cohesion), **PEG-400** (tack),
a **trace boric-acid** crosslink (cohesion without killing release). Solids ≈ 14.6%,
PVP:PVA ≈ 77:23.

**Watch out:** bare strontium aluminate hydrolyzes in water and stops glowing — use a
silica/fluoride-**coated/encapsulated** grade. Don't go anhydrous (PVA needs water).

## How coverage sensing works

`SrAl₂O₄:Eu,Dy` excites at ~365 nm and emits green ~520 nm. Flood the bed with 365 nm
UV; glued area glows green, bare bed stays dark. The **AS7341** F4 (515 nm) / F5 (555 nm)
channels straddle the peak and its filters reject 365 nm, so a single-point read often
needs no separate filter. Baseline the bare bed once; coverage is the green rise above it.

## Safety

Flammable alcohol carrier · phosphor dust (N95/P2 + eye protection when weighing) ·
boric acid (reproductive hazard if ingested) · 365 nm UV-A eye/skin hazard (enclose;
pulse during read only).

## Sources

- Frank's Instagoo — https://goo.by.frank.af/
- Homebrew PVP/PVA "Super Goop" (DrGhetto / Hackaday) — https://hackaday.com/2022/12/06/homebrew-3d-printer-goop-promises-better-bed-adhesion/
- Vision Miner Nano (SDS: IPA carrier, trade-secret polymer) — https://visionminer.com/products/nano-polymer-adhesive
- Luke's Laboratory bed adhesive — https://www.lukeslabonline.com/products/bed-adhesive
- PVP K30 vs K90 — https://ulipolymer.com/difference-between-pvp-k30-and-pvp-k90/
- PVP/PEG pressure-sensitive tack (~36 wt% optimum) — https://www.tandfonline.com/doi/abs/10.1080/00218460213491
- Boric-acid crosslinking of PVA — https://iopscience.iop.org/article/10.1088/2631-8695/ad4cb4
- Strontium aluminate (excitation/emission, water degradation) — https://en.wikipedia.org/wiki/Strontium_aluminate
- Encapsulation for water resistance — https://www.sciencedirect.com/science/article/abs/pii/S0254058407003719
- Coated/waterproof powder suppliers — https://www.technoglowproducts.com/strontium-aluminate/ · https://www.gloeffex.com/collections/super-phosphorescent-glow-powder
- SrAl₂O₄ SDS (no GHS hazard) — https://ltschem.com/msds/SrAl2O4.pdf
- AS7341 spectral sensor — https://www.adafruit.com/product/4698
- OSRAM LZ1-00UV0R-0000 (365 nm) — https://www.mouser.com/ProductDetail/LED-Engin/LZ1-00UV0R-0000
- MEAN WELL LDD-700H driver — https://www.mouser.com/ProductDetail/MEAN-WELL/LDD-700H-WDA
- Thorlabs FGL495 longpass / FBH520-10 bandpass — https://www.thorlabs.com/
- Klipper Command Templates (`action_raise_error`, `save_variables`) — https://www.klipper3d.org/Command_Templates.html
- `gcode_shell_command` (KIAUH) — https://github.com/dw-0/kiauh/blob/master/docs/gcode_shell_command.md

## License

CC0-1.0. Experimental — validate the recipe and hardware yourself.
