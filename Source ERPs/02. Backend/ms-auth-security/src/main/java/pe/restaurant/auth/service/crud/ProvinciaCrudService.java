package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.Provincia;
import pe.restaurant.auth.repository.ProvinciaRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProvinciaCrudService {

    private final ProvinciaRepository repository;

    public List<Provincia> listar() {
        return repository.findAll();
    }

    public Page<Provincia> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public Provincia obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "Provincia no encontrada: " + id, HttpStatus.NOT_FOUND, "PROVINCIA_NO_ENCONTRADA"));
    }

    public Provincia crear(Provincia body) {
        body.setId(null);
        return repository.save(body);
    }

    public Provincia actualizar(Long id, Provincia body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
