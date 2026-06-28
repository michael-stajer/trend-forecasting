#!/usr/bin/env python3
"""
forecast_model.py — a back-of-envelope modeling toolkit for the trend-forecasting skill.

Pure standard library, no dependencies. The point of a model is not precision; it is to
force you to (a) write your assumptions down, (b) find the parameter the answer is most
sensitive to, and (c) be honest about the parameters you can't justify.

Provides four building blocks that map to the skill's workflow:

  1. extrapolate_exponential  — step 1: bold extrapolation of a constant-growth-rate trend
  2. wrights_law              — step 3: experience/learning curve (cost vs cumulative volume)
  3. logistic                 — step 2: a trend that bends and plateaus (S-curve)
  4. correct_crowd            — step 4: shade a short-term market probability downward
  5. sensitivity              — step 3: how much the output swings on each parameter

Run `python3 forecast_model.py` for a worked demo, or import the functions.
"""

from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Callable


# --------------------------------------------------------------------------------------
# 1. Exponential / constant-growth extrapolation  (skill step 1)
# --------------------------------------------------------------------------------------
def extrapolate_exponential(start_value: float, annual_growth: float, years: float) -> float:
    """Project a value forward at a constant compound annual growth rate.

    annual_growth is a fraction: 0.20 == +20%/yr, -0.10 == -10%/yr.

    Rule of thumb from the skill: extrapolate about as far forward as the trend extends
    back. If you have 10 clean years of history, `years=10` is a reasonable *starting*
    point — then correct it in step 2. Work on the axis where the trend is linear: for an
    exponential, that means reasoning in log-space (this function does the right thing).
    """
    return start_value * (1.0 + annual_growth) ** years


def cagr(start_value: float, end_value: float, years: float) -> float:
    """Recover the compound annual growth rate implied by two endpoints of a series."""
    return (end_value / start_value) ** (1.0 / years) - 1.0


def doublings(growth_per_year: float, years: float) -> float:
    """How many doublings occur over `years` at a given annual growth rate."""
    return math.log((1.0 + growth_per_year) ** years, 2)


# --------------------------------------------------------------------------------------
# 2. Wright's law / experience curve  (skill step 3 — an explicit cost model)
# --------------------------------------------------------------------------------------
def wrights_law(cost_now: float, cum_volume_now: float, cum_volume_future: float,
                learning_rate: float) -> float:
    """Cost falls by `learning_rate` for every doubling of cumulative production volume.

    learning_rate is the fractional drop per doubling: 0.20 == costs fall 20% per doubling
    (an 80% "progress ratio"). This is the canonical model behind solar PV, batteries,
    DNA sequencing, etc. — a far more honest tool than naive calendar-time extrapolation,
    because it ties cost to the thing that actually drives it (accumulated experience).
    """
    b = -math.log(1.0 - learning_rate, 2)          # elasticity
    return cost_now * (cum_volume_future / cum_volume_now) ** (-b)


# --------------------------------------------------------------------------------------
# 3. Logistic / S-curve  (skill step 2 — the bend and the plateau)
# --------------------------------------------------------------------------------------
def logistic(t: float, ceiling: float, midpoint: float, steepness: float) -> float:
    """An S-curve: early exponential growth that bends and plateaus at `ceiling`.

    ceiling   — the plateau level X the trend asymptotes to (step 2's "level X")
    midpoint  — the time t at which the curve is at half its ceiling
    steepness — how fast it transitions (larger = sharper)

    Every real trend bends eventually. When step 2 tells you a constraint will bite,
    swap your exponential for a logistic and estimate where the ceiling is.
    """
    return ceiling / (1.0 + math.exp(-steepness * (t - midpoint)))


# --------------------------------------------------------------------------------------
# 4. Crowd correction for short-term discrete events  (skill step 4)
# --------------------------------------------------------------------------------------
def correct_crowd(market_prob: float, shade: float = 0.10) -> float:
    """Shade a short-term market/crowd probability downward toward "nothing happens".

    Prediction markets and online discourse carry a measured pro-"Yes" bias on discrete
    "will X happen by date Y" questions. `shade` is a relative haircut applied to the
    YES probability (0.10 == cut the implied YES odds by 10%). Clamped to [0, 1].

    Use ONLY for short-term discrete events. Do NOT apply to long-run trends — there the
    opposite error (timid under-extrapolation) dominates.
    """
    return max(0.0, min(1.0, market_prob * (1.0 - shade)))


# --------------------------------------------------------------------------------------
# 5. Sensitivity analysis  (skill step 3 — find the parameter that matters)
# --------------------------------------------------------------------------------------
@dataclass
class Param:
    name: str
    low: float
    mid: float
    high: float


def sensitivity(model: Callable[..., float], params: dict[str, Param]) -> list[tuple[str, float, float, float]]:
    """Vary each parameter low/high (others held at mid) and report the output swing.

    Returns rows of (param_name, output_at_low, output_at_high, abs_swing), sorted by the
    size of the swing. The top row is the parameter your forecast actually hinges on — the
    one to research hardest and to flag as your real uncertainty.
    """
    base = {k: p.mid for k, p in params.items()}
    rows = []
    for name, p in params.items():
        lo = dict(base, **{name: p.low})
        hi = dict(base, **{name: p.high})
        out_lo, out_hi = model(**lo), model(**hi)
        rows.append((name, out_lo, out_hi, abs(out_hi - out_lo)))
    return sorted(rows, key=lambda r: r[3], reverse=True)


# --------------------------------------------------------------------------------------
# Demo: a worked back-of-envelope forecast (illustrative numbers — re-pull live data!)
# --------------------------------------------------------------------------------------
def _demo() -> None:
    print("=" * 72)
    print("DEMO — illustrative solar-PV cost forecast (numbers are for illustration)")
    print("=" * 72)

    # Step 1: bold extrapolation. Cumulative installed solar has grown ~25%/yr.
    cum_now = 1500.0  # GW cumulative, illustrative
    g = 0.25
    horizon = 10
    cum_future = extrapolate_exponential(cum_now, g, horizon)
    print(f"\n[1] Extrapolate deployment {horizon}y at {g:.0%}/yr:")
    print(f"    {cum_now:.0f} GW -> {cum_future:.0f} GW  ({doublings(g, horizon):.1f} doublings)")

    # Step 3: experience curve. Module cost falls ~20% per doubling of cumulative volume.
    cost_now = 0.30  # $/W, illustrative
    lr = 0.20
    cost_future = wrights_law(cost_now, cum_now, cum_future, lr)
    print(f"\n[3] Wright's law at {lr:.0%}/doubling (learning curve):")
    print(f"    ${cost_now:.2f}/W -> ${cost_future:.2f}/W")

    # Step 2: but does it continue? Impose a plateau (materials/balance-of-system floor).
    floor = 0.10  # $/W, illustrative hard floor
    corrected = max(cost_future, floor)
    print(f"\n[2] Interrogate: balance-of-system / materials floor ~${floor:.2f}/W")
    print(f"    Corrected forecast: ${corrected:.2f}/W (bends & plateaus near the floor)")

    # Step 3 (cont.): sensitivity — which parameter does the answer hinge on?
    def model(growth, learn):
        cf = extrapolate_exponential(cum_now, growth, horizon)
        return wrights_law(cost_now, cum_now, cf, learn)

    rows = sensitivity(model, {
        "growth": Param("growth", 0.15, 0.25, 0.35),
        "learn":  Param("learn",  0.15, 0.20, 0.25),
    })
    print("\n[3] Sensitivity (low->high, others held at mid), most sensitive first:")
    for name, lo, hi, swing in rows:
        print(f"    {name:8s}: ${lo:.2f} -> ${hi:.2f}/W   (swing ${swing:.2f})")

    # Step 4: a short-term discrete-event sanity check.
    mkt = 0.40
    print(f"\n[4] Short-term discrete event — market says {mkt:.0%} YES.")
    print(f"    'Nothing ever happens' corrected: {correct_crowd(mkt):.0%} YES")
    print()


if __name__ == "__main__":
    _demo()
