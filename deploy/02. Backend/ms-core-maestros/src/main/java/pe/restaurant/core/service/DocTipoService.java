package pe.restaurant.core.service;

import pe.restaurant.core.entity.DocTipo;

import java.util.List;

public interface DocTipoService {
    List<DocTipo> findAll();
    DocTipo findById(Long id);
    DocTipo findByCodigo(String codigo);
    DocTipo create(DocTipo entity);
    DocTipo update(Long id, DocTipo entity);
    void delete(Long id);
    DocTipo activate(Long id);
    DocTipo deactivate(Long id);
}
