package io.helidon.examples.quickstart.mp;

import javax.enterprise.context.ApplicationScoped;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@ApplicationScoped
public class UserRepository {
    @PersistenceContext
    EntityManager entityManager;

    public List<User> all(){
        return entityManager.createQuery("select u from User u", User.class).getResultList();
    }
}
