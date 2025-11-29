create function add_staff(p_owner_id integer, p_staff_name character varying, p_role character varying, p_email character varying, p_phone character varying, p_hire_date date, p_salary numeric, p_status character varying) returns integer
    language plpgsql
as
$$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO public.staff (
        owner_id, staff_name, role, email, phone, hire_date, salary, status
    )
    VALUES (
               p_owner_id, p_staff_name, p_role, p_email, p_phone, p_hire_date, p_salary, p_status
           )
    RETURNING staff_id INTO new_id;

    RETURN new_id;
END;
$$;

alter function add_staff(integer, varchar, varchar, varchar, varchar, date, numeric, varchar) owner to coffeedb_zgpm_user;

