package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.NumTablas;

public interface NumTablasService {
    Page<NumTablas> findAll(Pageable pageable);
    NumTablas findById(NumTablas.NumTablasId id);
    NumTablas create(NumTablas entity);
    NumTablas update(NumTablas entity);
    void delete(NumTablas.NumTablasId id);
}
