package pe.restaurant.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.entity.Almacen;

public interface AlmacenService {

    Page<Almacen> findAll(Pageable pageable);

    Almacen findById(Long id);

    Almacen create(Almacen entity);

    Almacen update(Long id, Almacen entity);

    Almacen activate(Long id);

    Almacen deactivate(Long id);

    void delete(Long id);
}
