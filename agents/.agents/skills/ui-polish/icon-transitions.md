# Icon transitions

Swapping one icon for another on state or context change. Weight, color, direction: [icons.md](icons.md).

## The values

Contextual icon swaps animate with `opacity`, `scale` and `blur` — never a bare visibility toggle — on exactly these values:

- `scale`: `0.25` → `1` (never `0.5` or `0.6`)
- `opacity`: `0` → `1`
- `filter`: `blur(4px)` → `blur(0px)`
- Motion: `transition: { type: "spring", duration: 0.3, bounce: 0 }` — bounce is always `0`
- CSS fallback curve: `cubic-bezier(0.2, 0, 0, 1)`

## With a motion library

Use whatever the project already has: `motion` imports from `"motion/react"`, `framer-motion` from `"framer-motion"`. Where both exist, follow the surrounding code. Never add either dependency just for an icon swap.

```tsx
import { AnimatePresence, motion } from "motion/react";

function IconButton({ isActive, icon: Icon }) {
  return (
    <button>
      <AnimatePresence mode="popLayout">
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
    </button>
  );
}
```

## Without one

Both icons stay mounted, one layered absolutely over the other. The state toggle cross-fades them — entering icon scales up from `0.25`, exiting scales down, both with opacity and blur. Nothing unmounts, so both directions animate:

```tsx
function IconButton({ isActive, ActiveIcon, InactiveIcon }) {
  return (
    <button>
      <div className="relative">
        <div
          className={cn(
            "absolute inset-0 flex items-center justify-center",
            "transition-[opacity,filter,scale] duration-300",
            "ease-[cubic-bezier(0.2,0,0,1)]",
            isActive
              ? "scale-100 opacity-100 blur-0"
              : "scale-[0.25] opacity-0 blur-[4px]",
          )}
        >
          <ActiveIcon />
        </div>
        <div
          className={cn(
            "transition-[opacity,filter,scale] duration-300",
            "ease-[cubic-bezier(0.2,0,0,1)]",
            isActive
              ? "scale-[0.25] opacity-0 blur-[4px]"
              : "scale-100 opacity-100 blur-0",
          )}
        >
          <InactiveIcon />
        </div>
      </div>
    </button>
  );
}
```

The in-flow icon sets the layout size; the absolute one overlays without affecting flow. The CSS cross-fade approximates the spring with `cubic-bezier(0.2, 0, 0, 1)` — close enough at zero dependencies.

## When to animate an icon

| Animate | Leave static |
| --- | --- |
| Action icons appearing on hover | Always-visible navigation icons |
| State swaps: play/pause, like/liked | Decorative icons |
| Contextual toolbar reveals | Labels beside icons |
| Loading and success indicators | |
