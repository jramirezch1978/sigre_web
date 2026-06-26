package pe.restaurant.ventas.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.ventas.VentasTestFixtures;
import pe.restaurant.ventas.dto.request.ZonaVentaRequest;
import pe.restaurant.ventas.dto.response.ZonaVentaResponse;
import pe.restaurant.ventas.entity.ZonaVenta;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("ZonaVentaMapper — Pruebas Unitarias")
class ZonaVentaMapperTest {

    private final ZonaVentaMapper mapper = Mappers.getMapper(ZonaVentaMapper.class);

    @Test
    @DisplayName("toEntity() con request válido -> mapea correctamente")
    void toEntity_conRequestValido_mapeaCorrectamente() {
        ZonaVentaRequest request = VentasTestFixtures.zonaVentaRequest();

        ZonaVenta entity = mapper.toEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getZonaVenta()).isEqualTo("ZV-TEST-REQ");
        assertThat(entity.getDescZonaVenta()).isEqualTo("Zona Venta Test Request");
        assertThat(entity.getId()).isNull();
    }

    @Test
    @DisplayName("toResponse() con entity válida -> mapea correctamente")
    void toResponse_conEntityValida_mapeaCorrectamente() {
        ZonaVenta entity = VentasTestFixtures.zonaVentaEntity(1L, "1");

        ZonaVentaResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getZonaVenta()).isEqualTo("ZV-1");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() con lista -> mapea correctamente")
    void toResponseList_conLista_mapeaCorrectamente() {
        List<ZonaVenta> entities = List.of(
            VentasTestFixtures.zonaVentaEntity(1L, "1"),
            VentasTestFixtures.zonaVentaEntity(2L, "1")
        );

        List<ZonaVentaResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
    }
}
