// Pure scaling + unit-conversion helpers for the by-weight recipe scalers
// (WeightScaler.svelte and its thin wrappers). Everything is grams on a 0.01 g
// scale, with a g <-> oz toggle; `factor` multiplies the base-batch grams.
//
// Extracted from the component so the math is unit-testable (src/lib/scale.test.ts).

export const G_PER_OZ = 28.349523125;

export type Ingredient = { item: string; grams: number; role: string };
export type Unit = 'g' | 'oz';

/** Scale a base-batch gram amount by the batch factor. */
export function scaleGrams(grams: number, factor: number): number {
	return grams * factor;
}

/** Convert grams to ounces. */
export function gramsToOz(grams: number): number {
	return grams / G_PER_OZ;
}

/** Sum the base-batch ingredient grams, then scale by the factor. */
export function batchTotalGrams(ingredients: Ingredient[], factor: number): number {
	return ingredients.reduce((sum, i) => sum + i.grams, 0) * factor;
}

/** Format one scaled ingredient amount for display in the chosen unit. */
export function formatAmount(grams: number, factor: number, unit: Unit): string {
	const scaled = scaleGrams(grams, factor);
	return unit === 'oz' ? gramsToOz(scaled).toFixed(3) : scaled.toFixed(2);
}
