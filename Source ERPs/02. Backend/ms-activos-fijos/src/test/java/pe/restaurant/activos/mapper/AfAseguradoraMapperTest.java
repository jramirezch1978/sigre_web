package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfAseguradoraRequest;
import pe.restaurant.activos.dto.AfAseguradoraResponse;
import pe.restaurant.activos.entity.AfAseguradora;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfAseguradoraMapperTest {

    private final AfAseguradoraMapper mapper = Mappers.getMapper(AfAseguradoraMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfAseguradora entity = new AfAseguradora();
        entity.setId(1L);
        entity.setNombre("Rímac Seguros");
        entity.setRuc("20100041953");
        entity.setContacto("Juan Pérez");
        entity.setFlagEstado("1");

        AfAseguradoraResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("Rímac Seguros");
        assertThat(response.getRuc()).isEqualTo("20100041953");
        assertThat(response.getContacto()).isEqualTo("Juan Pérez");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfAseguradora e1 = new AfAseguradora();
        e1.setId(1L);
        e1.setNombre("Aseg 1");
        AfAseguradora e2 = new AfAseguradora();
        e2.setId(2L);
        e2.setNombre("Aseg 2");

        List<AfAseguradoraResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getNombre()).isEqualTo("Aseg 1");
        assertThat(result.get(1).getNombre()).isEqualTo("Aseg 2");
    }

    @Test
    void toEntity_mapsAllFields() {
        AfAseguradoraRequest request = new AfAseguradoraRequest();
        request.setNombre("Rímac Seguros");
        request.setRuc("20100041953");
        request.setContacto("Juan Pérez");

        AfAseguradora entity = mapper.toEntity(request);

        assertThat(entity.getNombre()).isEqualTo("Rímac Seguros");
        assertThat(entity.getRuc()).isEqualTo("20100041953");
        assertThat(entity.getContacto()).isEqualTo("Juan Pérez");
        assertThat(entity.getId()).isNull();
        assertThat(entity.getFlagEstado()).isNotNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfAseguradora entity = new AfAseguradora();
        entity.setId(99L);
        entity.setFlagEstado("1");
        entity.setNombre("Antigua");

        AfAseguradoraRequest request = new AfAseguradoraRequest();
        request.setNombre("Pacífico Seguros");
        request.setRuc("20332970411");
        request.setContacto("María López");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getNombre()).isEqualTo("Pacífico Seguros");
        assertThat(entity.getRuc()).isEqualTo("20332970411");
        assertThat(entity.getContacto()).isEqualTo("María López");
    }
}
