import fs from 'node:fs';
import path from 'node:path';
import assert from 'node:assert/strict';

// Read-only checks for source pages and downloadable teaching configurations.
const root = path.resolve(import.meta.dirname, '..');
const docs = path.join(root, 'docs');
const publicDir = path.join(docs, '.vuepress/public');
const errors = [];
function walk(dir, extension) {
  return fs.readdirSync(dir, {withFileTypes: true}).flatMap(entry => {
    const file = path.join(dir, entry.name);
    return entry.isDirectory() && !entry.name.startsWith('.') ? walk(file, extension)
      : entry.isFile() && entry.name.endsWith(extension) ? [file] : [];
  });
}
const pages = walk(docs, '.md');
let objects = 0, fragments = 0, links = 0;
function exists(file) {
  return fs.existsSync(file) || fs.existsSync(file.replace(/\.html$/, '.md'))
    || fs.existsSync(path.join(file, 'README.md'));
}
for (const file of pages) {
  const source = fs.readFileSync(file, 'utf8');
  const label = path.relative(root, file);
  for (const match of source.matchAll(/```(jsonc?)\s*\n([\s\S]*?)```/g)) {
    const body = match[2].trim();
    try {
      if (match[1] === 'json') { JSON.parse(body); objects++; }
      else {
        // Current examples use jsonc for placement, not comments or trailing commas.
        JSON.parse(body.startsWith('{') || body.startsWith('[') ? body : `{${body}}`);
        fragments++;
      }
    } catch (error) { errors.push(`${label}: invalid ${match[1]}: ${error.message}`); }
  }
  for (const match of source.matchAll(/\]\(([^)]+)\)|href="([^"]+)"/g)) {
    const target = (match[1] || match[2]).split('#')[0];
    if (!target || /^(https?:|mailto:)/.test(target)) continue;
    links++;
    const local = target.startsWith('/') ? path.join(publicDir, target) : path.resolve(path.dirname(file), target);
    const route = target.startsWith('/') ? path.join(docs, target) : local;
    if (!exists(local) && !exists(route)) errors.push(`${label}: missing link ${target}`);
  }
  if (/\/gwo give (?:firearm|ammo|melee) [a-z0-9_.-]+:/.test(source)) {
    errors.push(`${label}: unquoted content ID in give command`);
  }
  if (!file.startsWith(path.join(docs, 'en') + path.sep)) {
    const english = path.join(docs, 'en', path.relative(docs, file));
    if (!fs.existsSync(english)) errors.push(`${label}: missing English page`);
  }
}
const exampleDir = path.join(publicDir, 'downloads/examples');
const samples = Object.fromEntries(walk(exampleDir, '.json').map(file => {
  const value = JSON.parse(fs.readFileSync(file, 'utf8'));
  return [path.basename(file), value];
}));
const routing = samples['animation-routing.json'];
for (const action of Object.values(routing.animation_machine.actions)) {
  const states = [action.default_state, ...(action.variants || []).map(v => v.state),
    ...(action.sequences || []).flatMap(s => s.steps.map(step => step.state))];
  for (const state of states) {
    assert.ok(routing.animation_clips[state], `Missing clip mapping: ${state}`);
    assert.ok(routing.animation_controller.channels[state], `Missing channel: ${state}`);
  }
  const markers = new Set((action.sequences || []).flatMap(s => s.steps.map(step => step.marker)));
  for (const event of action.events || []) assert.ok(markers.has(event.marker), `Missing marker: ${event.marker}`);
}
for (const rule of routing.animation_machine.interrupts) {
  assert.ok(routing.animation_machine.actions[rule.active]);
  assert.ok(routing.animation_machine.actions[rule.incoming]);
  assert.ok(rule.reason);
}
assert.equal(samples['scope-example.json'].render, 'attachments/render/sights/training_scope.render.json');
if (errors.length) {
  console.error(errors.join('\n'));
  process.exitCode = 1;
} else {
  console.log(`PASS: ${pages.length} pages, ${objects} JSON objects, ${fragments} fragments, ${links} local links, ${Object.keys(samples).length} downloads; animation references and bilingual page coverage.`);
}
