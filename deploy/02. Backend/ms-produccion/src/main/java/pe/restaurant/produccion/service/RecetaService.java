package pe.restaurant.produccion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.produccion.dto.response.RecetaConsumibleResponse;
import pe.restaurant.produccion.dto.response.RecetaLaborResponse;
import pe.restaurant.produccion.dto.response.RecetaResponse;
import pe.restaurant.produccion.entity.FichaTecnica;
import pe.restaurant.produccion.entity.Receta;
import pe.restaurant.produccion.entity.RecetaLabor;
import pe.restaurant.produccion.entity.RecetaLaborConsumible;

import java.util.List;

public interface RecetaService {

    Page<Receta> findAll(String nroReceta, String nombre, String flagTipoReceta, String flagEstado, Long articuloProducidoId, Pageable pageable);

    Receta findById(Long id);

    Receta create(Receta receta, List<RecetaLabor> labores, List<RecetaLaborConsumible> consumibles, FichaTecnica fichaTecnica);

    Receta update(Long id, Receta receta, List<RecetaLabor> labores, List<RecetaLaborConsumible> consumibles, FichaTecnica fichaTecnica);

    Receta activate(Long id);

    Receta deactivate(Long id);

    Receta nuevaVersion(Long id);

    void delete(Long id);

    // Sub-recursos

    List<RecetaLabor> findLabores(Long recetaId);

    List<RecetaLaborConsumible> findConsumibles(Long recetaId);

    FichaTecnica findFichaTecnica(Long recetaId);

    // Enrichment: puebla campos con joins a otras tablas

    void enrichRecetaResponses(List<RecetaResponse> responses);

    void enrichLaborResponses(List<RecetaLaborResponse> responses);

    void enrichConsumibleResponses(List<RecetaConsumibleResponse> responses);
}
