"""
gemini_integration.py
----------------------
Converts SQL-generated pricing recommendations into personalized,
learner-facing explanations using the Google Gemini API.

IMPORTANT (read this first):
  Gemini NEVER decides the plan, discount, or renewal action.
  SQL (recommendation_engine.sql) already made that decision.
  Gemini's ONLY job here is to turn a structured row like:

      Current_Plan: Basic
      Recommended_Action: Recommend Upgrade to Pro
      Reason: "On Basic but completing 82% at 7.4 hrs/week"

  into a warm, personalized sentence a learner would actually read.
  This keeps the pricing logic 100% transparent and auditable (SQL),
  while still giving the learner a nice, human-sounding experience (LLM).

SETUP (3 steps):
  1. Get a free API key from Google AI Studio:
       https://aistudio.google.com/app/apikey
  2. Install the SDK:
       pip install google-generativeai --break-system-packages
  3. Set your API key as an environment variable (never hardcode it):
       export GEMINI_API_KEY="your-key-here"        (Mac/Linux)
       setx GEMINI_API_KEY "your-key-here"           (Windows)

USAGE:
  python gemini_integration.py                # processes first 10 rows (demo)
  python gemini_integration.py --all           # processes the full file
  python gemini_integration.py --limit 25       # processes first 25 rows
"""

import os
import csv
import time
import argparse

# The google-generativeai package is the official, beginner-friendly SDK.
import google.generativeai as genai


# ---------------------------------------------------------------------
# 1. CONFIGURE THE API
# ---------------------------------------------------------------------
def configure_gemini():
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        raise EnvironmentError(
            "GEMINI_API_KEY not found. Set it with:\n"
            "  export GEMINI_API_KEY='your-key-here'   (Mac/Linux)\n"
            "  setx GEMINI_API_KEY 'your-key-here'      (Windows, new terminal needed after)"
        )
    genai.configure(api_key=api_key)
    # gemini-1.5-flash is fast and free-tier friendly - good for this use case
    return genai.GenerativeModel("gemini-1.5-flash")


# ---------------------------------------------------------------------
# 2. BUILD THE PROMPT
# ---------------------------------------------------------------------
def build_prompt(row):
    """
    Takes one row from recommendations.csv (already decided by SQL)
    and builds a prompt asking Gemini ONLY to phrase it nicely.
    """
    prompt = f"""You are writing a short, warm, personalized message for an
online learning platform. A SQL rules engine has already decided the
recommendation below - do NOT change, second-guess, or add any pricing
decision of your own. Your only job is to explain it naturally in 2-3
sentences, as if speaking directly to the learner.

Learner's current plan: {row['Current_Plan']}
Recommended action: {row['Recommended_Action']}
Recommended discount: {row['Recommended_Discount_Pct']}%
Reason (from the data): {row['Reason']}

Write the message now. Keep it under 60 words. Do not mention SQL,
rules engines, or that this was automatically generated. Speak directly
to the learner in second person ("you")."""
    return prompt


# ---------------------------------------------------------------------
# 3. CALL GEMINI FOR A SINGLE ROW
# ---------------------------------------------------------------------
def get_personalized_message(model, row):
    prompt = build_prompt(row)
    try:
        response = model.generate_content(prompt)
        return response.text.strip()
    except Exception as e:
        # Never let one failed API call break the whole batch
        return f"[Gemini call failed: {e}]"


# ---------------------------------------------------------------------
# 4. MAIN PIPELINE
# ---------------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(description="Generate personalized recommendation messages via Gemini.")
    parser.add_argument("--input", default="recommendations.csv", help="CSV produced by recommendation_engine.sql")
    parser.add_argument("--output", default="sample_outputs.txt", help="Where to write the generated messages")
    parser.add_argument("--limit", type=int, default=10, help="Number of rows to process (ignored if --all)")
    parser.add_argument("--all", action="store_true", help="Process every row in the input file")
    args = parser.parse_args()

    model = configure_gemini()

    with open(args.input, newline="", encoding="utf-8") as f:
        rows = list(csv.DictReader(f))

    if not args.all:
        rows = rows[: args.limit]

    print(f"Processing {len(rows)} learner(s)...")

    with open(args.output, "w", encoding="utf-8") as out:
        for i, row in enumerate(rows, start=1):
            message = get_personalized_message(model, row)

            out.write(f"Learner_ID: {row['Learner_ID']}\n")
            out.write(f"Current Plan: {row['Current_Plan']}\n")
            out.write(f"SQL Recommendation: {row['Recommended_Action']} "
                      f"(Discount: {row['Recommended_Discount_Pct']}%)\n")
            out.write(f"SQL Reason: {row['Reason']}\n")
            out.write(f"Gemini Message: {message}\n")
            out.write("-" * 70 + "\n")

            print(f"  [{i}/{len(rows)}] {row['Learner_ID']} -> done")

            # Gentle rate-limiting - be kind to the free tier
            time.sleep(0.5)

    print(f"\nDone. Personalized messages saved to {args.output}")


if __name__ == "__main__":
    main()
