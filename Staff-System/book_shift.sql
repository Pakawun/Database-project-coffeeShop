create function book_shift(p_staff_id integer, p_shift_date date, p_start_time time without time zone, p_end_time time without time zone, p_shift_role character varying DEFAULT NULL::character varying, p_status character varying DEFAULT 'scheduled'::character varying) returns integer
    language plpgsql
as
$$
DECLARE
    new_shift_id INT;
BEGIN

    IF NOT EXISTS (
        SELECT 1 FROM staff WHERE staff_id = p_staff_id
    ) THEN
        RAISE EXCEPTION 'Staff ID % does not exist', p_staff_id;
    END IF;

    IF EXISTS (
        SELECT 1
        FROM staff_shift
        WHERE staff_id = p_staff_id
          AND shift_date = p_shift_date
          AND (
            (p_start_time BETWEEN start_time AND end_time)
                OR (p_end_time BETWEEN start_time AND end_time)
                OR (start_time BETWEEN p_start_time AND p_end_time)
            )
    ) THEN
        RAISE EXCEPTION
            'Staff % is already booked for a shift on % between % and %',
            p_staff_id, p_shift_date, p_start_time, p_end_time;
    END IF;

    INSERT INTO staff_shift (
        staff_id,
        shift_date,
        start_time,
        end_time,
        shift_role,
        status
    )
    VALUES (
               p_staff_id,
               p_shift_date,
               p_start_time,
               p_end_time,
               p_shift_role,
               p_status
           )
    RETURNING shift_id INTO new_shift_id;

    RETURN new_shift_id;
END;
$$;

alter function book_shift(integer, date, time, time, varchar, varchar) owner to coffeedb_zgpm_user;

