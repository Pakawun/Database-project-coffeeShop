create function get_all_inventory(p_owner_id integer)
    returns TABLE(inventory_id integer, item_name character varying, unit character varying, quantity integer, min_threshold integer, status character varying, type character varying)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
        SELECT
            i.inventory_id,
            i.item_name,
            i.unit,
            i.quantity,
            i.min_threshold,
            i.status,
            i.type
        FROM public.inventory i
        WHERE i.owner_id = p_owner_id
        ORDER BY i.item_name ASC;
END;
$$;

alter function get_all_inventory(integer) owner to coffeedb_zgpm_user;

