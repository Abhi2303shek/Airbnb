# 🏠 Airbnb Market & Pricing Intelligence Analysis

**74,000+ Listings | MySQL | Advanced Segmentation**

---

** Kaggle Link : https://www.kaggle.com/datasets/rupindersinghrana/airbnb-price-dataset ** 

---

## 📌 Project Overview

This project analyzes **74K+ Airbnb listings** to uncover:

* What truly drives pricing power?
* Do trust signals impact revenue?
* Are expensive listings actually better rated?
* Where do undervalued opportunities exist?
* How does host behaviour influence demand?

All analysis was performed using **pure MySQL**, supported by data cleaning in Python (Pandas).

---

## 🛠 Tools Used

* MySQL 8.0
* MySQL Workbench
* Python (Pandas) for preprocessing
* Window Functions (NTILE)
* Subqueries & Aggregations

---

## 🧹 Data Cleaning Performed

Before analysis, the dataset required transformation:

* Converted `t/f` to 1/0 (boolean normalization)
* Cleaned percentage fields (`host_response_rate`)
* Handled missing numeric values
* Fixed date formats (DD-MM-YYYY → DATE)
* Removed corrupted scientific notation in price
* Adjusted varchar lengths (zipcode handling)

This ensured accurate aggregations and reliable insights.

---

# 🔥 Core Pricing Insights

* Entire homes command significantly higher prices than private/shared rooms.
* Price increases with bedroom count but shows diminishing returns at larger sizes.
* Additional bathrooms increase price, but not proportionally.
* Instant-bookable listings tend to be priced higher.
* Verified hosts show stronger pricing power.
* Higher response rates correlate with higher pricing tiers.
* Profile pictures act as a measurable trust signal influencing price.

### Key Takeaway:

Pricing is influenced by trust signals nearly as much as property size.

---

# ⭐ Trust & Quality Signals

* Verified hosts receive higher average ratings.
* Hosts with profile pictures perform better in ratings.
* Higher response rates correlate with improved review scores.
* High price does not always guarantee a high rating.
* Certain neighbourhoods combine both premium pricing and strong ratings.

### Key Takeaway:

Customer trust and responsiveness influence satisfaction more than luxury alone.

---

# 📊 Market Structure & Demand

* Listing supply is concentrated in specific neighbourhood clusters.
* Certain bedroom categories attract disproportionately more reviews (demand proxy).
* Higher-priced listings receive fewer reviews (price elasticity effect).
* Market composition varies significantly by room type.
* Competition levels differ across neighbourhoods.

### Key Takeaway:

Pricing elasticity exists — aggressive pricing reduces review frequency.

---

# 🏆 Advanced Strategic Analysis

### Host Experience & Pricing

* Experienced hosts charge higher prices on average.
* New hosts appear to underprice to compete.

### Trust Signal Strength

Listings with:

* Verified identity
* Profile picture
* 90%+ response rate

Command higher average pricing.

### Overpriced vs Underpriced Detection

Identified:

* Listings priced above average with low ratings & low reviews.
* Listings rated above average but priced below neighbourhood average.

### Top 10% Premium Listings Analysis

Top decile listings show:

* Higher bedroom counts
* Higher response rates
* Greater trust signal presence
* Premium neighbourhood concentration

### Strategic Insight:

Market inefficiencies exist. Not all high-rated listings are optimally priced.

---

# 📈 Analytical Coverage

This project answers 30+ high-impact business questions covering:

* Revenue optimization
* Trust impact modeling
* Host performance segmentation
* Price elasticity effects
* Market competition analysis
* Investment opportunity detection
* Advanced decile-based segmentation

---

# 💡 What Makes This Project Strong

Instead of running excessive basic queries, this analysis focuses on:

* Business-driven questioning
* Revenue-oriented insights
* Strategic segmentation logic
* Window function usage
* Real-world ETL challenges
* Recruiter-ready storytelling

---

# 🚀 Skills Demonstrated

* Advanced SQL Aggregations
* CASE-based segmentation
* Window Functions (NTILE)
* Subqueries & Nested Aggregations
* Percentile approximation logic
* Data normalization
* Analytical thinking
* Market strategy interpretation

---

# 📊 Dataset Scale

* 74,000+ listings
* Multi-city & neighbourhood coverage
* Pricing, ratings, trust, and host behaviour data
* Structured & semi-structured cleaning challenges

---

# 🧠 Final Conclusion

Airbnb pricing is not driven solely by property size or location.

It is significantly influenced by:

* Trust signals
* Host responsiveness
* Verification status
* Booking convenience

Luxury alone does not guarantee performance.
Trust and experience create measurable pricing power.

---

## 👨‍💻 Author

Abhishek Singh
Data Analyst | SQL | Business Intelligence | Market Analytics
