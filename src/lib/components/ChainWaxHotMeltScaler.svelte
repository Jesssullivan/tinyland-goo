<script lang="ts">
	import WeightScaler from './WeightScaler.svelte';

	const ingredients = [
		{
			item: 'Fully refined paraffin wax',
			grams: 91.5,
			role: 'Low-oil crystalline base; the default clean-running chain carrier'
		},
		{
			item: 'Microcrystalline wax',
			grams: 4.0,
			role: 'Toughness and adhesion so the wax film is less brittle'
		},
		{
			item: 'Fischer-Tropsch or PE wax',
			grams: 2.0,
			role: 'Hardness / melt-point modifier; screen lower if the chain sheds flakes'
		},
		{
			item: 'Tungsten disulfide, sub-micron',
			grams: 1.0,
			role: 'PFAS-free lamellar solid lubricant; the primary additive screen'
		},
		{
			item: 'Hexagonal boron nitride, sub-micron',
			grams: 1.0,
			role: 'White/inert lamellar solid; useful contrast to black sulfides'
		},
		{
			item: 'Molybdenum disulfide, fine powder',
			grams: 0.5,
			role: 'Legacy Friction Facts band (~0.1-0.7 wt%); oil-additive optimum is ~0.01-0.05 wt%, so also run a low-dose sweep arm'
		}
	];

	const presets = [
		{ factor: 1, label: '100 g screen' },
		{ factor: 4.54, label: '1 lb pot' },
		{ factor: 5, label: '500 g pot', recommended: true }
	];

	const footnote =
		'Screening blend, not a claimed optimum. Total additive load is 2.5 wt%, deliberately below the old PTFE-heavy homebrew formulas. Keep one plain-paraffin control and vary one additive axis at a time before stacking effects.';
</script>

<WeightScaler
	title="Hot-melt chain wax scaler"
	{ingredients}
	{presets}
	defaultFactor={5}
	totalLabel="Finished chain wax"
	{footnote}
/>
