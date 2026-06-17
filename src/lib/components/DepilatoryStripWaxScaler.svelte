<script lang="ts">
	import WeightScaler from './WeightScaler.svelte';

	const ingredients = [
		{
			item: 'Glyceryl rosinate',
			grams: 58.0,
			role: 'High-tack strip-wax adhesive resin'
		},
		{
			item: 'Hydrogenated rosin ester',
			grams: 10.0,
			role: 'Color/oxidation-stable tack; reduces raw-rosin variability'
		},
		{
			item: 'Mineral oil or CCT',
			grams: 13.0,
			role: 'Plasticizer; lowers peel force and residue hardness'
		},
		{
			item: 'White beeswax',
			grams: 7.0,
			role: 'Body and ductility; track allergen response separately'
		},
		{
			item: 'Microcrystalline wax',
			grams: 6.0,
			role: 'Cohesion and non-drip behavior'
		},
		{
			item: 'Paraffin wax',
			grams: 4.0,
			role: 'Hardness / set-speed trim'
		},
		{
			item: 'Polysorbate 80',
			grams: 1.0,
			role: 'Compatibility aid for tiny hydrophilic additions; optional'
		},
		{
			item: 'Titanium dioxide or mica',
			grams: 1.0,
			role: 'Film-thickness visual; optional'
		}
	];

	const presets = [
		{ factor: 1, label: '100 g trial', recommended: true },
		{ factor: 2.5, label: '250 g' },
		{ factor: 5, label: '500 g' }
	];

	const footnote =
		'Strip wax stays tackier and relies on cloth/nonwoven removal. Start with small forearm strips only. Rosinate level is intentionally high because hair grip is the main function; skin tolerance is the gating metric.';
</script>

<WeightScaler
	title="Strip wax pilot scaler"
	{ingredients}
	{presets}
	defaultFactor={1}
	totalLabel="Finished strip wax"
	{footnote}
/>
