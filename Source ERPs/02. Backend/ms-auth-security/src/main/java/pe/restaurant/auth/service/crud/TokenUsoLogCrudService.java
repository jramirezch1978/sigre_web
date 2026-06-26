package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.TokenUsoLog;
import pe.restaurant.auth.repository.TokenUsoLogRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TokenUsoLogCrudService {

    private final TokenUsoLogRepository repository;

    public List<TokenUsoLog> listar() {
        return repository.findAll();
    }

    public Page<TokenUsoLog> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public TokenUsoLog obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "TokenUsoLog no encontrado: " + id, HttpStatus.NOT_FOUND, "TOKEN_USO_LOG_NO_ENCONTRADO"));
    }

    public TokenUsoLog crear(TokenUsoLog body) {
        body.setId(null);
        return repository.save(body);
    }

    public TokenUsoLog actualizar(Long id, TokenUsoLog body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
