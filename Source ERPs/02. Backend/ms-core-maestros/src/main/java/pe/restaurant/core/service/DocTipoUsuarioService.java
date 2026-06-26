package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.DocTipoUsuario;

public interface DocTipoUsuarioService {
    Page<DocTipoUsuario> findAll(Pageable pageable);
    DocTipoUsuario findById(Long id);
    DocTipoUsuario create(DocTipoUsuario entity);
    DocTipoUsuario update(Long id, DocTipoUsuario entity);
    void delete(Long id);
    DocTipoUsuario activate(Long id);
    DocTipoUsuario deactivate(Long id);
}
