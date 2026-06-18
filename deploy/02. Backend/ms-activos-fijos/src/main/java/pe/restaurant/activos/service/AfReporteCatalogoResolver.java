package pe.restaurant.activos.service;

import pe.restaurant.activos.entity.AfClase;
import pe.restaurant.activos.entity.AfSubClase;
import pe.restaurant.activos.entity.AfUbicacion;

import java.util.Map;
import java.util.Optional;

public interface AfReporteCatalogoResolver {

    Optional<AfSubClase> subClase(Long id);

    Optional<AfClase> clase(Long id);

    Optional<AfUbicacion> ubicacion(Long id);

    String centroCostoEtiqueta(Long centroCostoId);

    String monedaDefecto();

    Map<Long, String> etiquetasCentroCosto(Iterable<Long> ids);
}
