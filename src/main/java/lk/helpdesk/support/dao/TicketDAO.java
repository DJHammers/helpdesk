package lk.helpdesk.support.dao;

import lk.helpdesk.support.config.DBConfig;
import lk.helpdesk.support.model.Ticket;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TicketDAO {
    public static final int PAGE_SIZE = 20;

    public int countAll(Integer userId, String role, String statusFilter) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM tickets t");
        List<Object> params = new ArrayList<>();
        boolean where = false;

        if (!"Admin".equals(role) && !"Support".equals(role)) {
            sql.append(" WHERE t.user_id = ?");
            params.add(userId);
            where = true;
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(where ? " AND " : " WHERE ");
            if (statusFilter.startsWith("ASSIGNED_")) {
                sql.append("t.assigned_role = ?");
                params.add(statusFilter.substring(9));
            } else {
                sql.append("t.status = ?");
                params.add(statusFilter);
            }
        }

        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1);
            }
        }
    }

    public List<Ticket> findPage(Integer userId, String role, String statusFilter, int page) throws SQLException {
        int offset = (page - 1) * PAGE_SIZE;
        StringBuilder sql = new StringBuilder(
            "SELECT t.id, t.user_id, u.username, t.subject, t.status, t.assigned_role, t.created_at " +
            "FROM tickets t JOIN users u ON t.user_id = u.id");
        List<Object> params = new ArrayList<>();
        boolean where = false;

        if (!"Admin".equals(role) && !"Support".equals(role)) {
            sql.append(" WHERE t.user_id = ?");
            params.add(userId);
            where = true;
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(where ? " AND " : " WHERE ");
            if (statusFilter.startsWith("ASSIGNED_")) {
                sql.append("t.assigned_role = ?");
                params.add(statusFilter.substring(9));
            } else {
                sql.append("t.status = ?");
                params.add(statusFilter);
            }
        }

        sql.append(" ORDER BY t.created_at DESC LIMIT ? OFFSET ?");
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Object o : params) {
                ps.setObject(idx++, o);
            }
            ps.setInt(idx++, PAGE_SIZE);
            ps.setInt(idx, offset);

            List<Ticket> list = new ArrayList<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ticket t = new Ticket();
                    t.setId(rs.getInt("id"));
                    t.setUserId(rs.getInt("user_id"));
                    t.setUsername(rs.getString("username"));
                    t.setSubject(rs.getString("subject"));
                    t.setStatus(rs.getString("status"));
                    t.setAssignedRole(rs.getString("assigned_role"));
                    t.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(t);
                }
            }
            return list;
        }
    }

    public void create(int userId, String subject, String description) throws SQLException {
        String sql = "INSERT INTO tickets(user_id, subject, description) VALUES (?,?,?)";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, subject);
            ps.setString(3, description);
            ps.executeUpdate();
        }
    }

    public Ticket findById(int ticketId) throws SQLException {
        String sql = "SELECT subject,status,assigned_role FROM tickets WHERE id=?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                Ticket t = new Ticket();
                t.setId(ticketId);
                t.setSubject(rs.getString("subject"));
                t.setStatus(rs.getString("status"));
                t.setAssignedRole(rs.getString("assigned_role"));
                return t;
            }
        }
    }

    public void updateStatus(int ticketId, String status) throws SQLException {
        String sql = "UPDATE tickets SET status = ? WHERE id = ?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, ticketId);
            ps.executeUpdate();
        }
    }

    public void assign(int ticketId, String role) throws SQLException {
        String sql = "UPDATE tickets SET assigned_role=? WHERE id=?";
        try (Connection c = DBConfig.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, role);
            ps.setInt(2, ticketId);
            ps.executeUpdate();
        }
    }
}
