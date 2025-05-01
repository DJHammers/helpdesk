package lk.helpdesk.support.dao;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.model.User;

import java.io.InputStream;
import java.sql.*;

public class ProfileDAO {

    public User findById(int userId) throws SQLException {
        String sql = "SELECT id, username, email, full_name, phone FROM users WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                return u;
            }
        }
    }

    public boolean hasAvatar(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM user_avatars WHERE user_id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        }
    }

    public void saveAvatar(int userId, String mimeType, String originalName, InputStream blobIn) throws SQLException {
        String del = "DELETE FROM user_avatars WHERE user_id = ?";
        String ins = "INSERT INTO user_avatars(user_id, mime_type, original_name, img_blob) VALUES (?, ?, ?, ?)";
        try (Connection c = DBConfig.getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement pd = c.prepareStatement(del)) {
                pd.setInt(1, userId);
                pd.executeUpdate();
            }
            try (PreparedStatement pi = c.prepareStatement(ins)) {
                pi.setInt(1, userId);
                pi.setString(2, mimeType);
                pi.setString(3, originalName);
                pi.setBlob(4, blobIn);
                pi.executeUpdate();
            }
            c.commit();
        }
    }

    public void updateProfile(int userId, String email, String fullName, String phone, String pwHashOrNull) throws SQLException {
        StringBuilder sb = new StringBuilder(
            "UPDATE users SET email = ?, full_name = ?, phone = ?"
        );
        if (pwHashOrNull != null) {
            sb.append(", password_hash = ?");
        }
        sb.append(" WHERE id = ?");

        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sb.toString())) {

            int idx = 1;
            ps.setString(idx++, email);
            ps.setString(idx++, fullName);
            ps.setString(idx++, phone);

            if (pwHashOrNull != null) {
                ps.setString(idx++, pwHashOrNull);
            }

            ps.setInt(idx, userId);
            ps.executeUpdate();
        }
    }
}
