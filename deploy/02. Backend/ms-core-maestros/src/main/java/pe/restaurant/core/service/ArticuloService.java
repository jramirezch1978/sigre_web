package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.dto.*;
import pe.restaurant.core.entity.Articulo;

import java.util.List;

public interface ArticuloService {
    Page<Articulo> list(String codigo, String nombre, Long categoriaId, Pageable pageable);
    ArticuloDetalleResponse getById(Long id);
    ArticuloResponse create(ArticuloRequest request);
    ArticuloResponse update(Long id, ArticuloRequest request);
    void delete(Long id);
    Articulo activate(Long id);
    Articulo deactivate(Long id);
    List<ArticuloProveedorResponse> listProveedores(Long articuloId);
    ArticuloProveedorResponse createProveedor(Long articuloId, ArticuloProveedorRequest request);
    List<ArticuloAlmacenConfigResponse> listAlmacenesConfig(Long articuloId);
    ArticuloAlmacenConfigResponse upsertAlmacenConfig(Long articuloId, ArticuloAlmacenConfigRequest request);
    List<ArticuloImpuestoResponse> listImpuestos(Long articuloId);
    ArticuloImpuestoResponse createImpuesto(Long articuloId, ArticuloImpuestoRequest request);
    void deleteImpuesto(Long articuloId, Long impuestoId);
}
