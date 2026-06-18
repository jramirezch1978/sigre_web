package pe.restaurant.ventas.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.ventas.entity.ZonaDespacho;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("ZonaDespachoMapper — Pruebas Unitarias")
class ZonaDespachoMapperTest {

    private final ZonaDespachoMapper mapper = Mappers.getMapper(ZonaDespachoMapper.class);

    @Test
    @DisplayName("toResponse() con entity válida -> mapea correctamente")
    void toResponse_conEntityValida_mapeaCorrectamente() {
        ZonaDespacho entity = new ZonaDespacho();
        entity.setId(1L);
        entity.setZonaDespacho("ZD-001");
        entity.setDescZonaDespacho("Zona Despacho Test");
        entity.setUbigeo("150101");
        entity.setFlagEstado("1");

        var response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getZonaDespacho()).isEqualTo("ZD-001");
        assertThat(response.getDescZonaDespacho()).isEqualTo("Zona Despacho Test");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponse() con null -> retorna null")
    void toResponse_conNull_retornaNull() {
        var response = mapper.toResponse(null);
        assertThat(response).isNull();
    }
}
