# Performance

Transition specificity and GPU hints.

## Transition only what changes

Never `transition: all`, never Tailwind's `transition-all`:

- The browser watches every property and animates ones you never intended — colors, padding, shadows.
- It blocks optimizations the browser could otherwise make.

```css
/* right */
.button {
  transition-property: scale, background-color;
  transition-duration: 150ms;
  transition-timing-function: ease-out;
}

/* wrong */
.button {
  transition: all 150ms ease-out;
}
```

```tsx
// right
<button className="transition-[scale,background-color] duration-150 ease-out">

// wrong
<button className="transition-all duration-150 ease-out">
```

Tailwind notes: bare `transition` maps to a curated property list (colors, opacity, shadow, transform), not `all` — still worse than naming what changes. `transition-transform` covers `transform, translate, scale, rotate`: right when all of them animate, wrong when only `scale` does.

## will-change

`will-change` pre-promotes an element to its own compositing layer. Without it the browser promotes at animation start, and that one-time promotion can stutter the first frame — most visibly in Safari.

Treat it as a repair for observed stutter, never a preventive measure. Every promoted layer costs memory.

```css
/* right */
.animated-card { will-change: transform; }
.animated-card { will-change: transform, opacity; }

/* wrong */
.animated-card { will-change: all; }
.animated-card { will-change: background-color, padding; }
```

What the GPU can actually composite:

| Property | Compositable | Worth a hint |
| --- | --- | --- |
| `transform` | Yes | Yes |
| `opacity` | Yes | Yes |
| `filter` | Yes | Yes |
| `clip-path` | Recent Chromium only | Rarely — unreliable cross-browser |
| `top`/`left`/`width`/`height` | No | No |
| `background`/`border`/`color` | No | No |
