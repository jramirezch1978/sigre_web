package pe.restaurant.almacen.dto;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class ProcesoCosteoAlmacenResponse {

    Integer anio;
    Integer mes;
    Long sucursalFiltroId;
    int costeosEnPeriodo;
    int lineasValeActualizadas;
    int articulosAlmacenActualizados;
    String mensaje;
}
