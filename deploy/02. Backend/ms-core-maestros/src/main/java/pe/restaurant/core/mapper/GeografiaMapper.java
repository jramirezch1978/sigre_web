package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.*;
import pe.restaurant.core.entity.Departamento;
import pe.restaurant.core.entity.Distrito;
import pe.restaurant.core.entity.Pais;
import pe.restaurant.core.entity.Provincia;

import java.util.List;

@Mapper(componentModel = "spring")
public interface GeografiaMapper {

    PaisResponse toResponse(Pais entity);
    List<PaisResponse> toPaisResponseList(List<Pais> entities);
    Pais toEntity(PaisRequest request);
    void updateEntity(PaisRequest request, @MappingTarget Pais entity);

    DepartamentoResponse toResponse(Departamento entity);
    List<DepartamentoResponse> toDepartamentoResponseList(List<Departamento> entities);
    Departamento toEntity(DepartamentoRequest request);
    void updateEntity(DepartamentoRequest request, @MappingTarget Departamento entity);

    ProvinciaResponse toResponse(Provincia entity);
    List<ProvinciaResponse> toProvinciaResponseList(List<Provincia> entities);
    Provincia toEntity(ProvinciaRequest request);
    void updateEntity(ProvinciaRequest request, @MappingTarget Provincia entity);

    DistritoResponse toResponse(Distrito entity);
    List<DistritoResponse> toDistritoResponseList(List<Distrito> entities);
    Distrito toEntity(DistritoRequest request);
    void updateEntity(DistritoRequest request, @MappingTarget Distrito entity);
}
