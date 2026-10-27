-- Display categories with indentation, preserving parent/child order.
WITH RECURSIVE tree AS (
    SELECT id, name, parent_id, 0 AS depth, ARRAY[id] AS path
    FROM categories
    WHERE parent_id IS NULL

    UNION ALL

    SELECT c.id, c.name, c.parent_id, t.depth + 1, t.path || c.id
    FROM categories AS c
    JOIN tree AS t ON c.parent_id = t.id
    WHERE NOT c.id = ANY(t.path)
)
SELECT repeat('  ', depth) || name AS tree
FROM tree
ORDER BY path;
