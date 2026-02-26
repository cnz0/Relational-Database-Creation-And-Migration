Example CLI invocation of a stored procedure responsible for scheduled maintenance tasks:
```
@echo off
set PGPASSWORD=password
"psql.exe path" -U username -d database_name -c "CALL archery.sp_nightly_maintenance();" 
```

What this does:
- Connects to PostgreSQL using psql
- Executes stored procedure archery.sp_nightly_maintenance()
- Intended to be scheduled via OS-level task scheduler (e.g. Windows Task Scheduler or cron)

Flags used:
-U - database user
-d - target database
-c - execute single SQL command and exit

Logical backup (pg_dump)
```
pg_dump -U username -F c -d database_name -f archery_backup.dump
```

What this does:
- Creates a snapshot of the database structure and data.

Flags used:
-U - database user
-d - source database
-F c - custom format (compressed, required for pg_restore)
-f - output file

Restore (pg_restore)
```
pg_restore -U username -d target_database_name -c archery_backup.dump
```

What this does:
- Restores schema and data from custom dump
- Can be used for:
- Database recovery
- Migration testing

Flags explained:
-U - database user
-d - target database
-c - clean (drop objects before recreating them)
