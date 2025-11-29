create function add_sale_item(p_owner_id integer, p_receipt_id integer, p_product_id integer, p_quantity integer) returns void
    language plpgsql
as
$$
DECLARE
    v_unit_price NUMERIC(10,2);
    v_subtotal NUMERIC(10,2);
    v_inventory_id INTEGER;
BEGIN
    SELECT price, inventory_id
    INTO v_unit_price, v_inventory_id
    FROM public.product
    WHERE product_id = p_product_id AND owner_id = p_owner_id;

    IF v_unit_price IS NULL THEN
        RAISE EXCEPTION 'Product not found.';
    END IF;

    v_subtotal := v_unit_price * p_quantity;

    INSERT INTO public.sales_item (
        owner_id, receipt_id, product_id, quantity, unit_price, subtotal
    )
    VALUES (
               p_owner_id, p_receipt_id, p_product_id, p_quantity, v_unit_price, v_subtotal
           );

    UPDATE public.sales
    SET total_amount = total_amount + v_subtotal
    WHERE receipt_id = p_receipt_id;

    IF v_inventory_id IS NOT NULL THEN
        UPDATE public.inventory
        SET quantity = quantity - p_quantity,
            status = CASE WHEN (quantity - p_quantity) < min_threshold THEN 'low_stock' ELSE status END
        WHERE inventory_id = v_inventory_id;

        INSERT INTO public.inventory_log (
            inventory_id, owner_id, action_type, quantity_change, action_date, note
        ) VALUES (
                     v_inventory_id, p_owner_id, 'sale', -p_quantity, NOW(), 'Sold on Receipt #' || p_receipt_id
                 );
    END IF;
END;
$$;

alter function add_sale_item(integer, integer, integer, integer) owner to coffeedb_zgpm_user;

