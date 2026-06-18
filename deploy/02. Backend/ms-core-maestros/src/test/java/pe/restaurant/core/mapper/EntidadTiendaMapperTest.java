package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.EntidadTiendaRequest;
import pe.restaurant.core.dto.EntidadTiendaResponse;
import pe.restaurant.core.entity.EntidadTienda;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class EntidadTiendaMapperTest {

    private final EntidadTiendaMapper mapper = Mappers.getMapper(EntidadTiendaMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        EntidadTienda entity = new EntidadTienda();
        entity.setId(1L);
        entity.setEntidadContribuyenteId(10L);
        entity.setCodigo("T001");
        entity.setNombre("Tienda Central");
        entity.setDireccion("Av. Principal 123");
        entity.setFlagEstado("1");

        EntidadTiendaResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getEntidadContribuyenteId()).isEqualTo(10L);
        assertThat(response.getCodigo()).isEqualTo("T001");
        assertThat(response.getNombre()).isEqualTo("Tienda Central");
        assertThat(response.getDireccion()).isEqualTo("Av. Principal 123");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        EntidadTienda e1 = new EntidadTienda();
        e1.setId(1L);
        e1.setEntidadContribuyenteId(10L);
        e1.setCodigo("T001");
        e1.setNombre("Tienda Central");
        e1.setFlagEstado("1");

        EntidadTienda e2 = new EntidadTienda();
        e2.setId(2L);
        e2.setEntidadContribuyenteId(10L);
        e2.setCodigo("T002");
        e2.setNombre("Tienda Norte");
        e2.setFlagEstado("1");

        List<EntidadTiendaResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("T001");
        assertThat(responses.get(1).getCodigo()).isEqualTo("T002");
    }

    @Test
    void toEntity_mapsAllFields() {
        EntidadTiendaRequest request = new EntidadTiendaRequest();
        request.setCodigo("T001");
        request.setNombre("Tienda Central");
        request.setDireccion("Av. Principal 123");

        EntidadTienda entity = mapper.toEntity(request);

        assertThat(entity.getCodigo()).isEqualTo("T001");
        assertThat(entity.getNombre()).isEqualTo("Tienda Central");
        assertThat(entity.getDireccion()).isEqualTo("Av. Principal 123");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_ignoresNullFields() {
        EntidadTienda entity = new EntidadTienda();
        entity.setId(1L);
        entity.setEntidadContribuyenteId(10L);
        entity.setCodigo("T001");
        entity.setNombre("Tienda Central");
        entity.setDireccion("Av. Principal 123");
        entity.setFlagEstado("1");

        EntidadTiendaRequest request = new EntidadTiendaRequest();
        request.setNombre("Tienda Renovada");
        request.setCodigo(null);
        request.setDireccion(null);

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getNombre()).isEqualTo("Tienda Renovada");
        assertThat(entity.getCodigo()).isEqualTo("T001");
        assertThat(entity.getDireccion()).isEqualTo("Av. Principal 123");
    }
}
