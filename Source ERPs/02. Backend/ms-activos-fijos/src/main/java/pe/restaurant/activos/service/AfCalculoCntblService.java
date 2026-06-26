package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfCalculoCntbl;

import java.util.List;

public interface AfCalculoCntblService {
    Page<AfCalculoCntbl> findAll(Pageable pageable);
    AfCalculoCntbl findById(Long id);
    AfCalculoCntbl create(AfCalculoCntbl entity);
    AfCalculoCntbl update(Long id, AfCalculoCntbl entity);
    void delete(Long id);
    List<AfCalculoCntbl> obtenerHistorialPorActivo(Long afMaestroId);
    List<AfCalculoCntbl> obtenerPorPeriodo(Integer anio, Integer mes);
    default AfCalculoCntbl calcularDepreciacionMensual(Long afMaestroId, Integer anio, Integer mes) {
        return calcularDepreciacionMensual(afMaestroId, anio, mes, null);
    }

    AfCalculoCntbl calcularDepreciacionMensual(Long afMaestroId, Integer anio, Integer mes,
                                             Integer unidadesProducidasPeriodoOverride);

    List<AfCalculoCntbl> calcularDepreciacionMasiva(Integer anio, Integer mes);
}
