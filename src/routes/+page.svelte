<script lang="ts">
	import { base } from '$app/paths';
	import SEOHead from '$lib/components/SEOHead.svelte';
	import GlueScaler from '$lib/components/GlueScaler.svelte';
	import GlueScalerPinch from '$lib/components/GlueScalerPinch.svelte';

	const repo = 'https://github.com/jesssullivan/tinyland-goo/blob/main';

	// Verified, currently-purchasable BOM. Core = the minimum to gate a print;
	// optional = upgrades (full-field imaging, UV-dose normalization, fallback).
	const bomCore = [
		{
			role: '365 nm UV-A LED',
			part: 'LZ1-00UV0R-0000',
			mfr: 'OSRAM / LED Engin',
			src: 'Mouser',
			price: '~$20'
		},
		{
			role: 'Constant-current driver (700 mA)',
			part: 'LDD-700H',
			mfr: 'MEAN WELL',
			src: 'Mouser / DigiKey',
			price: '~$6'
		},
		{
			role: '11-ch spectral sensor (F4≈515, F5≈555 nm)',
			part: 'AS7341 breakout #4698',
			mfr: 'Adafruit',
			src: 'DigiKey',
			price: '$18.95'
		},
		{
			role: 'Klipper / Moonraker host (I2C + CSI)',
			part: 'Raspberry Pi 5',
			mfr: 'Raspberry Pi',
			src: 'PiShop / DigiKey',
			price: '~$80*'
		}
	];

	const bomOptional = [
		{
			role: '~500 nm green longpass (UV block for camera/TSL2591)',
			part: 'FGL495',
			mfr: 'Thorlabs',
			src: 'Thorlabs',
			price: '~$35'
		},
		{
			role: '520/10 nm bandpass (max selectivity)',
			part: 'FBH520-10',
			mfr: 'Thorlabs',
			src: 'Thorlabs',
			price: '~$95'
		},
		{
			role: 'Full-field mono global-shutter camera',
			part: 'Mira220 MONO',
			mfr: 'Arducam',
			src: 'Arducam / Pi Hut',
			price: '~$70'
		},
		{
			role: 'UV-dose reference (aging/normalization)',
			part: 'LTR-390 #4831',
			mfr: 'Adafruit',
			src: 'DigiKey',
			price: '$4.50'
		},
		{
			role: 'Cheap broadband fallback (needs a filter)',
			part: 'TSL2591 #1980',
			mfr: 'Adafruit',
			src: 'DigiKey',
			price: '$6.95'
		}
	];
</script>

<SEOHead
	title="tinyland-goo — UV-reactive bed glue + a Klipper coverage gate"
	description="UV-reactive, strontium-aluminate-infused 3D-printer bed glue: a stronger-than-Frank recipe, a weight-based batch scaler, an off-the-shelf UV coverage-sensing BOM, and a Klipper pre-print gate."
	jsonLd={{
		'@context': 'https://schema.org',
		'@type': 'TechArticle',
		headline: 'UV-reactive 3D-printer bed glue + a Klipper coverage gate',
		description:
			'A strontium-aluminate UV-reactive bed-glue recipe, a weight-based batch scaler, a UV coverage-sensing BOM, and a Klipper pre-print gate.'
	}}
/>

<main class="prose-body mx-auto max-w-3xl px-6 py-12 md:py-16">
	<p class="text-xs uppercase tracking-widest text-surface-500">Tinyland · maker log</p>
	<h1 class="mt-2 text-4xl font-bold leading-tight md:text-5xl">
		Glue you can <span class="text-primary-600">see in UV</span>
	</h1>
	<p class="mt-4 text-xl text-surface-700 dark:text-surface-300">
		A 3D-printer bed adhesive that is stronger than Frank’s “Instagoo,” loaded with
		strontium-aluminate phosphor so a 365&nbsp;nm flash shows exactly where you laid it down —
		and a Klipper macro that refuses to print until the bed is covered.
	</p>

	<h2 class="mt-12 text-2xl font-semibold">Adjacent wax tracks</h2>
	<p class="mt-3">
		The same lab-note structure now branches into paraffin wax experiments: one track for
		low-friction bicycle chain wax and ultrasonic wax emulsions, and one track for depilatory
		wax formulation with peel-force and skin-safety gates.
	</p>
	<div class="not-prose mt-4 grid gap-3 md:grid-cols-2">
		<a class="card block p-4 preset-outlined-surface-500" href={`${base}/chain-wax`}>
			<span class="block text-lg font-semibold">Bike chain wax</span>
			<span class="mt-1 block text-sm text-surface-600 dark:text-surface-400">
				PFAS-free additive screens, hot immersion, ultrasonic emulsion, and wear methodology.
			</span>
		</a>
		<a class="card block p-4 preset-outlined-surface-500" href={`${base}/hair-removal-wax`}>
			<span class="block text-lg font-semibold">Hair removal wax</span>
			<span class="mt-1 block text-sm text-surface-600 dark:text-surface-400">
				Rosinate/paraffin hard and strip wax pilots with bench tests and allergy constraints.
			</span>
		</a>
	</div>

	<h2 class="mt-12 text-2xl font-semibold">The starting point: Frank’s Instagoo</h2>
	<p class="mt-3">
		<a class="underline" href="https://goo.by.frank.af/">Frank’s recipe</a> is 21&nbsp;g PVP-K30 +
		9&nbsp;g PVA in 200&nbsp;ml of ~50% isopropyl alcohol — a 70:30 PVP:PVA solution at roughly
		15% solids. It’s the same family as the commercial brush-ons
		(<a class="underline" href="https://visionminer.com/products/nano-polymer-adhesive">Vision Miner Nano</a>,
		whose SDS discloses only an IPA carrier and a trade-secret polymer; and
		<a class="underline" href="https://www.lukeslabonline.com/products/bed-adhesive">Luke’s Laboratory</a>,
		sold as Standard/Double/Triple “strength,” i.e. the same liquid at different solids). None
		publishes a quantified bond strength. We keep Frank’s structure and turn three honest knobs.
	</p>

	<h2 class="mt-12 text-2xl font-semibold">The recipe</h2>
	<p class="mt-3">
		Everything by weight, for a 0.01&nbsp;g scale. The default below is the 4&nbsp;oz batch.
	</p>

	<GlueScaler />

	<h2 class="mt-12 text-2xl font-semibold">Why it’s stronger than Frank’s</h2>
	<ul class="mt-3 list-disc space-y-2 pl-6">
		<li>
			<strong>PVP-K90 instead of K30.</strong> K90 has ~30× the molecular weight (~1.3M vs ~40k),
			which raises viscosity, film cohesion, and tack — the single biggest lever, and a drop-in
			swap for Frank’s K30.
		</li>
		<li>
			<strong>PEG-400 tackifier.</strong> Pressure-sensitive tack in PVP/PEG blends is real and
			peaks near 36&nbsp;wt% PEG. We start conservative (20% of the PVP+PEG fraction) so the film
			still releases; nudge it up for more grab.
		</li>
		<li>
			<strong>A trace boric-acid crosslink.</strong> ~0.7% of the PVA mass lightly bonds the PVA
			for cohesive strength while keeping the film water/alcohol-redispersible — so prints still
			pop off on cooling. (More than ~1% and it stops releasing; this is the one number the
			research had to correct downward.)
		</li>
	</ul>

	<h2 class="mt-12 text-2xl font-semibold">The phosphor (and the water trap)</h2>
	<p class="mt-3">
		Strontium aluminate <span class="font-mono">SrAl₂O₄:Eu,Dy</span> is the long-afterglow green
		glow pigment: excited across UV-A (peak ~365&nbsp;nm), it emits a broad green band at
		~520&nbsp;nm. That is the whole sensing trick — a glued patch lights up green under UV; bare
		bed stays dark. It is non-toxic with no GHS hazard class, but it’s a hard mineral dust:
		<strong>mask and gloves when weighing powder.</strong>
	</p>
	<p class="mt-3">
		The trap: <strong>bare strontium aluminate hydrolyzes in water</strong> to non-luminescent
		Al(OH)₃/Sr(OH)₂ and slowly stops glowing. You can’t just go anhydrous — PVA needs water to
		dissolve. The fix is a <strong>silica/fluoride-coated (“waterproof”/encapsulated) grade</strong>
		(Techno Glow / GLO Effex sell 35–50&nbsp;µm encapsulated powder) plus a modest water fraction.
		Coated phosphor is mandatory here, not optional.
	</p>

	<h2 class="mt-12 text-2xl font-semibold">Mixing it</h2>
	<ol class="mt-3 list-decimal space-y-2 pl-6">
		<li>Pre-make a 1% boric stock: 1&nbsp;g boric acid in 99&nbsp;g warm distilled water.</li>
		<li>Dissolve the PVA in the warm-water portion (~45–50&nbsp;°C) until clear.</li>
		<li>Separately dissolve PVP-K90 + PEG-400 in the ethanol (K90 is slow — give it time).</li>
		<li>Combine the alcohol phase into the cooled PVA/water phase; add remaining free water.</li>
		<li>Stir in the boric stock <em>last</em>, slowly, to avoid local gel lumps.</li>
		<li>Disperse the coated phosphor just before use — it’s dense and settles. Apply thin, even coats.</li>
	</ol>

	<h2 class="mt-12 text-2xl font-semibold">In a pinch: a simpler PVP-40 derivation</h2>
	<p class="mt-3">
		The recipe above wants PVP-K90, an encapsulated phosphor, and a boric-acid
		crosslink — specialized stock. While that’s in the mail, here’s a derivation that
		uses only common, on-hand chemicals (PVP-40, PVA lab powder, 91% IPA, distilled
		water, a heavy PEG/PEO powder, and plain strontium aluminate). It’s meant for an
		automated applicator on <strong>less mission-critical</strong> printers, and it scales
		to 1/2/4&nbsp;oz mini batches.
	</p>
	<p class="mt-3">
		It still beats Frank’s: same PVP/PVA backbone, but with a touch more adhesive solids
		and a <strong>PEG/PEO tackifier</strong> — the documented bond-strength lever — instead of the
		K90 + crosslink combo. Trade-offs: the plain (uncoated) phosphor hydrolyzes in the
		aqueous carrier over time, so mix small and use fresh; and heavy PEO is stringy, so
		keep it low or your applicator will cobweb. Both glues read identically under UV.
	</p>

	<GlueScalerPinch />

	<h2 class="mt-12 text-2xl font-semibold">Mixing, working time &amp; gear</h2>
	<p class="mt-3">
		Good news: at 1–8&nbsp;oz this needs almost no equipment. Only one step wants heat —
		dissolving the PVA — and the high-shear gear you might reach for is the one thing to
		avoid, because it chops up the high-MW PEO.
	</p>

	<h3 class="mt-8 text-xl font-semibold">Temperature, per step</h3>
	<div class="not-prose my-4 overflow-x-auto">
		<table class="w-full text-sm">
			<thead>
				<tr class="text-left text-surface-600 dark:text-surface-400">
					<th class="py-1 pr-3 font-medium">Step</th>
					<th class="py-1 font-medium">Temperature</th>
				</tr>
			</thead>
			<tbody>
				<tr class="border-t border-surface-300 dark:border-surface-700">
					<td class="py-1 pr-3">Dissolve PVA in the water phase</td>
					<td class="py-1">45–55&nbsp;°C (88% grade) · ~85–90&nbsp;°C then cool if your lab powder is fully hydrolyzed</td>
				</tr>
				<tr class="border-t border-surface-300 dark:border-surface-700">
					<td class="py-1 pr-3">PVP (K90 / PVP-40) into alcohol</td>
					<td class="py-1">room temp — K90 is just slow; give it time, no heat</td>
				</tr>
				<tr class="border-t border-surface-300 dark:border-surface-700">
					<td class="py-1 pr-3">PEG-400 / heavy PEO</td>
					<td class="py-1">room temp — keep PEO cool, pre-wet with a little alcohol to avoid fish-eyes</td>
				</tr>
				<tr class="border-t border-surface-300 dark:border-surface-700">
					<td class="py-1 pr-3">Combine the phases</td>
					<td class="py-1">cool to &lt;40&nbsp;°C first — the carrier is flammable; never combine hot</td>
				</tr>
				<tr class="border-t border-surface-300 dark:border-surface-700">
					<td class="py-1 pr-3">Boric stock + phosphor</td>
					<td class="py-1">room temp, added last (boric slowly, to avoid gel lumps)</td>
				</tr>
			</tbody>
		</table>
		<p class="mt-1 text-xs text-surface-500">Mix away from open flame.</p>
	</div>

	<h3 class="mt-8 text-xl font-semibold">Working time</h3>
	<ul class="mt-3 list-disc space-y-2 pl-6">
		<li>
			<strong>Batch shelf life</strong> — the main recipe keeps weeks–months sealed (cap it;
			alcohol evaporation is the enemy). The in-a-pinch glue’s uncoated phosphor fades in
			days — mix small, use fresh.
		</li>
		<li>
			<strong>In-applicator settling</strong> — the phosphor (ρ≈3.6) resettles in minutes.
			Don’t fight it with a bigger mixer; use a sealable bottle and shake before each use
			(it resuspends in seconds), or draw from a stirred reservoir.
		</li>
		<li>
			<strong>Open / flash time</strong> — a thin coat flashes off in seconds on a hot bed,
			~1–2&nbsp;min at room temp. The main recipe’s trace borate makes it mildly
			shear-thinning — thins when pumped or brushed, firms at rest, which is handy for an
			applicator.
		</li>
	</ul>

	<h3 class="mt-8 text-xl font-semibold">Gear</h3>
	<ol class="mt-3 list-decimal space-y-2 pl-6">
		<li>
			<strong>Hotplate magnetic stirrer</strong> — the one buy worth making. Heat + stir for
			the PVA and PVP steps; with a temperature probe you can hold ~50&nbsp;°C. Handles the
			main recipe end to end.
		</li>
		<li>
			<strong>A drill + small paddle, low rpm</strong> — for the final viscous blend, especially
			the pinch recipe’s heavy PEO, which turns the mix stringy enough to stall a magnetic
			stir bar. A minute at ~100–300&nbsp;rpm is plenty.
		</li>
		<li>
			<strong>Overhead paddle mixer</strong> — suitable but <em>not needed</em> at these volumes;
			worth it only if you batch often or scale past ~8&nbsp;oz. If you get one, use an
			anchor/paddle (low-shear) impeller, not a disperser disc.
		</li>
	</ol>
	<p class="mt-3">
		<strong>Avoid</strong> immersion blenders, homogenizers, and Cowles dispersers — they
		degrade the high-MW PEO and whip in bubbles that won’t leave a viscous solution. Mix
		gently, let it degas at rest before bottling, and use alcohol-safe vessels
		(glass/HDPE/PP/PTFE — not polystyrene).
	</p>

	<h2 class="mt-12 text-2xl font-semibold">Seeing coverage: the sensor</h2>
	<p class="mt-3">
		Flood the bed with 365&nbsp;nm UV and read the ~520&nbsp;nm green that comes back. The
		<strong>AS7341</strong>’s F4 (515&nbsp;nm) and F5 (555&nbsp;nm) channels straddle the phosphor
		peak, and its on-chip interference filters already reject 365&nbsp;nm — so for a single-point
		read you often don’t need a separate glass filter. Take a bare-bed baseline once, then express
		coverage as the green rise above it. Pulse the UV only during the read (eye safety + repeatable
		charge). For a one-shot whole-bed heatmap, image it instead with a mono global-shutter camera
		behind a ~500&nbsp;nm longpass.
	</p>

	<h3 class="mt-8 text-xl font-semibold">Core BOM</h3>
	<div class="not-prose my-4 overflow-x-auto">
		<table class="w-full text-sm">
			<thead>
				<tr class="text-left text-surface-600 dark:text-surface-400">
					<th class="py-1 pr-3 font-medium">Role</th>
					<th class="py-1 pr-3 font-medium">Part</th>
					<th class="py-1 pr-3 font-medium">Source</th>
					<th class="py-1 font-medium">~Price</th>
				</tr>
			</thead>
			<tbody>
				{#each bomCore as p (p.part)}
					<tr class="border-t border-surface-300 dark:border-surface-700">
						<td class="py-1 pr-3">{p.role}</td>
						<td class="py-1 pr-3 font-mono">{p.part}<span class="block text-xs text-surface-500">{p.mfr}</span></td>
						<td class="py-1 pr-3">{p.src}</td>
						<td class="whitespace-nowrap py-1 font-mono">{p.price}</td>
					</tr>
				{/each}
			</tbody>
		</table>
		<p class="mt-1 text-xs text-surface-500">* The Pi is almost certainly already your Klipper host.</p>
	</div>

	<h3 class="mt-8 text-xl font-semibold">Optional upgrades</h3>
	<div class="not-prose my-4 overflow-x-auto">
		<table class="w-full text-sm">
			<thead>
				<tr class="text-left text-surface-600 dark:text-surface-400">
					<th class="py-1 pr-3 font-medium">Role</th>
					<th class="py-1 pr-3 font-medium">Part</th>
					<th class="py-1 pr-3 font-medium">Source</th>
					<th class="py-1 font-medium">~Price</th>
				</tr>
			</thead>
			<tbody>
				{#each bomOptional as p (p.part)}
					<tr class="border-t border-surface-300 dark:border-surface-700">
						<td class="py-1 pr-3">{p.role}</td>
						<td class="py-1 pr-3 font-mono">{p.part}<span class="block text-xs text-surface-500">{p.mfr}</span></td>
						<td class="py-1 pr-3">{p.src}</td>
						<td class="whitespace-nowrap py-1 font-mono">{p.price}</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>

	<h2 class="mt-12 text-2xl font-semibold">The Klipper gate</h2>
	<p class="mt-3">
		<code>PRINT_START</code> calls a host script (via the <code>gcode_shell_command</code> extension)
		that reads the AS7341 and writes the result back through Moonraker’s
		<code>SAVE_VARIABLE</code>. A second macro then reads that value and aborts with
		<code>action_raise_error</code> if coverage is below threshold — before any heating or motion.
		Two-point calibration (bare → 0%, glued → 100%) is required.
	</p>
	<pre class="not-prose my-4 overflow-x-auto rounded-lg bg-surface-100 p-4 text-xs dark:bg-surface-900"><code>[gcode_macro _COVERAGE_GATE]
gcode:
    &lbrace;% set min_cov = params.MIN_COVERAGE|default(70)|float %&rbrace;
    &lbrace;% set cov = printer.save_variables.variables.coverage_pct|default(-1)|float %&rbrace;
    &lbrace;% if cov &lt; min_cov %&rbrace;
        &lbrace; action_raise_error("COVERAGE GATE: %.1f%% &lt; %.1f%%. Re-glue and restart." % (cov, min_cov)) &rbrace;
    &lbrace;% endif %&rbrace;</code></pre>
	<p class="mt-3 text-sm">
		Full, usable files:
		<a class="underline" href={`${repo}/klipper/coverage_gate.cfg`}>coverage_gate.cfg</a> ·
		<a class="underline" href={`${repo}/klipper/coverage_gate.py`}>coverage_gate.py</a>
	</p>

	<h2 class="mt-12 text-2xl font-semibold">Safety</h2>
	<ul class="mt-3 list-disc space-y-2 pl-6">
		<li><strong>Flammable carrier</strong> (~55% ethanol/IPA). Mix and store away from flame/sparks; let the alcohol flash off before the bed gets hot.</li>
		<li><strong>Phosphor dust:</strong> N95/P2 (P100 better) + eye protection when weighing powder; no GHS hazard, but it’s an inhalation/eye irritant.</li>
		<li><strong>Boric acid</strong> is a reproductive hazard if ingested — gloves, keep away from food/children/pets.</li>
		<li><strong>365 nm UV-A</strong> is an eye/skin hazard at multi-watt levels — enclose it and pulse only during the read.</li>
	</ul>

	<h2 class="mt-12 text-2xl font-semibold">Sources</h2>
	<p class="mt-3 text-sm text-surface-600 dark:text-surface-400">
		Frank’s Instagoo · DrGhetto/Hackaday Super Goop · PVP K30↔K90 (ULI Polymer) · PVP/PEG
		tack (Feldstein et&nbsp;al.) · boric-acid/PVA crosslink (IOP) · strontium-aluminate
		hydrolysis + encapsulation (ScienceDirect; Wikipedia) · AS7341 (AMS/Adafruit) · Klipper
		Command Templates + <code>gcode_shell_command</code> (KIAUH). Full citation list in the
		<a class="underline" href="https://github.com/jesssullivan/tinyland-goo">repo README</a>.
	</p>
</main>
