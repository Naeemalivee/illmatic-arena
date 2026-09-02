CREATE DATABASE illmatic_arena;

USE illmatic_arena;

-- 1. CUSTOMERS AND ADMINS
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(30) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('customer', 'admin') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. ARENA
CREATE TABLE arenas (
    arena_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    location VARCHAR(150) NOT NULL,
    capacity INT NOT NULL,
    number_of_gates INT NOT NULL
);

-- 3. EVENTS
CREATE TABLE events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    arena_id INT NOT NULL,
    event_name VARCHAR(200) NOT NULL,
    event_type VARCHAR(100),
    description TEXT,
    event_date DATE NOT NULL,
    start_time TIME,
    end_time TIME,
    status ENUM('upcoming', 'ongoing', 'completed', 'cancelled')
        DEFAULT 'upcoming',
    FOREIGN KEY (arena_id) REFERENCES arenas(arena_id)
);

-- 4. SECTIONS
CREATE TABLE sections (
    section_id INT AUTO_INCREMENT PRIMARY KEY,
    arena_id INT NOT NULL,
    section_name VARCHAR(100) NOT NULL,
    description TEXT,
    FOREIGN KEY (arena_id) REFERENCES arenas(arena_id)
);

-- 5. SEATS
CREATE TABLE seats (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    section_id INT NOT NULL,
    row_name VARCHAR(20) NOT NULL,
    seat_number INT NOT NULL,
    FOREIGN KEY (section_id) REFERENCES sections(section_id),
    UNIQUE (section_id, row_name, seat_number)
);

-- 6. TICKET CATEGORIES
CREATE TABLE ticket_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- 7. EVENT TICKET TYPES
CREATE TABLE event_tickets (
    event_ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(12,2) NOT NULL,
    quantity_available INT NOT NULL,
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (category_id) REFERENCES ticket_categories(category_id)
);

-- 8. ORDERS
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    order_status ENUM('pending', 'paid', 'cancelled', 'refunded')
        DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (event_id) REFERENCES events(event_id)
);

-- 9. PAYMENTS
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(100) NOT NULL,
    transaction_reference VARCHAR(150),
    amount DECIMAL(12,2) NOT NULL,
    payment_status ENUM('pending', 'successful', 'failed', 'refunded')
        DEFAULT 'pending',
    paid_at TIMESTAMP NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 10. TICKETS
CREATE TABLE tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    event_id INT NOT NULL,
    event_ticket_id INT NOT NULL,
    seat_id INT,
    ticket_code VARCHAR(100) UNIQUE NOT NULL,
    qr_code VARCHAR(255) UNIQUE NOT NULL,
    price DECIMAL(12,2) NOT NULL,
    ticket_status ENUM('valid', 'used', 'cancelled', 'refunded')
        DEFAULT 'valid',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (event_ticket_id) REFERENCES event_tickets(event_ticket_id),
    FOREIGN KEY (seat_id) REFERENCES seats(seat_id)
);

-- 11. ENTRY SCANS
CREATE TABLE entry_scans (
    scan_id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT NOT NULL,
    gate_number INT NOT NULL,
    scanned_by INT,
    scan_result ENUM('approved', 'rejected') NOT NULL,
    scanned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id),
    FOREIGN KEY (scanned_by) REFERENCES users(user_id)
);
