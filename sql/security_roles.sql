-- OPTIONAL: run as a database administrator in the bootcamp database.
-- Roles are NOLOGIN; this avoids committing any password.
-- If these roles already exist, inspect them instead of rerunning CREATE ROLE.
CREATE ROLE app_read NOLOGIN;
CREATE ROLE app_write NOLOGIN;

GRANT CONNECT ON DATABASE bootcamp TO app_read, app_write;
GRANT USAGE ON SCHEMA public TO app_read, app_write;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_read;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_write;

-- Default privileges apply to future tables created by the current role.
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT ON TABLES TO app_read;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_write;

-- Optional login: uncomment only after replacing the placeholder locally.
-- CREATE ROLE api LOGIN PASSWORD 'REPLACE_WITH_A_STRONG_SECRET';
-- GRANT app_write TO api;

-- app_write should not own tables and must not be a superuser.
