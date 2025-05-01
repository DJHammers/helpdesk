package lk.helpdesk.support.dao;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.model.Feedback;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    public static final int PAGE_SIZE = 20;

    public int countAll() throws SQLException {
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM feedback");
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }

    public List<Feedback> findPage(int page) throws SQLException {
        int offset = (page - 1) * PAGE_SIZE;
        String sql =
          "SELECT f.id,f.user_id,u.username,f.message,f.rating,f.created_at " +
          "FROM feedback f JOIN users u ON f.user_id=u.id " +
          "ORDER BY f.created_at DESC LIMIT ? OFFSET ?";
        List<Feedback> list = new ArrayList<>();
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, PAGE_SIZE);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback fb = new Feedback();
                    fb.setId(rs.getInt("id"));
                    fb.setUserId(rs.getInt("user_id"));
                    fb.setUsername(rs.getString("username"));
                    fb.setMessage(rs.getString("message"));
                    fb.setRating(rs.getInt("rating"));
                    fb.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(fb);
                }
            }
        }
        return list;
    }

    public void create(int userId, String message, int rating) throws SQLException {
        String sql = "INSERT INTO feedback(user_id, message, rating) VALUES (?,?,?)";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, message);
            ps.setInt(3, rating);
            ps.executeUpdate();
        }
    }
}
