package pe.restaurant.produccion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.produccion.dto.response.CaractDetResponse;
import pe.restaurant.produccion.entity.ArticuloDocTecnica;
import pe.restaurant.produccion.entity.ArticuloDocTecnicaCaractDet;

import java.util.List;

public interface ArticuloDocTecnicaService {

    Page<ArticuloDocTecnica> findAll(Long docTipoId, String nombreDocumento, String flagEstado,
                                     Long articuloId, Pageable pageable);

    ArticuloDocTecnica findById(Long id);

    ArticuloDocTecnica create(ArticuloDocTecnica entity, List<ArticuloDocTecnicaCaractDet> caracteristicas);

    ArticuloDocTecnica update(Long id, ArticuloDocTecnica entity, List<ArticuloDocTecnicaCaractDet> caracteristicas);

    ArticuloDocTecnica activate(Long id);

    ArticuloDocTecnica deactivate(Long id);

    void delete(Long id);

    // Sub-recurso caracteristicas

    List<ArticuloDocTecnicaCaractDet> findCaracteristicas(Long docTecnicaId);

    // Enrichment

    void enrichCaractDetResponses(List<CaractDetResponse> responses);
}
