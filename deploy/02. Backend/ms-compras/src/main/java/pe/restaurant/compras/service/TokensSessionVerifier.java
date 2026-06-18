package pe.restaurant.compras.service;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import pe.restaurant.common.security.TokensSessionChecker;

@Service
public class TokensSessionVerifier implements TokensSessionChecker {

    private final JdbcTemplate securityJdbcTemplate;

    public TokensSessionVerifier(@Qualifier("securityJdbcTemplate") JdbcTemplate securityJdbcTemplate) {
        this.securityJdbcTemplate = securityJdbcTemplate;
    }

    @Override
    public boolean isActive(long usuarioId, long tokensSessionId) {
        Integer n = securityJdbcTemplate.queryForObject(
                "SELECT COUNT(*)::int FROM auth.tokens_session WHERE id = ? AND usuario_id = ? AND flag_estado = '1' AND expira_en > NOW()",
                Integer.class,
                tokensSessionId, usuarioId);
        return n != null && n > 0;
    }
}
