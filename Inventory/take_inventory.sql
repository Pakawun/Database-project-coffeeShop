create function take_inventory(p_owner_id integer, p_staff_id integer, p_inventory_id integer, p_quantity integer, p_reason character varying, p_note text) returns boolean
    language plpgsql
as
$$
DECLARE
    current_qty INTEGER;
    threshold_qty INTEGER;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM staff WHERE staff_id = p_staff_id AND owner_id = p_owner_id) THEN
        RAISE EXCEPTION 'Security Alert: Staff ID % does not belong to Owner %', p_staff_id, p_owner_id;
    END IF;

    SELECT quantity, min_threshold
    INTO current_qty, threshold_qty
    FROM public.inventory
    WHERE inventory_id = p_inventory_id AND owner_id = p_owner_id;

    IF current_qty IS NULL THEN
        RAISE EXCEPTION 'Item not found or access denied.';
    END IF;

    IF current_qty < p_quantity THEN
        RAISE EXCEPTION 'Insufficient Stock. You have %, but tried to take %.', current_qty, p_quantity;
    END IF;


    UPDATE inventory
    SET quantity = quantity - p_quantity,
        status = CASE
                     WHEN (quantity - p_quantity) <= min_threshold THEN 'low_stock'
                     ELSE status
            END
    WHERE inventory_id = p_inventory_id;

    INSERT INTO inventory_log (
        inventory_id,
        owner_id,
        staff_id,
        action_type,
        quantity_change,
        action_date,
        note
    )
    VALUES (
               p_inventory_id,
               p_owner_id,
               p_staff_id,
               p_reason,
               -p_quantity,
               NOW(),
               p_note
           );

    RETURN TRUE;
END;
$$;

alter function take_inventory(integer, integer, integer, integer, varchar, text) owner to coffeedb_zgpm_user;

