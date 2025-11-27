create function get_all_machine() returns SETOF machine
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
        SELECT *
        FROM machine;
END;
$$;

alter function get_all_machine() owner to coffeedb_zgpm_user;

