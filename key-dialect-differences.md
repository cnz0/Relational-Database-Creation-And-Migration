PostgreSQL -> SQL Server: Dialect Differences

This document summarizes key differences, encountered during migration from PostgreSQL to Microsoft SQL Server (MSSQL).

Auto-Incrementation
- PostgreSQL: bigserial / smallserial
- SQL Server: BIGINT IDENTITY(1,1) / SMALLINT IDENTITY(1,1)

Impact:
PostgreSQL implicitly creates a sequence for serial types.
SQL Server uses IDENTITY, which is column-bound and does not create a separate sequence object by default.

Timestamp with Time Zone
- PostgreSQL: timestamptz
- SQL Server: datetime2 (or datetimeoffset)
- Note: datetimeoffset preserves timezone offset, but was not required in this domain model.

Schema Handling
- PostgreSQL:
  CREATE SCHEMA archery;
  SET search_path TO archery;

- SQL Server:
  CREATE SCHEMA archery;

Difference:
- PostgreSQL allows search path manipulation.
- SQL Server requires explicit schema qualification in most cases.

BEFORE vs AFTER Triggers
- PostgreSQL supports:
  BEFORE INSERT

- SQL Server supports only:
  AFTER INSERT

- Impact:
  Logic originally implemented as BEFORE trigger in PostgreSQL was rewritten using AFTER trigger semantics in SQL Server.

NULL Handling:
- PostgreSQL:
  UNIQUE (m_email)

- SQL Server:
  CREATE UNIQUE INDEX ux_member_email
  ON dbo.club_members(m_email)
  WHERE m_email IS NOT NULL;

- Difference:
  PostgreSQL allows multiple NULL values in UNIQUE columns.
  SQL Server requires a filtered index to achieve the same behavior.

Date Construction:
- PostgreSQL:
  date_trunc('month', now())
- SQL Server:
  DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
- Note: SQL Server requires explicit date construction.

Procedural Language:
- PostgreSQL:
  PL/pgSQL
  RAISE EXCEPTION
  Native array support
- SQL Server:
  T-SQL
  TRY...CATCH
  THROW
  Table-Valued Parameters (TVP) used instead of array parameters
- Migration Decision:
  Used Table-Valued Parameters to replace array-based logic for passing collections to procedures.

Transaction Handling:
- PostgreSQL:
  BEGIN; ... COMMIT;
- SQL Server:
  BEGIN TRAN; ... COMMIT;

  Note: Error handling in SQL Server requires explicit TRY/CATCH blocks for rollback control.

Tooling Differences:
- PostgreSQL:	pg_dump / pg_restore
- SQL Server: SSMS / BACPAC / manual DDL rewrite

Automated migration tools such as DBeaver were insufficient for:
- procedural logic
- triggers
- constraints

Key Migration problems:
- Data types are mostly portable but require explicit mapping.
- Trigger semantics differ significantly.
- NULL handling in UNIQUE constraints requires attention.
- Procedural logic translation is the most migration-sensitive layer.

Why This Matters for Data Engineering?
- Database migration requires:
  understanding engine-specific behavior,
  validating constraints and transactions,
  adapting queries,
  testing data consistency after transformation
