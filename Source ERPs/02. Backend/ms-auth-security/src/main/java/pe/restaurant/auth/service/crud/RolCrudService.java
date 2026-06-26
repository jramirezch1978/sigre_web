package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.Rol;
import pe.restaurant.auth.repository.RolRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RolCrudService {

    private final RolRepository repository;

    public List<Rol> listar() {
        return repository.findAll();
    }

    public Page<Rol> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public Rol obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "Rol no encontrado: " + id, HttpStatus.NOT_FOUND, "ROL_NO_ENCONTRADO"));
    }

    public Rol crear(Rol body) {
        body.setId(null);
        return repository.save(body);
    }

    public Rol actualizar(Long id, Rol body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
