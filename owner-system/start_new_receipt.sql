create function start_new_receipt(p_owner_id integer, p_staff_id integer, p_member_id integer, p_coupon_id integer, p_payment_method character varying) returns integer
    language plpgsql
as
$$
DECLARE
    new_receipt_id INTEGER;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM public.staff WHERE staff_id = p_staff_id AND owner_id = p_owner_id) THEN
        RAISE EXCEPTION 'Security Alert: Staff does not belong to this shop.';
    END IF;

    INSERT INTO public.sales (
        owner_id,
        sale_date,
        total_amount,
        member_id,
        staff_id,
        coupon_id,
        payment_method
    )
    VALUES (
               p_owner_id,
               NOW(),
               0.00,
               p_member_id,
               p_staff_id,
               p_coupon_id,
               p_payment_method
           )
    RETURNING receipt_id INTO new_receipt_id;

    RETURN new_receipt_id;
END;
$$;

alter function start_new_receipt(integer, integer, integer, integer, varchar) owner to coffeedb_zgpm_user;

