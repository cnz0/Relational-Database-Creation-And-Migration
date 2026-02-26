CREATE TABLE "mytable" (
  "CREATE INDEX idx_payments_status_date" text
);

INSERT INTO "mytable" ("CREATE INDEX idx_payments_status_date")
VALUES
('ON dbo.payments (status_id'),
('select * from sys.indexes');
