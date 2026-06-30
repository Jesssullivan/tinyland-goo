import { describe, expect, it } from 'vitest';
import { G_PER_OZ, batchTotalGrams, formatAmount, gramsToOz, scaleGrams } from './scale';

describe('scale', () => {
	it('uses the international avoirdupois ounce', () => {
		expect(G_PER_OZ).toBe(28.349523125);
	});

	it('scales base-batch grams by the factor', () => {
		expect(scaleGrams(100, 5)).toBe(500);
		expect(scaleGrams(92, 1)).toBe(92);
		expect(scaleGrams(0, 4.54)).toBe(0);
	});

	it('converts grams to ounces', () => {
		expect(gramsToOz(G_PER_OZ)).toBe(1);
		expect(gramsToOz(0)).toBe(0);
	});

	it('sums then scales the ingredient batch', () => {
		const ingredients = [
			{ item: 'paraffin', grams: 18, role: 'base' },
			{ item: 'micro', grams: 3, role: 'flex' }
		];
		expect(batchTotalGrams(ingredients, 1)).toBe(21);
		expect(batchTotalGrams(ingredients, 2)).toBe(42);
		expect(batchTotalGrams([], 5)).toBe(0);
	});

	it('formats grams to 2 dp and ounces to 3 dp', () => {
		expect(formatAmount(92, 1, 'g')).toBe('92.00');
		expect(formatAmount(92, 5, 'g')).toBe('460.00');
		expect(formatAmount(G_PER_OZ, 1, 'oz')).toBe('1.000');
		expect(formatAmount(100, 1, 'oz')).toBe('3.527');
	});
});
