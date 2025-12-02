create function get_all_machine(p_owner_id integer) returns SETOF machine
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
        SELECT *
        FROM machine
        WHERE owner_id = p_owner_id;
END;
$$;

alter function get_all_machine(integer) owner to coffeedb_zgpm_user;

