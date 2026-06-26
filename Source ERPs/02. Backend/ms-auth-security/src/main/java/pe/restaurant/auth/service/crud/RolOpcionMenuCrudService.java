package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.RolOpcionMenu;
import pe.restaurant.auth.repository.RolOpcionMenuRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RolOpcionMenuCrudService {

    private final RolOpcionMenuRepository repository;

    public List<RolOpcionMenu> listar() {
        return repository.findAll();
    }

    public Page<RolOpcionMenu> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public RolOpcionMenu obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "RolOpcionMenu no encontrado: " + id, HttpStatus.NOT_FOUND, "ROL_OPCION_MENU_NO_ENCONTRADO"));
    }

    public RolOpcionMenu crear(RolOpcionMenu body) {
        body.setId(null);
        return repository.save(body);
    }

    public RolOpcionMenu actualizar(Long id, RolOpcionMenu body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
