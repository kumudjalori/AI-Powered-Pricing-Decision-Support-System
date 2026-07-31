/* =====================================================================
   AI-Powered Pricing Strategy Assistant
   File: product_metrics.sql
   Purpose: Define and compute the core product success metrics used to
   evaluate the pricing recommendation engine.

   IMPORTANT HONEST NOTE ON DATA LIMITATIONS:
   This dataset is a single-point-in-time SNAPSHOT (each learner has one
   row summarizing their current state), not a funnel/event log with a
   "before recommendation" and "after recommendation" state. In a real
   production system, Conversion Rate and Upgrade Rate would be measured
   by comparing a learner's plan/status BEFORE they saw a recommendation
   vs AFTER. Since we don't have that time-series data here, this file
   uses clearly-labeled PROXY definitions grounded in the columns we do
   have. This distinction is worth stating directly in interviews - it
   shows you understand the difference between snapshot and funnel data,
   which is a real product-analytics skill.
   ===================================================================== */


-- =====================================================================
-- METRIC 1: Monthly Recurring Revenue (MRR)
-- =====================================================================
-- Definition: Total predictable monthly revenue from all active subscribers.
-- SQL Formula: SUM(Monthly_Fee) across all learners with Months_Active >= 1
-- Why PMs track it: MRR is the single most important health metric for
--   any subscription business - it's the north-star number leadership
--   checks first, and every other metric here ultimately ladders up to it.
SELECT SUM(Monthly_Fee) AS MRR
FROM Learners
WHERE Months_Active >= 1;


-- =====================================================================
-- METRIC 2: Average Revenue Per User (ARPU)
-- =====================================================================
-- Definition: Average monthly revenue generated per learner.
-- SQL Formula: SUM(Monthly_Fee) / COUNT(DISTINCT Learner_ID)
-- Why PMs track it: ARPU reveals whether growth is coming from adding
--   more users (volume) or from monetizing existing users better
--   (value) - critical for deciding whether to invest in acquisition
--   or in upsell/retention.
SELECT
    ROUND(SUM(Monthly_Fee) * 1.0 / COUNT(DISTINCT Learner_ID), 2) AS ARPU
FROM Learners;


-- =====================================================================
-- METRIC 3: Renewal Rate
-- =====================================================================
-- Definition: % of learners who renewed their subscription at the end
--   of their last billing cycle.
-- SQL Formula: (COUNT WHERE Renewed_Last_Cycle='Y') / COUNT(*) * 100
-- Why PMs track it: Renewal rate is the clearest signal of product-market
--   fit and pricing fairness for a subscription product - low renewal
--   means either the price or the value delivered is misaligned.
SELECT
    ROUND(100.0 * SUM(CASE WHEN Renewed_Last_Cycle = 'Y' THEN 1 ELSE 0 END) / COUNT(*), 1) AS Renewal_Rate_Pct
FROM Learners;


-- =====================================================================
-- METRIC 4: Discount Redemption Rate
-- =====================================================================
-- Definition: % of learners who used a coupon/discount at signup or renewal.
-- SQL Formula: (COUNT WHERE Coupon_Used='Y') / COUNT(*) * 100
-- Why PMs track it: Tells you how dependent your revenue is on
--   discounting. A high redemption rate across price-insensitive
--   segments would be a red flag for margin erosion; a high rate in
--   price-sensitive segments (like College Students) is expected and healthy.
SELECT
    ROUND(100.0 * SUM(CASE WHEN Coupon_Used = 'Y' THEN 1 ELSE 0 END) / COUNT(*), 1) AS Discount_Redemption_Rate_Pct
FROM Learners;


-- =====================================================================
-- METRIC 5: Conversion Rate (PROXY - see note at top of file)
-- =====================================================================
-- Definition (proxy): Of the learners who redeemed a discount, what %
--   went on to actually renew - i.e., the discount "converted" them
--   into a retained paying customer rather than a one-time discount user.
-- SQL Formula: (COUNT WHERE Coupon_Used='Y' AND Renewed_Last_Cycle='Y')
--              / (COUNT WHERE Coupon_Used='Y') * 100
-- Why PMs track it: Measures whether discounting is actually working as
--   a growth lever, or just subsidizing users who churn anyway. In a
--   production system with real funnel data, this would instead be
--   measured as Free-Trial -> Paid or Recommendation-Shown -> Action-Taken.
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN Coupon_Used = 'Y' AND Renewed_Last_Cycle = 'Y' THEN 1 ELSE 0 END)
        / SUM(CASE WHEN Coupon_Used = 'Y' THEN 1 ELSE 0 END)
    , 1) AS Conversion_Rate_Pct_Of_Coupon_Users
FROM Learners;


-- =====================================================================
-- METRIC 6: Upgrade Rate (PROXY - see note at top of file)
-- =====================================================================
-- Definition (proxy): % of the total learner base that the SQL
--   recommendation engine flags as ready for an upgrade (Recommend
--   Premium / Recommend Pro / Recommend Upgrade to X actions).
-- SQL Formula: (COUNT WHERE Recommended_Action LIKE '%Upgrade%'
--               OR Recommended_Action LIKE '%Recommend Premium%'
--               OR Recommended_Action LIKE '%Recommend Pro%')
--              / COUNT(*) * 100
-- Why PMs track it: Sizes the upsell opportunity in the current base -
--   directly actionable by the growth/lifecycle marketing team. In
--   production, you'd track this longitudinally: % of learners shown
--   an upgrade recommendation who actually upgraded within 30 days.
-- NOTE: This query assumes recommendations.csv (Module 7 output) is
-- loaded into a Recommendations table with the same schema. If running
-- standalone against Learners only, see the CTE version below instead.
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN Recommended_Action LIKE '%Upgrade%'
                            OR Recommended_Action LIKE 'Recommend Premium%'
                            OR Recommended_Action LIKE 'Recommend Pro%'
                       THEN 1 ELSE 0 END)
        / COUNT(*)
    , 1) AS Upgrade_Rate_Pct
FROM Recommendations;
