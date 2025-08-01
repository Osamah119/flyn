-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Companies Table
CREATE TABLE companies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    registration_number VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Users Table (Employees)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES companies(id),
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- To be securely hashed
    role VARCHAR(50) NOT NULL DEFAULT 'employee', -- e.g., employee, manager, admin
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Departments Table
CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL REFERENCES companies(id),
    name VARCHAR(255) NOT NULL,
    budget NUMERIC(15, 2) DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(company_id, name)
);

-- Virtual Cards Table
CREATE TABLE virtual_cards (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    card_name VARCHAR(255),
    assigned_to_department_id UUID REFERENCES departments(id),
    assigned_to_user_id UUID REFERENCES users(id),
    card_number_hash VARCHAR(255) NOT NULL, -- Store a hash, not the actual number
    cvv_hash VARCHAR(255) NOT NULL,
    expiry_date DATE NOT NULL,
    spending_limit NUMERIC(15, 2) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'active', -- e.g., active, frozen, terminated
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Transactions Table
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    card_id UUID NOT NULL REFERENCES virtual_cards(id),
    amount NUMERIC(15, 2) NOT NULL,
    currency VARCHAR(10) NOT NULL DEFAULT 'SAR',
    merchant_name VARCHAR(255) NOT NULL,
    transaction_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    category VARCHAR(100),
    status VARCHAR(50) NOT NULL -- e.g., pending, completed, failed
);

-- Indexes for performance
CREATE INDEX ON users (company_id);
CREATE INDEX ON departments (company_id);
CREATE INDEX ON virtual_cards (assigned_to_department_id);
CREATE INDEX ON virtual_cards (assigned_to_user_id);
CREATE INDEX ON transactions (card_id);
