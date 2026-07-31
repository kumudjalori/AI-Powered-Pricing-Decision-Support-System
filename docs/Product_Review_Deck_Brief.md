# AI-Powered Pricing Strategy Assistant — Product Review Deck Brief
**Style:** Minimal, white background, blue accent, rounded cards, minimal icons, no paragraphs, max 5 bullets/slide, executive tone.
**Format:** Build this yourself in Canva/PowerPoint/Gamma using the spec below — one idea per slide.

---

## SLIDE 1 — Project Overview

**Slide Objective:** Frame the project as a business solution, not a school project.

**Exact Slide Content:**
- **Title:** AI-Powered Pricing Strategy Assistant
- **Subtitle:** Personalized pricing for a simulated EdTech platform
- Business Problem: Generic pricing is leaving renewals and upgrades on the table
- Objective: Recommend the right plan, discount, and renewal action — per learner, per rule
- Tech Stack: SQL · Excel · Python · Google Gemini API
- One-line solution: *"A transparent, rule-based pricing engine — explained in plain language by AI."*

**Visuals/Charts/Diagrams:**
- Simple 3-box architecture illustration: `Learner Data → SQL Rules Engine → Gemini Explanation`
- Small icon row under tech stack (database icon, spreadsheet icon, Python logo, sparkle/AI icon)

**Presenter Notes:**
"This is a full pricing intelligence system for a subscription EdTech platform — built end-to-end from raw data to a personalized recommendation, with every decision traceable to a business rule."

---

## SLIDE 2 — Business Problem

**Slide Objective:** Establish the pain point before showing the solution.

**Exact Slide Content:**
- **Title:** One-Size-Fits-All Pricing Is Costing Revenue
- Renewal rates swing from 19.6% to 86.7% across segments — with no system explaining why
- Discounts are handed out without a strategy — coupon users renew 9 points less than full-price learners
- No systematic way to flag churn risk before it happens
- No systematic way to flag upgrade-ready learners
- Different learner types need different pricing logic — today they all get the same

**Visuals/Charts/Diagrams:**
- Problem → Impact flowchart (horizontal, 3 nodes):
  `Generic Pricing → Missed Signals → Lost Renewals & Discount Leakage`

**Presenter Notes:**
"The data already shows the gap — a 3x renewal difference between our best and worst segments. The problem isn't the learners, it's that pricing doesn't adapt to them."

---

## SLIDE 3 — Dataset Overview

**Slide Objective:** Establish data credibility quickly — don't dwell here.

**Exact Slide Content:**
- **Title:** The Data Behind the Recommendations
- 1,600 simulated learners (exceeds 1,500+ target)
- 12 months of engagement history per learner
- 4 subscription plans · 6 learner segments
- 19 behavioral and monetization data points per learner
- Built with intentional segment correlations — not random noise

**Visuals/Charts/Diagrams:**
- KPI dashboard: 4 rounded stat cards in a row — **1,600 / 4 / 6 / 19**, each with a one-word label (Learners / Plans / Segments / Data Points)

**Presenter Notes:**
"This isn't random data — engagement and renewal are correlated by segment on purpose, so the SQL analysis on the next slide reflects a real, coherent pattern rather than noise."

---

## SLIDE 4 — SQL Product Analytics

**Slide Objective:** Show technical depth without turning it into a code review.

**Exact Slide Content:**
- **Title:** 22 Queries, Every Insight Verified
- Revenue by Plan → Pro generates ₹4.3L, the highest — despite fewer subscribers than Standard
- Renewal Analysis → 3x gap between Power Learners (86.7%) and Casual Learners (19.6%)
- Pricing Sensitivity → Coupon users complete 12 fewer points of course content
- Support Ticket Trends → Tickets drop from 2.8 to 0.5 as completion rises

**Visuals/Charts/Diagrams:**
- Two side-by-side bar charts: **Revenue by Plan** and **Renewal Rate by Segment**
- Blue accent bars, white background, no gridlines clutter

**Presenter Notes:**
"Every number on this slide came from a real query against the dataset — not an estimate. I can pull up the actual SQL for any of these live if useful."

---

## SLIDE 5 — Recommendation Framework ⭐ (Most Important Slide)

**Slide Objective:** Make the core mechanism instantly understandable.

**Exact Slide Content:**
- **Title:** How the Engine Decides
- Flow: **Learner Data → Business Rules → Recommendation Engine → Recommended Plan / Discount / Renewal Offer**
- 22 business rules (exceeds 20+ target)
- 14 pricing parameters (exceeds 10+ target)
- Priority-ordered: churn risk and satisfaction are checked *before* any upsell

**Visuals/Charts/Diagrams:**
- Horizontal decision-flow diagram, 4 connected rounded boxes with arrows, blue gradient left→right
- Small callout badge on the diagram: "100% SQL — zero ML"

**Presenter Notes:**
"This is the core IP of the project. Every recommendation traces to a named rule — nothing is a black box. And the ordering itself is a product decision: we check for problems before we pitch anything."

---

## SLIDE 6 — Gemini Integration

**Slide Objective:** Clarify the AI's role precisely — this is often misunderstood, so be explicit.

**Exact Slide Content:**
- **Title:** AI Explains. It Never Decides.
- SQL decides the recommendation — always
- Gemini never sets a price, discount, or plan
- Gemini only rewrites the SQL's reason into a natural, personalized message
- Flow: **SQL Output → Gemini Prompt → Friendly Explanation**

**Visuals/Charts/Diagrams:**
- Simple pipeline diagram, 3 boxes left to right, with a small "lock" icon on the SQL box (decision is locked) and a "message bubble" icon on the Gemini box (phrasing only)

**Presenter Notes:**
"This separation is deliberate — it means the pricing logic stays fully auditable even though the learner-facing message feels personal and human."

---

## SLIDE 7 — Product Metrics

**Slide Objective:** Speak the language leadership tracks.

**Exact Slide Content:**
- **Title:** The Numbers That Matter
- MRR: ₹11.78L
- ARPU: ₹736.50
- Renewal Rate: 64.7%
- Discount Redemption Rate: 34.3%
- Conversion Rate*: 58.8%
- Upgrade Rate*: 29.9%
- *Proxy metrics — dataset is a snapshot, not a funnel log (footnote, small text)

**Visuals/Charts/Diagrams:**
- Executive KPI dashboard: 6 rounded cards in a 3x2 grid, big number + small label each, blue accent on top row

**Presenter Notes:**
"I want to flag the two starred metrics honestly — they're well-reasoned proxies, not directly measured, because our data doesn't have a before/after timestamp. In production we'd close that gap with event-level tracking."

---

## SLIDE 8 — Key Product Insights

**Slide Objective:** Translate analysis into business narrative.

**Exact Slide Content:**
- **Title:** What the Data Is Telling Us
- Coupon users renew 9 points less than full-price learners — discounting has a ceiling
- Power Learners renew at 86.7% vs. 19.6% for Casual Learners — a 3x gap
- Working Professionals: highest revenue-per-learner segment
- Support tickets are a leading indicator of disengagement, not just a symptom
- Pro plan outperforms Standard on revenue, despite fewer subscribers

**Visuals/Charts/Diagrams:**
- 5 insight cards in a grid (rounded, white with light blue border), one bold stat + one short line per card

**Presenter Notes:**
"These are the five findings I'd actually bring into a pricing strategy meeting — each one changes what I'd recommend we do next."

---

## SLIDE 9 — Business Impact

**Slide Objective:** Answer "so what does a PM do with this?"

**Exact Slide Content:**
- **Title:** How This Changes Pricing Decisions
- Improve renewals — target low-engagement segments with nudges, not discounts
- Reduce discount leakage — gate discounts by behavior, not blanket segment rules
- Increase upgrades — 29.9% of the base is already upgrade-ready today
- Improve personalization — AI messaging adds relevance with zero new pricing risk
- Support pricing decisions — every recommendation is explainable in one sentence

**Visuals/Charts/Diagrams:**
- 5-icon impact row: renewal icon, discount/shield icon, upgrade arrow icon, personalization/message icon, decision/checkmark icon — each with a 3-4 word label underneath

**Presenter Notes:**
"This is the slide I'd use to pitch a pilot — each bullet is something a growth or lifecycle team could act on next sprint, not a research finding that needs more study."

---

## SLIDE 10 — Key Takeaways *(replaces "Thank You")*

**Slide Objective:** Close with the four things you want remembered, not a generic sign-off.

**Exact Slide Content:**
- **Title:** Key Takeaways
- **Business Problem:** One-size-fits-all pricing reduces renewals and upgrades
- **Solution:** SQL-based personalized pricing recommendations, with AI-generated learner explanations
- **Value:** Improved pricing consistency, transparency, and product decision-making
- **Scalability:** Rule-based today, extensible to ML once real funnel data exists

**Visuals/Charts/Diagrams:**
- Simple roadmap strip, 3 stages left to right: **Now: SQL Rules → Next: A/B Test the Rules → Later: ML Augmentation**
- Each stage in a rounded blue-outlined box, connected by a thin arrow (no heavy stripes/bars)

**Presenter Notes:**
"I'd rather end on what this system can become than a generic thank-you — the roadmap shows I know this is a v1, and I have a specific, grounded next step, not just 'add AI eventually.'"

---

## Design Notes for Recreation

- **Palette:** White background, one blue accent (e.g. `#2F5FDE` or similar corporate blue), dark gray/near-black text — avoid teal/mint here since this brief explicitly calls for blue, not the earlier deck's teal theme.
- **Cards:** Rounded corners (8-12px radius), subtle drop shadow or light blue border — never a colored edge stripe.
- **Typography:** One bold sans-serif for headers (e.g. Inter, Poppins, or Calibri Bold), regular weight for body — no serif, this needs to feel corporate/SaaS, not editorial.
- **Icons:** Simple line icons only, one accent color, never more than one per bullet row.
- **Every slide:** One idea, one visual, ≤5 bullets, no paragraph blocks.
