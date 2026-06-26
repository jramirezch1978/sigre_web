package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.UsuarioOpcionMenu;
import pe.restaurant.auth.repository.UsuarioOpcionMenuRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UsuarioOpcionMenuCrudService {

    private final UsuarioOpcionMenuRepository repository;

    public List<UsuarioOpcionMenu> listar() {
        return repository.findAll();
    }

    public Page<UsuarioOpcionMenu> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public UsuarioOpcionMenu obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "UsuarioOpcionMenu no encontrado: " + id, HttpStatus.NOT_FOUND, "USUARIO_OPCION_MENU_NO_ENCONTRADO"));
    }

    public UsuarioOpcionMenu crear(UsuarioOpcionMenu body) {
        body.setId(null);
        return repository.save(body);
    }

    public UsuarioOpcionMenu actualizar(Long id, UsuarioOpcionMenu body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
