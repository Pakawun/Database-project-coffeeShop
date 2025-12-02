create function get_maintenance_by_id(p_owner_id integer, p_maintenance_id integer)
    returns TABLE(maintenance_id integer, machine_name character varying, staff_name character varying, maintenance_date date, action_type character varying, note text)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
        SELECT
            mm.maintenance_id,
            m.machine_name,
            s.staff_name,
            mm.maintenance_date,
            mm.action_type,
            mm.note
        FROM public.machine_maintenance mm
                 JOIN public.machine m ON mm.machine_id = m.machine_id
                 JOIN public.staff s ON mm.staff_id = s.staff_id
        WHERE mm.maintenance_id = p_maintenance_id
          AND mm.owner_id = p_owner_id;
END;
$$;

alter function get_maintenance_by_id(integer, integer) owner to coffeedb_zgpm_user;

