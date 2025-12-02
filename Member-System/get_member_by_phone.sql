create function get_member_by_phone(p_owner_id integer, p_phone character varying) returns member
    language plpgsql
as
$$
DECLARE
    result public.member;
BEGIN
    SELECT *
    INTO result
    FROM public.member
    WHERE mobile = p_phone
      AND owner_id = p_owner_id;

    IF NOT FOUND THEN
        RETURN NULL;
    END IF;

    RETURN result;
END;
$$;

alter function get_member_by_phone(integer, varchar) owner to coffeedb_zgpm_user;

