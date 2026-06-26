package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.RolUsuario;
import pe.restaurant.auth.repository.RolUsuarioRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RolUsuarioCrudService {

    private final RolUsuarioRepository repository;

    public List<RolUsuario> listar() {
        return repository.findAll();
    }

    public Page<RolUsuario> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public RolUsuario obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "RolUsuario no encontrado: " + id, HttpStatus.NOT_FOUND, "ROL_USUARIO_NO_ENCONTRADO"));
    }

    public RolUsuario crear(RolUsuario body) {
        body.setId(null);
        return repository.save(body);
    }

    public RolUsuario actualizar(Long id, RolUsuario body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
