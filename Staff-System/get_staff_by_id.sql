create function get_staff_by_id(p_staff_id integer) returns staff
    language plpgsql
as
$$
DECLARE
    result staff;
BEGIN
    SELECT *
    INTO result
    FROM staff
    WHERE staff_id = p_staff_id;

    RETURN result;
END;
$$;

alter function get_staff_by_id(integer) owner to coffeedb_zgpm_user;

