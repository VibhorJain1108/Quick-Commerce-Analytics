
# QuickCommerce Analytics — Findings Reference

## Dataset
- The project uses synthetic data for learning and portfolio demonstration.
- Total orders: 5,000.
- Delivered orders: 4,812.
- Cancelled orders: 188.
- Previously reported cancellation rate: 3.76%.

## Previously Reported On-Time Delivery Results
- Overall on-time delivery rate: 67.21%.
- Noida: 62.05%.
- Gurugram: 62.95%.
- Pune: 71.07%.

These figures were reported in an earlier analysis and must be rechecked
against the SQL queries before being treated as final.

## Proposed Operational Experiment
Test improved picker allocation during selected evening hours in Noida
and Gurugram.

Primary metric:
- On-time delivery rate.

Secondary metrics:
- Average picking time.
- Cancellation rate.

Guardrails:
- Staffing cost per order.
- Order volume served.

The proposed target is a five-percentage-point improvement in on-time
delivery at each pilot store. This is a target, not a measured outcome.

## Limitations
- All data is simulated, not actual Blinkit operational data.
- The analysis does not establish causal relationships.
- Experiment outcomes have not been measured.
