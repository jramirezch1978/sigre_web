package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.CatalogoSunatDet;

import java.util.List;

public interface CatalogoSunatDetService {

    Page<CatalogoSunatDet> findAll(Long catalogoSunatId, String codigoItem, String nombreItem, String flagEstado, Pageable pageable);

    CatalogoSunatDet findById(Long id);

    List<CatalogoSunatDet> findActivosByCatalogoId(Long catalogoSunatId);

    CatalogoSunatDet create(CatalogoSunatDet entity);

    CatalogoSunatDet update(Long id, CatalogoSunatDet entity);

    CatalogoSunatDet activate(Long id);

    CatalogoSunatDet deactivate(Long id);
}
