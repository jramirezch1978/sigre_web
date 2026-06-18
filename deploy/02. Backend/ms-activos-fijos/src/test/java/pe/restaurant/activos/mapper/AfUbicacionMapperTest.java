package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfUbicacionRequest;
import pe.restaurant.activos.dto.AfUbicacionResponse;
import pe.restaurant.activos.entity.AfUbicacion;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfUbicacionMapperTest {

    private final AfUbicacionMapper mapper = Mappers.getMapper(AfUbicacionMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfUbicacion entity = new AfUbicacion();
        entity.setId(1L);
        entity.setSucursalId(10L);
        entity.setCodigo("ALM-01");
        entity.setNombre("Almacén Principal");
        entity.setFlagEstado("1");

        AfUbicacionResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getSucursalId()).isEqualTo(10L);
        assertThat(response.getCodigo()).isEqualTo("ALM-01");
        assertThat(response.getNombre()).isEqualTo("Almacén Principal");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfUbicacion e1 = new AfUbicacion();
        e1.setId(1L);
        e1.setCodigo("ALM-01");
        AfUbicacion e2 = new AfUbicacion();
        e2.setId(2L);
        e2.setCodigo("ALM-02");

        List<AfUbicacionResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getCodigo()).isEqualTo("ALM-01");
        assertThat(result.get(1).getCodigo()).isEqualTo("ALM-02");
    }

    @Test
    void toEntity_mapsAllFields() {
        AfUbicacionRequest request = new AfUbicacionRequest();
        request.setSucursalId(10L);
        request.setCodigo("ALM-01");
        request.setNombre("Almacén Principal");

        AfUbicacion entity = mapper.toEntity(request);

        assertThat(entity.getSucursalId()).isEqualTo(10L);
        assertThat(entity.getCodigo()).isEqualTo("ALM-01");
        assertThat(entity.getNombre()).isEqualTo("Almacén Principal");
        assertThat(entity.getId()).isNull();
        assertThat(entity.getFlagEstado()).isNotNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfUbicacion entity = new AfUbicacion();
        entity.setId(99L);
        entity.setFlagEstado("1");
        entity.setCodigo("OLD");

        AfUbicacionRequest request = new AfUbicacionRequest();
        request.setSucursalId(50L);
        request.setCodigo("OFI-03");
        request.setNombre("Oficina Tercer Piso");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getSucursalId()).isEqualTo(50L);
        assertThat(entity.getCodigo()).isEqualTo("OFI-03");
        assertThat(entity.getNombre()).isEqualTo("Oficina Tercer Piso");
    }
}
