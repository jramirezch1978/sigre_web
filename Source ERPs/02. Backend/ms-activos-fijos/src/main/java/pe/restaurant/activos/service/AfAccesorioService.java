package pe.restaurant.activos.service;

import pe.restaurant.activos.entity.AfAccesorio;

import java.util.List;

public interface AfAccesorioService {

    AfAccesorio findById(Long id);

    List<AfAccesorio> findByMaestro(Long afMaestroId);

    AfAccesorio create(AfAccesorio entity);

    AfAccesorio update(Long id, AfAccesorio entity);

    void delete(Long id);
}
