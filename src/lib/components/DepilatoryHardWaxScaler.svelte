<script lang="ts">
	import WeightScaler from './WeightScaler.svelte';

	const ingredients = [
		{
			item: 'Glyceryl hydrogenated rosinate',
			grams: 36.0,
			role: 'Primary hair-grip tackifier; lighter and more oxidation-stable than raw rosin'
		},
		{
			item: 'Hydrogenated rosin',
			grams: 14.0,
			role: 'Raises tack and cohesive snap; main allergy watch item'
		},
		{
			item: 'EVA copolymer',
			grams: 9.0,
			role: 'Elastic film former so the strip can peel without cloth'
		},
		{
			item: 'Microcrystalline wax',
			grams: 13.0,
			role: 'Plastic, cohesive wax phase; improves low-temperature workability'
		},
		{
			item: 'Paraffin wax, 45-52 C melt range',
			grams: 16.0,
			role: 'Cheap crystalline body and hardness; screen against brittleness'
		},
		{
			item: 'White beeswax',
			grams: 5.0,
			role: 'Body, opacity, and ductility; propolis traces are an allergen variable'
		},
		{
			item: 'Mineral oil or CCT',
			grams: 6.0,
			role: 'Plasticizer / spread control; too much leaves residue'
		},
		{
			item: 'Titanium dioxide or mica',
			grams: 1.0,
			role: 'Visual read of film thickness; optional'
		}
	];

	const presets = [
		{ factor: 1, label: '100 g trial', recommended: true },
		{ factor: 2.5, label: '250 g' },
		{ factor: 5, label: '500 g' }
	];

	const footnote =
		'Hard/no-strip wax pilot derived from patent ranges, not a skin-safety claim. Use a thermometer, tiny patch tests, and arm-only trials first. Stop if adhesion to skin exceeds adhesion to hair.';
</script>

<WeightScaler
	title="Hard wax pilot scaler"
	{ingredients}
	{presets}
	defaultFactor={1}
	totalLabel="Finished hard wax"
	{footnote}
/>
