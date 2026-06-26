package pe.restaurant.rrhh.mapper;

import org.mapstruct.*;
import org.springframework.beans.factory.annotation.Autowired;
import pe.restaurant.rrhh.dto.request.RemuneracionMinimaVitalCreateRequest;
import pe.restaurant.rrhh.dto.request.RemuneracionMinimaVitalUpdateRequest;
import pe.restaurant.rrhh.dto.response.RemuneracionMinimaVitalResponse;
import pe.restaurant.rrhh.entity.RemuneracionMinimaVital;
import pe.restaurant.rrhh.repository.TipoTrabajadorRepository;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public abstract class RemuneracionMinimaVitalMapper {

    @Autowired
    private TipoTrabajadorRepository tipoTrabajadorRepository;

    @Mapping(target = "tipoTrabajadorCodigo", ignore = true)
    @Mapping(target = "tipoTrabajadorNombre", ignore = true)
    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffset")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffset")
    public abstract RemuneracionMinimaVitalResponse toResponse(RemuneracionMinimaVital entity);

    public List<RemuneracionMinimaVitalResponse> toResponseList(List<RemuneracionMinimaVital> entities) {
        if (entities == null) {
            return null;
        }
        return entities.stream().map(this::toResponse).toList();
    }

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", constant = "1")
    public abstract RemuneracionMinimaVital toEntity(RemuneracionMinimaVitalCreateRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    public abstract void updateEntity(@MappingTarget RemuneracionMinimaVital entity, RemuneracionMinimaVitalUpdateRequest request);

    @AfterMapping
    protected void enrichTipoTrabajador(RemuneracionMinimaVital entity, @MappingTarget RemuneracionMinimaVitalResponse response) {
        if (entity == null || entity.getTipoTrabajadorId() == null) {
            return;
        }
        tipoTrabajadorRepository.findById(entity.getTipoTrabajadorId()).ifPresent(tipo -> {
            response.setTipoTrabajadorCodigo(tipo.getCodigo());
            response.setTipoTrabajadorNombre(tipo.getNombre());
        });
    }

    @Named("instantToOffset")
    protected OffsetDateTime instantToOffset(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
