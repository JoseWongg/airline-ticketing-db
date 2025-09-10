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

## How to Use  

1. Open **SQL Server Management Studio (SSMS)**.  
2. Run the scripts in the following order from the `sql/` folder:  
   1. `create_tables.sql` → defines schema and tables.  
   2. `constraints.sql` → adds constraints (PK, FK, checks).  
   3. `insert_data.sql` → populates sample data.  
   4. `views.sql` → creates views.  
   5. `stored_procedures.sql` → creates stored procedures.  
   6. `functions.sql` → creates user-defined functions.  
   7. `triggers.sql` → creates triggers.  
   8. `security.sql` → configures roles, permissions, and test logins.  
   9. `queries.sql` → includes test queries and examples.  

   All scripts are standard T‑SQL. Open each file in SSMS and execute against a blank database (e.g., `AirlineTicketingDB`).
   Alternatively, run **`all_in_one.sql`** to create and populate everything in one go.  


---

## Database Design
The project follows a full lifecycle: **Conceptual → Logical → Physical**, including normalisation (up to **3NF**), constraints, and security considerations.

---

## Repository Structure
```
airline-ticketing-db/
├── README.md
├── sql/
│   ├── all_in_one.sql
│   ├── constraints.sql
│   ├── create_tables.sql
│   ├── functions.sql
│   ├── insert_data.sql
│   ├── queries.sql
│   ├── security.sql
│   ├── stored_procedures.sql
│   ├── triggers.sql
│   └── views.sql
│ 
└── docs/
    └── airline_ticketing_report.pdf
```

---

## Notes
- The PDF report in `docs/` provides detailed design decisions, constraints, security, and backup guidance.
- - The `sql/` folder contains the original full script (`all_in_one.sql`) and split files (tables, inserts, views, procedures, functions, triggers, etc.) for clarity.


---
## How to clone this repository

**Clone the repository**
git clone https://github.com/JoseWongg/airline-ticketing-db.git

**Navigate into the project folder**
cd airline-ticketing-db

---


## Authorship & Contact
Developed by **Jose Wong**  
j.wong@mail.com  
https://www.linkedin.com/in/jose-wongg  
https://github.com/JoseWongg  

## License
MIT — see the [LICENSE](LICENSE) file for details.
