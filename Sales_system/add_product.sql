create function add_product(p_product_name character varying, p_category character varying, p_price numeric, p_product_type character varying, p_inventory_id integer DEFAULT NULL::integer) returns integer
    language plpgsql
as
$$
DECLARE
    new_id INT;
BEGIN
    IF p_product_type NOT IN ('made_to_order', 'inventory_item') THEN
        RAISE EXCEPTION
            'Invalid product_type: %. Must be made_to_order or inventory_item',
            p_product_type;
    END IF;

    IF p_product_type = 'made_to_order' THEN

        IF p_inventory_id IS NOT NULL THEN
            RAISE EXCEPTION
                'made_to_order products cannot have inventory_id';
        END IF;

        INSERT INTO product (
            product_name,
            category,
            price,
            product_type,
            inventory_id
        )
        VALUES (
                   p_product_name,
                   p_category,
                   p_price,
                   'made_to_order',
                   NULL
               )
        RETURNING product_id INTO new_id;

        -- inventory product: must link to existing inventory row
    ELSIF p_product_type = 'inventory_item' THEN

        IF p_inventory_id IS NULL THEN
            RAISE EXCEPTION
                'inventory_item products must specify inventory_id';
        END IF;

        IF NOT EXISTS (
            SELECT 1 FROM inventory WHERE inventory_id = p_inventory_id
        ) THEN
            RAISE EXCEPTION
                'inventory_id % does not exist in inventory table', p_inventory_id;
        END IF;

        INSERT INTO product (
            product_name,
            category,
            price,
            product_type,
            inventory_id
        )
        VALUES (
                   p_product_name,
                   p_category,
                   p_price,
                   'inventory_item',
                   p_inventory_id
               )
        RETURNING product_id INTO new_id;

    END IF;

    RETURN new_id;
END;
$$;

alter function add_product(varchar, varchar, numeric, varchar, integer) owner to coffeedb_zgpm_user;

