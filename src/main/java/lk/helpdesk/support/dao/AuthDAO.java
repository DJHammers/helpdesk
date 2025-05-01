package lk.helpdesk.support.dao;

import lk.helpdesk.support.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.SQLException;

public class AuthDAO {
    private final UserDAO userDao = new UserDAO();

    public User login(String username, String plainPassword) throws SQLException {
        User u = userDao.findByUsername(username);
        if (u == null) {
            return null;
        }
        if (BCrypt.checkpw(plainPassword, u.getPasswordHash())) {
            return u;
        }
        return null;
    }

    public void register(User u, String plainPassword) throws SQLException {
        if (userDao.existsByUsernameOrEmail(u.getUsername(), u.getEmail())) {
            throw new SQLException("Username or email already in use");
        }
        String hash = BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
        int newId = userDao.createUser(
            u.getUsername(),
            u.getEmail(),
            hash,
            u.getRole()
        );
        u.setId(newId);
    }
}
