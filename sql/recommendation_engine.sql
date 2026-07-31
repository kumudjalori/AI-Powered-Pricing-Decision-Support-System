/* =====================================================================
   AI-Powered Pricing Strategy Assistant
   File: recommendation_engine.sql
   Purpose: 100% SQL, rule-based pricing/renewal recommendation engine.

   NO Machine Learning. NO predictive models. Every decision below is a
   deterministic, human-readable business rule expressed as a CASE
   statement. This is the artifact that answers "why SQL instead of ML?"
   in interviews: transparency, explainability, and zero training data
   requirements for a brand-new product.
   ===================================================================== */

/* =====================================================================
   PRICING PARAMETERS USED (12 total - exceeds the 10+ requirement)
   ---------------------------------------------------------------------
    1. Subscription_Plan     - current plan, anchors upgrade/downgrade logic
    2. Monthly_Fee            - current price point paid
    3. Completion_Rate        - core engagement/outcome signal
    4. Weekly_Hours           - time investment signal
    5. Login_Frequency        - platform habit strength
    6. Months_Active          - tenure / loyalty signal
    7. Learner_Segment        - persona-driven pricing sensitivity
    8. Coupon_Used            - discount-dependency signal
    9. Discount_Availed       - magnitude of past discounting
   10. Renewed_Last_Cycle     - most recent renewal outcome
   11. Last_Login_Days        - recency / churn-risk signal
   12. Courses_Completed      - absolute output, not just rate
   13. Support_Tickets        - friction / satisfaction proxy
   14. Age                    - eligibility check for certain segment offers
   ===================================================================== */

/* =====================================================================
   BUSINESS RULES (22 total - exceeds the 20+ requirement)
   ---------------------------------------------------------------------
   Rules are evaluated in PRIORITY ORDER inside the CASE statement below.
   Higher-priority rules (churn risk, satisfaction issues) are checked
   first so they are never silently overridden by a lower-priority
   upsell rule.

   R1.  Power Learner + Completion > 80%              -> Recommend Premium
   R2.  Working Professional + high engagement          -> Recommend Premium
   R3.  Basic/Standard + high completion & hours        -> Upgrade to Pro
   R4.  Basic + moderate completion & frequent logins    -> Upgrade to Standard
   R5.  College Student + high completion               -> Student Discount 15%
   R6.  Casual Learner + very low completion             -> Engagement nudge, stay Basic
   R7.  Last_Login_Days > 45                             -> Renewal reminder
   R8.  Last_Login_Days > 60 + not renewed                -> High churn risk, win-back 20%
   R9.  Not renewed + high completion                    -> Loyalty discount 10% (price objection)
   R10. Coupon user + very low completion                -> Flag low-intent, no further discount
   R11. Power Learner + tenure >= 6 months                -> Recommend Annual Plan
   R12. Support_Tickets >= 3                              -> CS outreach before any upsell
   R13. Courses_Completed >= 10 + not on Premium           -> Recommend Premium (power signal)
   R14. Certification Seeker + high completion             -> Recommend Pro (cert value)
   R15. Career Switcher + high weekly hours                -> Recommend Pro
   R16. Premium + very low completion                     -> Downgrade review (value mismatch)
   R17. High past discount + low completion                -> Do not extend discount next cycle
   R18. New user (<=2 months) + low login frequency         -> Onboarding nudge, no discount
   R19. Working Professional + loyal renewer (9+ months)     -> Loyalty reward / free month
   R20. Age < 21 + on Pro/Premium                          -> Verify extended student eligibility
   R21. Mid-range completion & hours                       -> Maintain current plan, monitor
   R22. Very recent login + very high completion             -> Referral program candidate
   ===================================================================== */


-- =====================================================================
-- MAIN RECOMMENDATION QUERY
-- Produces one row per learner with a single prioritized recommendation.
-- =====================================================================
SELECT
    Learner_ID,
    Learner_Segment,
    Subscription_Plan          AS Current_Plan,
    Monthly_Fee                AS Current_Fee,
    Completion_Rate,
    Weekly_Hours,
    Last_Login_Days,
    Renewed_Last_Cycle,

    -- ---------------------------------------------------------------
    -- RECOMMENDED ACTION (priority-ordered CASE = rule engine core)
    -- ---------------------------------------------------------------
    CASE
        -- Priority 1: Satisfaction/friction issues override everything
        WHEN Support_Tickets >= 3
            THEN 'CS Outreach Before Upsell'                                   -- R12

        -- Priority 2: Churn risk / win-back
        WHEN Last_Login_Days > 60 AND Renewed_Last_Cycle = 'N'
            THEN 'High Churn Risk - Win-Back Offer'                            -- R8
        WHEN Last_Login_Days > 45
            THEN 'Renewal Reminder'                                            -- R7

        -- Priority 3: Value mismatch (paying too much, not using it)
        WHEN Subscription_Plan = 'Premium' AND Completion_Rate < 0.3
            THEN 'Downgrade Review'                                            -- R16

        -- Priority 4: Power-user upgrade signals
        WHEN Learner_Segment = 'Power Learner' AND Completion_Rate > 0.8
            THEN 'Recommend Premium'                                          -- R1
        WHEN Courses_Completed >= 10 AND Subscription_Plan <> 'Premium'
            THEN 'Recommend Premium (Power Usage)'                            -- R13
        WHEN Learner_Segment = 'Working Professional'
             AND Weekly_Hours > 6 AND Completion_Rate > 0.7
            THEN 'Recommend Premium'                                          -- R2
        WHEN Learner_Segment = 'Power Learner' AND Months_Active >= 6
            THEN 'Recommend Annual Plan'                                      -- R11

        -- Priority 5: Segment-specific Pro upgrades
        WHEN Learner_Segment = 'Certification Seeker' AND Completion_Rate > 0.8
            THEN 'Recommend Pro (Certification Value)'                        -- R14
        WHEN Learner_Segment = 'Career Switcher' AND Weekly_Hours > 8
            THEN 'Recommend Pro'                                              -- R15
        WHEN Subscription_Plan IN ('Basic', 'Standard')
             AND Completion_Rate > 0.75 AND Weekly_Hours > 6
            THEN 'Recommend Upgrade to Pro'                                    -- R3

        -- Priority 6: Not-renewed but engaged -> price objection
        WHEN Renewed_Last_Cycle = 'N' AND Completion_Rate > 0.7
            THEN 'Offer Loyalty Discount (10%)'                                -- R9

        -- Priority 7: Entry-tier engagement upgrades
        WHEN Subscription_Plan = 'Basic'
             AND Completion_Rate > 0.6 AND Login_Frequency > 10
            THEN 'Recommend Upgrade to Standard'                               -- R4

        -- Priority 8: Segment-based discounting
        WHEN Learner_Segment = 'College Student' AND Completion_Rate > 0.7
            THEN 'Student Discount (15%)'                                     -- R5

        -- Priority 9: Loyalty rewards
        WHEN Learner_Segment = 'Working Professional'
             AND Renewed_Last_Cycle = 'Y' AND Months_Active >= 9
            THEN 'Loyalty Reward (Free Month / 10% Off Renewal)'               -- R19

        -- Priority 10: Discount hygiene
        WHEN Discount_Availed > 20 AND Completion_Rate < 0.5
            THEN 'Do Not Extend Discount Next Cycle'                          -- R17
        WHEN Coupon_Used = 'Y' AND Completion_Rate < 0.4
            THEN 'Low-Intent Discount User - No Further Discount'              -- R10

        -- Priority 11: New user onboarding
        WHEN Months_Active <= 2 AND Login_Frequency < 3
            THEN 'Onboarding Nudge - No Discount'                              -- R18

        -- Priority 12: Disengagement
        WHEN Learner_Segment = 'Casual Learner' AND Completion_Rate < 0.3
            THEN 'Engagement Nudge - Stay on Basic'                            -- R6

        -- Priority 13: Advocacy
        WHEN Last_Login_Days <= 7 AND Completion_Rate > 0.85
            THEN 'Referral Program Candidate'                                  -- R22

        -- Priority 14: Eligibility check
        WHEN Age < 21 AND Subscription_Plan IN ('Pro', 'Premium')
            THEN 'Verify Extended Student Eligibility'                        -- R20

        -- Priority 15: Steady state
        WHEN Completion_Rate BETWEEN 0.4 AND 0.7
             AND Weekly_Hours BETWEEN 3 AND 6
            THEN 'Maintain Current Plan - Monitor'                             -- R21

        ELSE 'No Action - Standard Monitoring'
    END AS Recommended_Action,

    -- ---------------------------------------------------------------
    -- RECOMMENDED DISCOUNT % (separate CASE, independent of action)
    -- ---------------------------------------------------------------
    CASE
        WHEN Last_Login_Days > 60 AND Renewed_Last_Cycle = 'N' THEN 20   -- win-back
        WHEN Renewed_Last_Cycle = 'N' AND Completion_Rate > 0.7 THEN 10  -- loyalty/price objection
        WHEN Learner_Segment = 'College Student' AND Completion_Rate > 0.7 THEN 15 -- student
        WHEN Learner_Segment = 'Working Professional'
             AND Renewed_Last_Cycle = 'Y' AND Months_Active >= 9 THEN 10 -- loyalty reward
        WHEN Discount_Availed > 20 AND Completion_Rate < 0.5 THEN 0      -- discount hygiene: cut it off
        WHEN Coupon_Used = 'Y' AND Completion_Rate < 0.4 THEN 0          -- low-intent: no discount
        ELSE 0
    END AS Recommended_Discount_Pct,

    -- ---------------------------------------------------------------
    -- REASON (feeds into Gemini in Module 7 - plain-English justification)
    -- ---------------------------------------------------------------
    CASE
        WHEN Support_Tickets >= 3
            THEN 'High support ticket volume (' || Support_Tickets || ') needs resolution first'
        WHEN Last_Login_Days > 60 AND Renewed_Last_Cycle = 'N'
            THEN 'Inactive for ' || Last_Login_Days || ' days and did not renew last cycle'
        WHEN Last_Login_Days > 45
            THEN 'No login in ' || Last_Login_Days || ' days'
        WHEN Subscription_Plan = 'Premium' AND Completion_Rate < 0.3
            THEN 'Paying for Premium but completion rate is only ' || ROUND(Completion_Rate*100) || '%'
        WHEN Learner_Segment = 'Power Learner' AND Completion_Rate > 0.8
            THEN 'Power Learner with ' || ROUND(Completion_Rate*100) || '% completion rate'
        WHEN Courses_Completed >= 10 AND Subscription_Plan <> 'Premium'
            THEN 'Completed ' || Courses_Completed || ' courses - power usage on a non-Premium plan'
        WHEN Learner_Segment = 'Working Professional' AND Weekly_Hours > 6 AND Completion_Rate > 0.7
            THEN 'Working Professional averaging ' || Weekly_Hours || ' hrs/week with ' || ROUND(Completion_Rate*100) || '% completion'
        WHEN Learner_Segment = 'Power Learner' AND Months_Active >= 6
            THEN 'Power Learner active for ' || Months_Active || ' months - strong annual-plan candidate'
        WHEN Learner_Segment = 'Certification Seeker' AND Completion_Rate > 0.8
            THEN 'Certification Seeker with ' || ROUND(Completion_Rate*100) || '% completion - values credentialing'
        WHEN Learner_Segment = 'Career Switcher' AND Weekly_Hours > 8
            THEN 'Career Switcher investing ' || Weekly_Hours || ' hrs/week - high intent to reskill'
        WHEN Subscription_Plan IN ('Basic', 'Standard') AND Completion_Rate > 0.75 AND Weekly_Hours > 6
            THEN 'On ' || Subscription_Plan || ' but completing ' || ROUND(Completion_Rate*100) || '% at ' || Weekly_Hours || ' hrs/week - outgrowing current plan'
        WHEN Renewed_Last_Cycle = 'N' AND Completion_Rate > 0.7
            THEN 'Engaged (' || ROUND(Completion_Rate*100) || '% completion) but did not renew - likely a price objection, not a satisfaction issue'
        WHEN Subscription_Plan = 'Basic' AND Completion_Rate > 0.6 AND Login_Frequency > 10
            THEN 'On Basic but logging in ' || Login_Frequency || 'x/month with ' || ROUND(Completion_Rate*100) || '% completion'
        WHEN Learner_Segment = 'College Student' AND Completion_Rate > 0.7
            THEN 'College Student with strong ' || ROUND(Completion_Rate*100) || '% completion - budget-sensitive segment'
        WHEN Learner_Segment = 'Working Professional' AND Renewed_Last_Cycle = 'Y' AND Months_Active >= 9
            THEN 'Working Professional loyal for ' || Months_Active || ' months with consistent renewals'
        WHEN Discount_Availed > 20 AND Completion_Rate < 0.5
            THEN 'Received ' || Discount_Availed || '% discount but only ' || ROUND(Completion_Rate*100) || '% completion - discount not driving engagement'
        WHEN Coupon_Used = 'Y' AND Completion_Rate < 0.4
            THEN 'Coupon user with low ' || ROUND(Completion_Rate*100) || '% completion - signals low intent, not price sensitivity'
        WHEN Months_Active <= 2 AND Login_Frequency < 3
            THEN 'New learner (' || Months_Active || ' month(s)) with only ' || Login_Frequency || ' logins/month - needs onboarding, not a discount'
        WHEN Learner_Segment = 'Casual Learner' AND Completion_Rate < 0.3
            THEN 'Casual Learner with low ' || ROUND(Completion_Rate*100) || '% completion - keep expectations low-commitment'
        WHEN Last_Login_Days <= 7 AND Completion_Rate > 0.85
            THEN 'Highly active (logged in ' || Last_Login_Days || ' day(s) ago) with ' || ROUND(Completion_Rate*100) || '% completion - strong advocate potential'
        WHEN Age < 21 AND Subscription_Plan IN ('Pro', 'Premium')
            THEN 'Age ' || Age || ' on ' || Subscription_Plan || ' - confirm still eligible for extended student pricing'
        WHEN Completion_Rate BETWEEN 0.4 AND 0.7 AND Weekly_Hours BETWEEN 3 AND 6
            THEN 'Steady mid-range engagement (' || ROUND(Completion_Rate*100) || '% completion, ' || Weekly_Hours || ' hrs/week) - no action needed yet'
        ELSE 'No strong signal in either direction - continue standard monitoring'
    END AS Reason

FROM Learners
ORDER BY Learner_ID;
