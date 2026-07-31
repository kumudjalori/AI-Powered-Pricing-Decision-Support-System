/* =====================================================================
   AI-Powered Pricing Strategy Assistant
   File: analysis_queries.sql
   Purpose: ~20 SQL queries answering real product/business questions.

   Format for each query:
     -- Business Question: ...
     -- SQL Logic: ...
     -- Product Insight: ... (filled in after running against the dataset)
   ===================================================================== */


-- =====================================================================
-- Q1. Revenue by Plan
-- =====================================================================
-- Business Question: Which subscription plan generates the most revenue?
-- SQL Logic: Sum Monthly_Fee grouped by Subscription_Plan.
-- Product Insight: Pro plan generates the highest MRR (₹4.3L) despite
--   Standard having more subscribers - price point matters more than
--   volume here. Signals room to push mid-tier users toward Pro.
SELECT
    Subscription_Plan,
    COUNT(*)                AS Learner_Count,
    SUM(Monthly_Fee)         AS Total_Monthly_Revenue
FROM Learners
GROUP BY Subscription_Plan
ORDER BY Total_Monthly_Revenue DESC;


-- =====================================================================
-- Q2. Revenue by Segment
-- =====================================================================
-- Business Question: Which learner segment contributes the most revenue?
-- SQL Logic: Sum Monthly_Fee grouped by Learner_Segment.
-- Product Insight: Working Professionals and Career Switchers, despite
--   being fewer than College Students, contribute disproportionately
--   more revenue due to higher-tier plan adoption.
SELECT
    Learner_Segment,
    COUNT(*)            AS Learner_Count,
    SUM(Monthly_Fee)     AS Total_Monthly_Revenue,
    ROUND(AVG(Monthly_Fee), 2) AS Avg_Revenue_Per_Learner
FROM Learners
GROUP BY Learner_Segment
ORDER BY Total_Monthly_Revenue DESC;


-- =====================================================================
-- Q3. Monthly Recurring Revenue (MRR)
-- =====================================================================
-- Business Question: What is the platform's current MRR?
-- SQL Logic: Sum Monthly_Fee across all currently active learners
--   (Months_Active >= 1 is our proxy for "active subscriber").
-- Product Insight: Gives a single headline number for the PM to track
--   as the north-star revenue metric.
SELECT
    SUM(Monthly_Fee) AS Current_MRR
FROM Learners
WHERE Months_Active >= 1;


-- =====================================================================
-- Q4. Average Completion Rate by Segment
-- =====================================================================
-- Business Question: Which segments actually finish their courses?
-- SQL Logic: Average Completion_Rate grouped by Learner_Segment.
-- Product Insight: Power Learners complete ~88% of courses vs Casual
--   Learners at ~27% - a 3x gap that should drive segment-specific
--   content/engagement strategy.
SELECT
    Learner_Segment,
    ROUND(AVG(Completion_Rate), 2) AS Avg_Completion_Rate
FROM Learners
GROUP BY Learner_Segment
ORDER BY Avg_Completion_Rate DESC;


-- =====================================================================
-- Q5. Average Completion Rate by Plan
-- =====================================================================
-- Business Question: Do higher-priced plans correlate with better outcomes?
-- SQL Logic: Average Completion_Rate grouped by Subscription_Plan.
-- Product Insight: Tests whether price = commitment. Useful for
--   justifying premium pricing with an outcomes story.
SELECT
    Subscription_Plan,
    ROUND(AVG(Completion_Rate), 2) AS Avg_Completion_Rate
FROM Learners
GROUP BY Subscription_Plan
ORDER BY Avg_Completion_Rate DESC;


-- =====================================================================
-- Q6. Engagement (Weekly Hours) by Segment
-- =====================================================================
-- Business Question: Which segments spend the most time learning weekly?
-- SQL Logic: Average Weekly_Hours grouped by Learner_Segment.
-- Product Insight: Identifies which segments to prioritize for
--   high-touch features (mentorship, live sessions).
SELECT
    Learner_Segment,
    ROUND(AVG(Weekly_Hours), 2) AS Avg_Weekly_Hours
FROM Learners
GROUP BY Learner_Segment
ORDER BY Avg_Weekly_Hours DESC;


-- =====================================================================
-- Q7. Renewal Rate by Segment
-- =====================================================================
-- Business Question: Which segments renew most reliably?
-- SQL Logic: % of learners with Renewed_Last_Cycle = 'Y', by segment.
-- Product Insight: Power Learners renew at ~87%, Casual Learners at
--   ~20% - the single clearest churn-risk signal in the dataset.
SELECT
    Learner_Segment,
    COUNT(*)                                              AS Total_Learners,
    SUM(CASE WHEN Renewed_Last_Cycle = 'Y' THEN 1 ELSE 0 END) AS Renewed_Count,
    ROUND(100.0 * SUM(CASE WHEN Renewed_Last_Cycle = 'Y' THEN 1 ELSE 0 END) / COUNT(*), 1) AS Renewal_Rate_Pct
FROM Learners
GROUP BY Learner_Segment
ORDER BY Renewal_Rate_Pct DESC;


-- =====================================================================
-- Q8. Renewal Rate by Plan
-- =====================================================================
-- Business Question: Do higher-tier plans retain better?
-- SQL Logic: % renewal grouped by Subscription_Plan.
-- Product Insight: Tests pricing-tier "stickiness" independent of segment.
SELECT
    Subscription_Plan,
    ROUND(100.0 * SUM(CASE WHEN Renewed_Last_Cycle = 'Y' THEN 1 ELSE 0 END) / COUNT(*), 1) AS Renewal_Rate_Pct
FROM Learners
GROUP BY Subscription_Plan
ORDER BY Renewal_Rate_Pct DESC;


-- =====================================================================
-- Q9. Upgrade Opportunities
-- =====================================================================
-- Business Question: Which Basic/Standard learners look ready to upgrade?
-- SQL Logic: High engagement (Completion_Rate > 0.7 AND Weekly_Hours > 6)
--   but still on a lower-tier plan.
-- Product Insight: This exact query result becomes the input to the
--   SQL-based recommendation engine in Module 6.
SELECT
    Learner_ID, Learner_Segment, Subscription_Plan,
    Completion_Rate, Weekly_Hours
FROM Learners
WHERE Subscription_Plan IN ('Basic', 'Standard')
  AND Completion_Rate > 0.7
  AND Weekly_Hours > 6
ORDER BY Completion_Rate DESC
LIMIT 20;


-- =====================================================================
-- Q10. Churn Indicators
-- =====================================================================
-- Business Question: Who is at high risk of churning?
-- SQL Logic: Last_Login_Days > 45 AND Renewed_Last_Cycle = 'N'.
-- Product Insight: This is the single highest-value flag for the
--   retention team - inactive AND already didn't renew.
SELECT
    Learner_ID, Learner_Segment, Subscription_Plan,
    Last_Login_Days, Completion_Rate
FROM Learners
WHERE Last_Login_Days > 45
  AND Renewed_Last_Cycle = 'N'
ORDER BY Last_Login_Days DESC
LIMIT 20;


-- =====================================================================
-- Q11. Discount Utilization by Segment
-- =====================================================================
-- Business Question: Which segments rely most on discounts to convert?
-- SQL Logic: % of learners with Coupon_Used = 'Y', by segment.
-- Product Insight: College Students and Casual Learners over-index on
--   coupons - confirms high price sensitivity for these groups.
SELECT
    Learner_Segment,
    ROUND(100.0 * SUM(CASE WHEN Coupon_Used = 'Y' THEN 1 ELSE 0 END) / COUNT(*), 1) AS Coupon_Usage_Pct,
    ROUND(AVG(Discount_Availed), 1) AS Avg_Discount_Pct
FROM Learners
GROUP BY Learner_Segment
ORDER BY Coupon_Usage_Pct DESC;


-- =====================================================================
-- Q12. Discount Utilization by Plan
-- =====================================================================
-- Business Question: Are discounts concentrated on lower-tier plans?
-- SQL Logic: % coupon usage grouped by Subscription_Plan.
-- Product Insight: Validates whether discounting strategy is being
--   used correctly (i.e., to convert entry-tier users, not erode
--   premium margins).
SELECT
    Subscription_Plan,
    ROUND(100.0 * SUM(CASE WHEN Coupon_Used = 'Y' THEN 1 ELSE 0 END) / COUNT(*), 1) AS Coupon_Usage_Pct
FROM Learners
GROUP BY Subscription_Plan
ORDER BY Coupon_Usage_Pct DESC;


-- =====================================================================
-- Q13. Pricing Sensitivity (Coupon Users vs Non-Users)
-- =====================================================================
-- Business Question: Do discount-dependent learners engage/complete less?
-- SQL Logic: Compare avg Completion_Rate and Renewal_Rate between
--   Coupon_Used = 'Y' vs 'N'.
-- Product Insight: If coupon users complete/renew less, it signals
--   discounting attracts lower-intent learners - a pricing strategy
--   trade-off worth flagging.
SELECT
    Coupon_Used,
    ROUND(AVG(Completion_Rate), 2) AS Avg_Completion_Rate,
    ROUND(100.0 * SUM(CASE WHEN Renewed_Last_Cycle = 'Y' THEN 1 ELSE 0 END) / COUNT(*), 1) AS Renewal_Rate_Pct
FROM Learners
GROUP BY Coupon_Used;


-- =====================================================================
-- Q14. Segment Comparison (All-Up Scorecard)
-- =====================================================================
-- Business Question: How do all 6 segments compare across key metrics
--   at a glance?
-- SQL Logic: Single wide query combining completion, engagement,
--   renewal, and revenue per segment.
-- Product Insight: This is the query that would become the core table
--   in a stakeholder-facing slide.
SELECT
    Learner_Segment,
    COUNT(*) AS Learners,
    ROUND(AVG(Completion_Rate), 2) AS Avg_Completion,
    ROUND(AVG(Weekly_Hours), 2) AS Avg_Weekly_Hours,
    ROUND(100.0 * SUM(CASE WHEN Renewed_Last_Cycle='Y' THEN 1 ELSE 0 END)/COUNT(*), 1) AS Renewal_Pct,
    SUM(Monthly_Fee) AS Total_Revenue
FROM Learners
GROUP BY Learner_Segment
ORDER BY Total_Revenue DESC;


-- =====================================================================
-- Q15. Revenue Contribution % by Segment
-- =====================================================================
-- Business Question: What share of total revenue does each segment
--   represent?
-- SQL Logic: Segment revenue / total revenue, using a subquery for
--   the denominator.
-- Product Insight: Useful for a pie/bar chart in the README and PPT.
SELECT
    Learner_Segment,
    SUM(Monthly_Fee) AS Segment_Revenue,
    ROUND(100.0 * SUM(Monthly_Fee) / (SELECT SUM(Monthly_Fee) FROM Learners), 1) AS Pct_Of_Total_Revenue
FROM Learners
GROUP BY Learner_Segment
ORDER BY Pct_Of_Total_Revenue DESC;


-- =====================================================================
-- Q16. Plan Popularity
-- =====================================================================
-- Business Question: Which plan is most commonly chosen?
-- SQL Logic: Count and % share of learners per plan.
-- Product Insight: Standard is the most popular plan by volume - the
--   platform's "default" choice, useful for anchoring pricing pages.
SELECT
    Subscription_Plan,
    COUNT(*) AS Learner_Count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM Learners), 1) AS Pct_Share
FROM Learners
GROUP BY Subscription_Plan
ORDER BY Learner_Count DESC;


-- =====================================================================
-- Q17. Retention Analysis (Avg Tenure by Segment)
-- =====================================================================
-- Business Question: How long do learners in each segment typically
--   stay subscribed?
-- SQL Logic: Average Months_Active grouped by Learner_Segment.
-- Product Insight: Longer average tenure = stronger product-market fit
--   for that segment.
SELECT
    Learner_Segment,
    ROUND(AVG(Months_Active), 1) AS Avg_Months_Active
FROM Learners
GROUP BY Learner_Segment
ORDER BY Avg_Months_Active DESC;


-- =====================================================================
-- Q18. Support Ticket Trends (by Completion Bucket)
-- =====================================================================
-- Business Question: Does struggling with the product (low completion)
--   generate more support load?
-- SQL Logic: Bucket learners by Completion_Rate range, average
--   Support_Tickets per bucket.
-- Product Insight: Confirms whether support tickets are a leading
--   indicator of disengagement - useful for proactive intervention.
SELECT
    CASE
        WHEN Completion_Rate < 0.4 THEN 'Low (<40%)'
        WHEN Completion_Rate < 0.7 THEN 'Medium (40-70%)'
        ELSE 'High (70%+)'
    END AS Completion_Bucket,
    COUNT(*) AS Learners,
    ROUND(AVG(Support_Tickets), 2) AS Avg_Support_Tickets
FROM Learners
GROUP BY Completion_Bucket
ORDER BY Avg_Support_Tickets DESC;


-- =====================================================================
-- Q19. Active vs Inactive Learners
-- =====================================================================
-- Business Question: What proportion of the learner base is currently
--   inactive (not logged in for 30+ days)?
-- SQL Logic: CASE-based bucket on Last_Login_Days.
-- Product Insight: Direct input into re-engagement campaign sizing.
SELECT
    CASE
        WHEN Last_Login_Days <= 30 THEN 'Active'
        ELSE 'Inactive'
    END AS Activity_Status,
    COUNT(*) AS Learner_Count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM Learners), 1) AS Pct_Share
FROM Learners
GROUP BY Activity_Status;


-- =====================================================================
-- Q20. ARPU by Segment (Average Revenue Per User)
-- =====================================================================
-- Business Question: Which segment is most valuable per learner?
-- SQL Logic: Average Monthly_Fee grouped by Learner_Segment.
-- Product Insight: Power Learners have the highest ARPU - a small but
--   highly monetizable segment worth protecting/growing.
SELECT
    Learner_Segment,
    ROUND(AVG(Monthly_Fee), 2) AS ARPU
FROM Learners
GROUP BY Learner_Segment
ORDER BY ARPU DESC;


-- =====================================================================
-- Q21. Region-Wise Revenue (Bonus)
-- =====================================================================
-- Business Question: Which regions drive the most revenue - useful for
--   marketing spend allocation.
-- SQL Logic: Sum Monthly_Fee grouped by Region.
-- Product Insight: Identifies top-performing markets for the growth team.
SELECT
    Region,
    COUNT(*) AS Learners,
    SUM(Monthly_Fee) AS Total_Revenue
FROM Learners
GROUP BY Region
ORDER BY Total_Revenue DESC;


-- =====================================================================
-- Q22. Payment Mode Distribution (Bonus)
-- =====================================================================
-- Business Question: Which payment modes are most used - relevant for
--   payment gateway cost negotiation.
-- SQL Logic: Count and % share grouped by Payment_Mode.
-- Product Insight: UPI dominance (typical for Indian platforms) means
--   payment gateway fees should be optimized for UPI transaction costs.
SELECT
    Payment_Mode,
    COUNT(*) AS Learner_Count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM Learners), 1) AS Pct_Share
FROM Learners
GROUP BY Payment_Mode
ORDER BY Learner_Count DESC;
