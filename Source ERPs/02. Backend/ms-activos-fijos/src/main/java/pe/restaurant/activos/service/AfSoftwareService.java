package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfSoftware;

import java.util.List;

public interface AfSoftwareService {

    Page<AfSoftware> findAll(Pageable pageable);

    AfSoftware findById(Long id);

    List<AfSoftware> findByMaestro(Long afMaestroId);

    AfSoftware create(AfSoftware entity);

    AfSoftware update(Long id, AfSoftware entity);

    void delete(Long id);
}
