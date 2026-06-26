package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.Distrito;
import pe.restaurant.auth.repository.DistritoRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DistritoCrudService {

    private final DistritoRepository repository;

    public List<Distrito> listar() {
        return repository.findAll();
    }

    public Page<Distrito> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public Distrito obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "Distrito no encontrado: " + id, HttpStatus.NOT_FOUND, "DISTRITO_NO_ENCONTRADO"));
    }

    public Distrito crear(Distrito body) {
        body.setId(null);
        return repository.save(body);
    }

    public Distrito actualizar(Long id, Distrito body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
