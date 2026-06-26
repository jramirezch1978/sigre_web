package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.Sesion;
import pe.restaurant.auth.repository.SesionRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SesionCrudService {

    private final SesionRepository repository;

    public List<Sesion> listar() {
        return repository.findAll();
    }

    public Page<Sesion> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public Sesion obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "Sesion no encontrada: " + id, HttpStatus.NOT_FOUND, "SESION_NO_ENCONTRADA"));
    }

    public Sesion crear(Sesion body) {
        body.setId(null);
        return repository.save(body);
    }

    public Sesion actualizar(Long id, Sesion body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
