-- Demonstrate UPDATE and DELETE auditing (student id 3 is a sample row).
UPDATE students SET name = 'Kofi M.' WHERE id = 1;
DELETE FROM students WHERE id = 3;

SELECT tbl, op, old_row->>'name' AS was, new_row->>'name' AS now,
       changed_by, at
FROM audit_log
ORDER BY at DESC, id DESC;

-- Full JSON snapshots:
SELECT id, op, old_row, new_row
FROM audit_log
ORDER BY id DESC;
