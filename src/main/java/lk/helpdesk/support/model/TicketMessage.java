package lk.helpdesk.support.model;

import java.sql.Timestamp;

public class TicketMessage {
    private int id;
    private int ticketId;
    private int senderId;
    private String senderUsername;
    private String message;
    private Timestamp createdAt;

    public TicketMessage() {}

    public TicketMessage(int id, int ticketId, int senderId,String senderUsername, String message, Timestamp createdAt) {
        this.id = id;
        this.ticketId = ticketId;
        this.senderId = senderId;
        this.senderUsername = senderUsername;
        this.message = message;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getTicketId() { return ticketId; }
    public void setTicketId(int ticketId) { this.ticketId = ticketId; }

    public int getSenderId() { return senderId; }
    public void setSenderId(int senderId) { this.senderId = senderId; }

    public String getSenderUsername() { return senderUsername; }
    public void setSenderUsername(String senderUsername) {
        this.senderUsername = senderUsername;
    }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
