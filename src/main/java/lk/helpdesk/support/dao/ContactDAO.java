package lk.helpdesk.support.dao;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.model.Contact;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContactDAO {
    public void create(String name, String email, String subject, String message) throws SQLException {
        String sql = "INSERT INTO contact_us(name,email,subject,message) VALUES(?,?,?,?)";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, subject);
            ps.setString(4, message);
            ps.executeUpdate();
        }
    }

    public List<Contact> findAll() throws SQLException {
        List<Contact> list = new ArrayList<>();
        String sql = "SELECT id,name,email,subject,message,created_at FROM contact_us ORDER BY created_at DESC";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Contact c = new Contact();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setEmail(rs.getString("email"));
                c.setSubject(rs.getString("subject"));
                c.setMessage(rs.getString("message"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(c);
            }
        }
        return list;
    }
}
