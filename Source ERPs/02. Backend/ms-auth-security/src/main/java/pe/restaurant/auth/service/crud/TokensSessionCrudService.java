package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.TokensSession;
import pe.restaurant.auth.repository.TokensSessionRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TokensSessionCrudService {

    private final TokensSessionRepository repository;

    public List<TokensSession> listar() {
        return repository.findAll();
    }

    public Page<TokensSession> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public TokensSession obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "TokensSession no encontrado: " + id, HttpStatus.NOT_FOUND, "TOKENS_SESSION_NO_ENCONTRADO"));
    }

    public TokensSession crear(TokensSession body) {
        body.setId(null);
        return repository.save(body);
    }

    public TokensSession actualizar(Long id, TokensSession body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
