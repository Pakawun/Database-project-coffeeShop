create function create_empty_sale() returns integer
    language plpgsql
as
$$
DECLARE
    v_receipt_id INTEGER;
BEGIN
    INSERT INTO sales (sale_date)
    VALUES (NOW())
    RETURNING receipt_id INTO v_receipt_id;

    RETURN v_receipt_id;
END;
$$;

alter function create_empty_sale() owner to coffeedb_zgpm_user;

