package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.SucursalRequest;
import pe.restaurant.core.dto.SucursalResponse;
import pe.restaurant.core.entity.Sucursal;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class SucursalMapperTest {

    private final SucursalMapper mapper = Mappers.getMapper(SucursalMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        Sucursal entity = new Sucursal();
        entity.setId(1L);
        entity.setCodigo("LM");
        entity.setNombre("Sucursal Principal");
        entity.setDireccion("Av. Principal 123");
        entity.setCiudad("Lima");
        entity.setPaisId(1L);
        entity.setDepartamentoId(15L);
        entity.setProvinciaId(1501L);
        entity.setDistritoId(150101L);
        entity.setUbigeo("150101");
        entity.setFlagEstado("1");

        SucursalResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("LM");
        assertThat(response.getNombre()).isEqualTo("Sucursal Principal");
        assertThat(response.getDireccion()).isEqualTo("Av. Principal 123");
        assertThat(response.getCiudad()).isEqualTo("Lima");
        assertThat(response.getPaisId()).isEqualTo(1L);
        assertThat(response.getDepartamentoId()).isEqualTo(15L);
        assertThat(response.getProvinciaId()).isEqualTo(1501L);
        assertThat(response.getDistritoId()).isEqualTo(150101L);
        assertThat(response.getUbigeo()).isEqualTo("150101");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        Sucursal e1 = new Sucursal();
        e1.setId(1L);
        e1.setCodigo("LM");
        e1.setNombre("Sucursal Principal");
        e1.setFlagEstado("1");

        Sucursal e2 = new Sucursal();
        e2.setId(2L);
        e2.setCodigo("PI");
        e2.setNombre("Sucursal Norte");
        e2.setFlagEstado("1");

        List<SucursalResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("LM");
        assertThat(responses.get(1).getCodigo()).isEqualTo("PI");
    }

    @Test
    void toEntity_mapsAllFields() {
        SucursalRequest request = new SucursalRequest();
        request.setCodigo("LM");
        request.setNombre("Sucursal Principal");
        request.setDireccion("Av. Principal 123");
        request.setCiudad("Lima");
        request.setPaisId(1L);
        request.setDepartamentoId(15L);
        request.setProvinciaId(1501L);
        request.setDistritoId(150101L);
        request.setUbigeo("150101");
        request.setFlagEstado("1");

        Sucursal entity = mapper.toEntity(request);

        assertThat(entity.getCodigo()).isEqualTo("LM");
        assertThat(entity.getNombre()).isEqualTo("Sucursal Principal");
        assertThat(entity.getDireccion()).isEqualTo("Av. Principal 123");
        assertThat(entity.getCiudad()).isEqualTo("Lima");
        assertThat(entity.getPaisId()).isEqualTo(1L);
        assertThat(entity.getDepartamentoId()).isEqualTo(15L);
        assertThat(entity.getProvinciaId()).isEqualTo(1501L);
        assertThat(entity.getDistritoId()).isEqualTo(150101L);
        assertThat(entity.getUbigeo()).isEqualTo("150101");
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        Sucursal entity = new Sucursal();
        entity.setId(1L);
        entity.setCodigo("LM");
        entity.setNombre("Sucursal Principal");
        entity.setFlagEstado("1");

        SucursalRequest request = new SucursalRequest();
        request.setCodigo("PI");
        request.setNombre("Sucursal Norte");
        request.setDireccion("Av. Norte 456");
        request.setCiudad("Trujillo");
        request.setPaisId(1L);
        request.setDepartamentoId(13L);
        request.setProvinciaId(1301L);
        request.setDistritoId(130101L);
        request.setUbigeo("130101");
        request.setFlagEstado("1");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("PI");
        assertThat(entity.getNombre()).isEqualTo("Sucursal Norte");
        assertThat(entity.getDireccion()).isEqualTo("Av. Norte 456");
        assertThat(entity.getCiudad()).isEqualTo("Trujillo");
    }
}
