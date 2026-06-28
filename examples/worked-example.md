# Worked example: forecasting solar electricity cost to 2035

This walks the [trend-forecasting](../SKILL.md) workflow end to end on one question. The
numbers are **illustrative** — the point is to show the *moves*, not to publish a solar
forecast. Re-pull live data before relying on any figure. The quantitative steps mirror
[`scripts/forecast_model.py`](../scripts/forecast_model.py); run it to reproduce them.

> **Question:** How cheap will utility-scale solar electricity get by ~2035, and what does
> that imply for the grid?

---

## Core stance: drop the weirdness filter

"Solar undercuts coal almost everywhere and keeps falling" *sounded* like cleantech-booster
fantasy for two decades. The embarrassment of sounding like a booster is a social risk, not
evidence about physics. Judge it on the data. Mantra: some weird things happen, some don't —
case by case.

---

## Step 1 — Identify and extrapolate the trend

**The trend staring us in the face:** two clean, decades-long series.

- Cumulative installed PV has grown ~25%/yr for ~20 years.
- Module price has fallen ~20% for every *doubling* of that cumulative volume (Swanson's law /
  Wright's law) — roughly two orders of magnitude over the period.

**Extrapolate boldly.** The rule of thumb: extrapolate about as far forward as the trend
extends back. We have ~20 years of history, so a 10-year extrapolation is *conservative*, well
within bounds — the timid move would be to project 2–3 years and stop.

**Mind the axis.** Cost-vs-time looks like it's flattening on a linear plot, which fools people
into under-projecting. On a log-cost vs log-cumulative-volume axis the trend is a straight line.
Extrapolate *there*.

Mechanically (from the script):

- Deployment: 1500 GW → ~14,000 GW over 10y at 25%/yr ≈ **3.2 doublings**.
- Wright's law at 20%/doubling: $0.30/W → **~$0.15/W** module cost.

---

## Step 2 — Interrogate the trend: does it make sense to continue?

Extrapolation is the *start*, not the answer. Now ask why the line held and where it bends.

- **Why it held:** learning-by-doing, scale economies, silicon supply chain maturation, global
  competition. These drivers are still live, so the curve doesn't just stop.
- **Where it bends:** module cost is now a *minority* of a project. Balance-of-system (land,
  labor, inverters, grid hookup, permitting) and raw-material floors don't follow the same
  curve. So total system cost bends downward *less* steeply than the module line suggests.
- **The plateau:** modules approach a materials/manufacturing floor (~$0.10/W in this
  illustration). The learning curve flattens into an S-curve there.

**Sophisticated view:** module cost keeps falling but bends and plateaus near ~$0.12–0.15/W;
the *binding* constraint shifts from module price to balance-of-system and, increasingly, to
**storage and grid integration** rather than generation cost.

---

## Step 3 — Build an explicit model (and run sensitivity)

The two-line model is in [`forecast_model.py`](../scripts/forecast_model.py): exponential
deployment → Wright's law cost → floor. The *value* isn't the point estimate; it's the
sensitivity table:

```
growth  : $0.19 -> $0.11/W   (swing $0.08)   <- answer hinges most on deployment growth
learn   : $0.18 -> $0.12/W   (swing $0.06)
```

So the forecast hinges hardest on **whether 25%/yr deployment growth holds** — that's the
number to research hardest and the honest place to put the error bars. (If you have no real
basis for the learning rate, the model just *told you* it matters less than you feared — that's
the humility the modeling exercise is supposed to teach.)

---

## Step 4 — Short-term discrete event: correct the crowd downward

Different kind of question, bolted on to show the move. Suppose a market asks:

> "Will [Country X] hit its 2027 national solar target on schedule?" — market says **40% YES**.

National infrastructure targets slip constantly; "nothing ever happens" on schedule. Markets
and discourse over-predict discrete YES outcomes. Shade it down ~10% → **~36% YES**, and lower
if the target was set for political rather than engineering reasons.

Note the asymmetry: we extrapolated the *long-run trend* aggressively (step 1) while shading the
*short-term discrete event* downward (step 4). Same forecaster, opposite corrections, because
the dominant error differs by horizon.

---

## Step 5 — Scenario forecast

Two internally-consistent narratives, stepping forward from today. Neither is *the* prediction.

**Scenario A — "Generation is solved, the grid is the bottleneck" (central).**
2026–28: module prices drift to ~$0.13/W; solar is the cheapest new generation almost
everywhere. 2029–31: deployment stays ~20–25%/yr but **curtailment and duck-curve** problems
bite — midday power is near-free, evening power isn't. The story stays consistent only if
storage scales with it, so the binding question becomes batteries, not panels. 2032–35: the
constraint has fully migrated from $/W to $/kWh-stored and transmission permitting.

**Scenario B — "Trade and materials shock" (branch where a key uncertainty flips).**
A supply shock (polysilicon, trade barriers, a key-material squeeze) breaks the 25% deployment
assumption around 2028. Fewer doublings → the cost curve stalls higher (~$0.20/W) for several
years. Consistency check: if deployment stalls, the grid-integration crunch of Scenario A
arrives *later* — you can't have both a stalled rollout and an acute duck curve in the same year.

Writing them out surfaces the real pivot: **storage + grid**, not module cost. That's the plot
hole that point-estimates hide — a sign our beliefs were quietly assuming something we hadn't
checked.

---

## Output summary

| | Forecast |
|---|---|
| **Trend** | ~25%/yr deployment; ~20% cost drop per capacity doubling (~20y history) |
| **Naive extrapolation** | module cost ~$0.15/W by 2035 |
| **Corrected** | bends/plateaus ~$0.12–0.15/W; constraint shifts to storage + grid |
| **Model hinges on** | deployment growth rate (largest sensitivity swing) |
| **Short-term event** | shade market YES down ~10% ("nothing ever happens") |
| **Key uncertainty** | does 25%/yr deployment hold? does storage scale with generation? |

Throughout: sources cited, assumptions explicit, and no conclusion rejected for sounding weird.
