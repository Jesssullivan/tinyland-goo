<script lang="ts">
	import { base } from '$app/paths';
	import SEOHead from '$lib/components/SEOHead.svelte';
	import ChainWaxEmulsionScaler from '$lib/components/ChainWaxEmulsionScaler.svelte';
	import ChainWaxHotMeltScaler from '$lib/components/ChainWaxHotMeltScaler.svelte';

	const additiveMap = [
		{
			additive: 'Plain paraffin',
			range: 'control',
			why: 'Low static friction, no viscous drag, sheds grit instead of wetting it.',
			watch: 'Brittle flaking, poor wet durability, and chain prep sensitivity.'
		},
		{
			additive: 'WS2',
			range: '1.0 wt% (primary)',
			why: 'Down-select winner and commercial SOTA (Silca is WS2-only): finest dense sulfide on hand, more oxidation-robust than MoS2.',
			watch: 'WS2 is itself humidity-sensitive (boundary COF rises ~2-4x dry to humid), and there is zero peer-reviewed WS2-in-wax data — validate, do not assume.'
		},
		{
			additive: 'MoS2',
			range: 'control arm only',
			why: 'Dropped from the production blend; kept as a MoS2-only control so the drop is measured, not asserted.',
			watch: 'Most humidity/oxidation-sensitive sulfide, coarsest/least-pure powder on hand; no wax-matrix dose-response exists, so oil/vacuum wins may not transfer to a wet chain.'
		},
		{
			additive: 'hBN',
			range: '≤1 wt% (co-solid)',
			why: 'Kept as the distinct hedge: water/oxidation-inert (friction often drops with water), Pickering-friendly for the emulsion, white and inspectable.',
			watch: 'Clearest null/negative literature of the trio above ~1 wt%; hard to wet, needs a dispersant; weaker as a primary friction reducer.'
		},
		{
			additive: 'Graphene / rGO',
			range: '0.01-0.2 wt%',
			why: 'Very low optimum levels show up in oil tribology papers; useful as a high-upside micro-dose axis.',
			watch: 'Dispersion is the whole game; agglomerates become grit.'
		},
		{
			additive: 'PTFE',
			range: 'avoid first',
			why: 'It is the old fast-wax additive and a good literature comparison point.',
			watch: 'PFAS/microplastic baggage; keep the first Tinyland wax line PFAS-free unless data forces a control.'
		}
	];

	const experimentMatrix = [
		{
			factor: 'Wax matrix',
			levels: 'plain paraffin / +4% microcrystalline / +2% FT or PE wax',
			response: 'shed rate, residue mass, articulation force, dry contamination pickup'
		},
		{
			factor: 'Solid additive',
			levels: 'none (control) / WS2+hBN (lead) / WS2-only / MoS2-only (control) / +IF-WS2 arm',
			response: 'drivetrain loss proxy, chain wear, dark residue/stain, post-rain survival, rust'
		},
		{
			factor: 'Additive loading',
			levels: '0.25 / 0.75 / 1.5 / 3.0 wt%',
			response: 'friction proxy vs abrasive/agglomerate penalty'
		},
		{
			factor: 'Application route',
			levels: 'hot immersion / hot immersion + drip top-up / emulsion only',
			response: 'penetration, cure time, grams retained, reapplication interval'
		},
		{
			factor: 'Contamination challenge',
			levels: 'clean dry / road dust / wet rinse / dust-after-wet',
			response: 'wear acceleration and noise return, not just fresh-chain smoothness'
		}
	];

	const measurementProtocol = [
		'Strip factory grease completely; weigh the dry chain before treatment.',
		'Apply wax, hang, break links free, then weigh again for retained lubricant mass.',
		'Run a fixed 30 minute indoor break-in before measuring anything.',
		'Measure articulation drag with a hanging-weight or small motor pull fixture before moving to a power rig.',
		'Use a bicycle-specific wear sequence: no cleaning during the main block, fixed relube intervals, fixed contamination dose.',
		'Record chain elongation with a proper gauge plus mass loss, roller noise, and photos of residue at every interval.',
		'Keep chain model, cassette, chainring, cadence, load, and ambient humidity locked across the screen.'
	];

	const emulsionProcess = [
		'Heat the wax phase and water phase separately to 75-85 C, above the highest wax melt point.',
		'Pre-mix wax into the hot surfactant water with propeller or rotor-stator mixing until it is milky and uniform.',
		'Sonicate in short bursts with cooling pauses; target sub-micron droplets before chasing additives.',
		'Cool while gently stirring through the wax crystallization range so droplets solidify before creaming.',
		'Screen stability by jar photos, centrifuge/heat-cool cycles, residue mass after drying, and chain penetration.',
		'Only then add hBN (lead) and optional low-dose WS2, repeating droplet/stability checks; keep MoS2 out and treat de-agglomeration as a separate target from droplet stabilization.'
	];

	const sources = [
		{
			title: 'Jadhav et al., Ultrasound assisted manufacturing of paraffin wax nanoemulsions (Ultrason. Sonochem. 2015)',
			href: 'https://doi.org/10.1016/j.ultsonch.2014.10.024',
			note: '160.9 nm paraffin droplets; 15 min at 0.61 W/mL; >3 month stability — stabilized by modified SDS (anionic), not a Tween/Span blend.'
		},
		{
			title: 'ICI, The HLB System',
			href: 'https://www.scientificspectator.com/documents/personal%20care%20spectator/The%20HLB%20Book%20ICI.pdf',
			note: 'Required HLB ~10 for fluid O/W paraffin emulsions.'
		},
		{
			title: 'Gonen, Influence of silica nanoparticles on paraffin wax emulsion stability',
			href: 'https://eds.yildiz.edu.tr/AjaxTool/GetArticleByPublishedArticleId?PublishedArticleId=6862',
			note: 'Summarizes HLB 9.5-10.3 paraffin screens and ultrasound stability literature.'
		},
		{
			title: 'Zero Friction Cycling lubricant testing',
			href: 'https://zerofrictioncycling.com.au/lubetesting/',
			note: 'Bicycle-specific wear protocol; no chain cleaning during the main test.'
		},
		{
			title: 'Zero Friction Cycling chain-lubricant results PDF',
			href: 'https://zerofrictioncycling.com.au/wp-content/uploads/2024/09/Chain-Lubricant-Results-Sept-Aug-2024b.pdf',
			note: 'Like-for-like load, interval, and contamination framing.'
		},
		{
			title: 'Friction Facts UltraFast formula via BikeRadar',
			href: 'https://www.bikeradar.com/news/friction-facts-publishes-ultrafast-chain-lube-formula',
			note: 'Historical paraffin + PTFE + MoS2 home formula and ultrasonic tank workflow.'
		},
		{
			title: 'Zero Friction Cycling Molten Speed Wax review',
			href: 'https://zerofrictioncycling.com.au/wp-content/uploads/2017/12/MSW.pdf',
			note: 'Explains why chain articulation favors solid wax over viscous wet lubricant.'
		},
		{
			title: 'SILCA Secret Chain Blend',
			href: 'https://silca.cc/products/secret-chain-wax-blend',
			note: 'Commercial SOTA signal: paraffin plus multiple sizes of nano-scale WS2; no PFAS.'
		},
		{
			title: 'CeramicSpeed UFO application FAQ',
			href: 'https://ceramicspeed.com/pages/ufo-family-application-and-faq',
			note: 'Drip coating mass, overnight cure, and wet-condition reapplication guidance.'
		},
		{
			title: 'Graphene-family lubricant additive review',
			href: 'https://www.mdpi.com/2075-4442/10/9/215',
			note: 'Low-dose graphene/rGO mechanisms, tribofilm questions, and dispersion limits.'
		},
		{
			title: 'hBN/TiO2 water-based nanolubricant study',
			href: 'https://www.mdpi.com/2075-4442/12/4/123',
			note: 'hBN dispersion and synergistic nanoparticle test design, not bicycle-specific.'
		},
		{
			title: 'Nanolubricant additives review',
			href: 'https://link.springer.com/article/10.1007/s40544-020-0450-8',
			note: 'Broad additive map for WS2, MoS2, graphene, PTFE, and other nano-additives.'
		},
		{
			title: 'Spicer et al., Effects of Frictional Loss on Bicycle Chain Drive Efficiency (J. Mech. Des. 2001)',
			href: 'https://doi.org/10.1115/1.1412848',
			note: 'Peer-reviewed anchor: clean-lab efficiency 80.9-98.6% set by tension/sprocket size, not lube state; non-thermal meshing losses dominate.'
		},
		{
			title: 'Spicer, Nonlinear Elastic Behavior of Bicycle Chain on Transmission Efficiency (J. Appl. Mech. 2013)',
			href: 'https://doi.org/10.1115/1.4007431',
			note: 'Models the dominant loss as elastic pin-bushing contact scaling ~1/tension — why reaching the articulating interface matters.'
		},
		{
			title: 'In The Know Cycling — Chain Wax: Faster, Better, Cheaper (Friction Facts/VeloNews 250 W data)',
			href: 'https://intheknowcycling.com/chain-wax-faster-better-and-cheaper/',
			note: 'Accessible reproduction of the primary watt numbers: paraffin 0.24 W faster clean, ~2.5 W faster after dirt/sand/water.'
		},
		{
			title: 'CyclingAbout — Best Bike Chain Lubes According To Science (Zero Friction Cycling 5000 km data)',
			href: 'https://www.cyclingabout.com/best-bike-chain-lubes-according-to-science/',
			note: 'Source of the 2.6x-14.7x chains-worn wear multiples and the cyclocross field figures.'
		},
		{
			title: 'Hu et al., Tribological Properties of Different Morphology WS2 as Lubricant Additives (Materials 2020)',
			href: 'https://doi.org/10.3390/ma13071522',
			note: 'Primary: lamellar WS2 -29.35% COF (100 N), spherical -30.24% (120 N) at 1.5 wt% in PAO6, steel/steel.'
		},
		{
			title: 'Niste & Ratoi et al., Self-lubricating Al-WS2 composites (Sci. Rep. 2017)',
			href: 'https://doi.org/10.1038/s41598-017-15297-6',
			note: 'WS2 works in both dry and humid conditions with high-temperature resistance; 2H-WS2 -30%, IF-WS2 -20% COF.'
		},
		{
			title: 'Nagarajan et al., MoS2 nanoparticles as nano-additives in engine oil (Sci. Rep. 2022)',
			href: 'https://doi.org/10.1038/s41598-022-16026-4',
			note: 'MoS2 oil-additive optimum is 0.01 wt% (-19.24% COF); degrades to -2% by 0.1 wt% via agglomeration. Recalibrates the MoS2 range.'
		},
		{
			title: 'Sikdar, Rahman & Menezes, Solid Lubricant Nano-Additives in Canola Oil (Sustainability 2021)',
			href: 'https://doi.org/10.3390/su14010290',
			note: 'hBN minimum COF at 1.0 wt% (-40%); brackets the page hBN window.'
		},
		{
			title: 'Patel & Kiani, rGO at Different Concentrations on Tribological Properties (Lubricants 2019)',
			href: 'https://doi.org/10.3390/lubricants7020011',
			note: 'rGO optimum 0.05 wt% (wear -51.85%); 0.1 wt% worse — the agglomeration-limited basis for a graphene micro-dose.'
		},
		{
			title: 'Dou et al., Self-dispersed crumpled graphene balls in oil (PNAS 2016)',
			href: 'https://doi.org/10.1073/pnas.1520994113',
			note: 'Flat rGO restacks and fully sediments within ~20 h; crumpled balls resist aggregation. Evidence the low graphene dose is dispersion-limited.'
		},
		{
			title: 'Lindner et al., HLB, Surfactant, Particle Size and Stability of Wax Dispersions (Coatings 2018)',
			href: 'https://doi.org/10.3390/coatings8120469',
			note: 'Measured wax-in-water HLB optimum 11-13.5; Tween 20/Span 20 beat Tween 80/Span 80. Supports raising the HLB target above 10.'
		},
		{
			title: 'Onaizi, SDBS-Stabilized Crude Oil/Water Nanoemulsions (Nanomaterials 2022)',
			href: 'https://doi.org/10.3390/nano12101673',
			note: 'Anionic SDBS gives zeta -62 mV and >1 month stability — quantifies the charge/creaming link for the SDS/SDBS lane.'
		},
		{
			title: 'Zhang, Niu & Wu, Silicon-nanoparticle-embedded PCM-in-water emulsions (Appl. Energy 2019)',
			href: 'https://doi.org/10.1016/j.apenergy.2019.01.159',
			note: 'SiO2/silicon nanoparticles improve stability and act as nucleating agents — counters the blanket "particles destabilize" framing.'
		},
		{
			title: 'Cornell, Embedding Mixture Experiments inside Factorial Experiments (J. Qual. Technol. 1990)',
			href: 'https://doi.org/10.1080/00224065.1990.11979258',
			note: 'Canonical mixture-process design reference; basis for treating composition rows as a mixture crossed with process variables.'
		},
		{
			title: 'Joly-Pottuz, Dassenoy et al., Ultralow-friction and wear properties of IF-WS2 under boundary lubrication (Tribol. Lett. 2005)',
			href: 'https://doi.org/10.1007/s11249-005-3607-8',
			note: 'The actual primary source of the IF-WS2 COF <0.04 figure (PAO oil, smooth contact, ~0.83 GPa) — usually misattributed to Rapoport. An oil/smooth-contact best case that does not transfer to a wax film.'
		},
		{
			title: 'Prasad, McDevitt & Zabinski, Tribology of tungsten disulfide films in humid environments (Wear 1999)',
			href: 'https://doi.org/10.1016/S0043-1648(99)00082-4',
			note: 'WS2 COF ~0.04 in dry N2 rises to 0.10-0.15 at ~60% RH — WS2 is itself humidity-sensitive, so the moisture hedge is hBN, not WS2.'
		},
		{
			title: 'Zhang, Mo, Lv & Wang, WS2 Nanoparticles as Additives in Calcium Sulfonate Complex-Polyurea Grease (Lubricants 2023)',
			href: 'https://doi.org/10.3390/lubricants11060259',
			note: 'Closest non-oil analog: 2 wt% WS2 in grease cut COF only ~14.94% but raised max non-seizure load +31.41% — modest friction, real extreme-pressure benefit.'
		},
		{
			title: 'Sahoo & Biswas, Deformation and friction of MoS2 particles in liquid suspensions (Thin Solid Films 2010)',
			href: 'https://doi.org/10.1016/j.tsf.2010.05.127',
			note: '~2 µm MoS2 formed a better homogeneous low-friction transfer film and stayed in contact where ~50 nm could not — "finer always wins" is not a clean law.'
		},
		{
			title: 'Pena-Paras & Martini et al., Substrate roughness and nano/micro particle size on friction and wear (Tribol. Int. 2018)',
			href: 'https://doi.org/10.1016/j.triboint.2017.09.009',
			note: 'Optimal additive size is intermediate (~165 nm) and matched to surface roughness via valley-filling, not the absolute smallest particle.'
		}
	];
</script>

<SEOHead
	title="tinyland-goo — chain wax additive + ultrasonic emulsion research"
	description="PFAS-free bike chain wax research: a paraffin hot-melt + ultrasonic emulsion recipe, a WS2 + hBN solid-lubricant down-select, interactive batch scalers, and primary-source tribology notes."
	ogType="article"
	jsonLd={{
		'@context': 'https://schema.org',
		'@type': 'TechArticle',
		headline: 'PFAS-free bike chain wax: WS2 + hBN additive down-select',
		description:
			'Paraffin hot-melt and ultrasonic-emulsion chain-wax recipes with a WS2 + hBN solid-lubricant down-select and primary-source tribology notes.'
	}}
/>

<main class="prose-body mx-auto max-w-3xl px-6 py-12 md:py-16">
	<p class="text-xs uppercase tracking-widest text-surface-500">Tinyland · wax lab</p>
	<h1 class="mt-2 text-4xl font-bold leading-tight md:text-5xl">
		Bike chain wax as a <span class="text-primary-600">measured tribology project</span>
	</h1>
	<p class="mt-4 text-xl text-surface-700 dark:text-surface-300">
		A research track for paraffin chain waxes, PFAS-free solid additives, ultrasonic
		wax-in-water emulsions, and multivariate test design. The goal is not a magic powder;
		it is a repeatable path to lower friction, lower wear, cleaner chains, and honest null results.
	</p>
	<p class="mt-4 text-sm">
		<a class="underline" href={`${base}/`}>Back to UV bed glue</a> ·
		<a class="underline" href={`${base}/hair-removal-wax`}>Hair removal wax track</a>
	</p>

	<h2 class="mt-12 text-2xl font-semibold">Working hypothesis</h2>
	<p class="mt-3">
		Chain lubrication is weird because the chain does not spin like a bearing. It articulates,
		loads, unloads, and does that tens of thousands of times per minute. A clean solid wax can win
		because it has low static friction, near-zero viscous drag, and does not wet road grit the way
		oil does. The SOTA direction is therefore:
	</p>
	<ul class="mt-3 list-disc space-y-2 pl-6">
		<li><strong>Hot immersion first</strong> for true penetration into pins, rollers, and plates.</li>
		<li><strong>PFAS-free additive screens</strong> centered on WS2, hBN, and very low-dose graphene/rGO.</li>
		<li><strong>Wax emulsion as a top-up or convenience route</strong>, not a replacement until it proves penetration and durability.</li>
		<li><strong>Wear plus contamination as the real target</strong>; fresh-chain watt deltas alone are too easy to fool.</li>
	</ul>

	<p class="mt-3">
		Honesty calibration before any of this. In a clean lab rig, lubricant choice barely moves watts:
		Spicer et&nbsp;al. (2001) measured chain efficiency from 80.9% at 76&nbsp;N tension to 98.6% at
		305&nbsp;N — set by tension and sprocket size, with wax, synthetic oil, dry spray, and even no lube
		reading essentially the same; the unaccounted loss is non-thermal meshing, not friction. The wax
		case is almost entirely about contamination and wear, which is exactly why fresh-chain watt deltas
		are easy to fool.
	</p>
	<ul class="mt-3 list-disc space-y-2 pl-6">
		<li><strong>Clean-rig efficiency is lube-agnostic</strong> (80.9-98.6%, set by tension and sprocket size; Spicer et&nbsp;al. 2001). The unexplained loss is meshing, not lubrication.</li>
		<li><strong>The clean-chain wax win is sub-watt.</strong> A clean chain dissipates only ~3-4&nbsp;W at 250&nbsp;W, and Friction Facts measured plain paraffin just 0.24&nbsp;W faster than the best PTFE-additive oil; the gap widens to ~2.5&nbsp;W only after dirt/sand/water.</li>
		<li><strong>The real prize is wear.</strong> Zero Friction Cycling's 5000&nbsp;km contamination extrapolation puts top wax/wax-blend lubes at 2.6x (extreme wet) to ~14.7x (dry) fewer chains worn than an oil baseline.</li>
	</ul>

	<h2 class="mt-12 text-2xl font-semibold">Hot-melt screening blend</h2>
	<p class="mt-3">
		This is the first pot I would make after the plain-paraffin control. It deliberately avoids PTFE and is
		down-selected to two non-redundant solids — WS2 as the primary lamellar lubricant and hBN as the
		humidity-inert hedge — with MoS2 dropped to a measured control arm rather than carried in the blend.
	</p>

	<ChainWaxHotMeltScaler />

	<h3 class="mt-8 text-xl font-semibold">Immersion workflow</h3>
	<ol class="mt-3 list-decimal space-y-2 pl-6">
		<li>Deep-clean the chain until solvent comes out clear; dry fully before wax ever touches it.</li>
		<li>Melt the wax at 85-95&nbsp;C, high enough to stay fluid but far below smoking/overheat territory.</li>
		<li>Stir powders in as a slurry; keep stirring during chain immersion because dense additives settle.</li>
		<li>Preheat the chain, submerge, agitate, and hold until bubbles stop coming from the links.</li>
		<li>Hang to cool, flex every link free, then run in under light load before testing.</li>
	</ol>

	<h3 class="mt-8 text-xl font-semibold">Why immersion, mechanically</h3>
	<p class="mt-3">
		A roller chain doesn't spin like a bearing. Under tension each inner plate articulates about the
		pin/bushing through a small angle as it engages a sprocket, in boundary/mixed lubrication, and
		Spicer's follow-up (2013) models the dominant loss as elastic pin-bushing contact scaling
		~1/tension. Lubricant only helps if it reaches that interface — which a hot bath does and a wiped-on
		surface film mostly doesn't. (Bigger sprockets and higher tension cut the articulation angle, which
		is why they read faster on the rig.)
	</p>

	<h2 class="mt-12 text-2xl font-semibold">Additive map</h2>
	<div class="not-prose my-4 overflow-x-auto">
		<table class="w-full text-sm">
			<thead>
				<tr class="text-left text-surface-600 dark:text-surface-400">
					<th class="py-1 pr-3 font-medium">Additive</th>
					<th class="py-1 pr-3 font-medium">Start</th>
					<th class="py-1 pr-3 font-medium">Why test</th>
					<th class="py-1 font-medium">Failure mode</th>
				</tr>
			</thead>
			<tbody>
				{#each additiveMap as row (row.additive)}
					<tr class="border-t border-surface-300 dark:border-surface-700">
						<td class="py-1 pr-3 font-medium">{row.additive}</td>
						<td class="whitespace-nowrap py-1 pr-3 font-mono">{row.range}</td>
						<td class="py-1 pr-3">{row.why}</td>
						<td class="py-1">{row.watch}</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>

	<p class="mt-3">
		Calibrating the down-select against primary tribology — and flagging where the headline numbers were
		walked back by adversarial verification. The decisive caveat first: there is <strong>no peer-reviewed
		WS2-in-wax tribology at all</strong>. Every number below is oil-, grease-, or coating-matrix, so this blend
		is an engineering extrapolation to bench-validate, not a measured wax result.
	</p>
	<ul class="mt-3 list-disc space-y-2 pl-6">
		<li><strong>WS2 — keep as the primary, but de-hype it.</strong> The dazzling IF-WS2 &lt;0.04 COF is an oil/smooth-contact/0.83&nbsp;GPa best case (Joly-Pottuz et&nbsp;al. 2005, <em>not</em> the often-cited Rapoport papers), and a paraffin+IF composite only reached ~0.05; the "~2.5x finer-wins" gap is a single-study outlier (independent data show ~5%). In grease — the closest non-oil analog — WS2 cut COF only ~15% (Zhang et&nbsp;al. 2023). WS2 is also <em>not</em> moisture-proof: its boundary COF rises ~2-4x dry to humid via O-H...S hydrogen bonding (Prasad et&nbsp;al. 1999). It still wins the sulfide slot on oxidation robustness and commercial track record.</li>
		<li><strong>MoS2 — drop first, for the right reasons.</strong> Not primarily "redundant" (that claim is weak): drop it because it is the <em>most</em> humidity-sensitive sulfide (wrong failure mode for a wet, gritty chain), the coarsest (1.3&nbsp;µm) and least-pure powder on hand, and lower in oxidation onset than WS2 — the ranking holds even though the old 350-vs-540&nbsp;°C delta was overstated and one citation was misattributed to a NASA vacuum study. "Coarse loses" is itself not clean: micron MoS2 can build a <em>better</em> transfer film (Sahoo &amp; Biswas 2010; optimum ~165&nbsp;nm, roughness-matched, Pena-Paras &amp; Martini 2018). With no peer-reviewed MoS2-in-wax dose-response to lean on, it stays a control arm rather than a production row.</li>
		<li><strong>hBN — keep as the hedge, not the hero.</strong> It earns its place by being mechanistically distinct: water/oxidation-inert (its friction often <em>drops</em> with water), a near-ideal Pickering particle for the emulsion route, and white/inspectable. But it carries the clearest null/negative literature of the trio (no benefit above ~1&nbsp;wt% in several greases, raised COF in paraffinic oil), so it is pinned ≤1&nbsp;wt% as the anti-wear/weather leg, not the primary friction reducer.</li>
		<li><strong>Graphene/rGO — micro-dose, dispersion-limited.</strong> rGO optimized near 0.05&nbsp;wt% (wear ~52% lower; 0.1&nbsp;wt% was worse, Patel &amp; Kiani 2019). The low optimum is a dispersion property: flat rGO restacks and fully sediments within ~20&nbsp;h (Dou et&nbsp;al. 2016, PNAS), and the optimum climbs toward ~0.7-1&nbsp;wt% in viscous carriers.</li>
	</ul>

	<h2 class="mt-12 text-2xl font-semibold">Mixing and dispersion technique</h2>
	<p class="mt-3">
		Going from three solids to two is partly a dispersion decision: each powder needs its own surfactant,
		sonication optimum, and specific-energy target, so co-dispersing three means no single setpoint is right
		for any. The SOTA moves for getting sub-micron solids into wax and keeping them there:
	</p>
	<ul class="mt-3 list-disc space-y-2 pl-6">
		<li><strong>Probe, not bath.</strong> Dense sub-micron sulfides have strong van der Waals attraction; tip sonication delivers the intensity to de-agglomerate them. Bath sonication is only enough for the lighter hBN.</li>
		<li><strong>Dose by delivered energy (J/mL), not by time.</strong> Dense WS2 sediments <em>during</em> sonication, so wall-clock time misrepresents the dose. Calibrate and log J/mL per powder — one powder, one target, far better batch reproducibility.</li>
		<li><strong>Find the optimum, then stop.</strong> Stability and dispersion peak and then fall with excess sonication (heat-driven re-aggregation, particle fracture).</li>
		<li><strong>Functionalize the sulfide.</strong> Oleic acid or PVP measurably shrinks WS2 agglomerates; PVP gave the most homogeneous distribution in the literature — and PVP is already a house ingredient here.</li>
		<li><strong>Lock particles in on cooling.</strong> Add a metal-stearate dispersant for redispersibility and use a fast quench so the dense particles freeze in place before they cream; interfacial self-assembly partitions lamellar platelets toward the wax surface, where the film needs them.</li>
		<li><strong>Three-roll mill the hot-melt.</strong> Sonication alone leaves clumps that re-agglomerate; a high-shear mill pass physically locks platelets into the wax and is the step that delivers the wear benefit.</li>
		<li><strong>Quantify, don't eyeball.</strong> Track agglomerate size by DLS/laser diffraction and report agglomeration reduction separately from dispersion homogeneity — wear benefit tracks the latter.</li>
	</ul>

	<h2 class="mt-12 text-2xl font-semibold">Ultrasonic emulsion track</h2>
	<p class="mt-3">
		The useful emulsion question is not "can I make milky wax water?" It is whether the dried residue
		gets inside the chain, survives contamination, and tops up an immersion-waxed chain without becoming
		tacky dirt glue. Two corrections worth carrying from the literature. First, the verified benchmark —
		Jadhav et&nbsp;al. (2015): ~160.9&nbsp;nm paraffin droplets from 15&nbsp;min probe sonication at
		0.61&nbsp;W/mL, stable &gt;3&nbsp;months — was stabilized by <strong>modified SDS (anionic, ~10&nbsp;mg/mL),
		not a Tween/Span blend</strong>, so the sub-micron result came from electrostatic, not steric,
		stabilization (anionic surfactant drives the droplet charge strongly negative, past ~-30&nbsp;mV, and
		resists creaming for months). Second, on HLB: aim a touch <em>higher</em> than 10 — the required HLB
		for a fluid O/W paraffin is a band, roughly 10-13.5, and shorter-tail pairs (Tween&nbsp;20/Span&nbsp;20)
		beat oleate pairs at equal HLB (Lindner et&nbsp;al. 2018). Treat HLB&nbsp;10 as the low edge, not the target.
	</p>

	<ChainWaxEmulsionScaler />

	<h3 class="mt-8 text-xl font-semibold">Process ladder</h3>
	<ol class="mt-3 list-decimal space-y-2 pl-6">
		{#each emulsionProcess as step}
			<li>{step}</li>
		{/each}
	</ol>

	<p class="mt-3">
		One caveat on the last step: "particles can destabilize the emulsion" is only conditionally true. In
		phase-change-material O/W emulsions, silica/silicon nanoparticles usually <em>improve</em> stability and
		double as nucleating agents (Zhang et&nbsp;al. 2019); destabilization mainly shows up with excess
		loading or charged clay-type particles that bridge droplets. So screen each WS2/hBN addition for
		droplet-size and zeta change, but expect a regime, not an automatic penalty.
	</p>

	<h3 class="mt-8 text-xl font-semibold">What to measure before riding it</h3>
	<ul class="mt-3 list-disc space-y-2 pl-6">
		<li><strong>Droplet size:</strong> microscope first, DLS later. Big wax chunks are not a drip lube.</li>
		<li><strong>Creaming:</strong> daily jar photos against a ruler, plus one warm/cold cycle.</li>
		<li><strong>Residue:</strong> grams retained on a coupon and on a chain after a fixed dry time.</li>
		<li><strong>Penetration:</strong> split a sacrificial quick link or cleaned chain section after dyeing the wax phase.</li>
		<li><strong>Water sensitivity:</strong> mist/rinse after cure, dry, then weigh residue loss and inspect noise return.</li>
	</ul>

	<h2 class="mt-12 text-2xl font-semibold">Multivariate method</h2>
	<p class="mt-3">
		Start with a fractional factorial screen, then do response-surface work only on surviving factors.
		The first phase should answer "which knobs matter?" not "what is the perfect recipe?"
	</p>
	<p class="mt-3">
		One structural fix first: the composition rows (the wax-matrix split and the additive wt%) are a
		<strong>mixture</strong> — they sum to 100%, so the proportions are linearly dependent and an ordinary
		factorial/RSM model with an intercept isn't estimable. Use a mixture design (simplex-lattice or
		simplex-centroid, Scheffe polynomials) for the formulation factors, keep the genuine process knobs
		(immersion temperature, sonication time, cooling rate, contamination dose) in the factorial/RSM track,
		and join them as a crossed mixture-process design (Cornell 1990). Concretely: a Plackett-Burman screen
		(~12 runs) on the process variables, then Box-Behnken on the survivors with replicated center points —
		not one factorial-then-RSM pipeline stretched across composition too.
	</p>
	<p class="mt-3">
		Sequence the work so the down-select is <em>measured</em>, not asserted. Qualify dispersion first — sweep
		specific energy and dispersant and screen agglomerate size and settling <strong>before</strong> any
		tribology; that gate alone may eliminate MoS2 on settling grounds. Then run the solid-system screen in the
		real wax matrix with the controls that keep it honest: a no-solid arm, a MoS2-only arm, and — since
		closed-cage IF-WS2 behaves differently than platelets — an IF-WS2 arm. Make the contamination/humidity
		block the gating test rather than fresh-chain smoothness, and add dark-residue/stain and post-wet rust to
		the response set. The additive's real job is wear and weather, and the whole solid package may buy only
		~0.14&nbsp;W over plain paraffin, so the controls have to be able to say "the additives didn't pay."
	</p>

	<div class="not-prose my-4 overflow-x-auto">
		<table class="w-full text-sm">
			<thead>
				<tr class="text-left text-surface-600 dark:text-surface-400">
					<th class="py-1 pr-3 font-medium">Factor</th>
					<th class="py-1 pr-3 font-medium">Levels</th>
					<th class="py-1 font-medium">Primary response</th>
				</tr>
			</thead>
			<tbody>
				{#each experimentMatrix as row (row.factor)}
					<tr class="border-t border-surface-300 dark:border-surface-700">
						<td class="py-1 pr-3 font-medium">{row.factor}</td>
						<td class="py-1 pr-3">{row.levels}</td>
						<td class="py-1">{row.response}</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>

	<h3 class="mt-8 text-xl font-semibold">Minimum viable protocol</h3>
	<ol class="mt-3 list-decimal space-y-2 pl-6">
		{#each measurementProtocol as step}
			<li>{step}</li>
		{/each}
	</ol>

	<p class="mt-3">
		Two notes that keep this honest. Factory grease genuinely blocks wax adhesion and penetration into
		the pin/bushing, so the strip-clean step is a prerequisite, not folklore. And because clean-chain
		watt deltas barely separate good lubes (sub-1&nbsp;W), the wear block is what does the separating: run
		it with no cleaning at a fixed contamination dose and measure elongation and contamination handling,
		the way Zero Friction Cycling's protocol does — that is where the 2.6-15x wear spread lives.
	</p>

	<h2 class="mt-12 text-2xl font-semibold">Safety</h2>
	<ul class="mt-3 list-disc space-y-2 pl-6">
		<li><strong>Powders:</strong> WS2, MoS2, hBN, graphene, and PTFE-class powders are inhalation hazards. Use a respirator, gloves, wet cleanup, and no compressed air.</li>
		<li><strong>Hot wax:</strong> use temperature control and a dedicated pot. Never overheat PTFE-containing legacy controls.</li>
		<li><strong>Ultrasound:</strong> use hearing protection/enclosure, cool the vessel, and do not sonicate flammable solvent blends.</li>
		<li><strong>Road use:</strong> test braking-area contamination separately. Keep every wax, oil, and cleaner away from disc rotors and pads.</li>
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
