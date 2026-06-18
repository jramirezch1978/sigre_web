package pe.restaurant.produccion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.produccion.dto.response.ProcesarCosteoResponse;
import pe.restaurant.produccion.entity.CosteoProduccion;

import java.util.List;

public interface CosteoProduccionService {

    Page<CosteoProduccion> findAll(Long ordenTrabajoId, Integer anio, Integer mes, Pageable pageable);

    CosteoProduccion findById(Long id);

    ProcesarCosteoResponse procesar(Integer anio, Integer mes, Long sucursalId, Long almacenId);

    List<CosteoProduccion> findByPeriodo(Integer anio, Integer mes);

    CosteoProduccion guardar(CosteoProduccion entity);
}
