create function process_sale_with_phone(p_phone character varying, p_total_amount numeric, p_staff_id integer, p_coupon_id integer, p_payment_method character varying) returns integer
    language plpgsql
as
$$
DECLARE
    v_member_id INTEGER;
    v_receipt_id INTEGER;
BEGIN
    SELECT member_id
    INTO v_member_id
    FROM member
    WHERE mobile = p_phone;

    IF NOT FOUND THEN
        v_member_id := NULL;
    END IF;

    INSERT INTO sales (
        sale_date,
        total_amount,
        member_id,
        staff_id,
        coupon_id,
        payment_method
    )
    VALUES (
               NOW(),
               p_total_amount,
               v_member_id,
               p_staff_id,
               p_coupon_id,
               p_payment_method
           )
    RETURNING receipt_id INTO v_receipt_id;

    RETURN v_receipt_id;
END;
$$;

alter function process_sale_with_phone(varchar, numeric, integer, integer, varchar) owner to coffeedb_zgpm_user;

