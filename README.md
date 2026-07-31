# 🚀 AI-Powered Product Decision Support System for Personalized Pricing & Retention

> A Product Management case study demonstrating how Product Analytics, Deterministic Decision Systems, and Explainable AI can be combined to build an intelligent pricing and retention recommendation product for an EdTech subscription platform.

<p align="center">

![SQL](https://img.shields.io/badge/SQL-Analytics-blue)
![Python](https://img.shields.io/badge/Python-Automation-yellow)
![Google Gemini](https://img.shields.io/badge/Google-Gemini_AI-green)
![Product Management](https://img.shields.io/badge/Product-Management-purple)
![Explainable AI](https://img.shields.io/badge/Explainable-AI-orange)
![Rule Based](https://img.shields.io/badge/Decision_Engine-Rule_Based-red)

</p>

---

## 📌 Project Overview

Modern subscription platforms often treat every customer within a pricing tier the same, even though their behaviors differ significantly. Highly engaged learners may be ready to upgrade, while disengaged learners may require retention interventions instead of generic discounts.

This project demonstrates how behavioral analytics can be transformed into personalized pricing and retention decisions through a deterministic, explainable decision engine.

Unlike machine learning systems that rely on historical outcome data and often behave as black boxes, this solution adopts a **Product Management-first approach** by prioritizing transparency, auditability, and responsible AI.

The system combines:

- 📊 Product Analytics using SQL
- ⚙️ Rule-based Product Decision Engine
- 🤖 Google Gemini for personalized explanations
- 📈 Product Metrics for evaluating business impact

The result is a scalable internal decision-support product that helps Product, Pricing, Growth, and Customer Success teams make consistent, explainable, and data-driven pricing decisions.

---

# 🎯 Product Problem

Subscription-based learning platforms typically rely on static pricing models, where every learner within the same subscription tier receives identical pricing, renewal offers, and upgrade recommendations.

However, learner behavior varies significantly.

Some learners actively complete courses, log in regularly, and demonstrate high engagement, making them ideal candidates for premium offerings. Others gradually disengage, stop using the platform, and eventually churn, yet continue to receive the same generic pricing and promotional campaigns.

This one-size-fits-all approach creates multiple business challenges:

- High-intent learners are never identified for timely upgrades.
- At-risk learners receive generic discounts instead of targeted retention strategies.
- Pricing decisions lack behavioral context.
- Customer Success teams have no systematic way to prioritize intervention.
- Product teams cannot easily explain why a particular recommendation was generated.

Ultimately, this results in missed revenue opportunities, lower renewals, and reduced customer lifetime value.

---

# 💡 Product Opportunity

Rather than relying on complex machine learning models that require large amounts of historical outcome data, this project demonstrates how an explainable, rule-based decision engine can transform existing learner behavior into personalized pricing recommendations.

The objective is not simply to optimize pricing.

The objective is to build an internal product that enables multiple business teams to make consistent, transparent, and data-driven pricing decisions while maintaining complete explainability.

By combining product analytics, deterministic decision logic, and responsible AI, the platform can recommend personalized actions for every learner, including:

- Upgrade recommendations
- Renewal incentives
- Retention interventions
- Customer Success outreach
- Personalized learner communication

Every recommendation is fully auditable, making the system suitable for pricing, compliance, and business review.

---

# 👥 Target Users

This is an **internal decision-support product** designed for cross-functional teams responsible for subscription growth.

| User | Primary Responsibility | How the Product Helps |
|-------|------------------------|------------------------|
| **Product Managers** | Improve retention, engagement, and monetization | Identifies behavioral patterns and prioritizes pricing interventions |
| **Pricing Team** | Define pricing policies and discount guardrails | Generates transparent recommendations based on predefined business rules |
| **Growth Team** | Increase renewals and upgrades | Surfaces learners most likely to respond to personalized offers |
| **Customer Success** | Reduce churn and improve learner satisfaction | Flags high-risk learners requiring proactive engagement |

Rather than replacing human decision-making, the product augments it by providing consistent, explainable recommendations supported by behavioral analytics.

---

# 🎯 Product Vision

Build a scalable decision-support platform that enables subscription businesses to deliver personalized pricing and retention strategies using explainable analytics instead of opaque decision-making.

The long-term vision is to evolve from a deterministic recommendation engine into a continuously learning product that combines rule-based decision systems, experimentation, and machine learning while preserving transparency and user trust.

---

# ✨ Key Features

The AI-Powered Product Decision Support System combines product analytics, deterministic decision logic, and explainable AI to deliver personalized pricing and retention recommendations for every learner.

### 📊 Product Analytics

Analyze learner engagement, subscription behavior, renewal history, support interactions, and pricing patterns using SQL to uncover actionable product insights.

---

### ⚙️ Product Decision Engine

Generate personalized pricing recommendations through a deterministic SQL-based decision engine consisting of **22 business rules** evaluated across **14 behavioral and pricing signals**.

Every recommendation is:

- Transparent
- Explainable
- Deterministic
- Fully auditable

---

### 🤖 Explainable AI

Google Gemini transforms structured recommendations into learner-friendly natural language without influencing any pricing decisions.

This ensures personalized communication while preserving complete control over pricing logic.

---

### 📈 Product Metrics

Evaluate product performance using key subscription metrics including:

- Monthly Recurring Revenue (MRR)
- Average Revenue Per User (ARPU)
- Renewal Rate
- Upgrade Opportunity
- Discount Redemption Rate
- Churn Risk

---

### 🔍 Explainable Recommendations

Every recommendation is accompanied by a clear business rationale, allowing Product Managers and Pricing teams to understand exactly why a learner received a particular recommendation.

No recommendation is generated without an explicit decision rule.

---

### 🛡️ Responsible AI

The system intentionally separates pricing decisions from AI-generated communication.

The decision engine determines **what** recommendation should be made.

Google Gemini determines **how** that recommendation should be communicated.

This architectural separation improves transparency, auditability, and trust.

---

# 🏗️ Product Architecture

The product follows a hybrid architecture that separates deterministic decision-making from AI-powered communication.

```text
                         Learner Dataset
                                │
                                ▼
                     Product Analytics (SQL)
                                │
                                ▼
                  Product Decision Engine
                 (22 Rules • 14 Parameters)
                                │
                                ▼
                 Pricing Recommendation
                                │
                                ▼
                   Python Orchestration
                                │
                                ▼
              Google Gemini Explanation Layer
                                │
                                ▼
             Personalized Learner Communication
```

This architecture ensures that all pricing decisions remain deterministic and fully explainable, while the AI layer focuses exclusively on improving the user experience through personalized communication.

If the AI layer is removed entirely, the decision engine continues to function without any changes to recommendation quality.

---

# ⚖️ Why This Architecture?

A key product decision behind this project was to separate **decision-making** from **communication**.

Instead of allowing a Large Language Model to generate pricing recommendations directly, the system uses a deterministic SQL decision engine for all business logic.

This approach provides several advantages:

| Decision Engine | Google Gemini |
|-----------------|---------------|
| Generates all pricing recommendations | Explains recommendations in natural language |
| Uses deterministic business rules | Improves learner communication |
| Fully auditable | Enhances user experience |
| Transparent | Does not modify recommendations |
| Explainable | Does not override pricing decisions |

This separation aligns with responsible AI principles by ensuring that pricing decisions remain transparent, reproducible, and easy to review while still providing personalized communication for learners.

---

# 📊 Product Analytics Foundation

Every recommendation generated by the Product Decision Engine is driven by behavioral analytics rather than intuition.

The project analyzes learner engagement, subscription history, completion patterns, support interactions, and pricing behavior to identify opportunities for retention, upgrades, and personalized pricing.

Instead of asking **"What happened?"**, the analytics layer answers **"What should we do next?"**

This transforms raw learner data into actionable product decisions.

---

# 🗂️ Dataset

The project uses a simulated EdTech subscription dataset containing **1,600 learners**, designed to replicate realistic user behavior across multiple learner personas.

The dataset intentionally introduces behavioral correlations so that analytics produce meaningful product insights rather than random observations.

### Dataset Overview

| Attribute | Value |
|------------|-------|
| Total Learners | **1,600** |
| Subscription Plans | Basic, Standard, Pro, Premium |
| Learner Segments | 6 |
| Features | 19 |
| Product Analytics Queries | 22 |
| Product Decision Rules | 22 |
| Behavioral & Pricing Signals | 14 |

---

### Dataset Features

The dataset captures learner demographics, engagement, subscription activity, pricing behavior, and support interactions.

| Category | Features |
|----------|----------|
| Demographics | Age, Profession, Region |
| Subscription | Current Plan, Monthly Fee, Months Active |
| Learning Behavior | Weekly Hours, Login Frequency, Completion Rate |
| Course Activity | Courses Enrolled, Courses Completed |
| Pricing | Coupon Usage, Discount Availed |
| Customer Success | Support Tickets |
| Retention | Renewed Last Cycle |

The dataset was generated using Python with reproducible random seeds and behavior-driven rules to simulate realistic subscription patterns across different learner personas.

---

# 📈 Product Analytics

The analytics layer consists of **22 SQL queries**, each answering a product question rather than simply generating descriptive statistics.

Examples include:

- Which learner segments generate the highest recurring revenue?
- Which users are most likely to renew?
- Which behaviors predict upgrades?
- How effective are discounts?
- Which learners require Customer Success intervention?
- Which subscription tier contributes the most revenue?
- How does engagement influence retention?

These insights directly influence the Product Decision Engine.

No recommendation is generated without supporting behavioral evidence.

---

# 🔍 Key Product Insights

### 💰 Pro Plan Generates the Highest Revenue

Although the Standard plan has more subscribers, the Pro plan contributes the highest Monthly Recurring Revenue.

**Product implication**

Focus on identifying upgrade-ready learners instead of maximizing subscriber count alone.

---

### 📚 Engagement Strongly Predicts Renewal

Highly engaged learners consistently demonstrate significantly higher renewal rates than low-engagement learners.

**Product implication**

Engagement should be the primary signal when generating pricing and upgrade recommendations.

---

### 🎟️ Blanket Discounts Are Inefficient

Learners who frequently redeem coupons exhibit lower completion and renewal rates compared to learners who pay full price.

**Product implication**

Discounts should be personalized based on learner behavior instead of being offered universally.

---

### 🛠️ Support Activity Predicts Churn

Learners submitting multiple support tickets generally demonstrate lower completion rates and higher churn risk.

**Product implication**

Customer Success intervention should occur before offering upgrades or pricing changes.

---

### 🎯 Behavior Outperforms Demographics

Behavioral signals such as engagement, completion rate, and login frequency consistently provide stronger decision signals than demographic attributes like age or profession.

**Product implication**

The Product Decision Engine prioritizes behavioral analytics over demographic segmentation.

---

# 📊 Product Metrics

The system measures success using metrics commonly monitored by Product Managers in subscription businesses.

| Metric | Business Question |
|----------|-------------------|
| Monthly Recurring Revenue (MRR) | Is recurring revenue increasing? |
| Average Revenue Per User (ARPU) | How effectively are we monetizing each learner? |
| Renewal Rate | Are learners continuing their subscriptions? |
| Upgrade Opportunity | How many learners are ready for premium plans? |
| Discount Redemption Rate | Are discounts improving retention or reducing revenue unnecessarily? |
| Churn Risk | Which learners require proactive intervention? |

Unlike traditional business dashboards that focus only on reporting metrics, these KPIs directly inform the recommendation engine and influence personalized pricing decisions.

---

# ⚙️ Product Decision Engine

At the core of the product is a deterministic **Product Decision Engine** responsible for generating every pricing and retention recommendation.

Rather than relying on machine learning, the engine applies **22 product decision rules** across **14 behavioral and pricing signals** to recommend the most appropriate action for each learner.

Possible recommendations include:

- Recommend Premium Plan
- Recommend Pro Plan
- Personalized Renewal Discount
- Customer Success Outreach
- Retention Campaign
- Maintain Current Plan
- Monitor Engagement
- Re-engagement Incentive

Every recommendation is generated through explicit business logic, making the system completely transparent and easy to audit.

---

## 🎯 Behavioral & Pricing Signals

The recommendation engine evaluates multiple aspects of learner behavior before generating a decision.

| Category | Signals |
|----------|---------|
| Engagement | Weekly Hours, Login Frequency, Last Login Days |
| Learning Progress | Courses Completed, Completion Rate |
| Subscription | Current Plan, Monthly Fee, Months Active |
| Pricing | Coupon Usage, Discount History |
| Customer Success | Support Tickets |
| Retention | Renewal History |
| Demographics | Learner Segment, Age |

By combining these signals, the system captures both learner intent and business context, enabling recommendations that are personalized yet fully explainable.

---

## 🧠 Recommendation Strategy

The engine follows a priority-based decision framework rather than evaluating every rule equally.

The highest-priority objective is protecting learner success and long-term retention.

For example:

- A learner experiencing repeated support issues should receive Customer Success intervention before being considered for an upgrade.
- Highly engaged learners with strong completion rates should receive premium plan recommendations.
- Low-engagement learners should first receive retention-focused interventions rather than promotional pricing.

This prioritization reflects product strategy rather than technical implementation.

The goal is to recommend the **right intervention at the right time**, not simply maximize short-term revenue.

---

# 🤔 Why Rule-Based Decision Logic Instead of Machine Learning?

One of the most important product decisions in this project was choosing a deterministic rule engine over a machine learning model.

Although machine learning is often associated with recommendation systems, it was intentionally **not** used here.

The primary reason is that the available data represents a behavioral snapshot rather than historical outcomes from previous pricing experiments.

Without reliable labels such as:

- Which learners upgraded after receiving an offer?
- Which discounts actually improved renewals?
- Which interventions reduced churn?

a supervised machine learning model would lack trustworthy training data.

Instead, a deterministic decision engine provides several advantages.

| Rule-Based Decision Engine | Machine Learning |
|---------------------------|------------------|
| Fully explainable | Often difficult to interpret |
| Completely auditable | Requires model validation |
| Deterministic outputs | Probabilistic predictions |
| Immediate deployment | Requires historical outcome data |
| Easy for stakeholders to review | Harder to justify individual decisions |

For an initial product launch, transparency and stakeholder trust were prioritized over predictive sophistication.

Machine learning becomes a logical next step only after sufficient experimentation data has been collected.

---

# 🤖 Explainable AI

The project uses **Google Gemini** exclusively as a natural-language generation layer.

Gemini never determines:

- pricing
- discounts
- renewal offers
- upgrades
- retention actions

Its only responsibility is translating structured recommendations into learner-friendly explanations.

Example:

### Decision Engine Output

```text
Recommendation:
Upgrade to Pro

Reason:
Completion Rate = 84%
Weekly Hours = 9.3
Current Plan = Basic
```

### Gemini Output

> You're making excellent progress and consistently engaging with your courses. Upgrading to the Pro plan would give you access to more advanced learning resources that better match your current learning pace.

The recommendation remains unchanged.

Only the communication becomes more personalized and user-friendly.

---

# 🛡️ Responsible AI by Design

A core architectural principle of this project is the separation of **decision-making** and **communication**.

The Product Decision Engine determines **what** recommendation should be made.

Google Gemini determines **how** that recommendation should be communicated.

This separation provides several benefits:

- Transparent decision-making
- Complete auditability
- Easy compliance review
- Consistent pricing behavior
- Reduced AI risk
- Improved learner experience

Even if the AI layer becomes unavailable, the Product Decision Engine continues to generate identical recommendations.

This architectural independence ensures that business-critical pricing logic is never delegated to a Large Language Model.

---

# 🏛️ Product Design Decisions

Several deliberate product decisions shaped the architecture of this system.

### Prioritize Transparency Over Complexity

Rather than introducing an opaque recommendation model, the system favors explainability so that every recommendation can be justified during product and pricing reviews.

---

### Separate Decision Logic from AI

The recommendation engine and AI communication layer operate independently, reducing operational risk and preserving deterministic pricing behavior.

---

### Build for Cross-Functional Teams

The product is designed to support Product Managers, Pricing, Growth, and Customer Success teams rather than replacing human decision-making.

---

### Design for Future Experimentation

The architecture allows future A/B testing, rule refinement, and machine learning integration without requiring fundamental changes to the decision pipeline.

---

### Treat Explainability as a Product Feature

Explainability is not an implementation detail—it is a core product capability.

Every recommendation can be traced to explicit behavioral signals and decision rules, increasing trust among both internal stakeholders and end users.

---

# ⚙️ Product Decision Engine

At the core of the product is a deterministic **Product Decision Engine** responsible for generating every pricing and retention recommendation.

Rather than relying on machine learning, the engine applies **22 product decision rules** across **14 behavioral and pricing signals** to recommend the most appropriate action for each learner.

Possible recommendations include:

- Recommend Premium Plan
- Recommend Pro Plan
- Personalized Renewal Discount
- Customer Success Outreach
- Retention Campaign
- Maintain Current Plan
- Monitor Engagement
- Re-engagement Incentive

Every recommendation is generated through explicit business logic, making the system completely transparent and easy to audit.

---

## 🎯 Behavioral & Pricing Signals

The recommendation engine evaluates multiple aspects of learner behavior before generating a decision.

| Category | Signals |
|----------|---------|
| Engagement | Weekly Hours, Login Frequency, Last Login Days |
| Learning Progress | Courses Completed, Completion Rate |
| Subscription | Current Plan, Monthly Fee, Months Active |
| Pricing | Coupon Usage, Discount History |
| Customer Success | Support Tickets |
| Retention | Renewal History |
| Demographics | Learner Segment, Age |

By combining these signals, the system captures both learner intent and business context, enabling recommendations that are personalized yet fully explainable.

---

## 🧠 Recommendation Strategy

The engine follows a priority-based decision framework rather than evaluating every rule equally.

The highest-priority objective is protecting learner success and long-term retention.

For example:

- A learner experiencing repeated support issues should receive Customer Success intervention before being considered for an upgrade.
- Highly engaged learners with strong completion rates should receive premium plan recommendations.
- Low-engagement learners should first receive retention-focused interventions rather than promotional pricing.

This prioritization reflects product strategy rather than technical implementation.

The goal is to recommend the **right intervention at the right time**, not simply maximize short-term revenue.

---

# 🤔 Why Rule-Based Decision Logic Instead of Machine Learning?

One of the most important product decisions in this project was choosing a deterministic rule engine over a machine learning model.

Although machine learning is often associated with recommendation systems, it was intentionally **not** used here.

The primary reason is that the available data represents a behavioral snapshot rather than historical outcomes from previous pricing experiments.

Without reliable labels such as:

- Which learners upgraded after receiving an offer?
- Which discounts actually improved renewals?
- Which interventions reduced churn?

a supervised machine learning model would lack trustworthy training data.

Instead, a deterministic decision engine provides several advantages.

| Rule-Based Decision Engine | Machine Learning |
|---------------------------|------------------|
| Fully explainable | Often difficult to interpret |
| Completely auditable | Requires model validation |
| Deterministic outputs | Probabilistic predictions |
| Immediate deployment | Requires historical outcome data |
| Easy for stakeholders to review | Harder to justify individual decisions |

For an initial product launch, transparency and stakeholder trust were prioritized over predictive sophistication.

Machine learning becomes a logical next step only after sufficient experimentation data has been collected.

---

# 🤖 Explainable AI

The project uses **Google Gemini** exclusively as a natural-language generation layer.

Gemini never determines:

- pricing
- discounts
- renewal offers
- upgrades
- retention actions

Its only responsibility is translating structured recommendations into learner-friendly explanations.

Example:

### Decision Engine Output

```text
Recommendation:
Upgrade to Pro

Reason:
Completion Rate = 84%
Weekly Hours = 9.3
Current Plan = Basic
```

### Gemini Output

> You're making excellent progress and consistently engaging with your courses. Upgrading to the Pro plan would give you access to more advanced learning resources that better match your current learning pace.

The recommendation remains unchanged.

Only the communication becomes more personalized and user-friendly.

---

# 🛡️ Responsible AI by Design

A core architectural principle of this project is the separation of **decision-making** and **communication**.

The Product Decision Engine determines **what** recommendation should be made.

Google Gemini determines **how** that recommendation should be communicated.

This separation provides several benefits:

- Transparent decision-making
- Complete auditability
- Easy compliance review
- Consistent pricing behavior
- Reduced AI risk
- Improved learner experience

Even if the AI layer becomes unavailable, the Product Decision Engine continues to generate identical recommendations.

This architectural independence ensures that business-critical pricing logic is never delegated to a Large Language Model.

---

# 🏛️ Product Design Decisions

Several deliberate product decisions shaped the architecture of this system.

### Prioritize Transparency Over Complexity

Rather than introducing an opaque recommendation model, the system favors explainability so that every recommendation can be justified during product and pricing reviews.

---

### Separate Decision Logic from AI

The recommendation engine and AI communication layer operate independently, reducing operational risk and preserving deterministic pricing behavior.

---

### Build for Cross-Functional Teams

The product is designed to support Product Managers, Pricing, Growth, and Customer Success teams rather than replacing human decision-making.

---

### Design for Future Experimentation

The architecture allows future A/B testing, rule refinement, and machine learning integration without requiring fundamental changes to the decision pipeline.

---

### Treat Explainability as a Product Feature

Explainability is not an implementation detail—it is a core product capability.

Every recommendation can be traced to explicit behavioral signals and decision rules, increasing trust among both internal stakeholders and end users.

---

# ❓ Frequently Asked Questions

## Why did you use a rule-based system instead of machine learning?

The objective of this project was to build a transparent and explainable decision-support system.

Since the available dataset does not contain historical outcomes (e.g., which learners accepted offers or renewed after discounts), a supervised machine learning model would lack reliable training labels.

A deterministic rule engine provides:

- Transparent recommendations
- Consistent outputs
- Easy validation
- Full auditability
- Faster deployment

The architecture also allows machine learning to be incorporated in future iterations once sufficient historical data becomes available.

---

## Does Google Gemini make pricing decisions?

No.

Google Gemini is used only to convert structured recommendations into personalized learner-facing explanations.

All pricing and retention decisions are generated exclusively by the SQL-based Product Decision Engine.

---

## Who is this product designed for?

This is an internal decision-support product intended for:

- Product Managers
- Pricing Teams
- Growth Teams
- Customer Success Teams

It helps stakeholders generate personalized pricing and retention recommendations while maintaining complete transparency.

---

## Can this system be adapted to industries other than EdTech?

Yes.

The recommendation framework is domain-agnostic and can be adapted to any subscription-based business, including:

- SaaS
- OTT Streaming Platforms
- Fitness Applications
- FinTech Subscription Services
- E-commerce Membership Programs
- Digital Content Platforms

Only the business rules and behavioral signals would need to be customized.

---

## What makes this a Product Management project rather than a data analytics project?

The focus extends beyond analytics to include:

- Defining the product problem
- Identifying user personas
- Designing a decision-support workflow
- Choosing an explainable system architecture
- Prioritizing transparency and stakeholder trust
- Defining product success metrics
- Planning future product evolution

The analytics and AI components support these product decisions rather than serving as the primary outcome.

****

---

# 📸 Sample Recommendation

### Learner Profile

| Attribute | Value |
|-----------|-------|
| Current Plan | Basic |
| Weekly Learning Hours | 9.4 |
| Completion Rate | 87% |
| Login Frequency | High |
| Support Tickets | 0 |
| Renewal History | Renewed |

---

### Product Decision

**Recommendation**

✅ Upgrade to Pro Plan

**Reason**

The learner demonstrates consistently high engagement, strong course completion, and successful subscription renewal, indicating readiness for a higher-tier subscription.

---

### AI-Generated Explanation

> You're making excellent progress and consistently engaging with your learning journey. Based on your activity and course completion, upgrading to the Pro plan would unlock additional advanced content and features that better match your learning pace and goals.

---

This example demonstrates the separation between deterministic decision-making and AI-powered communication.

---

# 🤝 Contributing

Contributions are welcome.

Potential improvements include:

- Additional pricing strategies
- New behavioral signals
- Enhanced analytics
- Interactive dashboards
- Machine learning extensions
- Product experimentation features

Please feel free to open an issue or submit a pull request with suggestions or improvements.

---

# 📬 Contact

**Kumud Jalori**

B.Tech, Engineering Physics
Indian Institute of Technology Hyderabad

Interested in Product Management, Data Analytics, AI-powered Decision Systems, and Digital Product Strategy.
