create function book_maintenance(p_owner_id integer, p_machine_id integer, p_staff_id integer, p_maintenance_date date, p_action_type character varying, p_note text) returns integer
    language plpgsql
as
$$
DECLARE
    new_id INT;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM public.machine WHERE machine_id = p_machine_id AND owner_id = p_owner_id) THEN
        RAISE EXCEPTION 'Machine ID % not found for this shop', p_machine_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM public.staff WHERE staff_id = p_staff_id AND owner_id = p_owner_id) THEN
        RAISE EXCEPTION 'Staff ID % not found for this shop', p_staff_id;
    END IF;

    INSERT INTO public.machine_maintenance (
        owner_id, machine_id, staff_id, maintenance_date, action_type, note
    )
    VALUES (
               p_owner_id, p_machine_id, p_staff_id, p_maintenance_date, p_action_type, p_note
           )
    RETURNING maintenance_id INTO new_id;

    RETURN new_id;
END;
$$;

alter function book_maintenance(integer, integer, integer, date, varchar, text) owner to coffeedb_zgpm_user;

