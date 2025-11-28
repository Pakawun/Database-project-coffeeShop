create function add_sale_item(p_receipt_id integer, p_product_id integer, p_quantity integer) returns void
    language plpgsql
as
$$
DECLARE
    v_unit_price NUMERIC;
    v_subtotal NUMERIC;
BEGIN
    SELECT price INTO v_unit_price
    FROM product
    WHERE product_id = p_product_id;

    v_subtotal := v_unit_price * p_quantity;

    INSERT INTO sales_item (
        receipt_id, product_id, quantity, unit_price, subtotal
    )
    VALUES (
               receipt_id, p_product_id, p_quantity, v_unit_price, v_subtotal
           );

END;
$$;

alter function add_sale_item(integer, integer, integer) owner to coffeedb_zgpm_user;
