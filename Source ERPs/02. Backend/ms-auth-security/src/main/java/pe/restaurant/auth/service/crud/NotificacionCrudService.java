package pe.restaurant.auth.service.crud;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import pe.restaurant.auth.entity.Notificacion;
import pe.restaurant.auth.repository.NotificacionRepository;
import pe.restaurant.common.exception.BusinessException;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificacionCrudService {

    private final NotificacionRepository repository;

    public List<Notificacion> listar() {
        return repository.findAll();
    }

    public Page<Notificacion> listar(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public Notificacion obtener(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new BusinessException(
                        "Notificacion no encontrada: " + id, HttpStatus.NOT_FOUND, "NOTIFICACION_NO_ENCONTRADA"));
    }

    public Notificacion crear(Notificacion body) {
        body.setId(null);
        return repository.save(body);
    }

    public Notificacion actualizar(Long id, Notificacion body) {
        obtener(id);
        body.setId(id);
        return repository.save(body);
    }

    public void eliminar(Long id) {
        repository.delete(obtener(id));
    }
}
