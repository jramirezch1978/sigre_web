package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.FormaPagoRequest;
import com.sigre.core.dto.FormaPagoResponse;
import com.sigre.core.entity.FormaPago;

import java.util.List;

@Mapper(componentModel = "spring")
public interface FormaPagoMapper {
    FormaPago toEntity(FormaPagoRequest request);
    FormaPagoResponse toResponse(FormaPago entity);
    List<FormaPagoResponse> toResponseList(List<FormaPago> entities);
    void updateEntity(FormaPagoRequest request, @MappingTarget FormaPago entity);
}
