-- auto-generated definition
create function update_member_status() returns trigger
    language plpgsql
as
$$
BEGIN
    IF NEW.expired_date < CURRENT_DATE THEN
        NEW.status := 'expired';
    ELSE
        NEW.status := 'active';
    END IF;

    NEW.updated_at := NOW();
    RETURN NEW;
END;
$$;

alter function update_member_status() owner to coffeedb_zgpm_user;

