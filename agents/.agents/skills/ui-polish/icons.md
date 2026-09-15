# Icons

Stroke weight, state handling, sizing, direction. Cross-fade values for swaps: [icon-transitions.md](icon-transitions.md).

## Stroke matches text weight

An icon beside text carries the text's optical weight. On the 24px grid:

| Adjacent text | Stroke |
| --- | --- |
| Regular (400), 14–16px | `1.5px` |
| Medium/semibold (500–600) | `2px` |
| Bold (700), or standalone emphasis | `2.5px` |

```html
<!-- right -->
<button class="flex items-center gap-2 font-semibold">
  <PlusIcon stroke-width="2" class="size-4" />
  New project
</button>

<!-- wrong: hairline stroke against a bold label -->
<button class="flex items-center gap-2 font-bold">
  <PlusIcon stroke-width="1.5" class="size-4" />
  New project
</button>
```

Two consistency rules follow:

- **One optical strategy per surface.** Never mix icon libraries with different stroke conventions in one toolbar. Where the set ships stroke variants, map them to text weight as above; otherwise keep the set's native stroke and use size or color for emphasis.
- **Size against the adjacent text's cap height** — typically `1em`–`1.25em` inline — so the pair scales together.

## One SVG, states in CSS

Separate assets per state are a maintenance trap and a bundle tax. One SVG drawn with `currentColor`; hover, selected and disabled are CSS:

```css
.icon-button { color: oklch(0.552 0.016 285.938); }
.icon-button:hover { color: oklch(0.21 0.006 285.885); }
.icon-button[aria-pressed="true"] { color: oklch(0.623 0.188 259.815); }
.icon-button:disabled { opacity: 0.4; }
```

```html
<button class="text-zinc-500 hover:text-zinc-900 aria-pressed:text-blue-600 disabled:opacity-40">
  <BookmarkIcon />
</button>
```

Hardcoded fills inside the SVG (`fill="#666"`) defeat this — strip them to `currentColor` at import.

## Outline at rest, fill when active

Where the set ships both variants, they are a state pair, not a style choice:

| Variant | Where |
| --- | --- |
| Outline | Resting state: toolbars, rows, inline with text |
| Fill | Active state: current tab, toggled bookmark, liked heart |

```tsx
<TabIcon variant={isActive ? "solid" : "outline"} />
```

Filling everything leaves the active tab with no signal. The swap between variants is a contextual animation — exact values in [icon-transitions.md](icon-transitions.md).

## Design at render size

Detail that survives 48px dies at 16px: thin interior strokes, tight counters, fine texture all alias or blur out.

- Check every icon at the smallest size it actually renders — usually 16px. Where it stops reading, simplify the glyph; do not scale detailed art down.
- Stay on the set's native grid sizes (16, 20, 24). A 16px icon rendered from a 24px grid at fractional scale comes out soft.
- SVG only. Raster cannot stay crisp across densities.

## Direction

Under `dir="rtl"`, mirror icons whose meaning follows reading direction; leave the rest alone:

| Mirror | Leave alone |
| --- | --- |
| Back/forward arrows, navigation chevrons | Logos and brand marks |
| Text-block glyphs: alignment, list, indent | Checkmarks |
| Volume/speaker waves | Physical objects: clocks, cups, pencils |
| Send-style directional glyphs | Playback controls (play/rewind reference tape direction, kept LTR by convention) |

```css
[dir="rtl"] .icon-directional {
  scale: -1 1;
}
```

```html
<ChevronRightIcon class="icon-directional rtl:-scale-x-100" />
```

Analyze composite icons part by part — a badge or slash overlay may keep its position while the base glyph mirrors. Accessible names for icon-only buttons are outside this skill.
