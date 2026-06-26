package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.BeanMapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import pe.restaurant.core.dto.EntidadContribuyenteTelefonoRequest;
import pe.restaurant.core.dto.EntidadContribuyenteTelefonoResponse;
import pe.restaurant.core.entity.EntidadContribuyenteTelefono;

import java.util.List;

@Mapper(componentModel = "spring")
public interface EntidadContribuyenteTelefonoMapper {
    EntidadContribuyenteTelefono toEntity(EntidadContribuyenteTelefonoRequest request);
    EntidadContribuyenteTelefonoResponse toResponse(EntidadContribuyenteTelefono entity);
    List<EntidadContribuyenteTelefonoResponse> toResponseList(List<EntidadContribuyenteTelefono> entities);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateEntity(EntidadContribuyenteTelefonoRequest request, @MappingTarget EntidadContribuyenteTelefono entity);
}
