package lk.helpdesk.support.dao;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.model.Contact;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactDAO {
    public static final int PAGE_SIZE = 50;

    public void create(String name, String email, String subject, String message) throws SQLException {
        String sql = "INSERT INTO contact_us (name, email, subject, message) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, subject);
            ps.setString(4, message);
            ps.executeUpdate();
        }
    }

    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM contact_us";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public List<Contact> findPage(int page) throws SQLException {
        List<Contact> list = new ArrayList<>();
        String sql = "SELECT id, name, email, subject, message, created_at "
                   + "FROM contact_us ORDER BY created_at DESC "
                   + "LIMIT ? OFFSET ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, PAGE_SIZE);
            ps.setInt(2, (page - 1) * PAGE_SIZE);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public Contact findById(int id) throws SQLException {
        String sql = "SELECT id, name, email, subject, message, created_at "
                   + "FROM contact_us WHERE id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    private Contact mapRow(ResultSet rs) throws SQLException {
        Contact c = new Contact();
        c.setId(      rs.getInt("id"));
        c.setName(    rs.getString("name"));
        c.setEmail(   rs.getString("email"));
        c.setSubject( rs.getString("subject"));
        c.setMessage( rs.getString("message"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            c.setCreatedAt(ts);
        }
        return c;
    }
}
