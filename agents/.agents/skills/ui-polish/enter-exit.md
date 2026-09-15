# Enter and exit

Staged entrances and the exits that follow them. Interactive state feedback: [animations.md](animations.md). Icon swaps: [icon-transitions.md](icon-transitions.md).

## Entrances: split and stagger

For infrequent staged entrances where order communicates hierarchy — a hero on first load, a success state, an empty state. Never for routine interaction: row hovers, keystrokes, repeated tab switches.

1. **Split** the content into semantic groups: headline, body, actions.
2. **Stagger** the groups ~100ms apart.
3. Headlines may split further into words at ~80ms.
4. Animate each chunk with opacity + blur + a small translateY: `opacity 0→1`, `blur(4px)→blur(0px)`, `y 12→0`.

Motion:

```tsx
const chunk = {
  hidden: { opacity: 0, y: 12, filter: "blur(4px)" },
  visible: { opacity: 1, y: 0, filter: "blur(0px)" },
};

function PageHeader() {
  return (
    <motion.div
      initial="hidden"
      animate="visible"
      variants={{ visible: { transition: { staggerChildren: 0.1 } } }}
    >
      <motion.h1 variants={chunk}>Welcome</motion.h1>
      <motion.p variants={chunk}>A description of the page.</motion.p>
      <motion.div variants={chunk}>
        <Button>Get started</Button>
      </motion.div>
    </motion.div>
  );
}
```

CSS-only:

```css
.stagger-item {
  opacity: 0;
  transform: translateY(12px);
  filter: blur(4px);
  animation: fadeInUp 400ms ease-out forwards;
}
.stagger-item:nth-child(1) { animation-delay: 0ms; }
.stagger-item:nth-child(2) { animation-delay: 100ms; }
.stagger-item:nth-child(3) { animation-delay: 200ms; }

@keyframes fadeInUp {
  to {
    opacity: 1;
    transform: translateY(0);
    filter: blur(0);
  }
}
```

## Exits

The user's attention has already moved on; an exit that demands it back is fighting the interaction. Exits are shorter and smaller than entrances.

**Default — small and directional:**

```css
.item-exit {
  opacity: 0;
  transform: translateY(-12px);
  transition: opacity 150ms ease-out, transform 150ms ease-out;
}
```

A fixed small translate rather than the element's full height: enough movement to say where it went, not enough to become a spectacle. Exit duration stays below enter duration — 150ms against 300ms.

Motion equivalent:

```tsx
<motion.div
  exit={{
    opacity: 0,
    y: -12,
    filter: "blur(4px)",
    transition: { duration: 0.15, ease: "easeOut" },
  }}
>
```

**Full slide where position carries context** — an item returning to its list, a drawer closing back to its edge:

```tsx
<motion.div exit={{ opacity: 0, x: "-100%", transition: { duration: 0.2, ease: "easeOut" } }}>
```

**No exit at all where motion adds nothing:** frequent removals, dense list churn, anything under a reduced-motion preference. Remove the element immediately.

The wrong version, for contrast — full-height travel, collapsing scale, `transition: all`, slower than the enter:

```css
.item-exit {
  opacity: 0;
  transform: translateY(-100%) scale(0.5);
  transition: all 400ms ease-out;
}
```
