<script lang="ts">
	// Typed SEO head for the prerendered (adapter-static) tinyland-goo pages.
	// Vendored from the Tinyland site.scaffold house-canon SEOHead (TIN-2225):
	// typed `interface Props`, `$props()` defaults, `$derived.by` for the
	// multi-statement canonical normalization. The site is fully prerendered, so
	// `noindex` is honored as an explicit prop only (a host check would bake the
	// robots value into the static HTML at build time); the canonical path comes
	// from `page.url.pathname` (stable per route during prerender).
	import { page } from '$app/state';

	interface Props {
		title: string;
		description: string;
		keywords?: string;
		image?: string;
		imageAlt?: string;
		noindex?: boolean;
		canonical?: string | undefined;
		ogType?: string;
		siteName?: string;
		/** Production origin (incl. the Pages base path) for the canonical URL. */
		origin?: string;
		/** Optional JSON-LD object, serialized into one application/ld+json block. */
		jsonLd?: Record<string, unknown> | null;
	}

	let {
		title,
		description,
		keywords = '',
		image = '',
		imageAlt = '',
		noindex = false,
		canonical = undefined,
		ogType = 'website',
		siteName = 'tinyland-goo',
		origin = 'https://jesssullivan.github.io',
		jsonLd = null
	}: Props = $props();

	const canonicalUrl = $derived(canonical || `${origin}${page.url.pathname}`);
	const shouldNoindex = $derived(noindex);

	// Multi-statement normalization → `$derived.by` (never a `$derived` thunk).
	const normalizedCanonical = $derived.by(() => {
		const url = canonicalUrl;
		try {
			const parsed = new URL(url);
			let pathname = parsed.pathname;
			if (pathname !== '/' && pathname.endsWith('/')) {
				pathname = pathname.slice(0, -1);
			} else if (pathname === '/') {
				pathname = '';
			}
			return `${parsed.protocol}//${parsed.host}${pathname}${parsed.search}`;
		} catch {
			return url.replace(/\/$/, '');
		}
	});

	// Serialize JSON-LD once; escape every `<` so an embedded closing-script
	// sentinel in the data cannot terminate the inline block early.
	const jsonLdScript = $derived.by(() => {
		if (!jsonLd) return null;
		return JSON.stringify(jsonLd).replace(/</g, '\\u003c');
	});
</script>

<svelte:head>
	<title>{title}</title>
	<meta name="description" content={description} />
	{#if keywords}
		<meta name="keywords" content={keywords} />
	{/if}

	<link rel="canonical" href={normalizedCanonical} />

	<meta property="og:type" content={ogType} />
	<meta property="og:url" content={normalizedCanonical} />
	<meta property="og:title" content={title} />
	<meta property="og:description" content={description} />
	{#if image}
		<meta property="og:image" content={image} />
		<meta property="og:image:alt" content={imageAlt} />
	{/if}
	<meta property="og:site_name" content={siteName} />

	<meta name="twitter:card" content="summary_large_image" />
	<meta name="twitter:title" content={title} />
	<meta name="twitter:description" content={description} />
	{#if image}
		<meta name="twitter:image" content={image} />
		<meta name="twitter:image:alt" content={imageAlt} />
	{/if}

	{#if shouldNoindex}
		<meta name="robots" content="noindex, nofollow" />
	{:else}
		<meta name="robots" content="index, follow" />
	{/if}

	{#if jsonLdScript}
		{@html `<script type="application/ld+json">${jsonLdScript}</` + `script>`}
	{/if}
</svelte:head>
