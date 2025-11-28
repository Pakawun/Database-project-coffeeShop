create function process_sale(p_total_amount numeric, p_member_id integer, p_staff_id integer, p_coupon_id integer, p_payment_method character varying) returns integer
    language plpgsql
as
$$
DECLARE
    v_receipt_id INTEGER;
BEGIN
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
               p_member_id,
               p_staff_id,
               p_coupon_id,
               p_payment_method
           )
    RETURNING receipt_id INTO v_receipt_id;

    RETURN v_receipt_id;
END;
$$;

alter function process_sale(numeric, integer, integer, integer, varchar) owner to coffeedb_zgpm_user;

