/**
 * TEMPORARY — delete this file and its `postinstall` hook once the upstream
 * publish is fixed. It tells you when that has happened.
 *
 * THE BUG. `@sharpee/*` packages are published with their `exports` map
 * flattened to `"."` alone. The subpath modules are present in the tarball —
 * `transcript-tester/assertion-core.js` really is sitting there — but Node
 * refuses to resolve them, because a package with an `exports` map exposes
 * nothing that map does not name.
 *
 * The flattening is old and was harmless while nothing imported across a
 * subpath. ADR-340 (upstream #383, still open) made `@sharpee/branch-tester`
 * require `@sharpee/transcript-tester/assertion-core`, which turned it into a
 * hard crash: `sharpee test` dies with
 *
 *   Package subpath './assertion-core' is not defined by "exports"
 *
 * and `tools/build.py` exits 1 behind it. Verified on 5.3.1, 5.3.2 and 5.4.0;
 * 5.3.0 has the same flattened map and only escapes because nothing reached
 * across a subpath yet.
 *
 * THE FIX. Add a wildcard subpath to the installed packages. This exposes only
 * files the package already ships, and changes nothing else.
 *
 * WHY A POSTINSTALL RATHER THAN patch-package. Two reasons. It needs no new
 * dependency for a bug that should be short-lived, and it is self-erasing: the
 * day a release ships a correct `exports` map, this script finds nothing to do
 * and says so, instead of failing the way a stale patch file would.
 *
 * It never fails an install. The worst case is that `sharpee test` still
 * cannot run, which is where we started.
 */
import { readFileSync, writeFileSync, existsSync, readdirSync } from 'node:fs';
import { join } from 'node:path';

const SCOPE = join(process.cwd(), 'node_modules', '@sharpee');
const WILDCARD = { types: './*.d.ts', require: './*.js', default: './*.js' };

function main() {
  if (!existsSync(SCOPE)) return;

  const patched = [];
  let alreadyFine = 0;
  let stillShimmed = 0;

  for (const name of readdirSync(SCOPE)) {
    const manifest = join(SCOPE, name, 'package.json');
    if (!existsSync(manifest)) continue;

    let pkg;
    try {
      pkg = JSON.parse(readFileSync(manifest, 'utf8'));
    } catch {
      continue;
    }

    const exports = pkg.exports;
    // No exports map at all means everything is already reachable.
    if (!exports || typeof exports !== 'object' || Array.isArray(exports)) continue;

    // A package we already shimmed carries a sentinel. Without it, a second
    // run over a patched tree (plain `npm install`, which does not wipe
    // node_modules) would mistake our own wildcard for an upstream fix and
    // announce that the shim can be deleted.
    const shimmed = pkg._sharpeeExportsShim === true;
    const keys = Object.keys(exports);
    if (!shimmed && keys.some((k) => k !== '.' && k !== './package.json')) {
      alreadyFine += 1;   // this package names real subpaths — nothing to do
      continue;
    }
    if (shimmed) {
      stillShimmed += 1;
      continue;
    }

    // Only worth touching if it actually ships modules beside its entry point.
    const siblings = readdirSync(join(SCOPE, name))
      .filter((f) => f.endsWith('.js') && f !== 'index.js');
    if (siblings.length === 0) continue;

    exports['./*'] = WILDCARD;
    pkg._sharpeeExportsShim = true;
    writeFileSync(manifest, JSON.stringify(pkg, null, 2) + '\n');
    patched.push(`${pkg.name}(${siblings.length})`);
  }

  if (patched.length === 0) {
    if (stillShimmed > 0) {
      console.log(`[sharpee-exports] ${stillShimmed} package(s) already carry the shim from an` +
                  ' earlier install.');
    } else if (alreadyFine > 0) {
      console.log(
        '[sharpee-exports] Nothing to patch — the published packages name their own\n' +
        '                  subpaths now. The upstream publish is fixed: delete\n' +
        '                  scripts/fix-sharpee-exports.mjs, drop the postinstall hook\n' +
        '                  from package.json, and remove the note in CLAUDE.md.');
    }
    return;
  }

  console.log(
    `[sharpee-exports] Re-opened subpath exports on ${patched.length} @sharpee package(s) so\n` +
    '                  `sharpee test` can run. This is a temporary shim for an\n' +
    '                  upstream publishing bug — see the header of\n' +
    '                  scripts/fix-sharpee-exports.mjs.');
}

try {
  main();
} catch (error) {
  // A shim for someone else's bug must never be the thing that breaks an install.
  console.log(`[sharpee-exports] skipped (${error && error.message}) — \`sharpee test\` may not run.`);
}
