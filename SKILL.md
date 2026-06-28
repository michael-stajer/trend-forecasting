---
name: trend-forecasting
description: Forecast how a trend, technology, market, or geopolitical situation is likely to unfold. Use when the user wants to predict the future, extrapolate a trend, estimate a timeline, build a scenario, sanity-check a Polymarket/prediction-market bet, or stress-test a claim that "X will (or won't) happen." Applies a disciplined process — drop the weirdness filter, extrapolate trends, build explicit models, correct crowds downward on short-term events, and write scenarios.
allowed-tools:
  - WebSearch
  - WebFetch
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Trend Forecasting

A structured method for forecasting the future of a technology, market, or geopolitical
situation. The method is adapted from forecasting principles articulated by
**Daniel Kokotajlo** ([@DKokotajlo](https://x.com/dkokotajlo)), founder of the
[AI Futures Project](https://blog.aifutures.org/) and lead author of
[AI 2027](https://ai-2027.com/) and the earlier (and largely accurate) 2021 essay
[*What 2026 Looks Like*](https://www.alignmentforum.org/posts/6Xgy6CAf2jqHhynHL/what-2026-looks-like-daniel-s-median-future).
The five techniques below are drawn directly from his public writing on how he forecasts.

> "Trend extrapolation is your friend. Your best friend... I've only rarely seen someone
> extrapolate a trend too credulously; more often, people have a trend staring them in the
> face and extrapolate it a tiny bit into the future and then are too timid to keep
> extrapolating it." — Daniel Kokotajlo

## Core stance: drop the weirdness filter

Before forecasting anything, disarm the bias that does the most damage: **"things that sound
weird and sci-fi are less likely to happen."** That heuristic is bad. What's really going on
is that saying weird things puts you at *social* risk of being judged a weirdo — which is not
the same thing as those things being *unlikely*.

Repeat the mantra: **some weird sci-fi things really do happen, and others don't — judge each
on a case-by-case basis.** Do not down-weight a conclusion just because it would feel
embarrassing to assert. Weight it by the evidence.

## The workflow

Work through these five steps. Not every forecast needs all five, but always do (1) and (2);
add (3)–(5) as the stakes and time horizon warrant. State your reasoning out loud at each step.

### 1. Identify and extrapolate the trend

- **Find the trend that's staring you in the face.** Get the actual data — search for it,
  pull the numbers, look at the curve. Don't forecast from vibes when a measured series exists.
- **Extrapolate boldly, then correct.** As a default rule of thumb: *extrapolate a trend about
  as far into the future as it extends into the past.* A trend with 10 years of clean history
  earns ~10 years of extrapolation as a starting point. Most people stop far too early out of
  timidity — push further than feels comfortable, then reel it back with reasons.
- **Mind the axis.** Many real trends are exponential (or follow a power law). Extrapolate in
  the space where the trend is *linear* (often log-scale), or you'll wildly under-project.

### 2. Interrogate the trend — does it make sense to continue?

Extrapolation is the *beginning* of forecasting, not the end. For each extrapolated trend, ask:

- **Why has this trend held?** What are the underlying drivers (cost curves, feedback loops,
  adoption dynamics, physical limits)?
- **Will those drivers persist?** What would have to stay true for the line to continue?
- **Where does it bend or break?** Identify the constraint that eventually bites — a physical
  ceiling, a saturated market, a resource bottleneck, a regulatory wall, an S-curve plateau.

You'll usually land on a **sophisticated view**: the trend probably continues, *bends downward
a bit*, and eventually *plateaus around level X*. Name your best guess for X and roughly when.

### 3. Build (or borrow) an explicit model

For high-stakes or quantitative forecasts, make the reasoning a model — even a rough one.

- **Build your own.** Write down the key variables, their relationships, and your parameter
  estimates. A back-of-envelope model or small spreadsheet/script (use Bash/Python) beats a
  hand-wave. The *act of building* is the point: it forces you to find the parameters the
  answer is actually sensitive to, and to be honest about the ones you have no clue about.
- **Engage with existing models** rather than reinventing them. For AI/tech timelines, the
  canonical ones are:
  - **Bio Anchors** (Ajeya Cotra) — bounds AI timelines via the compute needed to "train"
    something brain-sized. [In a nutshell](https://www.cold-takes.com/forecasting-transformative-ai-the-biological-anchors-method-in-a-nutshell/).
  - **Takeoff Speeds model** (Tom Davidson / Epoch) — interactive compute-centric model of AGI
    takeoff. [takeoffspeeds.com](https://takeoffspeeds.com/).
  - **The AI Futures / AI 2027 model** — the timelines and takeoff models behind AI 2027.
    [ai-2027.com](https://ai-2027.com/).
- **Run sensitivity analysis.** Vary each parameter. Where the output swings hard on a number
  you can't justify, that's your real uncertainty — say so. This is where models teach humility.

### 4. For short-term events, correct the crowd downward

For near-term, discrete events — the kind people bet on at Polymarket, "will X happen by date Y"
geopolitical questions — apply the **"nothing ever happens"** heuristic.

- The base rate for "a specific dramatic thing happens by a specific soon date" is low. Things
  *do* happen, but **betting markets and online discourse are biased toward over-predicting that
  they will** (a measured pro-"Yes" bias).
- So: take the crowd / market probability and **shade it downward** a notch. Often an easy edge.
- This is a *short-term* heuristic for discrete events. Do **not** apply it to long-run trends —
  there, the opposite error (timid under-extrapolation) dominates.

### 5. Write a scenario forecast

A narrative forces coherence that point-estimates hide. This is the method behind *What 2026
Looks Like* and *AI 2027*.

- **Start from the present and step forward** in concrete increments (quarters or years).
  Describe what the world looks like at each step — capabilities, actors, prices, events.
- **Keep it internally consistent.** The discipline is that the pieces must hang together:
  if you wrote that X is cheap by 2027, the 2028 panel can't assume X is scarce. As Kokotajlo
  puts it, writing the detail makes you "realize it kind of just doesn't hang together — you
  can't fix the plot holes." Plot holes are *information*: they reveal beliefs that contradict.
- **Be specific and textured.** Vague scenarios are useless; name numbers, dates, and actors so
  the story can actually be wrong.
- **Consider 2–4 distinct scenarios**, not one. A common frame: a central "trend continues" line,
  plus branches where a key uncertainty resolves the other way. Don't treat any one as *the*
  prediction — they map the possibility space.
- **Adding speculative detail lowers probability.** A 7-step specific story is less likely than
  its 3-step skeleton. Use scenarios to test coherence and surface questions, then attach honest
  (lower) probabilities to the detailed versions.

## Output

Deliver, roughly in this shape:

1. **The trend(s)** with data and source links.
2. **The naive extrapolation** (far-out, before corrections) — be bold here.
3. **The corrected forecast** — where it bends/plateaus and why, with a best-guess level and date.
4. **A model or explicit reasoning** for quantitative claims, noting the parameters it's most
   sensitive to.
5. **Calibrated probabilities** — and for short-term discrete events, note where you shaded the
   crowd down.
6. **One or more scenario narratives** if the question warrants it.
7. **Key uncertainties** — what you'd most want to learn to sharpen the forecast.

Throughout: cite sources, state assumptions explicitly, and never reject a conclusion just
because it sounds weird.

## Pitfalls

- **Timid extrapolation** — stopping a year out when the trend has a decade of history. The most
  common error. Push further.
- **Weirdness aversion** — discounting a well-supported conclusion because it's socially awkward
  to say.
- **Extrapolating on the wrong axis** — projecting an exponential as if it were linear.
- **Pure extrapolation with no interrogation** — every trend bends eventually; find the bend.
- **Applying "nothing ever happens" to long-run trends** — it's a short-term, discrete-event tool.
- **Model false precision** — a model's output is only as good as its softest parameter; report
  the sensitivity, not just the point estimate.

## See also

- [`examples/worked-example.md`](examples/worked-example.md) — the full workflow applied end to
  end to one forecast (solar electricity cost to 2035), showing every step's reasoning.
- [`scripts/forecast_model.py`](scripts/forecast_model.py) — a pure-stdlib back-of-envelope
  modeling toolkit (exponential extrapolation, Wright's law, logistic plateau, crowd correction,
  sensitivity analysis). Run `python3 scripts/forecast_model.py` for a worked demo.

## Credit & sources

Method adapted from a thread by **Daniel Kokotajlo** (@DKokotajlo), AI Futures Project.

- Daniel Kokotajlo, [*What 2026 Looks Like*](https://www.alignmentforum.org/posts/6Xgy6CAf2jqHhynHL/what-2026-looks-like-daniel-s-median-future) (2021) — and a [retrospective on its accuracy](https://asteriskmag.substack.com/p/before-he-wrote-ai-2027-he-predicted).
- [AI 2027](https://ai-2027.com/) — Kokotajlo, Lifland, Larsen, Dean (2025).
- Ajeya Cotra, [Bio Anchors method in a nutshell](https://www.cold-takes.com/forecasting-transformative-ai-the-biological-anchors-method-in-a-nutshell/).
- Tom Davidson / Epoch, [Takeoff Speeds interactive model](https://takeoffspeeds.com/) and [writeup](https://epoch.ai/blog/interactive-model-of-takeoff-speeds).
- On "nothing ever happens": [Peter Wildeford, *Top Forecaster: "Nothing Ever Happens"*](https://peterwildeford.substack.com/p/3-top-forecaster-nothing-ever-happens).
- On scenario method: [Shell/Pierre Wack scenario planning](https://en.wikipedia.org/wiki/Scenario_planning).
