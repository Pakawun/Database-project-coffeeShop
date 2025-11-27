create function get_machine_maintenance_info()
    returns TABLE(machine_name character varying, maintenance_date date, staff_name character varying, machine_status character varying)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
        SELECT m.machine_name,
               mm.maintenance_date,
               s.staff_name,
               m.status AS machine_status
        FROM machine_maintenance mm
                 JOIN machine m ON mm.machine_id = m.machine_id
                 JOIN staff s ON mm.staff_id = s.staff_id
        ORDER BY mm.maintenance_date DESC;
END;
$$;

alter function get_machine_maintenance_info() owner to coffeedb_zgpm_user;

