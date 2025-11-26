create function add_machine(p_machine_name character varying, p_machine_type character varying, p_purchase_date date, p_status character varying) returns integer
    language plpgsql
as
$$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO machine(
        machine_name, machine_type, purchase_date, status
    )
    VALUES (
               p_machine_name, p_machine_type, p_purchase_date, p_status
           )
    RETURNING machine_id INTO new_id;

    RETURN new_id;
END;
$$;

alter function add_machine(varchar, varchar, date, varchar) owner to coffeedb_zgpm_user;

