create function mark_staff_attendance(p_staff_id integer, p_shift_id integer, p_check_in time without time zone, p_check_out time without time zone) returns integer
    language plpgsql
as
$$
DECLARE
    new_attendance_id INT;
    planned_start TIME;
    planned_end TIME;
    shift_day DATE;
    final_status VARCHAR(20);
    check_in_ts TIMESTAMP;
    check_out_ts TIMESTAMP;
BEGIN

    SELECT shift_date, start_time, end_time
    INTO shift_day, planned_start, planned_end
    FROM staff_shift
    WHERE shift_id = p_shift_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Shift % does not exist', p_shift_id;
    END IF;

    check_in_ts := shift_day + p_check_in;
    check_out_ts := shift_day + p_check_out;

    final_status := 'present';

    IF p_check_in > planned_start THEN
        final_status := 'late';
    END IF;

    IF p_check_out < planned_end THEN
        IF final_status = 'late' THEN
            final_status := 'late_early';
        ELSE
            final_status := 'early_leave';
        END IF;
    END IF;

    IF p_check_out > planned_end THEN
        IF final_status = 'late' THEN
            final_status := 'late_overtime';
        ELSE
            final_status := 'overtime';
        END IF;
    END IF;

    INSERT INTO staff_attendance (
        staff_id,
        shift_id,
        check_in,
        check_out,
        status
    )
    VALUES (
               p_staff_id,
               p_shift_id,
               check_in_ts,
               check_out_ts,
               final_status
           )
    RETURNING attendance_id INTO new_attendance_id;

    RETURN new_attendance_id;
END;
$$;

alter function mark_staff_attendance(integer, integer, time, time) owner to coffeedb_zgpm_user;

