
CREATE TABLE category (
    category_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_id BIGSERIAL REFERENCES category(category_id),
    description VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);


CREATE TABLE users (
    user_id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    employee_status VARCHAR(100),
    income_bracket VARCHAR(50),
    profile_pic BYTEA,
    gender VARCHAR(10),
    age VARCHAR(10),
    phone_number VARCHAR(15),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);


CREATE TABLE questions (
    question_id BIGSERIAL PRIMARY KEY,
    question_description VARCHAR(100) NOT NULL,
    question_code VARCHAR(20)
);


CREATE TABLE product (
    product_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    image_url TEXT,
    company_id BIGINT NOT NULL REFERENCES company(company_id),
    category_id BIGINT NOT NULL REFERENCES category(category_id)
);


CREATE TABLE company (
    company_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    country VARCHAR(100) DEFAULT 'INDIA',
    sector VARCHAR(100),
    parent_category BIGINT REFERENCES category(category_id)
);

