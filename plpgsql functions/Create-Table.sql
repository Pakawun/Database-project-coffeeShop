CREATE TABLE member
(
    member_id     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name          VARCHAR(100),
    email         VARCHAR(100) UNIQUE,
    mobile        VARCHAR(20),
    date_of_birth DATE,
    started_date  DATE,
    expired_date  DATE,
    points        INT DEFAULT 0
);

CREATE TABLE customer
(
    customer_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_type VARCHAR(20),
    member_id     INT,
    CONSTRAINT fk_customer_member
        FOREIGN KEY (member_id)
            REFERENCES member (member_id)
);

CREATE TABLE staff
(
    staff_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    staff_name VARCHAR(100),
    role       VARCHAR(50),
    email      VARCHAR(100),
    phone      VARCHAR(20),
    hire_date  DATE,
    salary     NUMERIC(10, 2),
    status     VARCHAR(20),
    shift_type VARCHAR(20)
);
CREATE TABLE coupon
(
    coupon_id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    coupon_code    VARCHAR(50) UNIQUE,
    discount_value INT,
    valid_from     DATE,
    valid_to       DATE
);

CREATE TABLE sales
(
    sale_id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sale_date    TIMESTAMP,
    total_amount NUMERIC(10, 2),
    customer_id  INT,
    staff_id     INT,
    coupon_id    INT,
    CONSTRAINT fk_sales_customer
        FOREIGN KEY (customer_id) REFERENCES customer (customer_id),
    CONSTRAINT fk_sales_staff
        FOREIGN KEY (staff_id) REFERENCES staff (staff_id),
    CONSTRAINT fk_sales_coupon
        FOREIGN KEY (coupon_id) REFERENCES coupon (coupon_id)
);

CREATE TABLE product
(
    product_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_name VARCHAR(100),
    category     VARCHAR(50),
    price        NUMERIC(10, 2),
    stock_qty    INT
);

CREATE TABLE sales_item
(
    sale_item_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sale_id      INT,
    product_id   INT,
    quantity     INT,
    unit_price   NUMERIC(10, 2),
    subtotal     NUMERIC(10, 2),
    CONSTRAINT fk_item_sale
        FOREIGN KEY (sale_id) REFERENCES sales (sale_id),
    CONSTRAINT fk_item_product
        FOREIGN KEY (product_id) REFERENCES product (product_id)
);
CREATE TABLE inventory
(
    inventory_id  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    item_name     VARCHAR(100),
    unit          VARCHAR(20),
    quantity      INT,
    min_threshold INT,
    status        VARCHAR(20),
    type          VARCHAR(50)
);

CREATE TABLE inventory_log
(
    log_id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    inventory_id    INT,
    action_type     VARCHAR(50),
    quantity_change INT,
    action_date     TIMESTAMP,
    staff_id        INT,
    note            TEXT,
    CONSTRAINT fk_log_inventory
        FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id),
    CONSTRAINT fk_log_staff
        FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);

CREATE TABLE machine
(
    machine_id    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    machine_name  VARCHAR(100),
    machine_type  VARCHAR(50),
    purchase_date DATE,
    status        VARCHAR(50),
    location      VARCHAR(100)
);
CREATE TABLE machine_maintenance
(
    maintenance_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    machine_id       INT,
    staff_id         INT,
    maintenance_date DATE,
    action_type      VARCHAR(100),
    note             TEXT,
    CONSTRAINT fk_maint_machine
        FOREIGN KEY (machine_id) REFERENCES machine (machine_id),
    CONSTRAINT fk_maint_staff
        FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);

CREATE TABLE staff_shift
(
    shift_id   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    staff_id   INT,
    shift_date DATE,
    start_time TIME,
    end_time   TIME,
    shift_role VARCHAR(50),
    status     VARCHAR(20),
    CONSTRAINT fk_shift_staff
        FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);

CREATE TABLE staff_attendance
(
    attendance_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    staff_id      INT,
    check_in      TIMESTAMP,
    check_out     TIMESTAMP,
    status        VARCHAR(20),
    CONSTRAINT fk_att_staff
        FOREIGN KEY (staff_id) REFERENCES staff (staff_id)
);
