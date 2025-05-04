package lk.helpdesk.support.dao;

import lk.helpdesk.support.config.DBConfig;

import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

public class DashboardDAO {

    private static final int LEADER_LIMIT = 10;

    public Map<String,Integer> fetchStatusCounts() throws SQLException {
        String sql =
            "SELECT status, COUNT(*) AS cnt " +
            "FROM tickets " +
            "GROUP BY status " +
            "ORDER BY FIELD(status,'Open','In_Progress','Resolved','Closed')";

        Map<String,Integer> out = new LinkedHashMap<>();
        out.put("Open", 0);
        out.put("In_Progress", 0);
        out.put("Resolved", 0);
        out.put("Closed", 0);

        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                out.put(rs.getString("status"), rs.getInt("cnt"));
            }
        }
        return out;
    }

    public Map<String,Integer> fetchTopTicketCreators() throws SQLException {
        String sql =
            "SELECT u.username, COUNT(*) AS cnt " +
            "FROM tickets t JOIN users u ON t.user_id = u.id " +
            "GROUP BY u.id ORDER BY cnt DESC LIMIT " + LEADER_LIMIT;

        return queryPairMap(sql);
    }

    public Map<String,Integer> fetchTopMessageSenders() throws SQLException {
        String sql =
            "SELECT u.username, COUNT(*) AS cnt " +
            "FROM ticket_messages m JOIN users u ON m.sender_id = u.id " +
            "GROUP BY u.id ORDER BY cnt DESC LIMIT " + LEADER_LIMIT;

        return queryPairMap(sql);
    }

    public Map<String,Integer> fetchTopMessagedTickets() throws SQLException {
        String sql =
            "SELECT t.subject, COUNT(*) AS cnt " +
            "FROM ticket_messages m JOIN tickets t ON m.ticket_id = t.id " +
            "GROUP BY t.id ORDER BY cnt DESC LIMIT " + LEADER_LIMIT;

        return queryPairMap(sql);
    }

    private Map<String,Integer> queryPairMap(String sql) throws SQLException {
        Map<String,Integer> out = new LinkedHashMap<>();
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                out.put(rs.getString(1), rs.getInt(2));
            }
        }
        return out;
    }
}
