---
name: ui-polish
description: The value book for interface work. Exact radii, shadows, icon strokes, motion values, press feedback, entrances and exits. Use when building or reviewing UI components.
---

# UI polish

Polish is the accumulation of small correct decisions. This skill is the reference for those decisions: which details matter and the exact values they take.

Ground rules:

- Values here are precise, not approximations. `0.96` is not `0.95`. `cubic-bezier(0.2, 0, 0, 1)` is not `ease-out`.
- Where the project has established tokens, a component library, or a motion language, follow it. These rules fill gaps and override only what is clearly wrong.
- When reviewing, play motion at 10% speed. What looks broken in slow motion is what feels subtly broken at full speed.
- Judgment calls — whether something should animate, what a duration communicates, spring versus tween — belong to the `design-eng` skill. This one holds the numbers once decided.

Out of scope: typography, focus/hit-area/ARIA accessibility, page-level layout systems.

## Surfaces

**Concentric radius.** Outer radius = inner radius + padding. Nested elements with mismatched radii are the single most common reason an interface feels wrong. Past ~24px of padding the layers stop reading as one nested surface; choose each radius independently. Recipes: [surfaces.md](surfaces.md).

**Shadows carry depth, borders carry meaning.** A border whose only job is lift becomes a layered, translucent `box-shadow` that adapts to any background. Borders that mean something stay: dividers, separators, selection and focus states, form outlines.

**Images get an outline.** 1px at 10% opacity — pure black in light mode, pure white in dark, never a tinted neutral (it picks up the surface below and reads as grime). Use `outline`, not `border`: zero layout impact.

**Optical over geometric alignment.** When centering looks wrong, it is wrong. Icon sides of buttons take ~2px less padding than label sides. Play triangles nudge ~2px forward. Asymmetric glyphs get fixed in the SVG itself, not patched with margins.

## Icons

**Stroke follows text weight.** `1.5px` beside regular text, `2px` beside semibold, `2.5px` beside bold. One icon library per surface, one stroke strategy per set.

**One asset, states in CSS.** Icons draw with `currentColor`; hover, selected and disabled come from CSS color and opacity, never separate files. Outline is the resting variant, fill marks active.

**Contextual swaps animate with fixed values.** Scale `0.25` to `1`, opacity `0` to `1`, blur `4px` to `0`, spring `{ duration: 0.3, bounce: 0 }` — bounce is always `0`. Motion and dependency-free CSS recipes: [icon-transitions.md](icon-transitions.md). Sizing, render-size design, RTL mirroring: [icons.md](icons.md).

## Motion

**Transitions for interaction, keyframes for sequences.** Anything a user can retrigger mid-flight uses CSS transitions — they retarget from the current state. Keyframes restart from zero and read as broken under rapid input. Reserve them for staged sequences that run once.

**Press feedback.** `scale(0.96)` at ~150ms ease-out on every pressable element. Never below `0.95`. Components get a `static` escape hatch where the movement would distract. Recipes: [animations.md](animations.md#press-feedback).

**Entrances stage, exits whisper.** Infrequent entrances split into semantic chunks staggered ~100ms apart (words within a headline ~80ms), animating opacity + blur + small translateY. Exits run shorter (~150ms vs ~300ms) and smaller — a fixed `-12px`, never the element's full height. Routine interactions stagger not at all. [enter-exit.md](enter-exit.md).

**First paint is not an entrance.** `initial={false}` on `AnimatePresence` keeps already-present elements from animating on mount — unless the entrance is the point (staged heroes).

**Theme flips kill transitions.** Inject `*,*::before,*::after{transition:none !important}`, force a reflow, remove it on the next frame. Otherwise every transition on every themed property fires at once and the flip smears. Recipe: [animations.md](animations.md#theme-flips).

**Name what you transition.** `transition-property: scale, opacity` — never `all`. Tailwind's `transition-transform` actually covers transform, translate, scale and rotate.

**`will-change` is a repair.** Only `transform`, `opacity`, `filter`; only after observing first-frame stutter; never `all`, never preemptive. [performance.md](performance.md).

**Restraint.** High-frequency interactions get instant feedback or ≤150ms on opacity/color — nothing choreographed. And every state change motion communicates also needs a static cue: color, icon, or label. Motion is never the only channel.

## Before you finish

| Symptom | Fix |
| --- | --- |
| Icons read off-center | Optical nudge, or fix the SVG |
| Entrance or exit feels heavy | Stage the entrance; shorten and shrink the exit |
| Theme flip smears | Suppress transitions for the flip, reflow, restore |
| Unexpected properties animate | Name exact properties; drop `all` |
| First frame stutters | `will-change: transform`, that element only |
| Hairline icon beside bold label | Match stroke to text weight |

## Reviewing UI

Severity: `HIGH` breaks an interaction, makes motion unusable, or leaves a state visible only while an animation runs. `MEDIUM` is a visible inconsistency in surfaces, icons or motion. `LOW` is isolated polish.

Verification: without a browser, walk every state the component defines — hover, focus, active, loading, empty — and read durations and easings from the code. With a browser, walk the states live and replay motion at 10% speed in the Animations panel. Mark anything unchecked `Not verified`.

Report one row per root cause, grouped under the rule violated, ordered by severity:

| Severity | Location | Before | After | Why |
| --- | --- | --- | --- | --- |

`Location` is `path/to/file:line`. `Why` names the rule and the user impact. Any open `HIGH` ends the review in `Block`; otherwise `Approve`, leaving the rest as work items. Never approve coverage you did not inspect. Nothing to report: "No UI-polish findings", plus what was verified.
