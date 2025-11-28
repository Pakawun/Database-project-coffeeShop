create function create_owner(p_owner_name character varying, p_shop_name character varying, p_email character varying, p_plain_password character varying) returns integer
    language plpgsql
as
$$
DECLARE
    new_owner_id INTEGER;
BEGIN

    IF EXISTS (SELECT 1 FROM public.owner WHERE email = p_email) THEN
        RAISE EXCEPTION 'Email % is already registered.', p_email;
    END IF;


    INSERT INTO public.owner (
        owner_name,
        shop_name,
        email,
        password_hash,
        status
    )
    VALUES (
               p_owner_name,
               p_shop_name,
               p_email,
               crypt(p_plain_password, gen_salt('bf')),
               'active'
           )
    RETURNING owner_id INTO new_owner_id;

    RETURN new_owner_id;
END;
$$;

alter function create_owner(varchar, varchar, varchar, varchar) owner to coffeedb_zgpm_user;

