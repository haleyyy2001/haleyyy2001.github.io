---
layout: post
title: "What a benchmark number entitles you to believe"
description: "A model that scores higher is not automatically the model you should use. Some notes on the gap between a leaderboard and a decision."
tags: [evaluation, explainability]
---

A colleague sends you two numbers: model A gets 0.91, model B gets 0.89. Which
one should go into the pipeline?

The honest answer is that you cannot tell yet, and most of the work of evaluation
is in what you have to know before the question becomes answerable. I want to
write down the checks I actually run, because I keep re-deriving them.

## The gap is smaller than it looks

The first thing to ask about a two-point difference is whether it would survive
being re-run. Three sources of wobble, roughly in order of how often they bite:

- **Seed variance.** Retrain with a different initialization and the ranking may
  flip. If you only trained once per model, you have one sample from each of two
  distributions and you are comparing their means.
- **Split variance.** A single held-out set is itself a sample. On a test set of
  500, the standard error on an accuracy near 0.9 is about 1.3 points — most of the
  gap you are trying to interpret.
- **Selection.** If you tuned model A on the same split you are now reporting, the
  number is optimistic by an amount nobody can estimate after the fact.

```python
# the cheapest useful check: how wide is a two-point gap, really?
import numpy as np

def accuracy_se(acc, n):
    return np.sqrt(acc * (1 - acc) / n)

accuracy_se(0.91, 500)   # 0.0128 -> a 0.02 gap is ~1.6 SE
```

None of this says model A is not better. It says a single scalar from a single run
does not carry the weight people put on it.

## Aggregate scores hide the cases you care about

The second question is where the gap lives. A model can gain two points overall
by getting easy cases slightly more right while getting worse on the subgroup
that motivated the project in the first place.

| | overall | common subtype | rare subtype |
|---|---|---|---|
| model A | 0.91 | 0.94 | 0.71 |
| model B | 0.89 | 0.90 | 0.83 |

Model A wins the leaderboard. Model B is the one you want, if the rare subtype is
the one where a prediction changes what a clinician does. This is not a
hypothetical failure mode; it is the default behavior of averaging over an
imbalanced population.

## The test I actually care about

The same problem shows up one level down, in explanations. A saliency map or an
attribution score is usually judged by whether it looks reasonable — the
highlighted region overlaps something a human would have pointed at.

That is a weak test, for two reasons. Stability is not identifiability: an
explanation can be perfectly reproducible across seeds and still be one of many
equally good explanations of the same prediction, in which case "the model used
this region" is not a claim the method can support. And plausibility is
circular — we are checking whether the explanation matches what we already
believed, which is precisely the case where it tells us nothing new.

> The question is not whether an explanation looks reasonable. It is whether it
> changes what we would do.

That reframing is useful because it is operational. If a method's output would
lead to the same next experiment whether it said *region X* or *region Y*, then
the method is not yet doing work, however good the visualization looks. If it
would lead somewhere different, then you have something to validate — and a
concrete perturbation to run.

## What I do before quoting a number

1. Retrain with at least three seeds and report the spread, not the best run.
2. Break the metric down by the subgroups the project exists to serve.
3. Say out loud what decision the number is supposed to license, and check that
   the gap is large enough to change it.
4. For any explanation, name the counterfactual: what would have to be different
   for me to act differently?

None of these are novel. They are just the steps that get skipped when a number
is already good enough to put in a slide.
