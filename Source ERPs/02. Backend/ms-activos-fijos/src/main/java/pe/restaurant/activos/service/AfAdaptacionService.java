package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfAdaptacion;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public interface AfAdaptacionService {
    Page<AfAdaptacion> findAll(Pageable pageable);
    AfAdaptacion findById(Long id);
    AfAdaptacion create(AfAdaptacion entity);
    AfAdaptacion update(Long id, AfAdaptacion entity);
    void delete(Long id);
    List<AfAdaptacion> findByActivo(Long activoId);
    List<AfAdaptacion> findByFechaRange(LocalDate fechaInicio, LocalDate fechaFin);
    AfAdaptacion capitalizar(Long id);
    BigDecimal obtenerTotalCapitalizado(Long activoId);
}
