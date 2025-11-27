create function get_member_information_by_phone(p_phone_number character varying) returns member
    language plpgsql
as
$$
DECLARE
    result member;
BEGIN
    SELECT *
    INTO result
    FROM member
    WHERE mobile = p_phone_number;

    RETURN result;
END;
$$;

alter function get_member_information_by_phone(varchar) owner to coffeedb_zgpm_user;

