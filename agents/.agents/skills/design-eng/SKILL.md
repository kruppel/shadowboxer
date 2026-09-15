---
name: design-eng
description: Judgment for interface motion - whether to animate, easing and duration choices, springs, gestures, perceived performance, debugging. Use when making animation decisions or reviewing UI motion.
---

# Design engineering

The craft layer of interface work. Functionality gets a product used; feel gets it chosen — and feel is the sum of hundreds of decisions nobody consciously notices. This skill is the framework for making them.

The exact numbers live in `ui-polish`; this skill decides whether motion belongs at all and what it should say. Where the two disagree on a value, `ui-polish` wins.

## Philosophy

**Taste is trained, not innate.** Good taste is not personal preference; it is a trained instinct for what elevates a solution beyond the obvious. Build it by pulling apart interfaces you admire — read the interaction code behind them, keep asking why the result works — and by deliberate practice. Making it work is the floor, not the goal.

**Invisible correctness compounds.** Users will never consciously notice most of these decisions. That is the point: when everything behaves exactly as expected, people move through the interface without friction, and the aggregate reads as quality. Details nobody sees one at a time become visible all together.

**Beauty is leverage.** People choose tools by how they feel, not only by what they do. Good defaults and considered motion are a real competitive edge, and most software still underinvests in them.

## The decision framework

Four questions, in order, before any animation code:

### 1. Should this move at all?

Frequency decides:

| Seen | Decision |
| --- | --- |
| 100+ times/day — keyboard shortcuts, palette toggles | Never animate |
| Tens of times/day — hover, list navigation | Nothing, or barely |
| Occasional — modals, drawers, toasts | Standard motion |
| Rare or first-time — onboarding, celebrations | Delight is allowed |

Keyboard-initiated actions are never animated, full stop: repeated hundreds of times a day, motion only makes them feel laggy and detached from the keystroke. The best command palettes open and close instantly for exactly this reason.

### 2. What does the motion say?

Every animation needs an answer to "why does this move?"

- **Spatial consistency** — a toast entering and exiting the same edge makes swipe-to-dismiss intuitive
- **State** — a morphing submit button shows its own progress
- **Explanation** — a marketing animation demonstrates how a feature works
- **Feedback** — a press scale confirms the interface heard the user
- **Continuity** — elements appearing or vanishing without transition read as broken

"It looks cool" is a valid answer only for things users see rarely.

### 3. Which easing?

Entering or exiting → **ease-out**: fast start, immediate response.
Moving or morphing on screen → **ease-in-out**: natural acceleration and deceleration.
Hover or color change → **ease**.
Constant motion (marquees, progress bars) → **linear**.
Nothing else fits → **ease-out**.

Built-in CSS easings are too timid for UI; define stronger curves:

```css
--ease-out: cubic-bezier(0.23, 1, 0.32, 1);      /* interactions */
--ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);  /* on-screen movement */
--ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);   /* iOS-like sheets */
```

**Never `ease-in` on UI motion.** Its slow start delays exactly the moment the user watches most closely: a 300ms ease-in dropdown feels slower than a 300ms ease-out one. Don't hand-draw curves either — start from stronger variants of the standards at [easing.dev](https://easing.dev/) or [easings.co](https://easings.co/).

### 4. How long?

| Element | Duration |
| --- | --- |
| Press feedback | 100–160ms |
| Tooltips, small popovers | 125–200ms |
| Dropdowns, selects | 150–250ms |
| Modals, drawers | 200–500ms |
| Marketing, explanatory | As long as it earns |

UI motion stays under 300ms. A 180ms dropdown feels more responsive than a 400ms one — feel is the measurement, not milliseconds.

### Perceived performance

Motion speed is a performance feature independent of actual performance:

- A fast-spinning spinner makes the same wait feel shorter
- A 180ms select reads as more responsive than a 400ms one
- Tooltips that go instant after the first one make a whole toolbar feel instant

Easing compounds this: at identical duration, ease-out feels faster than ease-in because movement starts immediately.

## Springs and gestures

Springs simulate physics and — unlike CSS animations — retain velocity when interrupted, so a gesture reversed mid-flight continues smoothly from its current state instead of snapping. Use them for drags with momentum, interruptible gestures, and elements that should feel alive (the Dynamic Island class of motion). Bounce stays subtle (0.1–0.3) and playful; contextual icon swaps always use bounce `0`.

Gestures: dismiss on velocity, not distance alone; damp at boundaries instead of walling; capture the pointer for the drag's duration; ignore extra touch points; prefer friction to hard stops.

Code: [springs-gestures.md](springs-gestures.md).

## Components

Pressables scale to `0.96`. Nothing enters from `scale(0)` — start at `0.95` with opacity zero. Popovers scale from their trigger; modals stay centered. Tooltips delay once, then go instant. Anything retriggerable uses transitions, not keyframes. A 2px blur rescues crossfades that won't sit right. `@starting-style` replaces mount hacks. Lists stagger 30–80ms; deliberate holds run slow, releases snap fast.

Code, plus product principles for shared components: [components.md](components.md).

## Transforms and clip-path

`translate` percentages are relative to the element itself — height-independent hides and slides. `scale()` takes the children with it. `transform-origin` defaults to center and is usually wrong for anchored elements. `clip-path: inset()` is a general-purpose animation tool: reveals, wipes, hold-to-delete, comparison sliders.

Code: [transforms.md](transforms.md).

## Performance

Only `transform` and `opacity` skip layout and paint. Per-frame values never go through inherited CSS variables — every child recalculates. Library shorthands (Motion's `x`, `y`) run on the main thread; full `transform` strings run on the compositor. Predetermined motion belongs in CSS, which survives a busy main thread; dynamic interruptible motion belongs in JS. WAAPI gives JS control at CSS speed.

Details: [performance.md](performance.md).

## Accessibility

**Reduced motion means gentler, not nothing.** Keep the opacity and color transitions that carry meaning; remove movement and position changes:

```css
@media (prefers-reduced-motion: reduce) {
  .element {
    animation: fade 0.2s ease;
  }
}
```

```jsx
const shouldReduceMotion = useReducedMotion();
const closedX = shouldReduceMotion ? 0 : '-100%';
```

**Hover is a pointer-device feature.** Touch screens fire hover on tap and leave it stuck. Gate hover effects:

```css
@media (hover: hover) and (pointer: fine) {
  .element:hover {
    transform: scale(1.05);
  }
}
```

## Debugging motion

**Slow it down.** Run animations at 2–5x duration, or use the DevTools animation inspector. Slow motion exposes what full speed hides: colors cross-fading as two overlapping states instead of one transformation, easings that lurch at either end, elements scaling from the wrong origin, properties drifting out of sync.

**Step frames.** Chrome's Animations panel steps frame by frame — the only way to see timing between coordinated properties.

**Use real hardware.** For touch work (drawers, swipes), test on a physical device: phone over USB, dev server by IP, Safari remote inspection. Simulators approximate; hands don't.

## Review format (required)

UI review output is a markdown table — never prose before/after pairs:

| Before | After | Why |
| --- | --- | --- |
| `transition: all 300ms` | `transition: transform 200ms ease-out` | Name what changes; `all` animates accidents |
| `transform: scale(0)` | `transform: scale(0.95); opacity: 0` | Nothing real appears from nothing |
| `ease-in` on a dropdown | `ease-out` with a strong curve | ease-in delays the watched moment |
| No `:active` state | `transform: scale(0.96)` on `:active` | Pressables acknowledge presses |
| `transform-origin: center` on a popover | `transform-origin: var(--transform-origin)` | Popovers grow from their trigger; modals stay centered |

One row per issue; the Why column carries the principle.

## Review checklist

| Finding | Fix |
| --- | --- |
| `transition: all` | Name the properties: `transition: transform 200ms ease-out` |
| Entry from `scale(0)` | `scale(0.95)` + `opacity: 0` |
| `ease-in` on UI motion | ease-out or a strong custom curve |
| Centered `transform-origin` on a popover | Trigger origin (`var(--transform-origin)` in Base UI); modals exempt |
| Animation on a keyboard action | Remove it |
| UI duration > 300ms | 150–250ms |
| Hover effect with no media query | `@media (hover: hover) and (pointer: fine)` |
| Keyframes on a rapidly retriggered element | CSS transitions |
| Motion `x`/`y` props under load | Full `transform` string |
| Enter and exit at equal speed | Exit faster than enter (2s hold, 200ms release) |
| A list appearing all at once | Stagger: 30–80ms items, ~100ms semantic chunks |
