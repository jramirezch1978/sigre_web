package pe.restaurant.almacen.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.almacen.dto.LotePalletRequest;
import pe.restaurant.almacen.dto.LotePalletResponse;
import pe.restaurant.almacen.entity.LotePallet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface LotePalletMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", constant = "1")
    LotePallet toEntity(LotePalletRequest request);

    LotePalletResponse toResponse(LotePallet entity);

    List<LotePalletResponse> toResponseList(List<LotePallet> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "almacenId", ignore = true)
    @Mapping(target = "articuloId", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(LotePalletRequest request, @MappingTarget LotePallet entity);
}
