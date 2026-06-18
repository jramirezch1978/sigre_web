package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfValuacion;

import java.time.LocalDate;
import java.util.List;

public interface AfValuacionService {
    Page<AfValuacion> findAll(Pageable pageable);
    AfValuacion findById(Long id);
    AfValuacion create(AfValuacion entity);
    AfValuacion update(Long id, AfValuacion entity);
    void delete(Long id);
    List<AfValuacion> findByActivo(Long activoId);
    List<AfValuacion> findByPeriodo(LocalDate fechaInicio, LocalDate fechaFin);
    AfValuacion validar(Long id);
    AfValuacion aprobar(Long id);
    AfValuacion anular(Long id);
}
