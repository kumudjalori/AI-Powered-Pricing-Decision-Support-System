# AI-Powered Pricing Strategy Assistant for a Simulated EdTech Platform

A rule-based (SQL-first, no ML) pricing recommendation engine for a simulated EdTech subscription platform, with an LLM layer (Google Gemini) used only to phrase recommendations in natural language.

---

## Project Overview

This project simulates the data, analysis, and pricing logic a Product Analyst / Product Manager would build for an EdTech subscription platform to improve **retention, renewals, upgrades, and pricing personalization**. Every pricing and renewal decision is made by transparent SQL business rules — an LLM (Gemini) is used *only* to turn the SQL's decision into a warm, personalized message for the learner. No machine learning, predictive models, or black-box logic is used anywhere in the decision-making path.

**Why this design?** For an early-stage product with no historical A/B test data, a rules-based system is more defensible, more explainable to stakeholders, and faster to ship than a trained model — and every rule can be justified individually in a business review. That trade-off is the central design decision of this project.

---

## Business Problem

A fictional EdTech platform wants to improve:
- Learner retention
- Subscription renewals
- Subscription upgrades
- Pricing personalization
- Customer satisfaction

using learner behavioral data, without building or maintaining a machine learning pipeline.

---

## Dataset

- **1,600 simulated learners** (exceeds the 1,500+ target), each with 12 months of engagement history summarized as a single snapshot row.
- **4 subscription plans:** Basic (₹299), Standard (₹599), Pro (₹999), Premium (₹1,499)
- **6 learner segments:** College Student, Working Professional, Career Switcher, Certification Seeker, Casual Learner, Power Learner
- **19 columns** including engagement (Weekly_Hours, Login_Frequency, Last_Login_Days), outcomes (Completion_Rate, Courses_Completed), monetization (Coupon_Used, Discount_Availed, Payment_Mode), and support (Support_Tickets, Renewed_Last_Cycle).

The data isn't random — it's generated with deliberate, segment-driven correlations so that SQL analysis actually surfaces a coherent story:

| Segment | Renewal Rate | Avg Completion Rate | Avg Weekly Hours |
|---|---|---|---|
| Power Learner | 86.7% | 0.88 | 15.32 |
| Certification Seeker | 78.8% | 0.77 | 5.38 |
| Career Switcher | 74.5% | 0.67 | 8.31 |
| Working Professional | 74.4% | 0.71 | 6.91 |
| College Student | 62.7% | 0.55 | 5.39 |
| Casual Learner | 19.6% | 0.27 | 2.23 |

See `Dataset/generate_dataset.py` for the full, reproducible (seeded) generation logic.

---

## Technology Stack

| Layer | Tool |
|---|---|
| Data generation | Python (stdlib `csv`, `random` — no ML libraries) |
| Database | SQL (SQLite-compatible; portable to MySQL/PostgreSQL) |
| Recommendation logic | Pure SQL `CASE` statements |
| Natural-language layer | Google Gemini API (`gemini-1.5-flash`) |
| Visualization | Excel (formulas + native charts), exported to PNG |
| Documentation | Markdown, PowerPoint |

No ML/DL frameworks, no vector databases, no cloud deployment, no BI tools (Tableau/Power BI) were used anywhere in this project — by design.

---

## Database Design

Three tables: a `Learners` fact table plus two lookup tables (`Subscription_Plans`, `Learner_Segments`) joined via foreign keys — normalized enough to show schema design skill, simple enough to explain in five minutes.

```sql
Learners (Learner_ID PK, Age, Profession, Region, Learner_Segment FK,
          Subscription_Plan FK, Monthly_Fee, Months_Active,
          Courses_Enrolled, Courses_Completed, Completion_Rate,
          Weekly_Hours, Login_Frequency, Last_Login_Days,
          Coupon_Used, Discount_Availed, Payment_Mode,
          Support_Tickets, Renewed_Last_Cycle)

Subscription_Plans (Plan_Name PK, Monthly_Fee, Target_Audience)
Learner_Segments (Segment_Name PK, Typical_Budget, Renewal_Tendency)
```

Full schema, indexes, and CSV import instructions (MySQL, PostgreSQL, SQLite, DB Browser) are in `SQL/create_tables.sql`. A "flat single-table" fallback is documented there too, if you'd rather skip the JOINs.

---

## SQL Analysis

22 documented queries in `SQL/analysis_queries.sql` (exceeds the 20+ target), each with a business question, SQL logic, and a verified insight. Every number below was run against the live dataset, not estimated:

- **MRR: ₹11,78,400**
- **Pro plan generates the most revenue (₹4,32,567)** despite Standard having more subscribers (535 vs 433) — price point beats volume here.
- **Coupon users complete fewer courses (0.54 vs 0.66) and renew less (58.8% vs 67.8%)** than non-coupon users — discounting attracts some lower-intent learners, a real pricing trade-off.
- **Support tickets fall sharply as completion rises** (2.84 → 1.49 → 0.47 across low/medium/high completion buckets) — a clean leading indicator for proactive support outreach.
- **81.6% of learners are "active"** (logged in within 30 days); 18.4% are inactive and worth a re-engagement push.

---

## Recommendation Engine

**100% SQL, zero ML.** `SQL/recommendation_engine.sql` implements **22 business rules** (exceeds 20+) across **14 pricing parameters** (exceeds 10+): current plan, monthly fee, completion rate, weekly hours, login frequency, months active, segment, coupon use, discount history, renewal status, last login days, courses completed, support tickets, and age.

Rules are evaluated in explicit **priority order** — satisfaction issues (support tickets) and churn risk always outrank upsell opportunities, so a struggling learner is never pitched an upgrade before their problem is addressed. Every rule fires on the real dataset (verified — no dead branches), producing:

| Recommended_Action | % of Learners |
|---|---|
| CS Outreach Before Upsell | 19.9% |
| No Action - Standard Monitoring | 19.4% |
| Maintain Current Plan - Monitor | 11.6% |
| Recommend Premium | 10.8% |
| Recommend Pro | 6.3% |
| *(17 more actions, full breakdown in SQL comments)* | |

---

## Gemini Integration

Gemini is used **only** to phrase a decision SQL has already made — it never sets a price, a discount, or a plan. `Gemini/gemini_integration.py` reads the SQL engine's CSV output and prompts Gemini with an explicit instruction not to alter the recommendation, only explain it in under 60 words, in second person, without mentioning it was automated.

```
SQL Output:  Current Plan: Basic | Recommendation: Upgrade to Pro
             Reason: "On Basic but completing 82% at 7.4 hrs/week"

Gemini Output: "You're putting in real effort — 82% course completion
and multiple hours a week. Pro would unlock more advanced content
that matches how seriously you're taking this."
```

Setup takes 3 steps (free API key → `pip install google-generativeai` → set `GEMINI_API_KEY`), documented at the top of the script. See `Gemini/sample_outputs.txt` for example messages.

---

## Product Metrics

| Metric | Formula | Value |
|---|---|---|
| MRR | `SUM(Monthly_Fee)` for active learners | ₹11,78,400 |
| ARPU | `SUM(Monthly_Fee) / COUNT(Learner_ID)` | ₹736.50 |
| Renewal Rate | % with `Renewed_Last_Cycle = 'Y'` | 64.7% |
| Discount Redemption Rate | % with `Coupon_Used = 'Y'` | 34.3% |
| Conversion Rate* | % of coupon users who renewed | 58.8% |
| Upgrade Rate* | % flagged for upgrade by the engine | 29.9% |

\* This dataset is a snapshot, not a before/after funnel log, so Conversion and Upgrade Rate use explicitly-labeled proxy definitions (documented in `SQL/product_metrics.sql`). A production system would measure these against a recommendation-shown timestamp and a follow-up plan-change event.

---

## Product Insights

- **Discounting works, but has a ceiling:** coupon users convert to renewal at 58.8% vs 67.8% for full-price learners — discounts recruit some learners who wouldn't have stayed at any price.
- **Engagement predicts renewal more than plan tier does:** the 3x renewal gap between Power Learners and Casual Learners dwarfs the ~17-point gap between Premium and Basic renewal rates.
- **Working Professionals are the most valuable segment per learner** (ARPU ₹847) and the most reliable revenue base (74.4% renewal, 9+ month average loyalty).
- **Casual Learners are the highest churn-risk segment** (19.6% renewal) — the recommendation engine intentionally avoids upselling them and instead nudges lower-commitment engagement.

---

## Visualizations

`Excel/learner_analytics.xlsx` — formula-driven (not hardcoded), zero recalculation errors across 1,630 formulas, with 6 native Excel charts. PNG exports for docs/slides are in `Images/charts/`:

- `revenue_by_plan.png`
- `revenue_by_segment.png`
- `subscription_distribution.png`
- `renewal_rate.png`
- `engagement_distribution.png`
- `monthly_revenue_trend.png` *(proxied via tenure buckets — see file header note; the dataset is a snapshot without true calendar-month granularity)*

---

## Future Improvements

- Replace the snapshot dataset with real event-level data (logins, purchases, plan changes over time) to measure true Conversion and Upgrade Rate instead of proxies.
- A/B test the SQL recommendation engine's discount offers against a control group before assuming the rules actually change behavior.
- Add a feedback loop: track whether learners who received a Gemini-personalized message acted on it more than those who saw the raw SQL recommendation.
- Extend the rules engine with a lightweight rule-conflict checker (currently resolved by priority order, but a formal audit trail would help as rule count grows).

---

## Project Structure

```text
AI-Powered-Pricing-Strategy-Assistant/
├── README.md
├── Dataset/
│   ├── learner_data.csv
│   └── generate_dataset.py
├── SQL/
│   ├── create_tables.sql
│   ├── analysis_queries.sql
│   ├── recommendation_engine.sql
│   └── product_metrics.sql
├── Gemini/
│   ├── gemini_integration.py
│   ├── recommendations.csv
│   └── sample_outputs.txt
├── Excel/
│   ├── build_workbook.py
│   └── learner_analytics.xlsx
├── Images/
│   └── charts/ (6 PNGs)
├── PPT/
│   └── Pricing_Strategy_Assistant.pptx
└── Interview_Preparation/
    └── interview_questions.md
```
