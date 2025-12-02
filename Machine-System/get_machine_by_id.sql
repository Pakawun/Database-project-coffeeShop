create function get_machine_by_id(p_owner_id integer, p_machine_id integer)
    returns TABLE(machine_id integer, machine_name character varying, machine_type character varying, serial_number character varying, status character varying, purchase_date date, warranty_expired_date date)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
        SELECT
            m.machine_id,
            m.machine_name,
            m.machine_type,
            m.serial_number,
            m.status,
            m.purchase_date,
            m.warranty_expired_date
        FROM public.machine m
        WHERE m.machine_id = p_machine_id
          AND m.owner_id = p_owner_id;  
END;
$$;

alter function get_machine_by_id(integer, integer) owner to coffeedb_zgpm_user;

