package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfHistorial;

import java.time.LocalDateTime;
import java.util.List;

public interface AfHistorialService {
    Page<AfHistorial> findAll(Pageable pageable);
    AfHistorial findById(Long id);
    AfHistorial create(AfHistorial entity);
    void delete(Long id);
    List<AfHistorial> findByActivo(Long activoId);
    List<AfHistorial> findByTipoEvento(String tipoEvento);
    List<AfHistorial> findByUsuario(Long usuarioId);
    List<AfHistorial> findByFechaRange(LocalDateTime fechaInicio, LocalDateTime fechaFin);
}
