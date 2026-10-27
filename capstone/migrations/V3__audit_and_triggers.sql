CREATE OR REPLACE FUNCTION log_expense_change() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 IF TG_OP = 'DELETE' THEN
  INSERT INTO audit_log (tenant_id,table_name,record_id,action,changed_by,old_data)
  VALUES (OLD.tenant_id,TG_TABLE_NAME,OLD.id,TG_OP,current_setting('app.user_id',true),to_jsonb(OLD));
  RETURN OLD;
 ELSIF TG_OP = 'UPDATE' THEN
  NEW.updated_at := now();
  INSERT INTO audit_log (tenant_id,table_name,record_id,action,changed_by,old_data,new_data)
  VALUES (NEW.tenant_id,TG_TABLE_NAME,NEW.id,TG_OP,current_setting('app.user_id',true),to_jsonb(OLD),to_jsonb(NEW));
  RETURN NEW;
 ELSE
  INSERT INTO audit_log (tenant_id,table_name,record_id,action,changed_by,new_data)
  VALUES (NEW.tenant_id,TG_TABLE_NAME,NEW.id,TG_OP,current_setting('app.user_id',true),to_jsonb(NEW));
  RETURN NEW;
 END IF;
END; $$;
CREATE TRIGGER expenses_audit_trigger AFTER INSERT OR UPDATE OR DELETE ON expenses FOR EACH ROW EXECUTE FUNCTION log_expense_change();
-- Runtime application role should not receive UPDATE/DELETE privileges on audit_log.