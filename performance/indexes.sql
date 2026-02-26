CREATE TABLE "mytable" (
  "------------------Indeksy-------------------" text
);

INSERT INTO "mytable" ("------------------Indeksy-------------------")
VALUES
('------------------Drop indeksów + reset-------------------'),
('DO $$'),
('DECLARE r record;'),
('BEGIN'),
('FOR r IN'),
('SELECT schemaname'),
('FROM pg_indexes'),
('WHERE schemaname = ''archery'''),
('AND indexname LIKE ''idx_%'''),
('LOOP'),
('EXECUTE format(''DROP INDEX IF EXISTS %I.%I;'''),
('END LOOP;'),
('END $$;'),
('VACUUM ANALYZE;'),
('------------------Indeksy proste-------------------'),
('CREATE INDEX IF NOT EXISTS idx_payments_status ON archery.payments(status_id);'),
('CREATE INDEX IF NOT EXISTS idx_payments_date   ON archery.payments(p_date);'),
('------------------Indeks kompozytowy z powyższych prostych-------------------'),
('CREATE INDEX idx_payments_status_date ON archery.payments(status_id');
