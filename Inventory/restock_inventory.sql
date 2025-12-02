create function restock_inventory(p_owner_id integer, p_staff_id integer, p_inventory_id integer, p_quantity integer, p_cost numeric, p_note text) returns boolean
    language plpgsql
as
$$
DECLARE
    v_current_qty INTEGER;
    v_threshold INTEGER;
BEGIN
    IF p_quantity <= 0 THEN
        RAISE EXCEPTION 'Restock quantity must be greater than 0';
    END IF;

    SELECT quantity, min_threshold
    INTO v_current_qty, v_threshold
    FROM public.inventory
    WHERE inventory_id = p_inventory_id
      AND owner_id = p_owner_id;

    IF v_current_qty IS NULL THEN
        RAISE EXCEPTION 'Item not found or access denied.';
    END IF;

    UPDATE public.inventory
    SET
        quantity = quantity + p_quantity,
        status = CASE
                     WHEN (quantity + p_quantity) > min_threshold THEN 'ok'
                     ELSE status
            END
    WHERE inventory_id = p_inventory_id;

    INSERT INTO public.inventory_log (
        inventory_id, owner_id, staff_id, action_type, quantity_change, action_date, note
    )
    VALUES (
               p_inventory_id, p_owner_id, p_staff_id, 'restock', p_quantity, NOW(), p_note
           );

    RETURN TRUE;
END;
$$;

alter function restock_inventory(integer, integer, integer, integer, numeric, text) owner to coffeedb_zgpm_user;

