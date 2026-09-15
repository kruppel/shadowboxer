# Springs and gestures

Physics-based motion and drag mechanics.

## Why springs

Springs settle by physical parameters instead of a fixed duration, and — the part that matters for interaction — they retain velocity when interrupted. A CSS animation restarted mid-flight jumps; a spring reversed mid-flight continues smoothly from its current position and speed. Click an expanded item, press Escape immediately, and a spring-based collapse reverses without a snap.

Use springs for:

- Drags with momentum
- Gestures users may interrupt or reverse
- Elements that should feel alive (the Dynamic Island class of motion)
- Decorative pointer-following effects

## Pointer-following motion

Binding a visual property directly to mouse position feels mechanical — no inertia. Interpolate through a spring instead:

```jsx
import { useSpring } from 'framer-motion';

// mechanical: glued to the cursor
const rotation = mouseX * 0.1;

// natural: carries momentum
const springRotation = useSpring(mouseX * 0.1, {
  stiffness: 100,
  damping: 10,
});
```

This works because the effect is decorative. The same motion on a functional element — a chart in a banking app — would be noise. Decoration earns its place where feel is the function.

## Configuration

Two vocabularies:

```js
// Apple-style: duration and bounce — easier to reason about
{ type: "spring", duration: 0.5, bounce: 0.2 }

// physics: mass, stiffness, damping — finer control
{ type: "spring", mass: 1, stiffness: 100, damping: 10 }
```

Bounce stays within 0.1–0.3 when it appears at all, reserved for drag-to-dismiss and playful surfaces. Everything else: `0`. Contextual icon swaps always bounce `0` (`ui-polish`).

## Dismiss on velocity, not distance

A flick should dismiss even when it barely covers the threshold. Compute velocity as distance over elapsed time and accept either condition:

```js
const timeTaken = Date.now() - dragStartTime.current.getTime();
const velocity = Math.abs(swipeAmount) / timeTaken;

if (Math.abs(swipeAmount) >= SWIPE_THRESHOLD || velocity > 0.11) {
  dismiss();
}
```

## Boundaries damp, they don't wall

Dragging past a natural limit — pulling an already-open drawer further — meets increasing resistance: the harder the pull, the less the element moves. Physical things decelerate before stopping; an invisible hard stop reads as a bug. Where a direction is truly forbidden, friction still beats a clamp: allow the movement, attenuate it.

## Pointer capture

The moment a drag starts, the element captures the pointer. Fast drags leave the element bounds constantly; without capture the gesture dies mid-swipe.

## One finger per gesture

Ignore additional touch points after a drag begins. Without that guard, switching fingers mid-drag teleports the element to the new position:

```js
function onPress() {
  if (isDragging) return;
  // start drag...
}
```
