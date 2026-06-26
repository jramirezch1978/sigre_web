package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.LogAcceso;
import pe.restaurant.auth.repository.LogAccesoRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class LogAccesoCrudService {

    private final LogAccesoRepository repository;

    public List<LogAcceso> listar() {
        return repository.findAll();
    }

    public Page<LogAcceso> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public LogAcceso obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "LogAcceso no encontrado: " + id, HttpStatus.NOT_FOUND, "LOG_ACCESO_NO_ENCONTRADO"));
    }

    public LogAcceso crear(LogAcceso body) {
        body.setId(null);
        return repository.save(body);
    }

    public LogAcceso actualizar(Long id, LogAcceso body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
