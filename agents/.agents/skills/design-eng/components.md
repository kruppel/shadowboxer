# Components

Principles for interface components that feel right: press feedback, entrances, anchored motion, masking, list choreography, and the product side of shared components.

## Press feedback

Every pressable element acknowledges the press: `transform: scale(0.96)` on `:active`, ~160ms ease-out transition. The interface should feel like it is listening. `0.96` is the value; below `0.95` reads as broken (recipes in `ui-polish`).

## Nothing enters from zero

`scale(0)` entrances pop into existence — nothing physical behaves that way. Enter from `scale(0.95)` with `opacity: 0`: the element reads as growing into place instead of appearing from nothing.

```css
/* wrong */
.entering { transform: scale(0); }

/* right */
.entering {
  transform: scale(0.95);
  opacity: 0;
}
```

## Anchored elements scale from their anchor

A popover grows out of the control that opened it — `transform-origin: center` is wrong for almost every popover. Set the origin to the trigger position (`var(--transform-origin)` in Base UI). Modals are the exception: unanchored, they stay centered.

Nobody notices any individual popover's origin. That is not the standard — in aggregate, this is precisely what people mean when they say an interface feels expensive.

## Tooltips: delay once, then instant

The first tooltip waits a short delay to prevent accidental activation. Every tooltip after that — while one is already open — appears instantly with no animation:

```css
.tooltip {
  transition: transform 125ms ease-out, opacity 125ms ease-out;
  transform-origin: var(--transform-origin);
}

.tooltip[data-starting-style],
.tooltip[data-ending-style] {
  opacity: 0;
  transform: scale(0.97);
}

.tooltip[data-instant] {
  transition-duration: 0ms;
}
```

Scanning a toolbar becomes immediate without making single hovers twitchy.

## Transitions for anything retriggerable

CSS transitions retarget from the current state; keyframe animations restart from zero. Toasts arrive in bursts, toggles get flipped mid-flight — that is transitions. Keyframes are for staged sequences that run once.

## Blur masks imperfect crossfades

When a crossfade between two states reads as two overlapping objects no matter how the easing and duration are tuned, add `filter: blur(2px)` during the swap. The blur blends the states so the eye perceives one transformation instead of an exchange:

```css
.button { transition: transform 160ms ease-out; }
.button:active { transform: scale(0.96); }

.button-content { transition: filter 200ms ease, opacity 200ms ease; }
.button-content.transitioning {
  filter: blur(2px);
  opacity: 0.7;
}
```

Keep blur under 20px — heavy blur is expensive, worst in Safari.

## Enter states without mount hacks

`@starting-style` animates first render in pure CSS:

```css
.toast {
  opacity: 1;
  transform: translateY(0);
  transition: opacity 400ms ease, transform 400ms ease;

  @starting-style {
    opacity: 0;
    transform: translateY(100%);
  }
}
```

Where browser support forbids it, the fallback is the classic mount flag:

```jsx
useEffect(() => setMounted(true), []);
// <div data-mounted={mounted}>
```

## List choreography

Items entering together stagger: each starts a small delay after the previous. 30–80ms between list items; ~100ms between semantic chunks like hero sections (see `ui-polish`). Stagger is decoration — it never blocks interaction.

Opacity and height animating in the same list — expanding rows, drawers of items — have no formula. They interact in ways that cannot be derived; tune them together until they feel right.

## Asymmetric timing

Slow where the user is deciding, fast where the system is answering. A hold-to-delete fills over ~2s linear — the duration is the confirmation. Its release snaps back in 200ms ease-out. The same split applies everywhere: deliberate in, instant out.

## Shared-component product principles

When a component ships for other people to use:

1. **Adoption is API design.** Zero setup beats features: one component rendered once, one function callable from anywhere. No providers, no hook ceremony, no config to read first.
2. **Defaults over options.** Almost nobody customizes. The out-of-box easing, timing and visuals carry the entire reputation.
3. **Names build identity.** A distinctive, evocative name beats a descriptive one — memorability is worth more than searchability when you can get it.
4. **Edge cases stay invisible.** Pause timers when the tab hides. Bridge the gaps between stacked elements so hover does not drop. Capture the pointer during drags. Users never see this work; that is what makes it right.
5. **Docs are interactive.** People decide by touching the thing. Live examples with copy-ready code lower every barrier at once.

## Cohesion

Motion must match the component's personality. The same easing can be elegant on one surface and sluggish on another: playful components carry bounce; professional dashboards stay crisp and fast. When values feel wrong against the design, the design's mood is the tiebreaker — choose motion that sounds like the thing it is attached to.

## Review it tomorrow

Motion mistakes hide from their author. Re-watch animations the next day, in slow motion or frame by frame; timing problems invisible during the build are obvious with fresh eyes.
