package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.FormaPagoRequest;
import pe.restaurant.core.dto.FormaPagoResponse;
import pe.restaurant.core.entity.FormaPago;

import java.util.List;

@Mapper(componentModel = "spring")
public interface FormaPagoMapper {
    FormaPago toEntity(FormaPagoRequest request);
    FormaPagoResponse toResponse(FormaPago entity);
    List<FormaPagoResponse> toResponseList(List<FormaPago> entities);
    void updateEntity(FormaPagoRequest request, @MappingTarget FormaPago entity);
}
