create function add_staff(p_staff_name character varying, p_role character varying, p_email character varying, p_phone character varying, p_hire_date date, p_salary numeric, p_status character varying, p_working_slot character varying) returns integer
    language plpgsql
as
$$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO staff (
        staff_name,
        role,
        email,
        phone,
        hire_date,
        salary,
        status,
        working_slot
    )
    VALUES (
               p_staff_name,
               p_role,
               p_email,
               p_phone,
               p_hire_date,
               p_salary,
               p_status,
               working_slot
           )
    RETURNING staff_id INTO new_id;

    RETURN new_id;
END;
$$;

alter function add_staff(varchar, varchar, varchar, varchar, date, numeric, varchar, varchar) owner to coffeedb_zgpm_user;

