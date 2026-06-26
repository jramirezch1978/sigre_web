package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.UnidadMedidaRequest;
import pe.restaurant.core.dto.UnidadMedidaResponse;
import pe.restaurant.core.entity.UnidadMedida;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class UnidadMedidaMapperTest {

    private final UnidadMedidaMapper mapper = Mappers.getMapper(UnidadMedidaMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        UnidadMedida entity = new UnidadMedida();
        entity.setId(1L);
        entity.setCodigo("KG");
        entity.setNombre("Kilogramo");
        entity.setAbreviatura("kg");
        entity.setFlagEstado("1");

        UnidadMedidaResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("KG");
        assertThat(response.getNombre()).isEqualTo("Kilogramo");
        assertThat(response.getAbreviatura()).isEqualTo("kg");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        UnidadMedida e1 = new UnidadMedida();
        e1.setId(1L);
        e1.setCodigo("KG");
        e1.setNombre("Kilogramo");
        e1.setFlagEstado("1");

        UnidadMedida e2 = new UnidadMedida();
        e2.setId(2L);
        e2.setCodigo("UND");
        e2.setNombre("Unidad");
        e2.setFlagEstado("1");

        List<UnidadMedidaResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("KG");
        assertThat(responses.get(1).getCodigo()).isEqualTo("UND");
    }

    @Test
    void toEntity_mapsAllFields() {
        UnidadMedidaRequest request = new UnidadMedidaRequest();
        request.setCodigo("KG");
        request.setNombre("Kilogramo");
        request.setAbreviatura("kg");
        request.setFlagEstado("1");

        UnidadMedida entity = mapper.toEntity(request);

        assertThat(entity.getCodigo()).isEqualTo("KG");
        assertThat(entity.getNombre()).isEqualTo("Kilogramo");
        assertThat(entity.getAbreviatura()).isEqualTo("kg");
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        UnidadMedida entity = new UnidadMedida();
        entity.setId(1L);
        entity.setCodigo("KG");
        entity.setNombre("Kilogramo");
        entity.setAbreviatura("kg");
        entity.setFlagEstado("1");

        UnidadMedidaRequest request = new UnidadMedidaRequest();
        request.setCodigo("UND");
        request.setNombre("Unidad");
        request.setAbreviatura("und");
        request.setFlagEstado("1");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("UND");
        assertThat(entity.getNombre()).isEqualTo("Unidad");
        assertThat(entity.getAbreviatura()).isEqualTo("und");
    }
}
