create function start_online_order(p_owner_id integer, p_member_id integer, p_coupon_id integer, p_payment_method character varying) returns integer
    language plpgsql
as
$$
DECLARE
    new_receipt_id INTEGER;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM public.member WHERE member_id = p_member_id AND owner_id = p_owner_id) THEN
        RAISE EXCEPTION 'Security Alert: Member ID % does not belong to Owner %', p_member_id, p_owner_id;
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
               NULL,
               p_coupon_id,
               p_payment_method
           )
    RETURNING receipt_id INTO new_receipt_id;

    RETURN new_receipt_id;
END;
$$;

alter function start_online_order(integer, integer, integer, varchar) owner to coffeedb_zgpm_user;

