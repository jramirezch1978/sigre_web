package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.BeanMapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import pe.restaurant.core.dto.EntidadContribuyenteRepresentanteRequest;
import pe.restaurant.core.dto.EntidadContribuyenteRepresentanteResponse;
import pe.restaurant.core.entity.EntidadContribuyenteRepresentante;

import java.util.List;

@Mapper(componentModel = "spring")
public interface EntidadContribuyenteRepresentanteMapper {
    EntidadContribuyenteRepresentante toEntity(EntidadContribuyenteRepresentanteRequest request);
    EntidadContribuyenteRepresentanteResponse toResponse(EntidadContribuyenteRepresentante entity);
    List<EntidadContribuyenteRepresentanteResponse> toResponseList(List<EntidadContribuyenteRepresentante> entities);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateEntity(EntidadContribuyenteRepresentanteRequest request, @MappingTarget EntidadContribuyenteRepresentante entity);
}
