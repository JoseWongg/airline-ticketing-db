# Airline Ticketing Database System

## Overview
A **relational database** for managing an airline’s ticketing operations, designed and implemented in **Microsoft SQL Server (T‑SQL)**.

It supports:
- Passenger reservations and ticket issuance
- Employee roles and secure access control
- Seat allocation and automatic reservation updates
- Baggage handling with fee calculation
- Revenue reporting per employee and flight

---

## Tech Stack
- **Database**: Microsoft SQL Server / SQL Server Management Studio (SSMS)
- **Objects**: Tables, Views, Stored Procedures, User-Defined Functions, Triggers
- **Design**: Normalized to **3NF**, with constraints, transactions & concurrency controls

---

## Features Implemented
- **Reservation & Ticketing**
  - Role‑based operations (Ticketing Staff / Supervisor)
  - PNR-based reservation lookup and ticket issuance with **e‑boarding number**
  - Seat selection with automatic status updates (trigger)

- **Business Logic**
  - Additional services & fees (baggage, meal upgrade, preferred seat)
  - Constraints (e.g., no past reservation dates)

- **Reporting**
  - View: **Employee revenue per flight** (tickets + baggage fees)
  - Functions/queries for business‑class meals today, pending reservations, age filters
  - Baggage checked‑in count by flight & date

---

## 🚀 How to Run (order of scripts)
1) `sql/create_tables.sql`
2) `sql/insert_data.sql`
3) `sql/views.sql`
4) `sql/stored_procedures.sql`
5) `sql/functions.sql`
6) `sql/triggers.sql`
7) `sql/queries.sql`  (sample checks / demo queries)

> All scripts are standard T‑SQL. Open each file in SSMS and execute against a blank database (e.g., `AirlineTicketingDB`).

---

## Database Design
The project follows a full lifecycle: **Conceptual → Logical → Physical**, including normalization (up to **3NF**), constraints, and security considerations.

- **ER Diagram** (export yours from SSMS and replace this file):
  - `docs/er_diagram.png`

---

## Repository Structure
```
airline-ticketing-db/
├── README.md
├── sql/
│   ├── create_tables.sql
│   ├── insert_data.sql
│   ├── views.sql
│   ├── stored_procedures.sql
│   ├── functions.sql
│   ├── triggers.sql
│   └── queries.sql
└── docs/
    ├── er_diagram.png
    └── airline_ticketing_report.pdf
```

---

## Notes
- The PDF report in `docs/` provides detailed design decisions, constraints, security, and backup guidance.
- - The `sql/` folder contains both the original full script (`all_in_one.sql`) and split files (tables, inserts, views, procedures, functions, triggers, etc.) for clarity.

## Author
**Jose Wong** · [LinkedIn](https://www.linkedin.com/in/jose-wongg) · [GitHub](https://github.com/JoseWongg)
