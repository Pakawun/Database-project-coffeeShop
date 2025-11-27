create function get_all_products()
    returns TABLE
            (
                product_id       integer,
                product_name     character varying,
                price            numeric,
                inventory_amount integer
            )
    language plpgsql
as
$$
BEGIN
RETURN QUERY
SELECT p.product_id,
       p.product_name,
       p.price,
       i.quantity AS inventory_amount
FROM product p
         LEFT JOIN inventory i ON p.inventory_id = i.inventory_id;
END;
$$;

alter function get_all_products() owner to coffeedb_zgpm_user;

