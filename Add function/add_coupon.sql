create function add_coupon(p_coupon_code character varying, p_discount_value integer, p_valid_from date, p_valid_to date) returns integer
    language plpgsql
as
$$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO coupon(
        coupon_code, discount_value, valid_from, valid_to
    )
    VALUES (
               p_coupon_code, p_discount_value, p_valid_from, p_valid_to
           )
    RETURNING coupon_id INTO new_id;

    RETURN new_id;
END;
$$;

alter function add_coupon(varchar, integer, date, date) owner to coffeedb_zgpm_user;

