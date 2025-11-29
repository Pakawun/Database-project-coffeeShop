create function customer_login(p_owner_id integer, p_username character varying, p_plain_password character varying)
    returns TABLE(user_id integer, customer_name character varying, email character varying, mobile character varying, is_member boolean, member_id integer)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
        SELECT
            cu.user_id,
            cu.customer_name,
            cu.email,
            cu.mobile,
            cu.is_member,
            cu.member_id
        FROM public.customer_user cu
        WHERE cu.owner_id = p_owner_id
          AND cu.username = p_username
          AND cu.password_hash = crypt(p_plain_password, cu.password_hash);
END;
$$;

alter function customer_login(integer, varchar, varchar) owner to coffeedb_zgpm_user;

