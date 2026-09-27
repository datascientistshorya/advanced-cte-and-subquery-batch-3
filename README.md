# SQL Subqueries & CTEs — Business Analysis Practice

A practical SQL project focused on solving business-analysis problems using **subqueries, Common Table Expressions (CTEs), aggregations, conditional logic, and existence-based filtering**.

The purpose of this exercise is not simply to write SQL queries, but to develop the ability to translate business questions into structured analytical logic.

---

## Project Objective

In real-world analytics, business questions rarely arrive in the form of simple SQL requirements.

Questions such as:

* Which customers spend more than the average customer in their city?
* Which products are priced above their category benchmark?
* Which customers have purchased expensive products?
* Which customers have never cancelled an order?
* Which high-value customers also show cancellation risk?

require multiple analytical steps.

This exercise is designed to build that reasoning process:

**Business Question → Metric Definition → Aggregation → Benchmark → Comparison → Business Insight**

The focus is therefore on developing SQL that is not only syntactically correct, but also analytically meaningful and reusable for real business scenarios.

---

# Dataset Structure

The exercise uses a simple online-store relational database consisting of three tables.

## 1. Customers

Stores customer-level information.

| Column          | Description                         |
| --------------- | ----------------------------------- |
| `customer_id`   | Unique identifier for each customer |
| `customer_name` | Customer name                       |
| `city`          | Customer's city                     |

---

## 2. Orders

Stores transaction-level information.

| Column        | Description                                 |
| ------------- | ------------------------------------------- |
| `order_id`    | Unique identifier for each order            |
| `customer_id` | Customer who placed the order               |
| `product_id`  | Product associated with the order           |
| `amount`      | Order amount                                |
| `status`      | Order status such as Completed or Cancelled |
| `order_date`  | Date of the order                           |

Relationship:

`orders.customer_id → customers.customer_id`

`orders.product_id → products.product_id`

---

## 3. Products

Stores product-level information.

| Column         | Description                        |
| -------------- | ---------------------------------- |
| `product_id`   | Unique identifier for each product |
| `product_name` | Product name                       |
| `category`     | Product category                   |
| `price`        | Product price                      |

Relationship:

`products.product_id → orders.product_id`

---

# Business Questions Covered

## Q1 — Customers Above City Average

Identify customers whose total spending is greater than the average total spending of customers in their city.

### Analytical concept

This requires:

1. Calculating customer-level spending.
2. Calculating the average spending for each city.
3. Comparing each customer against their city's benchmark.

### Techniques used

* `INNER JOIN`
* `SUM()`
* `AVG()`
* `GROUP BY`
* CTEs
* Multi-level aggregation
* Benchmark comparison

---

## Q2 — Customers Above Overall Average

Identify customers whose total spending is greater than the overall average customer spending.

### Analytical concept

The query first needs to calculate spending at the customer level and then calculate the average across those customers.

This demonstrates an important analytical principle:

> When comparing customers against an average customer metric, calculate the metric at the customer level before calculating the benchmark.

### Techniques used

* CTEs
* `SUM()`
* `AVG()`
* Aggregation over aggregated results
* Non-correlated subqueries

---

## Q3 — Products Above Category Average Price

Identify products whose price is higher than the average price of products within their category.

### Analytical concept

Each product is compared with a category-level benchmark rather than the overall product average.

This is a common analytical pattern for:

* Pricing analysis
* Product positioning
* Category benchmarking
* Premium-product identification

### Techniques used

* `GROUP BY`
* `AVG()`
* `INNER JOIN`
* CTEs
* Category-level benchmarking

---

## Q4 — Customers Who Bought Expensive Products

Identify customers who purchased at least one product whose price is above the overall average product price.

### Analytical concept

First, identify products above the overall average price.

Then determine which customers have purchased at least one of those products.

This introduces an important SQL pattern:

**Benchmark → Filter qualifying records → Test customer relationship**

### Techniques used

* CTEs
* `AVG()`
* `EXISTS`
* `INNER JOIN`
* Non-correlated subqueries
* Relationship-based filtering

---

## Q5 — Customers With No Cancelled Orders

Identify customers who have never placed a cancelled order.

### Analytical concept

Instead of finding customers who have cancellations, this query identifies customers for whom a qualifying cancellation record does not exist.

This is a practical use case for negative existence testing.

### Techniques used

* `NOT EXISTS`
* Subqueries
* Conditional filtering
* Parent-child relationship analysis

This query also reinforces the distinction between:

```sql
EXISTS
```

and

```sql
NOT EXISTS
```

---

## Q6 — Above-Average Spending + Successful Orders

Identify customers who:

1. Have total spending above the overall average customer spending.
2. Have placed at least one completed order.

### Analytical concept

This combines two independent business conditions:

**Financial performance**

Customer spending > average customer spending

**Customer activity**

Customer has at least one completed order

The final result therefore represents customers who satisfy both conditions.

### Techniques used

* CTEs
* `SUM()`
* `AVG()`
* `IN`
* Subqueries
* Multiple business conditions
* Customer-level aggregation

---

## Q7 — Category Revenue Above Average Category Revenue

Calculate revenue for each product category and return only categories whose revenue is greater than the average revenue across all categories.

### Analytical concept

This follows a two-stage aggregation process:

1. Calculate revenue for each category.
2. Calculate the average category revenue.
3. Compare every category against that benchmark.

This is a common pattern in business reporting and performance analysis.

### Techniques used

* `INNER JOIN`
* `SUM()`
* `AVG()`
* `GROUP BY`
* CTEs
* Aggregation over aggregated results
* Benchmark analysis

---

## Q8 — High-Value Customers With Cancellation Risk

Identify customers who satisfy both:

1. Their total spending is above the overall average customer spending.
2. Their cancelled-order count is greater than the average cancelled-order count per customer.

### Analytical concept

This query combines two different dimensions of customer analysis:

**Customer value**

Above-average total spending

**Customer risk**

Above-average cancelled-order count

The resulting segment represents customers who are financially valuable while simultaneously displaying higher-than-average cancellation activity.

This type of segmentation can support deeper analysis such as:

* Customer retention
* Cancellation investigation
* Revenue-risk analysis
* Customer experience analysis
* Targeted retention strategies

### Techniques used

* CTEs
* `SUM()`
* Conditional aggregation
* `CASE`
* `AVG()`
* `CROSS JOIN`
* Multiple benchmark comparisons
* Business segmentation

---

# SQL Techniques Practiced

This exercise focuses on several important SQL capabilities.

## 1. Common Table Expressions

CTEs are used to break complex analytical problems into logical stages.

```sql
WITH customer_data AS (
    ...
)
```

They improve readability and make multi-step analysis easier to reason about.

---

## 2. Aggregate Functions

The project uses:

```sql
SUM()
AVG()
COUNT()
```

These functions transform transaction-level data into meaningful business metrics.

Examples include:

* Total customer spending
* Average customer spending
* Category revenue
* Average product price
* Cancelled-order counts

---

## 3. Conditional Aggregation

The project uses `CASE` inside aggregate functions to create business metrics from transaction data.

Example:

```sql
SUM(
    CASE
        WHEN status = 'Cancelled' THEN 1
        ELSE 0
    END
)
```

This is particularly useful for calculating:

* Cancellation counts
* Completed orders
* Conversion-related metrics
* Segment-specific measures

---

## 4. Subqueries

Non-correlated subqueries are used to calculate benchmarks and filter analytical results.

Example:

```sql
SELECT AVG(amount_spent)
FROM customer_data
```

The result can then be used as a benchmark for customer-level analysis.

---

## 5. EXISTS

`EXISTS` is used when the business question is essentially:

> Does at least one qualifying record exist?

For example, identifying customers who purchased at least one expensive product.

---

## 6. NOT EXISTS

`NOT EXISTS` is useful for questions involving absence.

For example:

> Find customers for whom no cancelled order exists.

This is an important pattern for customer eligibility and exclusion analysis.

---

## 7. CROSS JOIN for Benchmark Analysis

`CROSS JOIN` can be useful when a CTE produces a single benchmark row that needs to be compared against every record.

For example:

```sql
CROSS JOIN benchmarks b
```

This allows every customer to be compared against the same overall benchmark.

---

## 8. Multi-Level Aggregation

Several questions follow the analytical pattern:

```text
Transaction Data
       ↓
Customer / Product / Category Metric
       ↓
Aggregate Benchmark
       ↓
Comparison
       ↓
Business Segment
```

This is one of the most important patterns in analytical SQL.

---

# What I Am Learning and Mastering

Through these eight problems, the focus is moving beyond basic SQL syntax toward **analytical SQL thinking**.

### Core SQL Skills

* CTE construction
* Subqueries
* Aggregations
* Conditional aggregation
* `CASE`
* `EXISTS`
* `NOT EXISTS`
* `IN`
* `INNER JOIN`
* `CROSS JOIN`
* `GROUP BY`
* Multi-level aggregation

### Analytical Skills

* Customer-level metric creation
* Product-level analysis
* Category-level analysis
* Benchmark creation
* Above-average analysis
* Customer segmentation
* Risk identification
* Revenue analysis
* Comparative analysis

### Business Analytics Thinking

The larger objective is to understand that SQL is not just about retrieving data.

It is about answering questions such as:

**Who is valuable?**

**Who is performing above or below a benchmark?**

**Where is revenue concentrated?**

**Which customers exhibit potential risk?**

**Which products or categories are positioned above their peers?**

The exercises therefore combine SQL implementation with business reasoning.

---

# Key Analytical Pattern

A recurring pattern throughout the project is:

```text
Raw Transaction Data
        ↓
Create Business Metric
        ↓
Aggregate at Correct Level
        ↓
Calculate Benchmark
        ↓
Compare Against Benchmark
        ↓
Identify Business Segment
```

Understanding the **level of aggregation** is especially important.

For example:

`AVG(order amount)`

is not necessarily the same as:

`AVG(customer total spending)`

The correct benchmark depends on the business question.

---

# Project Takeaway

These exercises are designed to strengthen the transition from:

**Writing SQL queries**

to

**Thinking like a business analyst using SQL.**

The emphasis is on creating meaningful metrics, choosing the correct level of aggregation, constructing appropriate benchmarks, and translating business requirements into structured SQL logic.

This foundation will support more advanced analytical SQL involving:

* Window functions
* Advanced segmentation
* Funnel analysis
* Customer behavior analysis
* Cohort analysis
* Revenue analytics
* Business performance diagnostics

---

## Author

**Shorya Dev Bisht**

LinkedIn: www.linkedin.com/in/shorya-bisht-a20144349
