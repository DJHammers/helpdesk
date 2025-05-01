package lk.helpdesk.support.dao;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.model.User;

import java.io.InputStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    public static final int PAGE_SIZE = 20;
    
    public static class AvatarData {
    public final String mimeType;
    public final byte[] bytes;
    AvatarData(String mimeType, byte[] bytes) {
        this.mimeType = mimeType;
        this.bytes = bytes;
    }
}

public AvatarData loadAvatar(int userId) throws SQLException {
    String sql = "SELECT mime_type, img_blob FROM user_avatars WHERE user_id = ?";
    try (Connection c = DBConfig.getConnection();
         PreparedStatement ps = c.prepareStatement(sql)) {
        ps.setInt(1, userId);
        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) return null;
            String mime  = rs.getString("mime_type");
            byte[] bytes = rs.getBytes("img_blob");
            return new AvatarData(mime, bytes);
        }
    }
}
    
    public User findByUsername(String username) throws SQLException {
        String sql =
            "SELECT id, username, email, password_hash, role, " +
            "       full_name, phone, created_at, updated_at " +
            "FROM users WHERE username = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setRole(rs.getString("role"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                return u;
            }
        }
    }

    public boolean existsByUsernameOrEmail(String username, String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ? OR email = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        }
    }

    public int createUser(String username, String email, String passwordHash, String role) throws SQLException {
        String sql = "INSERT INTO users(username, email, password_hash, role) VALUES (?,?,?,?)";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, passwordHash);
            ps.setString(4, role);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                } else {
                    throw new SQLException("Creating user failed, no ID obtained.");
                }
            }
        }
    }

    public void updateUser(int id, String username, String email, String role, String passwordHashOrNull) throws SQLException {
        StringBuilder sb = new StringBuilder(
            "UPDATE users SET username=?, email=?, role=?"
        );
        if (passwordHashOrNull != null && !passwordHashOrNull.isBlank()) {
            sb.append(", password_hash=?");
        }
        sb.append(" WHERE id=?");
        String sql = sb.toString();

        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setString(idx++, username);
            ps.setString(idx++, email);
            ps.setString(idx++, role);
            if (passwordHashOrNull != null && !passwordHashOrNull.isBlank()) {
                ps.setString(idx++, passwordHashOrNull);
            }
            ps.setInt(idx, id);
            ps.executeUpdate();
        }
    }

    public void saveAvatar(int userId, String mimeType, String originalName, InputStream blobData) throws SQLException {
        String sql =
            "INSERT INTO user_avatars(user_id, mime_type, original_name, img_blob) " +
            "VALUES (?,?,?,?) " +
            "ON DUPLICATE KEY UPDATE mime_type=VALUES(mime_type), " +
            "original_name=VALUES(original_name), img_blob=VALUES(img_blob)";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, mimeType);
            ps.setString(3, originalName);
            ps.setBinaryStream(4, blobData);
            ps.executeUpdate();
        }
    }

    public User findById(int id) throws SQLException {
        String sql =
            "SELECT id, username, email, role, full_name, phone, created_at, updated_at " +
            "FROM users WHERE id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return mapRow(rs);
            }
        }
    }

    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }

    public List<User> findPage(int page) throws SQLException {
        int offset = (page - 1) * PAGE_SIZE;
        String sql =
            "SELECT id, username, email, role, full_name, phone, created_at, updated_at " +
            "FROM users ORDER BY username LIMIT ? OFFSET ?";
        List<User> list = new ArrayList<>();
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, PAGE_SIZE);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setRole(rs.getString("role"));
        u.setFullName(rs.getString("full_name"));
        u.setPhone(rs.getString("phone"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setUpdatedAt(rs.getTimestamp("updated_at"));
        return u;
    }
}
