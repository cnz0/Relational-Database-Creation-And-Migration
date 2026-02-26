Relational Database Engineering & Migration (PostgreSQL)

- This project presents the design and implementation of a fully normalized relational database system built in PostgreSQL, with a strong focus on data engineering practices, such as performance benchmarking, access control, and cross-database migration readiness.
- The database models a bow training management system and was developed with scalability, analytical workload, and migration considerations in mind.

Project Structure:
  relational-db-engineering/
  |--- schema/<br>
  |--- data/<br>
  |--- analytics/<br>
  |--- performance/<br>
  |--- roles-and-security/<br>
  |--- migration/

The project focuses on:
- 3NF schema design and referential integrity
- Synthetic data generation at scale
- Performance benchmarking using EXPLAIN ANALYZE
- Role-based access control (RBAC)
- Analytical views and derived metrics
- Cross-database migration preparation (PostgreSQL -> SQL Server)

The system includes:
- Core entities: members, trainers, sessions, bookings, payments
- Lookup tables (statuses, currencies, methods)
- Many-to-many relationships (booking_equipment, sessions_trainers)
- Analytical entities (scores)

Key characteristics:
- Full referential integrity (FK + ON DELETE CASCADE where appropriate)
- Composite primary keys
- Unique constraints for business logic enforcement
- CHECK constraints for data validation
- Dedicated schema (archery)
- Synthetic Data Generation

An ER diagram is available in: schema/schema.pdf

To simulate realistic workload conditions, two datasets were prepared:
- seed_small.sql – functional testing dataset
- seed_large.sql – extended dataset (~200k bookings) for performance benchmarking

Data generation includes:
- Controlled randomness using generate_series
- Logical time windows for sessions and bookings
- Status distribution modeling
- Payment and session relationships
- Automatic statistics refresh (VACUUM ANALYZE)

This approach allows testing query plans under realistic load conditions.

Analytical Layer (views and queries):
- Trainer workload (next 30 days)
- Field utilization metrics
- Member activity scoring with recency decay
- Equipment popularity
- Aggregated reporting views

Example: time-decay based activity score using exponential weighting:
```
exp( -lambda * time_difference )
```

Performance Engineering:
- Performance benchmarking was conducted using:
- Baseline query execution (EXPLAIN ANALYZE)
- Dropping all indexes for clean measurement

Single-column indexes
- Composite indexes aligned with workload

Files:
performance/query_under_performance_test.sql<br>
performance/indexes.sql

Key observations:
- Composite indexes significantly reduced query cost
- Statistics refresh affected planner decisions
- Index design must align with filtering predicates

Role-Based Access Control (RBAC):
- Two application-level roles were implemented: app_member and app_staff

Security configuration includes:
- REVOKE default public privileges
- Minimal SELECT/INSERT/UPDATE permissions
- Controlled access through views for external users
- Explicit role testing (SET ROLE, success/failure cases)

Files:
roles-and-security/roles_and_access.sql
roles-and-security/roles_testing.sql

Migration:
- The schema was prepared with cross-database portability in mind.
- Differences between PostgreSQL and SQL Server were analyzed, including:
  bigserial vs IDENTITY
  timestamptz vs datetimeoffset
  Schema handling and search path
  Trigger behavior differences
  Index syntax differences
  
Migration scripts and notes are located in: migration/

This stage simulates a real-world database engine transition scenario.

For more informations considering migration, see:
- migration/dialect_differences.md
- migration/mssql/

Operations:
- Nightly maintenance execution via psql
- Logical backup using pg_dump
- Restore using pg_restore

What I Learned:
- Designing normalized relational schemas for scalable workloads
- Generating synthetic datasets for performance testing
- Interpreting PostgreSQL query plans and optimizing indexes
- Implementing role-based access control in SQL
- Preparing schema for cross-engine migration

Migration (PostgreSQL → SQL Server)

Migration treated as a logical transformation task rather than simple dump-and-load.
