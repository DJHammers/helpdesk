package lk.helpdesk.support.dao;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.model.TicketMessage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TicketMessageDAO {
    public List<TicketMessage> findByTicket(int ticketId) throws SQLException {
        String sql =
          "SELECT m.id,m.ticket_id,m.sender_id,u.username,u.role AS sender_role," +
          "m.message,m.created_at " +
          "FROM ticket_messages m " +
          "JOIN users u ON m.sender_id=u.id " +
          "WHERE m.ticket_id=? ORDER BY m.created_at DESC";
        List<TicketMessage> list = new ArrayList<>();
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TicketMessage m = new TicketMessage();
                    m.setId(rs.getInt("id"));
                    m.setTicketId(rs.getInt("ticket_id"));
                    m.setSenderId(rs.getInt("sender_id"));
                    m.setSenderUsername(rs.getString("username"));
                    m.setSenderRole(rs.getString("sender_role"));
                    m.setMessage(rs.getString("message"));
                    m.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(m);
                }
            }
        }
        return list;
    }

    public void create(int ticketId, int senderId, String message) throws SQLException {
        String sql = "INSERT INTO ticket_messages(ticket_id, sender_id, message) VALUES (?,?,?)";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            ps.setInt(2, senderId);
            ps.setString(3, message);
            ps.executeUpdate();
        }
    }
}
