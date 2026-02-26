CREATE TABLE "mytable" (
  "------------------Zmodyfikowane zapytanie do testów-------------------" text
);

INSERT INTO "mytable" ("------------------Zmodyfikowane zapytanie do testów-------------------")
VALUES
('EXPLAIN (ANALYZE'),
('WITH paid AS ('),
('SELECT p.payment_id'),
('FROM archery.payments p'),
('WHERE p.status_id = (SELECT status_id FROM archery.payment_statuses WHERE name=''paid'')'),
('AND p.p_date BETWEEN now() - interval ''365 days'' AND now()'),
(')'),
('SELECT tf.f_name'),
('FROM paid p'),
('JOIN archery.bookings b ON b.booking_id = p.booking_id'),
('JOIN archery.sessions s ON s.session_id = b.session_id'),
('JOIN archery.training_fields tf ON tf.field_id = s.field_id'),
('ORDER BY s.s_starts_at DESC');
