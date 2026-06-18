package pe.restaurant.ventas.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.ventas.VentasTestFixtures;
import pe.restaurant.ventas.dto.request.ZonaRequest;
import pe.restaurant.ventas.dto.response.ZonaResponse;
import pe.restaurant.ventas.entity.Zona;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("ZonaMapper — Pruebas Unitarias")
class ZonaMapperTest {

    private final ZonaMapper mapper = Mappers.getMapper(ZonaMapper.class);

    @Test
    @DisplayName("toEntity() con request válido -> mapea correctamente")
    void toEntity_conRequestValido_mapeaCorrectamente() {
        ZonaRequest request = VentasTestFixtures.zonaRequest();

        Zona entity = mapper.toEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getNombre()).isEqualTo("Zona Test Request");
        assertThat(entity.getCapacidad()).isEqualTo(20);
        assertThat(entity.getId()).isNull();
    }

    @Test
    @DisplayName("toResponse() con entity válida -> mapea correctamente")
    void toResponse_conEntityValida_mapeaCorrectamente() {
        Zona entity = VentasTestFixtures.zonaEntity(1L, "1");

        ZonaResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("Zona Test 1");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() con lista -> mapea correctamente")
    void toResponseList_conLista_mapeaCorrectamente() {
        List<Zona> entities = List.of(
            VentasTestFixtures.zonaEntity(1L, "1"),
            VentasTestFixtures.zonaEntity(2L, "1")
        );

        List<ZonaResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
    }

    @Test
    @DisplayName("updateEntity() actualiza campos modificables")
    void updateEntity_actualizaCamposModificables() {
        Zona existing = VentasTestFixtures.zonaEntity(5L, "1");
        ZonaRequest request = new ZonaRequest();
        request.setNombre("Zona Modificada");
        request.setCapacidad(30);

        mapper.updateEntity(request, existing);

        assertThat(existing.getId()).isEqualTo(5L);
        assertThat(existing.getNombre()).isEqualTo("Zona Modificada");
        assertThat(existing.getCapacidad()).isEqualTo(30);
    }
}
