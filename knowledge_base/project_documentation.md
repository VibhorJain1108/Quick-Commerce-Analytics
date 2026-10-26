# QuickCommerce Analytics — Project Knowledge Base

## 1. Project Purpose

This project analyzes a simulated quick-commerce operation using Python, Microsoft SQL Server, and SQL. It investigates order delivery reliability, store performance, picker availability, stockouts, and cancellations.

The project is intended for portfolio and learning purposes. It does not use real Blinkit operational data.

## 2. Dataset

The synthetic dataset contains:
- 10 simulated stores across Indian cities.
- 5,000 simulated orders.
- Order timestamps, product categories, item counts, and order values.
- Promised delivery times and actual delivery times.
- Picking duration, picker availability, stockout indicators, cancellation indicators, and order status.

## 3. Important Metrics

### Total Orders
The number of order records in the dataset.

### Delivered Orders
Orders with a delivered status. Cancelled orders should not be included in delivered-order delivery-time calculations.

### Cancellation Rate
Cancelled orders divided by total orders, multiplied by 100.

### On-Time Delivery Rate
Delivered orders that arrived within their promised delivery time, divided by all delivered orders, multiplied by 100.

### Late-Delivery Rate
Delivered orders that arrived after their promised delivery time, divided by all delivered orders, multiplied by 100.

### Average Picking Time
The average recorded picking duration, measured in minutes, for the specified group of orders. The analysis should state whether cancelled orders are included.

## 4. Initial Simulated Findings

The initial SQL analysis reported:
- Total orders: 5,000.
- Delivered orders: 4,812.
- Cancelled orders: 188.
- Cancellation rate: 3.76%.
- Overall on-time delivery rate: 67.21%.
- Noida on-time delivery rate: 62.05%.
- Gurugram on-time delivery rate: 62.95%.
- Pune on-time delivery rate: 71.07%.

These are previously reported results from the synthetic dataset. They should be rechecked against SQL queries before being treated as final.

## 5. Operational Questions

The project investigates:
- Which stores have lower on-time delivery rates?
- How does picker availability relate to delivery performance?
- Do picking times differ between on-time and late deliveries?
- Which hours have weaker delivery reliability?
- How do stockouts and cancellations vary by store and category?
- What operational experiment could improve delivery performance?

## 6. Interpretation Rules

- These findings are descriptive, not proof of causation.
- Picker availability, stockouts, and picking duration may be associated with delivery outcomes, but association does not establish causality.
- Recommendations should be presented as hypotheses to test, not guaranteed improvements.
- If the available data cannot answer a question, the assistant should state that limitation.
- Do not present simulated results as real Blinkit performance.

## 7. Proposed Operational Experiment

A proposed experiment is to test improved picker allocation during selected evening hours in Noida and Gurugram.

Primary metric:
- On-time delivery rate.

Secondary metrics:
- Average picking time.
- Cancellation rate.

Guardrails:
- Staffing cost per order.
- Order volume served.

The proposed target is a five-percentage-point improvement in on-time delivery at each pilot store. This is an experiment target, not an observed outcome or forecast.