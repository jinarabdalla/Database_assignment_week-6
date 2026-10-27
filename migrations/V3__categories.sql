-- V3: Hierarchical categories.
CREATE TABLE categories (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    parent_id BIGINT REFERENCES categories(id) ON DELETE RESTRICT,
    CONSTRAINT categories_no_self_parent
        CHECK (parent_id IS NULL OR parent_id <> id)
);

CREATE INDEX idx_categories_parent_id ON categories(parent_id);

INSERT INTO categories (name, parent_id) VALUES
    ('Electronics', NULL),
    ('Computers', 1),
    ('Laptops', 2),
    ('Phones', 1);
