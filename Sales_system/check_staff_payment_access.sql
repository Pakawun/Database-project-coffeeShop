create function check_staff_payment_access(p_owner_id integer, p_staff_id integer) returns boolean
    language plpgsql
as
$$
DECLARE
    v_role VARCHAR;
BEGIN
    SELECT role INTO v_role
    FROM public.staff
    WHERE staff_id = p_staff_id
      AND owner_id = p_owner_id;

    IF v_role IS NULL THEN
        RETURN FALSE;
    END IF;


    IF v_role IN ('Cashier', 'Manager') THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;

alter function check_staff_payment_access(integer, integer) owner to coffeedb_zgpm_user;

