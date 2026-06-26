package pe.restaurant.contabilidad.mapper;

import org.springframework.stereotype.Component;
import pe.restaurant.contabilidad.dto.request.PlanContableRequest;
import pe.restaurant.contabilidad.dto.response.PlanContableResponse;
import pe.restaurant.contabilidad.entity.PlanContable;

@Component
public class PlanContableMapper {

    public PlanContableResponse toResponse(PlanContable entity) {
        if (entity == null) return null;

        return PlanContableResponse.builder()
                .id(entity.getId())
                .codigo(entity.getCodigo())
                .nombre(entity.getNombre())
                .anio(entity.getAnio())
                .effectiveFrom(entity.getEffectiveFrom())
                .flagEstado(entity.getFlagEstado())
                .build();
    }

    public PlanContable toEntity(PlanContableRequest request) {
        if (request == null) return null;

        PlanContable entity = new PlanContable();
        entity.setCodigo(request.getCodigo());
        entity.setNombre(request.getNombre());
        entity.setAnio(request.getAnio());
        entity.setEffectiveFrom(request.getEffectiveFrom());
        entity.setFlagEstado("1");
        return entity;
    }

    public void updateEntity(PlanContable entity, PlanContableRequest request) {
        if (request == null) return;

        entity.setCodigo(request.getCodigo());
        entity.setNombre(request.getNombre());
        entity.setAnio(request.getAnio());
        entity.setEffectiveFrom(request.getEffectiveFrom());
    }
}
