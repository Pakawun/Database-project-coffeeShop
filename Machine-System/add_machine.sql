create function add_machine(p_owner_id integer, p_machine_name character varying, p_machine_type character varying, p_purchase_date date, p_status character varying, p_serial_number character varying, p_warranty_expired_date date) returns integer
    language plpgsql
as
$$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO public.machine (
        owner_id, machine_name, machine_type, purchase_date, status, serial_number, warranty_expired_date
    )
    VALUES (
               p_owner_id, p_machine_name, p_machine_type, p_purchase_date, p_status, p_serial_number, p_warranty_expired_date
           )
    RETURNING machine_id INTO new_id;

    RETURN new_id;
END;
$$;

alter function add_machine(integer, varchar, varchar, date, varchar, varchar, date) owner to coffeedb_zgpm_user;

