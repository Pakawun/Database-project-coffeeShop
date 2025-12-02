create function register_business_with_plan(p_owner_name character varying, p_shop_name character varying, p_email character varying, p_plain_password character varying, p_shop_code character varying, p_plan_id integer, p_payment_ref character varying) returns integer
    language plpgsql
as
$$
DECLARE
    v_new_owner_id INTEGER;
    v_plan_days INTEGER;
    v_plan_price NUMERIC;
    v_end_date DATE;
BEGIN
    SELECT duration_days, price
    INTO v_plan_days, v_plan_price
    FROM public.subscription_plan
    WHERE plan_id = p_plan_id;

    IF v_plan_days IS NULL THEN
        RAISE EXCEPTION 'Invalid Plan ID selected.';
    END IF;

    v_end_date := CURRENT_DATE + v_plan_days;

    IF EXISTS (SELECT 1 FROM public.owner WHERE email = p_email) THEN
        RAISE EXCEPTION 'Email % is already registered.', p_email;
    END IF;
    IF EXISTS (SELECT 1 FROM public.owner WHERE shop_code = p_shop_code) THEN
        RAISE EXCEPTION 'Shop Code % is already taken.', p_shop_code;
    END IF;

    INSERT INTO public.owner (
        owner_name,
        shop_name,
        email,
        password_hash,
        shop_code,
        status,
        current_plan_id,
        subscription_end_date
    )
    VALUES (
               p_owner_name,
               p_shop_name,
               p_email,
               crypt(p_plain_password, gen_salt('bf')),
               p_shop_code,
               'active',
               p_plan_id,
               v_end_date
           )
    RETURNING owner_id INTO v_new_owner_id;

    INSERT INTO public.owner_payment_log (
        owner_id, plan_id, amount_paid, payment_ref, new_end_date
    )
    VALUES (
               v_new_owner_id, p_plan_id, v_plan_price, p_payment_ref, v_end_date
           );

    RETURN v_new_owner_id;
END;
$$;

alter function register_business_with_plan(varchar, varchar, varchar, varchar, varchar, integer, varchar) owner to coffeedb_zgpm_user;

