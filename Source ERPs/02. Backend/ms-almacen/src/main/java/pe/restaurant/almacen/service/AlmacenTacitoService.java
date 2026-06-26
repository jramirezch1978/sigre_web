package pe.restaurant.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.entity.AlmacenTacito;

public interface AlmacenTacitoService {

    Page<AlmacenTacito> buscar(String codClase, Long sucursalId, Long almacenId, Pageable pageable);

    AlmacenTacito findById(Long id);

    AlmacenTacito create(AlmacenTacito entity);

    AlmacenTacito update(Long id, AlmacenTacito entity);

    AlmacenTacito activate(Long id);

    AlmacenTacito deactivate(Long id);

    void delete(Long id);
}
