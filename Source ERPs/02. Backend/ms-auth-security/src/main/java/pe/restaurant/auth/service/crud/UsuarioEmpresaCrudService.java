package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.UsuarioEmpresa;
import pe.restaurant.auth.repository.UsuarioEmpresaRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UsuarioEmpresaCrudService {

    private final UsuarioEmpresaRepository repository;

    public List<UsuarioEmpresa> listar() {
        return repository.findAll();
    }

    public Page<UsuarioEmpresa> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public UsuarioEmpresa obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "UsuarioEmpresa no encontrado: " + id, HttpStatus.NOT_FOUND, "USUARIO_EMPRESA_NO_ENCONTRADO"));
    }

    public UsuarioEmpresa crear(UsuarioEmpresa body) {
        body.setId(null);
        return repository.save(body);
    }

    public UsuarioEmpresa actualizar(Long id, UsuarioEmpresa body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
