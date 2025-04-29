package lk.helpdesk.support.model;

import java.sql.Timestamp;

public class Ticket {
    private int id;
    private String username;
    private String subject;
    private String status;
    private String assignedRole;
    private Timestamp createdAt;

    public Ticket() {
    }

    public Ticket(int id, String username, String subject, String status, String assignedRole, Timestamp createdAt) {
        this.id = id;
        this.username = username;
        this.subject = subject;
        this.status = status;
        this.assignedRole = assignedRole;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }

    public String getSubject() {
        return subject;
    }
    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public String getAssignedRole() {
        return assignedRole;
    }
    public void setAssignedRole(String assignedRole) {
        this.assignedRole = assignedRole;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
