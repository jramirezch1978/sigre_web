package pe.restaurant.activos.service;

import pe.restaurant.activos.dto.AfMaestroCcDistribRequest;
import pe.restaurant.activos.entity.AfMaestroCcDistrib;

import java.util.List;

public interface AfMaestroCcDistribService {

    List<AfMaestroCcDistrib> listarPorMaestro(Long afMaestroId);

    List<AfMaestroCcDistrib> reemplazarDistribucion(Long afMaestroId, List<AfMaestroCcDistribRequest> lineas);
}
