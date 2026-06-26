package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.RolOpcionMenuAccion;
import pe.restaurant.auth.repository.RolOpcionMenuAccionRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RolOpcionMenuAccionCrudService {

    private final RolOpcionMenuAccionRepository repository;

    public List<RolOpcionMenuAccion> listar() {
        return repository.findAll();
    }

    public Page<RolOpcionMenuAccion> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public RolOpcionMenuAccion obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "RolOpcionMenuAccion no encontrado: " + id, HttpStatus.NOT_FOUND, "ROL_OPCION_MENU_ACCION_NO_ENCONTRADO"));
    }

    public RolOpcionMenuAccion crear(RolOpcionMenuAccion body) {
        body.setId(null);
        return repository.save(body);
    }

    public RolOpcionMenuAccion actualizar(Long id, RolOpcionMenuAccion body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
