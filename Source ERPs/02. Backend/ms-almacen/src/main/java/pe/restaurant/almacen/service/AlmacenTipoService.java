package pe.restaurant.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.entity.AlmacenTipo;

public interface AlmacenTipoService {

    Page<AlmacenTipo> findAll(Pageable pageable);

    AlmacenTipo findById(Long id);

    AlmacenTipo create(AlmacenTipo entity);

    AlmacenTipo update(Long id, AlmacenTipo entity);

    AlmacenTipo activate(Long id);

    AlmacenTipo deactivate(Long id);

    void delete(Long id);
}
