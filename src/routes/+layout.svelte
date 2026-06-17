<script lang="ts">
	import { base } from '$app/paths';
	import '../app.css';

	let { children } = $props();

	let mode = $state<'light' | 'dark'>('light');

	$effect(() => {
		// Sync the toggle with whatever the FOUC script applied.
		const current = document.documentElement.getAttribute('data-mode');
		mode = current === 'dark' ? 'dark' : 'light';
	});

	function toggleMode() {
		mode = mode === 'dark' ? 'light' : 'dark';
		document.documentElement.setAttribute('data-mode', mode);
		document.documentElement.style.colorScheme = mode;
		try {
			localStorage.setItem('color-mode', mode);
		} catch {
			// ignore
		}
	}
</script>

<div class="min-h-screen bg-surface-50 text-surface-950 dark:bg-surface-950 dark:text-surface-50">
	<header
		class="sticky top-0 z-10 border-b border-surface-300 bg-surface-50/85 backdrop-blur dark:border-surface-700 dark:bg-surface-950/85"
	>
		<div class="mx-auto flex max-w-3xl flex-wrap items-center justify-between gap-3 px-6 py-3">
			<a href={`${base}/`} class="font-mono text-sm font-semibold">
				tinyland-goo
			</a>
			<nav class="flex flex-wrap items-center gap-3 text-xs font-medium text-surface-600 dark:text-surface-300">
				<a class="underline-offset-4 hover:underline" href={`${base}/`}>bed glue</a>
				<a class="underline-offset-4 hover:underline" href={`${base}/chain-wax`}>chain wax</a>
				<a class="underline-offset-4 hover:underline" href={`${base}/hair-removal-wax`}>hair wax</a>
			</nav>
			<button
				type="button"
				class="btn btn-sm preset-outlined-surface-500"
				aria-label="Toggle light and dark mode"
				onclick={toggleMode}
			>
				{mode === 'dark' ? '☀ light' : '☾ dark'}
			</button>
		</div>
	</header>

	{@render children()}

	<footer class="mx-auto max-w-3xl px-6 py-12 text-sm text-surface-500">
		<p>
			Built from the Tinyland
			<a class="underline" href="https://github.com/tinyland-inc/site.scaffold">site.scaffold</a>.
			Recipe and hardware are experimental — validate on your own bed and read the safety notes.
		</p>
	</footer>
</div>
