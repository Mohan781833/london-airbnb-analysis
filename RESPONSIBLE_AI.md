# Responsible AI Statement — London Airbnb Analysis

## 1. Intended use

This model predicts whether a London Airbnb listing is a `high_performer` — a listing whose estimated occupancy is above the London median of 9 booked nights/year — to help a property management portfolio team decide which listings to prioritise for viewing or acquisition. It is a **decision-support tool for internal portfolio strategy only**. It must not be used to set guest prices automatically, to auto-accept or auto-reject acquisitions without human review, to assess individual hosts, or outside the London market or June 2026 data period it was trained on.

## 2. Data

The model is trained on the public [Inside Airbnb](https://insideairbnb.com) London snapshot (June 2026): 92,638 listings, all publicly listed marketplace data. No personal, financial, or identity data about hosts or guests is used. Features are pre-purchase listing attributes only — price, accommodates, bathrooms, bedrooms, minimum_nights, availability_365, host tenure, host listing count, borough, room type, and property type. Free-text reviews were used only for aggregate VADER sentiment elsewhere in the project, not as model features. Crucially, `reviews_per_month`, `number_of_reviews`, and `estimated_revenue_l365d` were **deliberately excluded to prevent data leakage** — the occupancy target is itself derived from review counts (correlations 0.74 and 0.56), and revenue is occupancy × price, so including them would let the model relearn its own target rather than genuine market signal.

## 3. Performance

Two models were compared. The selected model is the **Random Forest** (accuracy 0.754, high-performer recall 0.829, ROC-AUC 0.833), chosen over Logistic Regression (accuracy 0.629, recall 0.491, ROC-AUC 0.682) because it identifies far more of the genuinely high-performing listings — the outcome that matters for a shortlist. In business terms: of every 100 truly high-performing listings, the model flags roughly 83. It errs toward flagging, so a flagged listing is a **candidate to review, not a guaranteed winner**. The model is reliable for ranking and shortlisting at portfolio scale; it is **not** a precise revenue or occupancy forecast for any single property, and because the target is built on Inside Airbnb's *estimated* occupancy (derived from review counts), it predicts an estimate, not measured bookings.

## 4. Bias

The dataset contains no protected demographic attributes, so fairness was assessed across the categorical groups that carry commercial and indirect-bias risk: **room type** and **borough** (groups with n < 100 excluded). Recall and false-positive rate were compared per group. Findings: recall is slightly higher for entire homes (0.841) than private rooms (0.797), and varies across boroughs from ~0.61 (Bexley) to ~0.71 (Croydon). The gaps are modest but real — used unchecked, the model would identify high performers slightly less reliably in some outer boroughs and for non-entire-home listings, which could concentrate investment in already-popular central areas. This is acceptable for a first-pass shortlist **only if** outer-borough and private-room candidates are reviewed on their own merits rather than filtered out wholesale.

## 5. Explainability

Individual predictions can be explained using SHAP (TreeExplainer on the Random Forest). The global SHAP summary shows the strongest drivers of the `high_performer` prediction are **price and accommodates**, followed by the other listing attributes. For a single listing, a SHAP waterfall plot shows exactly which attributes pushed its score toward or away from high-performer — so a portfolio manager can see *why* any given listing was flagged, not just that it was. [If not already present, add one `shap.plots.waterfall` cell for a single listing plus a one-line plain-English read of it — the rubric requires a global chart AND at least one waterfall.]

## 6. Conditions for deployment

Before this model informs real portfolio decisions:

1. **Human-in-the-loop review** — every flagged listing is checked by an analyst before any acquisition decision; the model shortlists, it does not decide.
2. **Cost-based threshold** — the decision threshold is set from the business cost of a missed opportunity versus a wasted viewing, not left at the default 0.5.
3. **Group-fairness monitoring** — recall by borough and room type is re-checked on each data refresh, so the model isn't quietly steering investment away from under-served areas.
4. **Scheduled retraining** — retrain on a fresh Inside Airbnb snapshot at least quarterly, and re-review after any change to London short-let regulation (e.g. the 90-night rule), since these reshape the whole market and the June 2026 data will go stale.
