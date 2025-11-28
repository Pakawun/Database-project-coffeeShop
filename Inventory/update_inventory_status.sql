create functionupdate_inventory_status() returns void
    language plpgsql
as
$$
BEGIN
    UPDATE inventory
    SET status = CASE
                     WHEN quantity = 0 THEN 'out_of_stock'
                     WHEN quantity < min_threshold THEN 'low_stock'
                     ELSE 'normal'
        END
    WHERE 1 = 1;
END;
$$;

alter function update_inventory_status() owner to coffeedb_zgpm_user;

