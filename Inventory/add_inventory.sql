create function add_inventory(p_owner_id integer, p_item_name character varying, p_unit character varying, p_quantity integer, p_min_threshold integer, p_status character varying, p_type character varying) returns integer
    language plpgsql
as
$$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO public.inventory(
        owner_id, item_name, unit, quantity, min_threshold, status, type
    )
    VALUES (
               p_owner_id, p_item_name, p_unit, p_quantity, p_min_threshold, p_status, p_type
           )
    RETURNING inventory_id INTO new_id;

    RETURN new_id;
END;
$$;

alter function add_inventory(integer, varchar, varchar, integer, integer, varchar, varchar) owner to coffeedb_zgpm_user;

