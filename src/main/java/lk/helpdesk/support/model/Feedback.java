package lk.helpdesk.support.model;

import java.sql.Timestamp;

public class Feedback {
    private int id;
    private int userId;
    private String username;
    private String message;
    private int rating;
    private Timestamp createdAt;

    public Feedback() {}

    // Getters & setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
