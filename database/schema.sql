CREATE DATABASE IF NOT EXISTS ticket_system;
USE ticket_system;

-- users table
CREATE TABLE IF NOT EXISTS users (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    username       VARCHAR(50)   NOT NULL UNIQUE,
    email          VARCHAR(100)  NOT NULL UNIQUE,
    password_hash  VARCHAR(60)   NOT NULL,
    full_name      VARCHAR(100)       DEFAULT NULL,
    phone          VARCHAR(20)        DEFAULT NULL,
    role           ENUM('User','Support','Admin') NOT NULL DEFAULT 'User',
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- user avatars table
CREATE TABLE IF NOT EXISTS user_avatars (
    user_id        INT PRIMARY KEY,
    mime_type      VARCHAR(100)  NOT NULL,
    original_name  VARCHAR(255)  NOT NULL,
    img_blob       LONGBLOB      NOT NULL,
    uploaded_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_avatar_user FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE CASCADE
);

-- tickets table
CREATE TABLE IF NOT EXISTS tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('Open','In_Progress','Resolved','Closed') NOT NULL DEFAULT 'Open',
    assigned_role ENUM('User','Support','Admin') DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ticket messages table
CREATE TABLE IF NOT EXISTS ticket_messages (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  ticket_id    INT NOT NULL,
  sender_id    INT NOT NULL,
  message      TEXT NOT NULL,
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE,
  FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Feedback table
CREATE TABLE feedback (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    message     TEXT      NOT NULL,
    rating      TINYINT   NOT NULL CHECK (rating BETWEEN 1 AND 5),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);