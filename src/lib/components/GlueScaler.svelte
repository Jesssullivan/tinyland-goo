<script lang="ts">
	// GlueScaler.svelte — weight-based batch scaler for the UV-reactive bed glue.
	//
	// Everything is BY WEIGHT (grams) for a 0.01 g jeweller's/micro scale. The 1×
	// column is the smallest batch worth mixing (~2 oz); the practical minimum is
	// 2× = ~4 oz, which is the default selection. Data lives in this .svelte file
	// (not in markdown) so the file is portable to the mdsvex blog, whose pipeline
	// escapes `{`/`}` in post source.

	type Ingredient = {
		item: string;
		grams: number; // mass for the 1× (~2 oz) base batch
		role: string;
	};

	// 1× base batch ≈ 56.4 g ≈ 2 oz (half of the verified 4 oz formulation).
	const ingredients: Ingredient[] = [
		{ item: 'PVP-K90 powder', grams: 4.0, role: 'Primary film former — K90 (MW ~1.3M) is the strength upgrade over Frank’s K30' },
		{ item: 'PVA, 88% hydrolyzed (cold-water grade)', grams: 1.2, role: 'Secondary film former / toughness — pins a minimum water fraction' },
		{ item: 'PEG-400', grams: 1.0, role: 'Tackifier / plasticizer — the highest-leverage bond-strength additive' },
		{ item: '1% boric-acid stock solution', grams: 0.85, role: 'Delivers a trace PVA crosslink (~0.7% of PVA) — dosed via stock so it’s weighable' },
		{ item: 'Coated SrAl₂O₄:Eu,Dy phosphor, 35–50 µm', grams: 2.0, role: 'UV-reactive coverage indicator — MUST be waterproof/encapsulated grade' },
		{ item: 'Ethanol (≥95%, denatured ok)', grams: 26.5, role: 'Co-solvent for PVP/PEG; flashes off on the heated bed' },
		{ item: 'Distilled water (free water)', grams: 20.86, role: 'Dissolves the PVA; carrier lands at ~55:45 ethanol:water' }
	];

	const scales = [1, 2, 4];
	const G_PER_OZ = 28.349523125;

	let scale = $state(2); // default to the 4 oz recommended minimum
	let unit = $state<'g' | 'oz'>('g');

	const rows = $derived(
		ingredients.map((ing) => {
			const grams = ing.grams * scale;
			const amount = unit === 'oz' ? (grams / G_PER_OZ).toFixed(3) : grams.toFixed(2);
			return { item: ing.item, role: ing.role, amount, suffix: unit };
		})
	);

	const totalGrams = $derived(ingredients.reduce((sum, i) => sum + i.grams, 0) * scale);
	const totalOz = $derived(totalGrams / G_PER_OZ);

	function batchLabel(s: number): string {
		const oz = (ingredients.reduce((sum, i) => sum + i.grams, 0) * s) / G_PER_OZ;
		return `×${s} · ~${oz.toFixed(0)} oz`;
	}
</script>

<div class="card p-4 preset-outlined-surface-500 not-prose my-6">
	<div class="mb-3 flex flex-wrap items-center justify-between gap-3">
		<h3 class="m-0 text-lg font-semibold">Glue batch scaler (by weight)</h3>
		<div class="flex items-center gap-2">
			<div class="flex gap-1" role="group" aria-label="Scale the batch size">
				{#each scales as s (s)}
					<button
						type="button"
						class="badge {scale === s ? 'preset-filled-primary-500' : 'preset-outlined-surface-500'}"
						aria-pressed={scale === s}
						aria-label={`Scale batch ${batchLabel(s)}${s === 2 ? ', recommended minimum' : ''}`}
						onclick={() => (scale = s)}
					>
						{batchLabel(s)}{s === 2 ? ' ✓' : ''}
					</button>
				{/each}
			</div>
			<button
				type="button"
				class="badge preset-outlined-surface-500"
				aria-pressed={unit === 'oz'}
				aria-label="Toggle grams or ounces"
				onclick={() => (unit = unit === 'g' ? 'oz' : 'g')}
			>
				{unit === 'g' ? 'grams' : 'ounces'}
			</button>
		</div>
	</div>

	<table class="w-full text-sm">
		<caption class="sr-only">
			UV-reactive bed glue, scaled ×{scale} (~{totalOz.toFixed(1)} oz), shown in {unit === 'g'
				? 'grams'
				: 'ounces'}
		</caption>
		<thead>
			<tr class="text-left text-surface-600 dark:text-surface-400">
				<th scope="col" class="py-1 pr-3 font-medium">Weight</th>
				<th scope="col" class="py-1 font-medium">Ingredient</th>
			</tr>
		</thead>
		<tbody>
			{#each rows as row (row.item)}
				<tr class="border-t border-surface-300 dark:border-surface-700">
					<td class="whitespace-nowrap py-1 pr-3 font-mono">{row.amount} {row.suffix}</td>
					<td class="py-1">
						<span class="font-medium">{row.item}</span>
						<span class="block text-xs text-surface-500">{row.role}</span>
					</td>
				</tr>
			{/each}
			<tr class="border-t-2 border-surface-400 dark:border-surface-600 font-semibold">
				<td class="whitespace-nowrap py-1 pr-3 font-mono">
					{unit === 'oz' ? totalOz.toFixed(3) : totalGrams.toFixed(2)}
					{unit}
				</td>
				<td class="py-1">Finished glue (~{totalOz.toFixed(1)} oz)</td>
			</tr>
		</tbody>
	</table>

	<p class="mt-3 text-xs text-surface-500">
		Solids are ~14.6% by weight (PVP:PVA ≈ 77:23). 1× is the smallest worthwhile
		batch; 2× (~4&nbsp;oz) is the recommended minimum. A 0.01&nbsp;g scale is assumed —
		the boric acid is dosed as a 1% stock because the neat mass (≈8&nbsp;mg) is below
		that resolution.
	</p>
	<p class="sr-only" aria-live="polite">Showing ×{scale} batch in {unit === 'g' ? 'grams' : 'ounces'}.</p>
</div>
