package pe.restaurant.core.service;

import pe.restaurant.core.entity.TipoDocIdentidad;

import java.util.List;

public interface TipoDocIdentidadService {
    List<TipoDocIdentidad> findAll(String flagEstado);
    TipoDocIdentidad findById(Long id);
    TipoDocIdentidad create(TipoDocIdentidad entity);
    TipoDocIdentidad update(Long id, TipoDocIdentidad entity);
    void delete(Long id);
    TipoDocIdentidad activate(Long id);
    TipoDocIdentidad deactivate(Long id);
}
