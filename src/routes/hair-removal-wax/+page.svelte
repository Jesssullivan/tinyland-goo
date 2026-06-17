<script lang="ts">
	import { base } from '$app/paths';
	import DepilatoryHardWaxScaler from '$lib/components/DepilatoryHardWaxScaler.svelte';
	import DepilatoryStripWaxScaler from '$lib/components/DepilatoryStripWaxScaler.svelte';

	const formulationKnobs = [
		{
			knob: 'Rosinate / resin tack',
			range: '45-83 wt%',
			effect: 'Hair grip and peel adhesion, with an optimum: peel rises then falls as cohesion is lost. Patent examples run 60-80%+.',
			risk: 'Colophony/rosin allergy, too much skin grab, brittle peel if under-plasticized.'
		},
		{
			knob: 'EVA / elastomer',
			range: '3-12 wt%',
			effect: 'Turns brittle resin/wax into a cohesive no-strip film.',
			risk: 'Too much stringing, slow melt, poor spread at low temperature.'
		},
		{
			knob: 'Paraffin',
			range: '4-30 wt%',
			effect: 'Cheap crystalline body, set speed, hardness, opacity.',
			risk: 'Brittle snap, poor hair wetting, narrow working window.'
		},
		{
			knob: 'Microcrystalline wax',
			range: '5-18 wt%',
			effect: 'Plastic cohesive wax phase; improves flex and low-temp handling.',
			risk: 'Too soft or residue-prone when paired with high oil.'
		},
		{
			knob: 'Beeswax / candelilla',
			range: '3-12 wt%',
			effect: 'Body, spread, and more forgiving peel feel.',
			risk: 'Beeswax/propolis allergy signal; batch-to-batch natural variability.'
		},
		{
			knob: 'Oil / CCT plasticizer',
			range: '4-15 wt%',
			effect: 'Lowers peel harshness and improves spread.',
			risk: 'Residue, weak hair grip, oily post-feel, lower cohesive strength.'
		}
	];

	const testMatrix = [
		{
			factor: 'Application temperature',
			levels: '42 / 45 / 48 / 52 C',
			response: 'spreadability, burn margin, hair removal, redness at 1 h and 24 h'
		},
		{
			factor: 'Film thickness',
			levels: '0.4 / 0.7 / 1.0 mm drawdown',
			response: 'set time, peel integrity, residue mass, hair capture'
		},
		{
			factor: 'Resin system',
			levels: 'glyceryl rosinate / hydrogenated rosinate / hydrocarbon resin blend',
			response: 'tack-to-hair vs tack-to-skin, allergy posture, odor/color stability'
		},
		{
			factor: 'Elastic modifier',
			levels: '0 / 5 / 9 / 12 wt% EVA',
			response: 'stringing, snap, cohesive failure, no-strip peel force'
		},
		{
			factor: 'Plasticizer',
			levels: 'mineral oil / CCT / jojoba-like ester at 4-12 wt%',
			response: 'residue, comfort, hair grip, shelf stability'
		}
	];

	const benchProtocol = [
		'Melt under temperature control and log the actual pot temperature, not the warmer setting.',
		'Draw a fixed film thickness onto silicone sheet, glass, paper, and a hair swatch before any skin test.',
		'Measure set time: glossy-to-matte transition, peelable time, and over-set brittleness.',
		'Measure peel force with a luggage scale or force gauge at a fixed peel angle and speed.',
		'Track residue mass by weighing the substrate before wax, after peel, and after oil cleanup.',
		'Only after bench tests pass, do a 24 h patch test with a rice-grain amount at low temperature.',
		'Escalate to tiny forearm strips only; no face, underarm, groin, damaged skin, retinoid-treated skin, or sunburned skin.'
	];

	const sources = [
		{
			title: 'CN108379120A depilatory wax patent',
			href: 'https://patents.google.com/patent/CN108379120A/en',
			note: 'Low-temperature target, rosin/hydrogenated rosinate/EVA/paraffin examples.'
		},
		{
			title: 'US20180028419A1 depilatory composition',
			href: 'https://patents.google.com/patent/US20180028419A1/en',
			note: 'Rosin/resin tackifier, wax/oil texturizers, polymer, surfactant, water, salt ranges.'
		},
		{
			title: 'EP3009168A1 depilatory wax',
			href: 'https://data.epo.org/publication-server/rest/v1.2/publication-dates/20160420/patents/EP3009168NWA1/document.pdf',
			note: 'Adhesive resin, plasticizer, glycerin, and emulsifier patent ranges.'
		},
		{
			title: 'US10166178B2 depilatory wax composition',
			href: 'https://patents.justia.com/patent/10166178',
			note: 'Fat-soluble resin waxes with carriers for hydrophilic cosmetic actives.'
		},
		{
			title: 'Quain et al., allergic contact dermatitis caused by colophony in an epilating product',
			href: 'https://pubmed.ncbi.nlm.nih.gov/17498415/',
			note: 'Classic depilatory-wax colophony allergy case report.'
		},
		{
			title: 'George et al., depilatory wax allergen review',
			href: 'https://pubmed.ncbi.nlm.nih.gov/39501881/',
			note: '2024 ingredient survey: vitamin E, colophony, botanicals, fragrance, beeswax/propolis, color additives.'
		},
		{
			title: 'Lahouel et al., pustular allergic contact dermatitis caused by colophonium',
			href: 'https://pubmed.ncbi.nlm.nih.gov/32876340/',
			note: 'Rare but useful warning case for rosin-heavy depilatory waxes.'
		},
		{
			title: 'DermNet, rosin and colophony allergy',
			href: 'https://dermnetnz.org/topics/rosin-allergy',
			note: 'Timing and presentation of allergic contact dermatitis after rosin exposure.'
		},
		{
			title: 'Kobo no-heat hair removal wax formula',
			href: 'https://www.koboproductsinc.com/formulations/KHP-059.pdf',
			note: 'Modern film-former direction for nontraditional wax/adhesive systems.'
		},
		{
			title: 'EP0194181A1 — depilatory composition containing rosin derivatives',
			href: 'https://patents.google.com/patent/EP0194181A1/en',
			note: 'Names both failure modes: rosin+beeswax adheres to hair not skin (residue); rosin+sugar adheres less to hair (hairs left). Clean removal = hair-vs-skin adhesion balance.'
		},
		{
			title: 'EP1245220A1 — depilatory wax composition',
			href: 'https://patents.google.com/patent/EP1245220A1/en',
			note: '60-85 wt% rosin-type wax, softening 70-80 C; self-supporting (no-strip) base contains 5-15% elastomer/thermoplastic.'
		},
		{
			title: 'CA2567117C — epilatory compositions',
			href: 'https://patents.google.com/patent/CA2567117C/en',
			note: 'Worked example: 63.8 wt% glyceryl rosinate + 4.4 wt% EVA + beeswax + paraffin, usable to ~68 C. Concrete low-EVA self-supporting anchor.'
		},
		{
			title: 'Grzelka et al., Viscoelastic-to-fracture transition in PSA peeling (Soft Matter 2022)',
			href: 'https://arxiv.org/abs/2107.09367',
			note: 'Peel energy ~4 J/m² vs ~0.1 J/m² interfacial work of adhesion (~40x dissipative amplification); peel force is rate/state-dependent — "rip fast" is a regime, not stronger bonding.'
		},
		{
			title: 'Coumarone resin as a tackifier in SBS-based PSA: a viscoelasticity study (2025)',
			href: 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12687324/',
			note: 'Dahlquist criterion G&prime; < 0.3 MPa at 1 Hz; peel peaks at 40 wt% resin (~27 N/25mm) then falls to ~15 at 80 wt% — the tackifier optimum.'
		},
		{
			title: 'Park et al., Adhesion of EVA hot-melt adhesives — tackifier and wax effects (Int. J. Adhesion 2020)',
			href: 'https://www.sciencedirect.com/science/article/abs/pii/S0143749620300476',
			note: 'T-peel maxes near ~70 phr glycerol ester of hydrogenated rosin per 100 EVA; tackifier ineffective once blend Tg > ~15 C. Direct no-strip-wax analog.'
		},
		{
			title: 'Karimian et al., Contact allergy to colophonium: systematic review & meta-analysis (Contact Dermatitis 2026)',
			href: 'https://onlinelibrary.wiley.com/doi/10.1111/cod.70153',
			note: '73 studies, 459,757 patients; pooled colophony prevalence 3.54% (95% CI 3.01-4.16), Southeast Asia 6.83%. Quantitative anchor for the rosin warning.'
		},
		{
			title: 'Karlberg et al., Hydrogenation reduces the allergenicity of colophony (Contact Dermatitis 1988)',
			href: 'https://pubmed.ncbi.nlm.nih.gov/3180766/',
			note: 'Primary evidence that hydrogenating the oxidizable double bonds markedly lowers rosin sensitization.'
		},
		{
			title: 'Gafvert, Patch testing with allergens from modified rosin (Contact Dermatitis 1994/96)',
			href: 'https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1600-0536.1996.tb02391.x',
			note: 'Glyceryl monoabietate (GMA) and maleopimaric acid (MPA) are distinct allergens in modified/ester rosins that the standard 20% colophony test misses.'
		},
		{
			title: 'Martin & Falder, Evidence for the threshold of burn injury (Burns 2017)',
			href: 'https://pubmed.ncbi.nlm.nih.gov/28536038/',
			note: 'Basal-layer threshold 44 C (~6 h), pain just above 43 C, logarithmic damage rise 44-70 C, near-instant above 70 C. Basis for the low-temperature burn gate.'
		},
		{
			title: 'Lee et al., Depilatory wax burns: experience and investigation (Burns 2011)',
			href: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC3098007/',
			note: 'Unstirred microwave wax up to 108.5 C, 17/60 readings >90 C; stirred max fell to 65.7 C. The data behind "wax warmers lie — measure stirred wax."'
		},
		{
			title: 'Scheffe, Experiments with Mixtures (J. R. Stat. Soc. B 1958)',
			href: 'https://doi.org/10.1111/j.2517-6161.1958.tb00299.x',
			note: 'Foundational mixture-design theory: components summing to 1 are not independent, so simplex-lattice/canonical polynomials replace factorial models for composition.'
		},
		{
			title: 'Cornell, Embedding Mixture Experiments inside Factorial Experiments (J. Qual. Technol. 1990)',
			href: 'https://doi.org/10.1080/00224065.1990.11979258',
			note: 'Canonical crossed mixture-process design: composition to a mixture design, process variables to factorial/RSM, joined.'
		}
	];
</script>

<svelte:head>
	<title>tinyland-goo — hair removal wax formulation research</title>
</svelte:head>

<main class="prose-body mx-auto max-w-3xl px-6 py-12 md:py-16">
	<p class="text-xs uppercase tracking-widest text-surface-500">Tinyland · wax lab</p>
	<h1 class="mt-2 text-4xl font-bold leading-tight md:text-5xl">
		Hair removal wax as a <span class="text-primary-600">peel-mechanics project</span>
	</h1>
	<p class="mt-4 text-xl text-surface-700 dark:text-surface-300">
		A bench-first formulation track for paraffin/rosinate depilatory wax: tackifiers, elastomers,
		paraffin and microcrystalline waxes, low-temperature spread, peel force, residue, and skin-safety gates.
	</p>
	<p class="mt-4 text-sm">
		<a class="underline" href={`${base}/`}>Back to UV bed glue</a> ·
		<a class="underline" href={`${base}/chain-wax`}>Bike chain wax track</a>
	</p>

	<h2 class="mt-12 text-2xl font-semibold">The product physics</h2>
	<p class="mt-3">
		Depilatory wax is closer to a hot-melt pressure-sensitive adhesive than to a candle. It needs
		to wet and grip hair, avoid excessive skin grab, set into a cohesive film, and peel without
		shattering or leaving a sticky residue. Paraffin can supply body and set speed, but it is not
		the hair-grip engine. That job usually belongs to rosin/rosinate or synthetic hydrocarbon resins.
	</p>
	<p class="mt-3">
		The hard constraint is biological: a formula that removes hair but burns, sensitizes, tears skin,
		or leaves allergenic residue is a failed formula. Rosin chemistry is effective and common, but
		colophony allergy is well documented in depilatory products, so every test should track allergy
		posture alongside peel performance.
	</p>

	<p class="mt-3">
		Framing it as a hot-melt PSA gives a number to aim at. To wet hair the warm film has to drop below the
		Dahlquist tack criterion — storage modulus G&prime; under ~0.3&nbsp;MPa at 1&nbsp;Hz — then it stiffens as it
		cools toward skin temperature and locks onto the hair. The two failure modes are named directly in the patent
		literature: rosin+beeswax systems "adhere strongly to the hairs but little to the skin" (good pluck, sticky
		residue) while rosin+sugar systems "adhere less well to the hairs" (hairs left behind) — clean removal is a
		hair-vs-skin adhesion balance, not raw stickiness (EP0194181A1).
	</p>
	<p class="mt-3">
		Put a number on the allergy risk too. A 2026 meta-analysis of 459,757 dermatitis patients pooled colophony
		contact-allergy prevalence at 3.54% (95% CI 3.01-4.16), stable over decades and ~6.8% in Southeast Asia
		(Karimian et&nbsp;al. 2026). The real sensitizers are air-oxidation products of the resin acids — peroxide/epoxide
		species and 7-oxo-dehydroabietic acid, not pristine abietic acid — which is why fresh vs air-aged rosin differ
		and oxidation control matters (Hausen 1990). It is documented from waxes specifically but case-report-level, so
		track it without overclaiming it as a high-incidence hazard.
	</p>

	<h2 class="mt-12 text-2xl font-semibold">Hard wax pilot</h2>
	<p class="mt-3">
		This no-strip pilot sits in the patent-informed lane: rosinate tack, EVA elasticity, paraffin for
		body, microcrystalline wax for flex, and a small oil fraction for spread. The first optimization
		target is a clean peel at the lowest useful application temperature.
	</p>

	<p class="mt-3">
		Patent worked-examples to anchor the pilot rather than guess. CN108379120A Ex.1: rosin 60% + hydrogenated
		rosin 10% + glyceryl hydrogenated rosinate 2% + EVA 7% + beeswax 10% + paraffin 10% + mineral oil 1%,
		softening point 38-42&nbsp;C, applied 25-45&nbsp;C. EP3009168A1 Ex.1: rosin ester 78.25% + beeswax 9.8% +
		paraffin 4.79% + styrene resin 4.26%, compounded at 120&nbsp;C. US10166178B2 Ex.2 (rosin-free hydrocarbon-resin
		route): hydrogenated C6-20 olefin resin 66.4% + paraffin 14% + microcrystalline 7.37% + EVA 6.23%. Note the
		manufacture-vs-use gap: these are blended hot (~120&nbsp;C) but designed to <em>apply</em> warm, gated by
		softening point, not by the melt temperature.
	</p>

	<DepilatoryHardWaxScaler />

	<h2 class="mt-12 text-2xl font-semibold">Strip wax pilot</h2>
	<p class="mt-3">
		Strip wax can be tackier because the cloth or nonwoven provides peel strength. It is a useful
		comparison formula because failures show up differently: too much tack grabs skin and leaves
		residue; too little tack polishes the hair and misses removal.
	</p>

	<p class="mt-3">
		The high rosinate level isn't an outlier: rosin-tackified PSAs reach commercial peel/tack at ~50&nbsp;wt% resin
		and depilatory patents run 60-85% resin, so a strip wax near the top of that band is normal PSA territory, not
		over-tackified. The cloth backing is precisely what lets you push tack that high — it supplies the peel
		strength a no-strip wax has to build internally with EVA.
	</p>

	<DepilatoryStripWaxScaler />

	<h2 class="mt-12 text-2xl font-semibold">Formulation knobs</h2>
	<div class="not-prose my-4 overflow-x-auto">
		<table class="w-full text-sm">
			<thead>
				<tr class="text-left text-surface-600 dark:text-surface-400">
					<th class="py-1 pr-3 font-medium">Knob</th>
					<th class="py-1 pr-3 font-medium">Screen</th>
					<th class="py-1 pr-3 font-medium">Effect</th>
					<th class="py-1 font-medium">Risk</th>
				</tr>
			</thead>
			<tbody>
				{#each formulationKnobs as row (row.knob)}
					<tr class="border-t border-surface-300 dark:border-surface-700">
						<td class="py-1 pr-3 font-medium">{row.knob}</td>
						<td class="whitespace-nowrap py-1 pr-3 font-mono">{row.range}</td>
						<td class="py-1 pr-3">{row.effect}</td>
						<td class="py-1">{row.risk}</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>

	<p class="mt-3">
		Resin is not a "more = stickier" knob — peel and tack have an optimum, then cohesion is sacrificed and peel
		drops. In a model SBS PSA, peel rose to ~27&nbsp;N/25mm at 40&nbsp;wt% resin and fell to ~15&nbsp;N/25mm at
		80&nbsp;wt%; in EVA hot-melts the T-peel peaks near ~70&nbsp;phr hydrogenated-rosin ester and the tackifier
		stops helping once blend Tg climbs above ~15&nbsp;C (coumarone-SBS study 2025; Park et&nbsp;al. 2020). So EVA has
		to rise alongside rosin or the wax smears. For tack selection, glyceryl (hydrogenated) rosinate softens at
		~80-90&nbsp;C and C5/C9 hydrocarbon resins span ~60-140&nbsp;C ring-and-ball; a higher softening point gives more
		cohesive, less skin-grabby tack but needs a hotter melt and more plasticizer to stay peelable.
	</p>

	<h2 class="mt-12 text-2xl font-semibold">Bench methodology</h2>
	<p class="mt-3">
		Use a staged test ladder. The first pass should produce numbers without involving skin:
		softening point, application temperature, drawdown thickness, set time, peel force, residue,
		and hair capture on a sacrificial swatch.
	</p>
	<ol class="mt-3 list-decimal space-y-2 pl-6">
		{#each benchProtocol as step}
			<li>{step}</li>
		{/each}
	</ol>

	<p class="mt-3">
		Correction to my own application window: 42-52&nbsp;C is a defensible conservative target and ~52&nbsp;C is a
		safety ceiling, but it sits low versus practice — professional hard-wax application runs nearer 51-57&nbsp;C
		(125-135&nbsp;F) at a thick-honey consistency, with the warmer set higher (~65&nbsp;C) to melt and then cooled
		before contact. 42&nbsp;C is below the spreadable range, so treat the low end as a stretch goal, not a typical
		pour. The lower bound is still patent-backed (CN108379120A applies at 25-45&nbsp;C; US20180028419A1 prefers
		45-55&nbsp;C).
	</p>

	<h3 class="mt-8 text-xl font-semibold">Multivariate screen</h3>
	<div class="not-prose my-4 overflow-x-auto">
		<table class="w-full text-sm">
			<thead>
				<tr class="text-left text-surface-600 dark:text-surface-400">
					<th class="py-1 pr-3 font-medium">Factor</th>
					<th class="py-1 pr-3 font-medium">Levels</th>
					<th class="py-1 font-medium">Response</th>
				</tr>
			</thead>
			<tbody>
				{#each testMatrix as row (row.factor)}
					<tr class="border-t border-surface-300 dark:border-surface-700">
						<td class="py-1 pr-3 font-medium">{row.factor}</td>
						<td class="py-1 pr-3">{row.levels}</td>
						<td class="py-1">{row.response}</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>

	<p class="mt-3">
		Design caveat, same as the chain track: resin, EVA, waxes, and plasticizer are <strong>mixture</strong>
		components — they sum to 100%, so raising one lowers the others and an ordinary factorial/RSM model on the
		composition rows isn't estimable. Screen composition with a mixture design (Scheffe simplex-lattice or
		simplex-centroid), keep the genuine process knobs (application temperature, film thickness, cooling rate) in
		factorial/RSM, and join them as a crossed mixture-process design (Scheffe 1958; Cornell 1990). Practically: a
		12-run Plackett-Burman on the process variables, then a mixture design on composition with replicated center
		points.
	</p>

	<h2 class="mt-12 text-2xl font-semibold">How I’d score a candidate</h2>
	<ul class="mt-3 list-disc space-y-2 pl-6">
		<li><strong>Pass 1: handling.</strong> Melts uniformly, spreads under 50&nbsp;C, no stringing beyond the spatula, peelable in under 45 seconds.</li>
		<li><strong>Pass 2: mechanics.</strong> Cohesive peel, no shattering, low residue mass, removes a fixed hair swatch cleanly.</li>
		<li><strong>Pass 3: skin gate.</strong> No burn sensation at measured temperature, no excess redness at 1 hour, no delayed reaction at 24-48 hours.</li>
		<li><strong>Pass 4: repeatability.</strong> Same batch passes after one week, one heat/cool cycle, and one deliberate overheat-recovery test.</li>
	</ul>

	<p class="mt-3">
		On "rip it fast": faster peel changes the rate regime, not the bond. Peel force scales with rate and angle and
		is dominated by viscoelastic dissipation inside the wax, not the bare interface — measured peel energies are
		~4&nbsp;J/m² against an interfacial work of adhesion near ~0.1&nbsp;J/m², roughly 40x amplification (Grzelka
		et&nbsp;al. 2022). A cold, stiff wax peels by brittle fracture (smears, breaks up); warm and slightly soft it
		peels viscously and cleanly. A fast pull selects the cleaner regime — it does not make the wax grip hair harder.
	</p>

	<h2 class="mt-12 text-2xl font-semibold">Safety rules</h2>
	<ul class="mt-3 list-disc space-y-2 pl-6">
		<li><strong>Thermometer required:</strong> wax warmers lie. Test the actual stirred wax before every application.</li>
		<li><strong>Patch test first:</strong> especially for rosin/colophony, fragrance, botanicals, beeswax/propolis, vitamin E, and colorants.</li>
		<li><strong>No compromised skin:</strong> avoid retinoids, isotretinoin history, sunburn, abrasions, eczema flares, bruising, or recently exfoliated skin.</li>
		<li><strong>No shared pot hygiene shortcuts:</strong> single-use spatulas, clean containers, and no double-dipping if any human testing starts.</li>
		<li><strong>Friend trials need consent:</strong> share ingredients, patch-test plan, temperature, and stop criteria before anyone volunteers skin.</li>
		<li><strong>The burn gate has numbers.</strong> Skin injury starts around 44&nbsp;C (hours of contact), but the damage rate climbs logarithmically to ~70&nbsp;C where injury is near-instant — so every degree past ~48&nbsp;C sharply cuts safe contact time, and wax behaves like a scald, not a dry touch (Martin &amp; Falder 2017; Moritz &amp; Henriques 1947). Application temperature <em>and</em> time-to-peel both belong in the matrix.</li>
		<li><strong>Why warmers lie, quantified.</strong> Unstirred microwave-heated depilatory wax was measured up to 108.5&nbsp;C, with 17 of 60 readings over 90&nbsp;C; stirring dropped the max to 65.7&nbsp;C (Lee et&nbsp;al., Burns 2011). Gate every application on an IR/probe reading of freshly stirred wax.</li>
		<li><strong>The standard patch test can miss your resin.</strong> Hydrogenation does lower rosin sensitization, but glyceryl/ester-modified rosins create new allergens (glyceryl monoabietate, maleopimaric acid) that the standard 20% colophony test routinely misses — patients react while testing negative (Gafvert 1994/96; Quain 2007). Patch-test the actual finished wax, not a store-bought rosin proxy.</li>
		<li><strong>Don't forget the non-rosin allergens.</strong> A 2024 product census found vitamin E (tocopherol) in 100% of post-wax products and color additives in 67% of online waxes, alongside colophony, botanicals, fragrance, and beeswax/propolis (George et&nbsp;al. 2024). Tocopherol and colorants deserve equal billing with rosin.</li>
	</ul>

	<h2 class="mt-12 text-2xl font-semibold">Sources</h2>
	<ul class="mt-3 space-y-2 text-sm text-surface-600 dark:text-surface-400">
		{#each sources as source (source.href)}
			<li>
				<a class="underline" href={source.href}>{source.title}</a>
				<span class="block">{source.note}</span>
			</li>
		{/each}
	</ul>
</main>
