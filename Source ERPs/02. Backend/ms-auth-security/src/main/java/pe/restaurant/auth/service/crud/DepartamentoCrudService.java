package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.Departamento;
import pe.restaurant.auth.repository.DepartamentoRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DepartamentoCrudService {

    private final DepartamentoRepository repository;

    public List<Departamento> listar() {
        return repository.findAll();
    }

    public Page<Departamento> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public Departamento obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "Departamento no encontrado: " + id, HttpStatus.NOT_FOUND, "DEPARTAMENTO_NO_ENCONTRADO"));
    }

    public Departamento crear(Departamento body) {
        body.setId(null);
        return repository.save(body);
    }

    public Departamento actualizar(Long id, Departamento body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
