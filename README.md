# tinyland-goo

Tinyland static lab notebook for UV-reactive 3D-printer **bed glue** and adjacent
paraffin **wax** experiments. The original page covers a stronger-than-Frank
[Instagoo](https://goo.by.frank.af/) recipe, an off-the-shelf UV **coverage sensor**,
and a **Klipper pre-print gate** that won't print on a bare bed. The new wax pages
cover bike chain wax additives / ultrasonic emulsions and hair-removal wax formulation.

A static SvelteKit SPA (built from the Tinyland
[site.scaffold](https://github.com/tinyland-inc/site.scaffold)), published to
GitHub Pages at **https://jesssullivan.github.io/tinyland-goo/**. The pages carry
interactive, weight-based batch scalers; this README is the source-of-record for
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
| `src/routes/+page.svelte` | UV bed-glue article (recipe, BOM, gate, safety) |
| `src/routes/chain-wax/+page.svelte` | Bike chain wax additive + ultrasonic emulsion research |
| `src/routes/hair-removal-wax/+page.svelte` | Depilatory wax formulation research |
| `src/lib/components/GlueScaler.svelte` | Weight-based batch scaler (by-weight, 0.01 g) |
| `src/lib/components/GlueScalerPinch.svelte` | Simplified on-hand bed-glue derivation |
| `src/lib/components/ChainWaxHotMeltScaler.svelte` | Hot-melt chain wax screening scaler |
| `src/lib/components/ChainWaxEmulsionScaler.svelte` | Ultrasonic chain wax emulsion scaler |
| `src/lib/components/DepilatoryHardWaxScaler.svelte` | Hard/no-strip hair-removal wax scaler |
| `src/lib/components/DepilatoryStripWaxScaler.svelte` | Strip hair-removal wax scaler |
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

## In a pinch (on-hand chemicals, 1 oz)

A simpler derivation for an automated applicator on **less mission-critical** printers,
from common stock only — no K90, no boric acid, no coated phosphor. Still beats Frank's
via the PEG/PEO tack lever + slightly higher solids. Scales 1/2/4 oz.

| Ingredient | 1 oz (g) | Role |
| --- | ---: | --- |
| PVP-40 (K-30 class) | 2.80 | Backbone (same PVP grade as Frank's) |
| PVA lab powder | 1.10 | Toughness (PVP:PVA ≈ 72:28) |
| PEG/PEO powder (heavy MW) | 0.50 | Tackifier — the strength edge; potent & stringy, start low |
| Strontium aluminate (plain) | 1.00 | UV indicator — uncoated, mix small & use fresh |
| 91% isopropyl alcohol | 16.00 | Carrier (kept IPA-heavy to slow hydrolysis) |
| Distilled water | 6.95 | Dissolves the PVA (carrier ≈ 63:37 IPA:water) |

Adhesive solids ≈ 15.5%. Uncoated phosphor fades with water exposure → use fresh;
heavy PEO strings → cut it if the applicator cobwebs.

## Mixing, working time & gear

At 1–4 oz this needs almost no equipment; only the PVA step wants heat, and high-shear
gear is the thing to avoid (it chops the high-MW PEO).

**Temperature, per step**

| Step | Temp |
| --- | --- |
| Dissolve PVA in the water phase | 45–55 °C (88% grade); ~85–90 °C then cool if fully hydrolyzed |
| PVP (K90 / PVP-40) in alcohol | room temp |
| PEG-400 / heavy PEO | room temp (keep PEO cool; pre-wet with alcohol) |
| Combine the phases | cool to <40 °C first — carrier is flammable |
| Boric stock + phosphor | room temp, added last |

**Working time**

- Batch shelf life: main ≈ weeks–months sealed; in-a-pinch (uncoated phosphor) ≈ days.
- In-applicator settling: phosphor resettles in minutes → sealable bottle + shake before use, or a stirred reservoir.
- Open/flash time: seconds on a hot bed, ~1–2 min at room temp. Main recipe is mildly shear-thinning (trace borate).

**Gear**

1. **Hotplate magnetic stirrer** — the one buy; heat + stir, hold ~50 °C. Covers the main recipe end to end.
2. **Drill + small paddle, low rpm (~100–300)** — for the viscous/elastic blend (esp. the pinch recipe's heavy PEO, which stalls a stir bar).
3. **Overhead paddle mixer** — suitable but not needed at these volumes; only if scaling past ~8 oz, with an anchor/paddle (not a disperser disc).

Avoid high-shear blenders/homogenizers (PEO chain scission + trapped air). Mix gently, degas
at rest, use alcohol-safe vessels (glass/HDPE/PP/PTFE).

## How coverage sensing works

`SrAl₂O₄:Eu,Dy` excites at ~365 nm and emits green ~520 nm. Flood the bed with 365 nm
UV; glued area glows green, bare bed stays dark. The **AS7341** F4 (515 nm) / F5 (555 nm)
channels straddle the peak and its filters reject 365 nm, so a single-point read often
needs no separate filter. Baseline the bare bed once; coverage is the green rise above it.

## Bike chain wax research

Route: `/chain-wax`

The chain-wax page treats paraffin lubrication as a measured tribology problem:

- Hot immersion first, because wax must reach the pin/roller/plate interfaces before it solidifies.
- Down-selected to two non-redundant PFAS-free solids — WS₂ (0.5 µm) as the primary lamellar lubricant and hBN as the water/oxidation-inert hedge — with MoS₂ dropped to a measured control arm and low-dose graphene/rGO as an advanced axis.
- Ultrasonic paraffin wax-in-water emulsion as a drip/top-up experiment, not a claimed replacement for immersion until penetration and contamination durability are measured.
- Bicycle-specific wear testing inspired by Zero Friction Cycling: fixed load, fixed intervals, fixed contamination dose, and no chain cleaning during the main block.

Key calibrations from a deeper paper review:

- In a clean rig, lube choice barely moves watts — chain efficiency runs ~80.9–98.6% set by tension and sprocket size, not lubrication (Spicer 2001). The wax advantage is contamination and wear: top waxes wear ~2.6–14.7× fewer chains over a 5000 km contamination test (Zero Friction Cycling).
- Additive doses are lower than folklore: WS₂ at ~1–1.5 wt% cuts COF ~29–30% in oil, the measured MoS₂ oil-additive optimum is ~0.01 wt% (not the 0.1–0.7 wt% homebrew band), and graphene/rGO optima sit near ~0.05 wt% and are dispersion-limited.
- The down-select is a measured bet, not a settled result: there is no peer-reviewed WS₂-in-wax tribology, the headline IF-WS₂ COF <0.04 is an oil/smooth-contact best case (Joly-Pottuz 2005, ~0.05 in a paraffin composite, ~15% in grease), and WS₂ is itself humidity-sensitive (COF rises ~2–4× dry→humid, Prasad 1999) — which is why hBN is kept as the moisture hedge and MoS₂-only / no-solid control arms stay in the DOE.
- The verified ultrasonic paraffin nanoemulsion (160.9 nm, 15 min) was stabilized by anionic SDS, not a Tween/Span blend; the required HLB for a fluid O/W paraffin is a band, ~10–13.5.

The hot-melt scaler starts with a 100 g screen:

| Ingredient | 100 g (g) | Role |
| --- | ---: | --- |
| Fully refined paraffin wax | 92.00 | Low-oil crystalline base |
| Microcrystalline wax | 4.00 | Toughness / adhesion |
| Fischer-Tropsch or PE wax | 2.00 | Hardness / melt-point modifier |
| Tungsten disulfide (0.5 µm) | 1.00 | Primary PFAS-free lamellar solid lubricant |
| Hexagonal boron nitride (0.5 µm) | 0.75 | Distinct water/oxidation-inert co-solid (≤1 wt%) |
| Metal stearate / oleic acid dispersant | 0.25 | In-melt wetting / anti-settling for the dense WS₂ |

That is 1.75 wt% solids (2.0 wt% with dispersant), down from the prior 3-solid 2.5 wt% blend;
MoS₂ moves to a DOE control arm rather than a production row.

The emulsion scaler starts with a 100 g, 23.75 wt% wax/additive-solids prototype using
paraffin, microcrystalline wax, FT/PE wax, an hBN-led Pickering solid load (build the base
emulsion first, add solids after), an HLB ~11–13 nonionic emulsifier blend, an anionic
SDS/SDBS lane (the verified nanoemulsion's actual stabilizer), and distilled water. It is
meant for droplet size, creaming, residue, penetration, and water-sensitivity screens before
road use.

## Hair-removal wax research

Route: `/hair-removal-wax`

The depilatory-wax page treats wax as a hot-melt peel adhesive, not a candle:

- Hair grip comes primarily from rosin/rosinate or synthetic hydrocarbon resin tackifiers.
- Paraffin and microcrystalline wax tune body, set speed, hardness, and peel behavior.
- EVA/elastomer content controls cohesive no-strip peel.
- Oil/CCT plasticizer controls spread, harshness, and residue.
- Rosin/colophony allergy, burn margin, residue, delayed irritation, and hygiene are gating metrics, not side notes.

Two 100 g pilots are included: a hard/no-strip wax and a cloth-strip wax. Both are
bench-first formulas; the page explicitly gates any human testing behind temperature
measurement, patch testing, tiny forearm trials, and stop criteria.

Key calibrations from a deeper paper review: real hard-wax application runs ~51–57 °C (the
page's 42–52 °C is a conservative, safety-driven low end); colophony contact-allergy prevalence
pools at 3.54% across 459,757 patients (Karimian 2026), and the standard 20% colophony patch
test can miss the glyceryl/ester-modified rosin allergens (GMA, maleopimaric acid) actually
present in waxes; resin tack has an optimum (peel rises, then falls past ~40 wt% resin), so
"more rosin" is not "stickier".

## Safety

Flammable alcohol carrier · phosphor dust (N95/P2 + eye protection when weighing) ·
boric acid (reproductive hazard if ingested) · 365 nm UV-A eye/skin hazard (enclose;
pulse during read only) · hot wax burns · solid-lube powder inhalation · depilatory
rosin/colophony allergy and skin trauma.

## Sources

### UV bed glue

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

### Bike chain wax

- Jadhav et al., *Ultrasound assisted manufacturing of paraffin wax nanoemulsions* (Ultrason. Sonochem. 2015; 160.9 nm, modified-SDS stabilized) — https://doi.org/10.1016/j.ultsonch.2014.10.024
- ICI, *The HLB System* — https://www.scientificspectator.com/documents/personal%20care%20spectator/The%20HLB%20Book%20ICI.pdf
- Gonen, *Influence of silica nanoparticles on the stability of paraffin wax emulsions* — https://eds.yildiz.edu.tr/AjaxTool/GetArticleByPublishedArticleId?PublishedArticleId=6862
- Zero Friction Cycling lubricant testing — https://zerofrictioncycling.com.au/lubetesting/
- Zero Friction Cycling chain-lubricant results PDF — https://zerofrictioncycling.com.au/wp-content/uploads/2024/09/Chain-Lubricant-Results-Sept-Aug-2024b.pdf
- Friction Facts UltraFast formula via BikeRadar — https://www.bikeradar.com/news/friction-facts-publishes-ultrafast-chain-lube-formula
- Zero Friction Cycling Molten Speed Wax review — https://zerofrictioncycling.com.au/wp-content/uploads/2017/12/MSW.pdf
- SILCA Secret Chain Blend — https://silca.cc/products/secret-chain-wax-blend
- CeramicSpeed UFO application FAQ — https://ceramicspeed.com/pages/ufo-family-application-and-faq
- Graphene-family lubricant additive review — https://www.mdpi.com/2075-4442/10/9/215
- hBN/TiO₂ water-based nanolubricant study — https://www.mdpi.com/2075-4442/12/4/123
- Nanolubricant additives review — https://link.springer.com/article/10.1007/s40544-020-0450-8
- Spicer et al., *Effects of Frictional Loss on Bicycle Chain Drive Efficiency* (J. Mech. Des. 2001) — https://doi.org/10.1115/1.1412848
- Spicer, *Nonlinear Elastic Behavior of Bicycle Chain on Transmission Efficiency* (J. Appl. Mech. 2013) — https://doi.org/10.1115/1.4007431
- Hu et al., *Tribological Properties of Different Morphology WS₂ as Lubricant Additives* (Materials 2020) — https://doi.org/10.3390/ma13071522
- Nagarajan et al., *MoS₂ nanoparticles as nano-additives in engine oil* (Sci. Rep. 2022) — https://doi.org/10.1038/s41598-022-16026-4
- Patel & Kiani, *rGO at different concentrations on tribological properties* (Lubricants 2019) — https://doi.org/10.3390/lubricants7020011
- Dou et al., *Self-dispersed crumpled graphene balls in oil* (PNAS 2016) — https://doi.org/10.1073/pnas.1520994113
- Lindner et al., *HLB, surfactant, particle size and stability of wax dispersions* (Coatings 2018) — https://doi.org/10.3390/coatings8120469
- Cornell, *Embedding mixture experiments inside factorial experiments* (J. Qual. Technol. 1990) — https://doi.org/10.1080/00224065.1990.11979258
- Friction Facts/VeloNews & Zero Friction Cycling watt/wear data — https://intheknowcycling.com/chain-wax-faster-better-and-cheaper/ · https://www.cyclingabout.com/best-bike-chain-lubes-according-to-science/

### Hair-removal wax

- CN108379120A depilatory wax patent — https://patents.google.com/patent/CN108379120A/en
- US20180028419A1 depilatory composition — https://patents.google.com/patent/US20180028419A1/en
- EP3009168A1 depilatory wax — https://data.epo.org/publication-server/rest/v1.2/publication-dates/20160420/patents/EP3009168NWA1/document.pdf
- US10166178B2 depilatory wax composition — https://patents.justia.com/patent/10166178
- Quain et al., allergic contact dermatitis caused by colophony in an epilating product — https://pubmed.ncbi.nlm.nih.gov/17498415/
- George et al., depilatory wax allergen review — https://pubmed.ncbi.nlm.nih.gov/39501881/
- Lahouel et al., pustular allergic contact dermatitis caused by colophonium — https://pubmed.ncbi.nlm.nih.gov/32876340/
- DermNet rosin and colophony allergy — https://dermnetnz.org/topics/rosin-allergy
- Kobo no-heat hair-removal wax formula — https://www.koboproductsinc.com/formulations/KHP-059.pdf
- EP0194181A1 depilatory composition (hair-vs-skin adhesion balance) — https://patents.google.com/patent/EP0194181A1/en
- Karimian et al., *Contact allergy to colophonium: systematic review & meta-analysis* (Contact Dermatitis 2026) — https://onlinelibrary.wiley.com/doi/10.1111/cod.70153
- Karlberg et al., *Hydrogenation reduces the allergenicity of colophony* (Contact Dermatitis 1988) — https://pubmed.ncbi.nlm.nih.gov/3180766/
- Gáfvert, *Patch testing with allergens from modified rosin* (Contact Dermatitis 1994/96) — https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1600-0536.1996.tb02391.x
- Lee et al., *Depilatory wax burns: experience and investigation* (Burns 2011) — https://pmc.ncbi.nlm.nih.gov/articles/PMC3098007/
- Martin & Falder, *Evidence for the threshold of burn injury* (Burns 2017) — https://pubmed.ncbi.nlm.nih.gov/28536038/
- Grzelka et al., *Viscoelastic-to-fracture transition in PSA peeling* (Soft Matter 2022) — https://arxiv.org/abs/2107.09367
- Park et al., *Adhesion of EVA hot-melt adhesives: tackifier and wax* (Int. J. Adhesion 2020) — https://www.sciencedirect.com/science/article/abs/pii/S0143749620300476
- Scheffé, *Experiments with Mixtures* (J. R. Stat. Soc. B 1958) — https://doi.org/10.1111/j.2517-6161.1958.tb00299.x

## License

CC0-1.0. Experimental — validate the recipe and hardware yourself.
