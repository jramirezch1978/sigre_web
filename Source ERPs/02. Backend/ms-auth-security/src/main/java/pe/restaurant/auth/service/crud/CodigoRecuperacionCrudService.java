package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.CodigoRecuperacion;
import pe.restaurant.auth.repository.CodigoRecuperacionRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CodigoRecuperacionCrudService {

    private final CodigoRecuperacionRepository repository;

    public List<CodigoRecuperacion> listar() {
        return repository.findAll();
    }

    public Page<CodigoRecuperacion> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public CodigoRecuperacion obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "CodigoRecuperacion no encontrado: " + id, HttpStatus.NOT_FOUND, "CODIGO_RECUPERACION_NO_ENCONTRADO"));
    }

    public CodigoRecuperacion crear(CodigoRecuperacion body) {
        body.setId(null);
        return repository.save(body);
    }

    public CodigoRecuperacion actualizar(Long id, CodigoRecuperacion body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
