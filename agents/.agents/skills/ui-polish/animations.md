# Animations

Interruptibility, press feedback, first-paint behavior, theme flips, restraint. Staged entrances: [enter-exit.md](enter-exit.md). Icon swaps: [icon-transitions.md](icon-transitions.md).

## Transitions vs keyframes

Users change their mind mid-interaction. Motion that cannot cope reads as broken.

| | Transition | Keyframe animation |
| --- | --- | --- |
| Retriggered mid-flight | Retargets from current state | Restarts from zero |
| Right for | Hover, toggles, open/close — anything interactive | Staged sequences that run once |

```css
/* right: toggling mid-animation reverses smoothly */
.drawer {
  transform: translateX(-100%);
  transition: transform 200ms ease-out;
}
.drawer.open {
  transform: translateX(0);
}

/* wrong: closing mid-slide snaps */
.drawer.open {
  animation: slideIn 200ms ease-out forwards;
}
```

## Press feedback

Every pressable element acknowledges the press with `scale(0.96)`:

```css
.button {
  transition-property: scale;
  transition-duration: 150ms;
  transition-timing-function: ease-out;
}
.button:active {
  scale: 0.96;
}
```

```tsx
<button className="transition-transform duration-150 ease-out active:scale-[0.96]">
```

```tsx
<motion.button whileTap={{ scale: 0.96 }}>
```

Two rules: never below `0.95` — that reads as broken, not tactile — and always provide an escape hatch for contexts where the movement would distract (dense tables, toolbars):

```tsx
const tapScale = "active:not-disabled:scale-[0.96]";

function Button({ static: isStatic, className, children, ...props }) {
  return (
    <button
      className={cn(
        "transition-transform duration-150 ease-out",
        !isStatic && tapScale,
        className,
      )}
      {...props}
    >
      {children}
    </button>
  );
}
```

## First paint is not an entrance

Elements already in their default state at page load should not animate. With `AnimatePresence` that means `initial={false}`:

```tsx
<AnimatePresence initial={false} mode="popLayout">
  <motion.span
    key={isActive ? "active" : "inactive"}
    initial={{ opacity: 0, scale: 0.25, filter: "blur(4px)" }}
    animate={{ opacity: 1, scale: 1, filter: "blur(0px)" }}
    exit={{ opacity: 0, scale: 0.25, filter: "blur(4px)" }}
    transition={{ type: "spring", duration: 0.3, bounce: 0 }}
  >
    <Icon />
  </motion.span>
</AnimatePresence>
```

Right for icon swaps, toggles, tabs, segmented controls — anything with a default state at load. Wrong where the entrance is the point: a staged hero or loading reveal relying on its `initial` prop loses it entirely under `initial={false}`. Check a full page refresh before shipping.

## Theme flips

A theme switch changes color, background, border and shadow on nearly every element at once. Every transition on those properties fires together and the flip smears instead of snapping. Suppress, commit, restore:

```tsx
"use client";

import { useEffect } from "react";

export function DisableThemeTransitions() {
  useEffect(() => {
    const mql = window.matchMedia("(prefers-color-scheme: dark)");

    const handleChange = () => {
      const style = document.createElement("style");
      style.append(
        document.createTextNode("*,*::before,*::after{transition:none !important}"),
      );
      document.head.append(style);

      const _reflow = document.body.offsetHeight; // style flush while suppressed

      requestAnimationFrame(() => {
        requestAnimationFrame(() => style.remove());
      });
    };

    mql.addEventListener("change", handleChange);
    return () => mql.removeEventListener("change", handleChange);
  }, []);

  return null;
}
```

The reflow read commits the new colors while suppression is still in effect; the double `requestAnimationFrame` removes the override only after that paint. In-app toggles need the same treatment around their own flip: apply, switch, flush, remove. `next-themes` ships this as `disableTransitionOnChange`.

## Restraint

Motion is a budget. Three rules spend it:

1. **High-frequency interactions answer instantly.** Keystrokes, row hovers, tab switches in a work tool: instant feedback, or the quietest possible transition (opacity/background-color, ≤150ms). Choreography is for infrequent moments — a view's first load, success states, empty states.
2. **Every motion has a static twin.** A state change an animation communicates must still read with the animation removed: a color change, an icon swap, a label. Reduced-motion users and everyone who blinked need the same information.
3. **Shorter and smaller wins.** Where a smaller animation says the same thing, use it. When in doubt, cut duration, never clarity.

```css
/* right: dense row hover is nearly instant */
.row:hover {
  background-color: var(--surface-hover);
  transition: background-color 100ms ease-out;
}

/* wrong: hover replays choreography */
.row:hover .row-icon {
  animation: bounceIn 500ms;
}
```
