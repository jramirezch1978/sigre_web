package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.CalendarioFeriado;

public interface CalendarioFeriadoService {
    Page<CalendarioFeriado> findAll(Pageable pageable);
    CalendarioFeriado findById(Long id);
    CalendarioFeriado create(CalendarioFeriado entity);
    CalendarioFeriado update(Long id, CalendarioFeriado entity);
    void delete(Long id);
    CalendarioFeriado activate(Long id);
    CalendarioFeriado deactivate(Long id);
}
