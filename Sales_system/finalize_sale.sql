create function finalize_sale(p_phone character varying, p_total_amount numeric, p_staff_id integer, p_coupon_code character varying, p_payment_method character varying) returns integer
    language plpgsql
as
$$
DECLARE
    v_member_id INTEGER;
    v_coupon_id INTEGER;
    v_receipt_id INTEGER;
BEGIN

    SELECT member_id INTO v_member_id
    FROM member
    WHERE mobile = p_phone;

    IF NOT FOUND THEN
        v_member_id := NULL;
    END IF;


    IF p_coupon_code IS NOT NULL THEN
        SELECT coupon_id INTO v_coupon_id
        FROM coupon
        WHERE coupon_code = p_coupon_code;

        IF NOT FOUND THEN
            v_coupon_id := NULL;
        END IF;
    ELSE
        v_coupon_id := NULL;
    END IF;

    UPDATE sales
    SET
        total_amount   = p_total_amount,
        member_id      = v_member_id,
        staff_id       = p_staff_id,
        coupon_id      = v_coupon_id,
        payment_method = p_payment_method
    WHERE receipt_id = (
        SELECT MAX(receipt_id) FROM sales
    )
    RETURNING receipt_id INTO v_receipt_id;


    PERFORM update_inventory_status();

    RETURN v_receipt_id;
END;
$$;

alter function finalize_sale(varchar, numeric, integer, varchar, varchar) owner to coffeedb_zgpm_user;

