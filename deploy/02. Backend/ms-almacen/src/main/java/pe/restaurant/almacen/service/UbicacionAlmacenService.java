package pe.restaurant.almacen.service;

import pe.restaurant.almacen.entity.UbicacionAlmacen;

import java.util.List;

public interface UbicacionAlmacenService {

    List<UbicacionAlmacen> findByAlmacenId(Long almacenId);

    UbicacionAlmacen findById(Long id);

    UbicacionAlmacen create(UbicacionAlmacen entity);

    UbicacionAlmacen update(Long id, UbicacionAlmacen entity);

    void delete(Long id);
}
