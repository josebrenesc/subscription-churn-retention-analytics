# Data model

```mermaid
erDiagram
    CUSTOMERS ||--o{ SUBSCRIPTIONS : owns
    PLANS ||--o{ SUBSCRIPTIONS : defines
    SUBSCRIPTIONS ||--o{ PAYMENTS : generates
    SUBSCRIPTIONS ||--o{ MONTHLY_USAGE : records
    SUBSCRIPTIONS ||--o{ SUPPORT_CONTACTS : creates
    SUBSCRIPTIONS ||--o| CANCELLATIONS : may_have
    SUBSCRIPTIONS ||--o| REACTIVATIONS : may_have
```

Subscriptions are the central portfolio table. Payments represent financial
activity, monthly usage represents engagement, support contacts represent
customer experience, and cancellation/reactivation tables represent lifecycle
events.
