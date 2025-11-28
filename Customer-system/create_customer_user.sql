create function create_customer_user(p_owner_id integer, p_name character varying, p_email character varying, p_mobile character varying, p_username character varying, p_plain_password character varying) returns integer
    language plpgsql
as
$$
DECLARE
    new_member_id INTEGER;
    new_user_id INTEGER;
BEGIN

    IF EXISTS (SELECT 1 FROM public.customer_user WHERE username = p_username AND owner_id = p_owner_id) THEN
        RAISE EXCEPTION 'Username % is already taken at this shop.', p_username;
    END IF;

    IF EXISTS (SELECT 1 FROM public.member WHERE email = p_email AND owner_id = p_owner_id) THEN
        RAISE EXCEPTION 'Member with email % already exists at this shop.', p_email;
    END IF;

    INSERT INTO public.member (
        owner_id,
        name,
        email,
        mobile,
        status,
        started_date,
        points
    )
    VALUES (
               p_owner_id,
               p_name,
               p_email,
               p_mobile,
               'active',
               CURRENT_DATE,
               0
           )
    RETURNING member_id INTO new_member_id;


    INSERT INTO public.customer_user (
        owner_id,
        member_id,
        username,
        password_hash
    )
    VALUES (
               p_owner_id,
               new_member_id,
               p_username,
               crypt(p_plain_password, gen_salt('bf'))
           )
    RETURNING user_id INTO new_user_id;


    RETURN new_user_id;

END;
$$;

alter function create_customer_user(integer, varchar, varchar, varchar, varchar, varchar) owner to coffeedb_zgpm_user;

