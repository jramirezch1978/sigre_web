package com.sigre.produccion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.produccion.dto.response.RecetaConsumibleResponse;
import com.sigre.produccion.dto.response.RecetaLaborResponse;
import com.sigre.produccion.dto.response.RecetaResponse;
import com.sigre.produccion.entity.FichaTecnica;
import com.sigre.produccion.entity.Receta;
import com.sigre.produccion.entity.RecetaLabor;
import com.sigre.produccion.entity.RecetaLaborConsumible;

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
