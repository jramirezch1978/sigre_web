package com.sigre.rrhh.mapper;

import org.mapstruct.AfterMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;
import org.springframework.beans.factory.annotation.Autowired;
import com.sigre.rrhh.dto.request.PermisoLicenciaCreateRequest;
import com.sigre.rrhh.dto.request.PermisoLicenciaUpdateRequest;
import com.sigre.rrhh.dto.response.PermisoLicenciaResponse;
import com.sigre.rrhh.entity.PermisoLicencia;
import com.sigre.rrhh.repository.PermisoLicenciaDetRepository;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring", uses = PermisoLicenciaDetMapper.class)
public abstract class PermisoLicenciaMapper {

    @Autowired
    private PermisoLicenciaDetRepository detRepository;

    @Autowired
    private PermisoLicenciaDetMapper detMapper;

    @Mapping(target = "tipoSuspensionLaboralId", ignore = true)
    @Mapping(target = "fechaInicio", ignore = true)
    @Mapping(target = "fechaFin", ignore = true)
    @Mapping(target = "dias", ignore = true)
    @Mapping(target = "fechaSolicitud", ignore = true)
    @Mapping(target = "detalles", ignore = true)
    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffsetDateTime")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffsetDateTime")
    public abstract PermisoLicenciaResponse toResponse(PermisoLicencia entity);

    public List<PermisoLicenciaResponse> toResponseList(List<PermisoLicencia> entities) {
        if (entities == null) {
            return null;
        }
        return entities.stream().map(this::toResponse).toList();
    }

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "periodoInicio", ignore = true)
    @Mapping(target = "periodoFin", ignore = true)
    @Mapping(target = "diasTotales", ignore = true)
    @Mapping(target = "diasGozados", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    public abstract PermisoLicencia toEntity(PermisoLicenciaCreateRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "trabajadorId", ignore = true)
    @Mapping(target = "periodoInicio", ignore = true)
    @Mapping(target = "periodoFin", ignore = true)
    @Mapping(target = "diasTotales", ignore = true)
    @Mapping(target = "diasGozados", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    public abstract void updateEntity(@MappingTarget PermisoLicencia entity, PermisoLicenciaUpdateRequest request);

    @AfterMapping
    protected void enrichFromDetalle(PermisoLicencia entity, @MappingTarget PermisoLicenciaResponse response) {
        if (entity == null || entity.getId() == null) {
            return;
        }
        var detalles = detRepository.findByPermisoLicenciaIdOrderByItemAsc(entity.getId());
        response.setDetalles(detMapper.toResponseList(detalles));
        if (!detalles.isEmpty()) {
            var primero = detalles.get(0);
            response.setFechaInicio(primero.getFechaInicio());
            response.setFechaFin(primero.getFechaFin());
            response.setFechaSolicitud(primero.getFechaSolicitud());
            response.setTipoSuspensionLaboralId(primero.getTipoSuspensionLaboralId());
            response.setDias(primero.getDias() != null ? primero.getDias().intValue() : entity.getDiasTotales());
        }
    }

    @Named("instantToOffsetDateTime")
    protected OffsetDateTime instantToOffsetDateTime(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
