package com.sigre.produccion.mapper;

import org.mapstruct.Mapper;
import com.sigre.produccion.dto.response.OtAdminUderResponse;
import com.sigre.produccion.entity.OtAdminUder;

import java.util.List;

@Mapper(componentModel = "spring")
public interface OtAdminUderMapper {

    OtAdminUderResponse toResponse(OtAdminUder entity);

    List<OtAdminUderResponse> toResponseList(List<OtAdminUder> entities);
}
