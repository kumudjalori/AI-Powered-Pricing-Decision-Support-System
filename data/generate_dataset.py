"""
generate_dataset.py
--------------------
Generates a realistic simulated dataset for the AI-Powered Pricing Strategy
Assistant project (EdTech learner data).

Output: learner_data.csv (1,500+ rows)

Design principles:
- 6 learner segments with realistic distribution weights
- 4 subscription plans with realistic pricing
- Segment-driven correlations (Power Learners engage more, Casual Learners churn more, etc.)
- No ML / no external data sources - pure rule-based simulation with controlled randomness
"""

import csv
import random

random.seed(42)  # reproducibility

# ------------------------------------------------------------------
# CONFIG: Segments, Plans, Regions
# ------------------------------------------------------------------

SEGMENTS = {
    "College Student":       {"weight": 0.28, "age_range": (18, 23)},
    "Working Professional":  {"weight": 0.24, "age_range": (24, 35)},
    "Career Switcher":       {"weight": 0.16, "age_range": (25, 40)},
    "Casual Learner":        {"weight": 0.14, "age_range": (18, 45)},
    "Certification Seeker":  {"weight": 0.12, "age_range": (22, 40)},
    "Power Learner":         {"weight": 0.06, "age_range": (20, 45)},
}

PLANS = {
    "Basic":    299,
    "Standard": 599,
    "Pro":      999,
    "Premium":  1499,
}

# Segment -> likely plan distribution (weights)
SEGMENT_PLAN_PREFERENCE = {
    "College Student":      {"Basic": 0.45, "Standard": 0.40, "Pro": 0.12, "Premium": 0.03},
    "Working Professional": {"Basic": 0.10, "Standard": 0.35, "Pro": 0.40, "Premium": 0.15},
    "Career Switcher":      {"Basic": 0.10, "Standard": 0.25, "Pro": 0.50, "Premium": 0.15},
    "Casual Learner":       {"Basic": 0.65, "Standard": 0.25, "Pro": 0.08, "Premium": 0.02},
    "Certification Seeker": {"Basic": 0.10, "Standard": 0.45, "Pro": 0.35, "Premium": 0.10},
    "Power Learner":        {"Basic": 0.02, "Standard": 0.08, "Pro": 0.30, "Premium": 0.60},
}

REGIONS = ["Mumbai", "Bengaluru", "Delhi NCR", "Hyderabad", "Pune", "Chennai", "Ahmedabad", "Jaipur"]

PAYMENT_MODES = ["UPI", "Card", "Netbanking", "Wallet"]

PROFESSION_BY_SEGMENT = {
    "College Student": ["Student"],
    "Working Professional": ["Software Engineer", "Marketing Executive", "Data Analyst", "Sales Executive", "HR Executive"],
    "Career Switcher": ["Ex-Teacher", "Ex-Banker", "Ex-Marketer", "Ex-Operations", "Unemployed (Upskilling)"],
    "Casual Learner": ["Homemaker", "Freelancer", "Student", "Retired", "Part-time Worker"],
    "Certification Seeker": ["Software Engineer", "Consultant", "Analyst", "Manager"],
    "Power Learner": ["Software Engineer", "Data Scientist", "Consultant", "Entrepreneur"],
}

TOTAL_LEARNERS = 1600  # >1,500 as required


def weighted_choice(weight_dict):
    keys = list(weight_dict.keys())
    weights = list(weight_dict.values())
    return random.choices(keys, weights=weights, k=1)[0]


def generate_learner(learner_id):
    segment = weighted_choice({k: v["weight"] for k, v in SEGMENTS.items()})
    age_min, age_max = SEGMENTS[segment]["age_range"]
    age = random.randint(age_min, age_max)
    profession = random.choice(PROFESSION_BY_SEGMENT[segment])
    region = random.choice(REGIONS)

    plan = weighted_choice(SEGMENT_PLAN_PREFERENCE[segment])
    monthly_fee = PLANS[plan]

    months_active = random.randint(1, 12)

    # --- Engagement behavior driven by segment ---
    if segment == "Power Learner":
        weekly_hours = round(random.uniform(10, 20), 1)
        login_frequency = random.randint(20, 30)
        last_login_days = random.randint(0, 3)
        completion_bias = random.uniform(0.75, 0.98)
    elif segment == "Casual Learner":
        weekly_hours = round(random.uniform(0.5, 4), 1)
        login_frequency = random.randint(1, 6)
        last_login_days = random.randint(20, 90)
        completion_bias = random.uniform(0.10, 0.45)
    elif segment == "Working Professional":
        weekly_hours = round(random.uniform(4, 10), 1)
        login_frequency = random.randint(8, 16)
        last_login_days = random.randint(0, 20)
        completion_bias = random.uniform(0.55, 0.85)
    elif segment == "Career Switcher":
        weekly_hours = round(random.uniform(5, 12), 1)
        login_frequency = random.randint(8, 18)
        last_login_days = random.randint(0, 15)
        completion_bias = random.uniform(0.50, 0.80)
    elif segment == "Certification Seeker":
        weekly_hours = round(random.uniform(3, 8), 1)
        login_frequency = random.randint(6, 14)
        last_login_days = random.randint(0, 25)
        completion_bias = random.uniform(0.60, 0.90)
    else:  # College Student
        weekly_hours = round(random.uniform(2, 9), 1)
        login_frequency = random.randint(4, 14)
        last_login_days = random.randint(0, 40)
        completion_bias = random.uniform(0.35, 0.75)

    courses_enrolled = random.randint(1, 15)
    courses_completed = max(0, min(courses_enrolled, round(courses_enrolled * completion_bias)))
    completion_rate = round(courses_completed / courses_enrolled, 2) if courses_enrolled > 0 else 0.0

    # --- Coupons / Discounts (students & casual learners use more) ---
    if segment in ("College Student", "Casual Learner"):
        coupon_used = random.random() < 0.55
        discount_availed = round(random.uniform(10, 30), 0) if coupon_used else 0
    else:
        coupon_used = random.random() < 0.20
        discount_availed = round(random.uniform(5, 15), 0) if coupon_used else 0

    payment_mode = random.choice(PAYMENT_MODES)

    # --- Support tickets inversely related to completion rate ---
    if completion_rate < 0.4:
        support_tickets = random.randint(1, 5)
    elif completion_rate < 0.7:
        support_tickets = random.randint(0, 3)
    else:
        support_tickets = random.randint(0, 1)

    # --- Renewal logic: driven by engagement + recency ---
    renewal_score = completion_rate * 0.4 + (1 - min(last_login_days, 90) / 90) * 0.4 + (months_active / 12) * 0.2
    if last_login_days > 45:
        renewal_score -= 0.3
    renewed_last_cycle = random.random() < max(0.03, min(0.95, renewal_score))

    return {
        "Learner_ID": f"L{learner_id:05d}",
        "Age": age,
        "Profession": profession,
        "Region": region,
        "Learner_Segment": segment,
        "Subscription_Plan": plan,
        "Monthly_Fee": monthly_fee,
        "Months_Active": months_active,
        "Courses_Enrolled": courses_enrolled,
        "Courses_Completed": courses_completed,
        "Completion_Rate": completion_rate,
        "Weekly_Hours": weekly_hours,
        "Login_Frequency": login_frequency,
        "Last_Login_Days": last_login_days,
        "Coupon_Used": "Y" if coupon_used else "N",
        "Discount_Availed": int(discount_availed),
        "Payment_Mode": payment_mode,
        "Support_Tickets": support_tickets,
        "Renewed_Last_Cycle": "Y" if renewed_last_cycle else "N",
    }


def main():
    rows = [generate_learner(i + 1) for i in range(TOTAL_LEARNERS)]

    fieldnames = list(rows[0].keys())
    out_path = "learner_data.csv"
    with open(out_path, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

    print(f"Generated {len(rows)} learner records -> {out_path}")


if __name__ == "__main__":
    main()
