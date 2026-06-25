<script lang="ts">
	import WeightScaler from './WeightScaler.svelte';

	const ingredients = [
		{
			item: 'Fully refined paraffin wax',
			grams: 92.0,
			role: 'Low-oil crystalline base; carries nearly all the measured efficiency win — the solids are for wear and contamination life, not watts'
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
			item: 'Tungsten disulfide, 0.5 µm',
			grams: 1.0,
			role: 'Primary PFAS-free lamellar solid; finest dense sulfide on hand and the commercial SOTA bet. The 1 µm mil-spec lot is a coarse/fallback fraction, not a second factor'
		},
		{
			item: 'Hexagonal boron nitride, 0.5 µm',
			grams: 0.75,
			role: 'Mechanistically distinct co-solid: water/oxidation-inert humidity hedge, emulsion-friendly, white (inspectable). Pinned ≤1 wt% per the null-above-optimum data'
		},
		{
			item: 'Metal stearate or oleic acid dispersant',
			grams: 0.25,
			role: 'In-melt wetting / anti-settling so the dense WS2 stays suspended through crystallization; pairs with high-shear milling and a fast quench'
		}
	];

	const presets = [
		{ factor: 1, label: '100 g screen' },
		{ factor: 4.54, label: '1 lb pot' },
		{ factor: 5, label: '500 g pot', recommended: true }
	];

	const footnote =
		'Down-selected from the prior 3-solid 2.5 wt% blend to two non-redundant solids (1.75 wt% solids, 2.0 wt% with dispersant). MoS2 was dropped to a DOE control arm, not deleted: keep a MoS2-only and a plain-paraffin arm so the drop is measured, not asserted. There is no peer-reviewed WS2-in-wax tribology, so treat every row as a hypothesis to bench-validate.';
</script>

<WeightScaler
	title="Hot-melt chain wax scaler"
	{ingredients}
	{presets}
	defaultFactor={5}
	totalLabel="Finished chain wax"
	{footnote}
/>
