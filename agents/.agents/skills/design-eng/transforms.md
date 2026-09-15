# Transforms and clip-path

The transform mechanics every motion decision sits on, plus clip-path as an animation tool.

## Percentages are self-relative

`translate` percentages resolve against the element's own box. `translateY(100%)` hides an element exactly its own height away — drawers, sheets, toasts — without knowing a pixel of its size:

```css
.sheet-hidden { transform: translateY(100%); }
.toast-enter  { transform: translateY(-100%); }
```

Prefer it over hardcoded offsets; it survives content changes.

## scale() takes the children

Unlike `width`/`height`, `scale()` transforms the whole subtree — text, icons and borders shrink with the press. That is the feature: press feedback stays proportional at any button size.

## 3D without JavaScript

`rotateX`/`rotateY` under `transform-style: preserve-3d` produce real depth — orbits, flips, parallax:

```css
.wrapper { transform-style: preserve-3d; }

@keyframes orbit {
  from { transform: translate(-50%, -50%) rotateY(0deg) translateZ(64px) rotateY(360deg); }
  to   { transform: translate(-50%, -50%) rotateY(360deg) translateZ(64px) rotateY(0deg); }
}
```

## transform-origin

Every transform pivots on an anchor point; the default is dead center, which is wrong for anything attached to a trigger. Set the origin to where the interaction came from (popovers, menus); leave center for unanchored overlays (modals).

## clip-path as animation

`clip-path: inset(top right bottom left)` crops to a rectangle, each value eating in from its side. Cropping is compositor-friendly, which makes it a surprisingly general animation tool:

```css
.hidden  { clip-path: inset(0 100% 0 0); }
.visible { clip-path: inset(0 0 0 0); }

.overlay {
  clip-path: inset(0 100% 0 0);
  transition: clip-path 200ms ease-out;
}
.button:active .overlay {
  clip-path: inset(0 0 0 0);
  transition: clip-path 2s linear;
}
```

Patterns it enables:

- **Wipes and reveals.** Transition the inset values to sweep a color across a button or unroll a section left to right.
- **Hold-to-delete.** A colored overlay fills over ~2s linear while held — the duration is the confirmation — and snaps back in 200ms on release. Pair with `scale(0.96)` press feedback.
- **Tab color transitions.** Duplicate the tab list, style the copy as active, clip it to just the active tab, and animate the clip on change. Color transitions that would otherwise fight each other become one clean wipe.
- **Scroll reveals.** Start at `inset(0 0 100% 0)` and open to `inset(0 0 0 0)` when the element scrolls in — `IntersectionObserver`, or `useInView` with `{ once: true, margin: "-100px" }`.
- **Comparison sliders.** Two stacked images, the top clipped with `inset(0 50% 0 0)`; drive the right value from the drag position. No extra DOM, fully accelerated.
