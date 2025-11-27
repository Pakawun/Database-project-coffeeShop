create function get_staff_shift_by_id(p_staff_id integer) returns staff_shift
    language plpgsql
as
$$
DECLARE
    result staff_shift;
BEGIN
    SELECT *
    INTO result
    FROM staff_shift
    WHERE staff_id = p_staff_id;

    RETURN result;
END;
$$;

alter function get_staff_shift_by_id(integer) owner to coffeedb_zgpm_user;

