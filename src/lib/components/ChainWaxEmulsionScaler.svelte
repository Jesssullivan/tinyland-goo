<script lang="ts">
	import WeightScaler from './WeightScaler.svelte';

	const ingredients = [
		{
			item: 'Fully refined paraffin wax',
			grams: 18.0,
			role: 'Main dry film former after water evaporates'
		},
		{
			item: 'Microcrystalline wax',
			grams: 3.0,
			role: 'Adds flexibility and metal hold; too much raises tack'
		},
		{
			item: 'Fischer-Tropsch or PE wax',
			grams: 2.0,
			role: 'Hardness / melt-point modifier for a cleaner dry coating'
		},
		{
			item: 'WS2 or hBN additive pack',
			grams: 0.75,
			role: 'Sub-micron solid lubricant; keep low until dispersion is proven'
		},
		{
			item: 'Nonionic surfactant blend, HLB ~11-13',
			grams: 4.5,
			role: 'Paraffin O/W emulsifier band is ~10-13.5 (not a sharp 10); short-tail Tween 20/Span 20 beats oleate pairs'
		},
		{
			item: 'SDS or SDBS (anionic emulsifier)',
			grams: 0.25,
			role: 'Primary lane, not optional: the verified 160.9 nm paraffin nanoemulsion used modified SDS alone (~10 mg/mL) for a strong negative zeta'
		},
		{
			item: 'Distilled water',
			grams: 71.5,
			role: 'Continuous phase; boil/degas first for cleaner sonication'
		}
	];

	const presets = [
		{ factor: 1, label: '100 g trial', recommended: true },
		{ factor: 2.5, label: '250 g' },
		{ factor: 5, label: '500 g' }
	];

	const footnote =
		'23.75 wt% wax/additive solids. Make hot above the wax melt range, pre-emulsify mechanically, then sonicate in short cooled bursts. Treat as a lab prototype: measure droplet size, creaming, residue mass per chain, cure time, and water sensitivity before road use.';
</script>

<WeightScaler
	title="Ultrasonic wax emulsion scaler"
	{ingredients}
	{presets}
	defaultFactor={1}
	totalLabel="Finished emulsion"
	{footnote}
/>
