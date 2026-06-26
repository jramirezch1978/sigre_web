package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.Pais;
import pe.restaurant.auth.repository.PaisRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PaisCrudService {

    private final PaisRepository repository;

    public List<Pais> listar() {
        return repository.findAll();
    }

    public Page<Pais> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public Pais obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "Pais no encontrado: " + id, HttpStatus.NOT_FOUND, "PAIS_NO_ENCONTRADO"));
    }

    public Pais crear(Pais body) {
        body.setId(null);
        return repository.save(body);
    }

    public Pais actualizar(Long id, Pais body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
