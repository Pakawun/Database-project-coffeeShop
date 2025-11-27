create function add_machine(p_machine_name character varying, p_machine_type character varying, p_purchase_date date, p_status character varying, p_serial_number character varying, p_warranty_expired_date date) returns integer
    language plpgsql
as
$$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO machine (
        machine_type,
        purchase_date,
        status,
        warranty_expired_date,
        serial_number,
        machine_name
    )
    VALUES (
               p_machine_type,
               p_purchase_date,
               p_status,
               p_warranty_expired_date,
               p_serial_number,
               p_machine_name
           )
    RETURNING machine_id INTO new_id;

    RETURN new_id;
END;
$$;

alter function add_machine(varchar, varchar, date, varchar, varchar, date) owner to coffeedb_zgpm_user;

