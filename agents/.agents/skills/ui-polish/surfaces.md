# Surfaces

Radius, optical alignment, shadow, and image outlines.

## Concentric radius

Nested rounded surfaces look right when their curves stay parallel:

```
outerRadius = innerRadius + padding
```

```css
/* right: curves parallel */
.panel {
  border-radius: 20px; /* 12 + 8 */
  padding: 8px;
}
.panel-inner {
  border-radius: 12px;
}

/* wrong: one radius for both layers */
.panel,
.panel-inner {
  border-radius: 12px;
}
```

Tailwind:

```tsx
<div className="rounded-2xl p-2">   {/* 16px radius, 8px padding */}
  <div className="rounded-lg">      {/* 8px = 16 - 8 */}
```

The constraint holds while the inset is small and visible. Past ~24px of padding the layers read as separate surfaces: pick each radius on its own instead of forcing the arithmetic. Where an established component token exists, keep it — consistency beats concentricity at the margins.

## Optical alignment

Geometric centering and visual centering disagree on anything asymmetric. Align to what the eye reports, not what the box model computes.

**Icon + label buttons.** The icon side needs slightly less padding to look even — start 2px tighter than the label side:

```css
.button-with-icon {
  padding-inline-start: 16px;
  padding-inline-end: 14px;
}
```

```tsx
<button className="ps-4 pe-3.5 flex items-center gap-2">
  <span>Continue</span>
  <ArrowRightIcon />
</button>
```

**Play triangles.** A triangle's centroid sits behind its visual center; nudge it ~2px forward:

```css
.play svg {
  transform: translateX(2px);
}
```

**Stars, arrows, carets.** Uneven visual weight is best fixed in the glyph — adjust the viewBox or path so the icon centers optically on its own. Margin nudges are the fallback, not the fix:

```tsx
<span className="translate-x-px">
  <StarIcon />
</span>
```

## Shadow vs border

Where buttons, cards and containers use a border purely for lift, replace it with stacked translucent shadows. Transparency adapts to whatever sits underneath — images, tinted sections, alternating rows — which a fixed border color cannot.

Dividers are the exception. `border-b` between list items, table rules, hairline separators: those communicate structure and stay borders.

**Light mode, three layers.** A 1px ring replaces the border, the second layer lifts, the third spreads ambient depth:

```css
:root {
  --shadow-border:
    0px 0px 0px 1px oklch(0 0 0 / 0.06),
    0px 1px 2px -1px oklch(0 0 0 / 0.06),
    0px 2px 4px 0px oklch(0 0 0 / 0.04);
  --shadow-border-hover:
    0px 0px 0px 1px oklch(0 0 0 / 0.08),
    0px 1px 2px -1px oklch(0 0 0 / 0.08),
    0px 2px 4px 0px oklch(0 0 0 / 0.06);
}
```

**Dark mode, one ring.** Depth shadows vanish against dark backgrounds; a single white ring does the work:

```css
--shadow-border: 0 0 0 1px oklch(1 0 0 / 0.08);
--shadow-border-hover: 0 0 0 1px oklch(1 0 0 / 0.13);
```

Match the project's theme mechanism — class, data attribute, or media query.

**Hover transition:**

```css
.card {
  box-shadow: var(--shadow-border);
  transition-property: box-shadow;
  transition-duration: 150ms;
  transition-timing-function: ease-out;
}
.card:hover {
  box-shadow: var(--shadow-border-hover);
}
```

Which tool for which job:

| Shadow | Border |
| --- | --- |
| Cards and containers with depth | Dividers between rows |
| Bordered-style buttons | Table cell rules |
| Dropdowns, popovers, modals | Form input outlines (accessibility) |
| Elements over mixed backgrounds | Hairline separators in dense UI |
| Hover/focus lift | |

## Image outlines

Images get a 1px outline at 10% opacity so they hold an edge on any background:

```css
img {
  outline: 1px solid oklch(0 0 0 / 0.1); /* dark mode: oklch(1 0 0 / 0.1) */
  outline-offset: -1px;
}
```

```tsx
<img className="outline outline-1 -outline-offset-1 outline-black/10 dark:outline-white/10" />
```

The color rules do not flex:

- Light mode: pure black at 10%. Dark mode: pure white at 10%.
- Never slate, zinc, neutral or any palette gray — a tinted outline picks up the surface below and reads as grime on the image edge.
- Never the accent or ink color. The outline is a neutral separator, not theming.
- `outline`, not `border`: outlines never touch layout, and the `-1px` offset draws the ring just inside the edge so it follows the corner radius.
