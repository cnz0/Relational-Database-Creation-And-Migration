PostgreSQL -> SQL Server: Dialect Differences

This document summarizes key differences, encountered during migration from PostgreSQL to Microsoft SQL Server (MSSQL).

Auto-Incrementation
---
PostgreSQL              | SQL Server
bigserial / smallserial | BIGINT IDENTITY(1,1) / SMALLINT IDENTITY(1,1)
---

Impact:
PostgreSQL implicitly creates a sequence for serial types.
SQL Server uses IDENTITY, which is column-bound and does not create a separate sequence object by default.

2. Timestamp with Time Zone
PostgreSQL	SQL Server
timestamptz	datetime2 (or datetimeoffset)

Decision:
Used datetime2 in SQL Server.

Note:
datetimeoffset preserves timezone offset, but was not required in this domain model.

3. Schema Handling

PostgreSQL:

CREATE SCHEMA archery;
SET search_path TO archery;

SQL Server:

CREATE SCHEMA archery;
-- Explicit schema qualification required: archery.table_name

Difference:
PostgreSQL allows search path manipulation.
SQL Server requires explicit schema qualification in most cases.

4. BEFORE vs AFTER Triggers

PostgreSQL supports:

BEFORE INSERT

SQL Server supports only:

AFTER INSERT

Impact:
Logic originally implemented as BEFORE trigger in PostgreSQL was rewritten using AFTER trigger semantics in SQL Server.

Behavioral adjustments were required to ensure consistent data state handling.

5. Filtered Unique Constraints (NULL Handling)

PostgreSQL:

UNIQUE (m_email)

SQL Server:

CREATE UNIQUE INDEX ux_member_email
ON dbo.club_members(m_email)
WHERE m_email IS NOT NULL;

Difference:
PostgreSQL allows multiple NULL values in UNIQUE columns.
SQL Server requires a filtered index to achieve the same behavior.

6. String Aggregation

PostgreSQL:

string_agg(column, ', ')

SQL Server:

STRING_AGG(column, ', ')

Minor syntax differences; functionality equivalent.

7. Date Construction

PostgreSQL:

date_trunc('month', now())

SQL Server:

DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)

SQL Server requires explicit date construction.

8. Procedural Language

PostgreSQL:

PL/pgSQL

RAISE EXCEPTION

Native array support

SQL Server:

T-SQL

TRY...CATCH

THROW

Table-Valued Parameters (TVP) used instead of array parameters

Migration Decision:
Used Table-Valued Parameters to replace array-based logic for passing collections to procedures.

9. Transaction Handling

PostgreSQL:

BEGIN;
...
COMMIT;

SQL Server:

BEGIN TRAN;
...
COMMIT;

Error handling in SQL Server requires explicit TRY/CATCH blocks for rollback control.

10. Tooling Differences
PostgreSQL	SQL Server
pg_dump / pg_restore	SSMS / BACPAC / manual DDL rewrite

Automated migration tools were insufficient for:

procedural logic

triggers

advanced constraints

Manual adjustment was required.

Key Migration Takeaways

Data types are mostly portable but require explicit mapping.

Trigger semantics differ significantly.

NULL handling in UNIQUE constraints requires attention.

Procedural logic translation is the most migration-sensitive layer.

Logical backup (pg_dump) is preferred over physical file transfer.

Why This Matters for Data Engineering

Cross-database migration requires:

understanding engine-specific behavior,

validating constraints and transaction semantics,

adapting analytical queries,

testing consistency after transformation.

This migration was treated as a schema and logic transformation task rather than a simple dump-and-load operation.
