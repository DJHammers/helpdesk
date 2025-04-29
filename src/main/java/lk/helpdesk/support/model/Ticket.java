package lk.helpdesk.support.model;

import java.sql.Timestamp;

public class Ticket {
    private int id;
    private String username;
    private String subject;
    private String status;
    private Timestamp createdAt;

    public Ticket(int id, String username, String subject, String status, Timestamp createdAt) {
        this.id = id;
        this.username = username;
        this.subject = subject;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public String getUsername() { return username; }
    public String getSubject() { return subject; }
    public String getStatus() { return status; }
    public Timestamp getCreatedAt() { return createdAt; }
}