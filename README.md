# trend-forecasting

A [Claude Code](https://claude.com/claude-code) **skill** for forecasting how a trend,
technology, market, or geopolitical situation is likely to unfold — with a disciplined,
repeatable process instead of vibes.

The method is adapted from forecasting principles articulated by **Daniel Kokotajlo**
([@DKokotajlo](https://x.com/dkokotajlo)), founder of the
[AI Futures Project](https://blog.aifutures.org/) and lead author of [AI 2027](https://ai-2027.com/)
and the 2021 essay [*What 2026 Looks Like*](https://www.alignmentforum.org/posts/6Xgy6CAf2jqHhynHL/what-2026-looks-like-daniel-s-median-future).
See [Credit & sources](#credit--sources).

> "Trend extrapolation is your friend. Your best friend... more often, people have a trend
> staring them in the face and extrapolate it a tiny bit into the future and then are too timid
> to keep extrapolating it." — Daniel Kokotajlo

## What it does

When you ask Claude to predict something, estimate a timeline, extrapolate a trend, sanity-check
a Polymarket bet, or stress-test a "X will/won't happen" claim, this skill steers it through a
five-step process:

1. **Identify & extrapolate the trend** — get the real data; extrapolate as far forward as the
   trend extends back (most people stop far too early); reason on the axis where it's linear.
2. **Interrogate the trend** — why has it held, will the drivers persist, where does it bend or
   plateau? Land on a sophisticated view, not a naive straight line.
3. **Build an explicit model** — make the reasoning quantitative; run sensitivity analysis to
   find the parameter the answer actually hinges on (and stay humble about the ones you can't
   justify).
4. **Correct the crowd downward** on short-term discrete events — the "nothing ever happens"
   heuristic, because markets and discourse over-predict dramatic YES outcomes.
5. **Write a scenario forecast** — a concrete, internally-consistent narrative that surfaces the
   contradictions point-estimates hide.

It opens by **dropping the weirdness filter**: a conclusion isn't less likely just because it
sounds sci-fi and would be socially awkward to assert. Social risk ≠ low probability.

## Contents

| File | What it is |
|---|---|
| [`SKILL.md`](SKILL.md) | The skill itself — workflow, output format, pitfalls, sources. |
| [`examples/worked-example.md`](examples/worked-example.md) | The full workflow applied end to end (solar electricity cost to 2035). |
| [`scripts/forecast_model.py`](scripts/forecast_model.py) | Pure-stdlib modeling toolkit: exponential extrapolation, Wright's law, logistic plateau, crowd correction, sensitivity analysis. |

## Install

This is a personal Claude Code skill. Clone it into your skills directory:

```bash
git clone https://github.com/michael-stajer/trend-forecasting.git \
  ~/.claude/skills/trend-forecasting
```

Or symlink a checkout so you can keep it updated with `git pull`:

```bash
git clone https://github.com/michael-stajer/trend-forecasting.git
ln -s "$(pwd)/trend-forecasting" ~/.claude/skills/trend-forecasting
```

Claude Code discovers skills in `~/.claude/skills/<name>/SKILL.md` automatically. Project-scoped
installs work too — drop it in `.claude/skills/` inside a repo.

## Use

Just ask in natural language; the skill triggers on forecasting-shaped requests. Examples:

- "Forecast where home battery prices land by 2032."
- "Extrapolate this user-growth curve and tell me where it plateaus."
- "Polymarket has this at 60% — is that too high?"
- "Write a scenario forecast for the EV transition in this region."

Try the model toolkit directly:

```bash
python3 scripts/forecast_model.py     # runs an illustrative worked demo
```

## Credit & sources

Method adapted from a public thread by **Daniel Kokotajlo** (@DKokotajlo), AI Futures Project.
This repository is an independent reformulation of those ideas into a skill; it is not affiliated
with or endorsed by him.

- Daniel Kokotajlo, [*What 2026 Looks Like*](https://www.alignmentforum.org/posts/6Xgy6CAf2jqHhynHL/what-2026-looks-like-daniel-s-median-future) (2021) — and a [retrospective on its accuracy](https://asteriskmag.substack.com/p/before-he-wrote-ai-2027-he-predicted).
- [AI 2027](https://ai-2027.com/) — Kokotajlo, Lifland, Larsen, Dean (2025).
- Ajeya Cotra, [Bio Anchors method in a nutshell](https://www.cold-takes.com/forecasting-transformative-ai-the-biological-anchors-method-in-a-nutshell/).
- Tom Davidson / Epoch, [Takeoff Speeds interactive model](https://takeoffspeeds.com/) and [writeup](https://epoch.ai/blog/interactive-model-of-takeoff-speeds).
- On "nothing ever happens": [Peter Wildeford, *Top Forecaster: "Nothing Ever Happens"*](https://peterwildeford.substack.com/p/3-top-forecaster-nothing-ever-happens).
- On the scenario method: [Shell / Pierre Wack scenario planning](https://en.wikipedia.org/wiki/Scenario_planning).

## License

[MIT](LICENSE).
