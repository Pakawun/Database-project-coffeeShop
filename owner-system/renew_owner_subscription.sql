create function renew_owner_subscription(p_owner_id integer, p_plan_id integer, p_payment_reference character varying) returns date
    language plpgsql
as
$$
DECLARE
    v_days INTEGER;
    v_price NUMERIC;
    v_current_end DATE;
    v_new_end DATE;
BEGIN
    SELECT duration_days, price
    INTO v_days, v_price
    FROM public.subscription_plan
    WHERE plan_id = p_plan_id;

    IF v_days IS NULL THEN
        RAISE EXCEPTION 'Invalid Plan ID';
    END IF;

    SELECT subscription_end_date INTO v_current_end
    FROM public.owner
    WHERE owner_id = p_owner_id;

    IF v_current_end IS NULL OR v_current_end < CURRENT_DATE THEN
        v_new_end := CURRENT_DATE + v_days;
    ELSE
        v_new_end := v_current_end + v_days;
    END IF;

    UPDATE public.owner
    SET subscription_end_date = v_new_end,
        current_plan_id = p_plan_id,
        status = 'active'
    WHERE owner_id = p_owner_id;

    INSERT INTO public.owner_payment_log (
        owner_id, plan_id, amount_paid, payment_ref, new_end_date
    )
    VALUES (
               p_owner_id, p_plan_id, v_price, p_payment_reference, v_new_end
           );

    RETURN v_new_end;
END;
$$;

alter function renew_owner_subscription(integer, integer, varchar) owner to coffeedb_zgpm_user;

