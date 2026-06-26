package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.TokensSession;

public interface TokensSessionRepository extends JpaRepository<TokensSession, Long> {
}
