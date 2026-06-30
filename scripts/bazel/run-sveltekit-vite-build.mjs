// SvelteKit/Vite build smoke as a Bazel action (the BUILD-authority RBE target).
// Bazel sandboxes inputs read-only, so copy the declared inputs + symlink the
// Bazel-linked node_modules into a writable tmp root, run `svelte-kit sync` +
// `vite build`, and assert the prerendered routes exist. Adapted (simplified —
// no workspace packages) from the live jesssullivan.github.io build smoke.

import { cpSync, existsSync, mkdirSync, mkdtempSync, readdirSync, readFileSync, symlinkSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join, resolve } from 'node:path';
import { spawnSync } from 'node:child_process';

const workspaceRoot = process.cwd();
const runtimeRoot = mkdtempSync(join(tmpdir(), 'tinyland-goo-vite-build-'));
const buildRoot = join(runtimeRoot, 'workspace');
mkdirSync(buildRoot, { recursive: true });

ensureWritableEnvDir('HOME', join(runtimeRoot, 'home'));
ensureWritableEnvDir('XDG_CONFIG_HOME', join(runtimeRoot, 'xdg-config'));
ensureWritableEnvDir('XDG_CACHE_HOME', join(runtimeRoot, 'xdg-cache'));
process.env.CI = 'true';
process.env.NODE_ENV = 'production';

copyInputsToBuildRoot();
linkNodeModules();

const packageJson = JSON.parse(readFileSync(join(buildRoot, 'package.json'), 'utf8'));

run('svelte-kit', ['sync']);
run('vite', ['build']);

for (const route of ['index.html', 'chain-wax.html', 'hair-removal-wax.html']) {
	const path = join(buildRoot, 'build', route);
	if (!existsSync(path)) {
		throw new Error(`SvelteKit build did not write build/${route}`);
	}
}
const indexHtml = readFileSync(join(buildRoot, 'build', 'index.html'), 'utf8');
if (!indexHtml.includes('<!doctype html>')) {
	throw new Error('build/index.html is missing the doctype');
}

console.log(`SvelteKit/Vite build smoke passed for ${packageJson.name}; 3 routes prerendered under ${buildRoot}/build`);

function ensureWritableEnvDir(envName, dir) {
	mkdirSync(dir, { recursive: true });
	process.env[envName] = dir;
}

function copyInputsToBuildRoot() {
	for (const dir of ['src', 'static']) {
		copyPath(resolve(workspaceRoot, dir), resolve(buildRoot, dir));
	}
	for (const file of [
		'.npmrc',
		'package.json',
		'pnpm-lock.yaml',
		'pnpm-workspace.yaml',
		'svelte.config.js',
		'tsconfig.json',
		'vite.config.ts',
	]) {
		copyPath(resolve(workspaceRoot, file), resolve(buildRoot, file));
	}
}

function copyPath(source, destination) {
	if (!existsSync(source)) {
		throw new Error(`Missing declared build input: ${source}`);
	}
	mkdirSync(dirname(destination), { recursive: true });
	cpSync(source, destination, {
		dereference: true,
		errorOnExist: false,
		force: true,
		preserveTimestamps: false,
		recursive: true,
	});
}

function linkNodeModules() {
	const sourceNodeModules = resolve(workspaceRoot, 'node_modules');
	const buildNodeModules = resolve(buildRoot, 'node_modules');
	if (!existsSync(sourceNodeModules)) {
		throw new Error(`Missing Bazel node_modules tree: ${sourceNodeModules}`);
	}
	mkdirSync(buildNodeModules, { recursive: true });
	for (const entry of readdirSync(sourceNodeModules, { withFileTypes: true })) {
		const sourcePath = resolve(sourceNodeModules, entry.name);
		const destinationPath = resolve(buildNodeModules, entry.name);
		if (entry.name.startsWith('@') && entry.isDirectory()) {
			mkdirSync(destinationPath, { recursive: true });
			for (const scopedEntry of readdirSync(sourcePath, { withFileTypes: true })) {
				symlinkSync(resolve(sourcePath, scopedEntry.name), resolve(destinationPath, scopedEntry.name), 'dir');
			}
		} else {
			symlinkSync(sourcePath, destinationPath, entry.isDirectory() ? 'dir' : 'file');
		}
	}
}

function run(cmd, args) {
	const bin = resolve(buildRoot, 'node_modules', '.bin', cmd);
	const result = spawnSync(bin, args, { cwd: buildRoot, stdio: 'inherit', env: process.env });
	if (result.status !== 0) {
		throw new Error(`${cmd} ${args.join(' ')} failed (exit ${result.status ?? result.signal})`);
	}
}
