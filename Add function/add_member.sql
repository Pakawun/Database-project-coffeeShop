create function add_member(p_name character varying, p_email character varying, p_mobile character varying, p_date_of_birth date, p_started_date date, p_expired_date date, p_points integer DEFAULT 0) returns integer
    language plpgsql
as
$$
DECLARE
    new_member_id INT;
BEGIN
    INSERT INTO member(
        name, email, mobile, date_of_birth, started_date, expired_date, points
    )
    VALUES (
               p_name, p_email, p_mobile, p_date_of_birth, p_started_date, p_expired_date, p_points
           )
    RETURNING member_id INTO new_member_id;

    RETURN new_member_id;
END;
$$;

alter function add_member(varchar, varchar, varchar, date, date, date, integer) owner to coffeedb_zgpm_user;

