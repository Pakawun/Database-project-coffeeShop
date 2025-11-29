create function login_owner(p_email character varying, p_plain_password character varying)
    returns TABLE(match_owner_id integer, match_shop_name character varying, match_owner_name character varying)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
        SELECT
            owner_id,
            shop_name,
            owner_name
        FROM public.owner
        WHERE email = p_email
          AND password_hash = crypt(p_plain_password, password_hash);
END;
$$;

alter function login_owner(varchar, varchar) owner to coffeedb_zgpm_user;

