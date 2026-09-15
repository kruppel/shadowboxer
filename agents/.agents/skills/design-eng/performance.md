# Performance

Keeping motion off the critical path.

## Animate transform and opacity, nothing else

Those two skip layout and paint and run on the compositor. `padding`, `margin`, `width`, `height` re-run the whole pipeline per frame — the animation stutters and takes the page with it.

## Inherited CSS variables are a per-frame trap

Changing a custom property on a container recalculates styles for every descendant. Driving a drag through `--swipe-amount` on a drawer full of items recomputes them all, every frame:

```js
// wrong: recalc cascades to every child
element.style.setProperty('--swipe-amount', `${distance}px`);

// right: touches one element
element.style.transform = `translateY(${distance}px)`;
```

## Library shorthands run on the main thread

Motion's `x`/`y`/`scale` props animate via `requestAnimationFrame` — main-thread work that drops frames the moment the page is busy loading or scripting. The full `transform` string goes to the compositor:

```jsx
// drops frames under load
<motion.div animate={{ x: 100 }} />

// stays smooth while the page works
<motion.div animate={{ transform: "translateX(100px)" }} />
```

The difference only shows under real conditions: mid-navigation, during data loads, on low-end hardware. Test there, not on an idle page.

## Predetermined motion belongs in CSS

CSS animations run off the main thread and keep playing while JS is busy; rAF-driven animation drops frames in the same situation. Split by nature: end state known ahead of time → CSS. Dynamic, interruptible, gesture-driven → JS (springs, see [springs-gestures.md](springs-gestures.md)).

Main-thread layout animations are the classic failure: flawless in development, stuttering through production page loads.

## WAAPI: JS control, CSS speed

The Web Animations API drives compositor-friendly animations programmatically — hardware-accelerated, interruptible, no dependency:

```js
element.animate(
  [{ transform: 'translateY(100%)' }, { transform: 'translateY(0)' }],
  {
    duration: 300,
    fill: 'forwards',
    easing: 'cubic-bezier(0.77, 0, 0.175, 1)',
  },
);
```
