package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.CreditoFiscalRequest;
import pe.restaurant.core.dto.CreditoFiscalResponse;
import pe.restaurant.core.entity.CreditoFiscal;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CreditoFiscalMapper {
    CreditoFiscal toEntity(CreditoFiscalRequest request);
    CreditoFiscalResponse toResponse(CreditoFiscal entity);
    List<CreditoFiscalResponse> toResponseList(List<CreditoFiscal> entities);
    void updateEntity(CreditoFiscalRequest request, @MappingTarget CreditoFiscal entity);
}
