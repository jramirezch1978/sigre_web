package pe.restaurant.ventas.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.ventas.VentasTestFixtures;
import pe.restaurant.ventas.dto.request.VendedorRequest;
import pe.restaurant.ventas.dto.response.VendedorResponse;
import pe.restaurant.ventas.entity.Vendedor;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("VendedorMapper — Pruebas Unitarias")
class VendedorMapperTest {

    private final VendedorMapper mapper = Mappers.getMapper(VendedorMapper.class);

    @Test
    @DisplayName("toEntity() con request válido -> mapea correctamente")
    void toEntity_conRequestValido_mapeaCorrectamente() {
        VendedorRequest request = VentasTestFixtures.vendedorRequest();

        Vendedor entity = mapper.toEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getUsuarioId()).isEqualTo(1L);
        assertThat(entity.getNombre()).isEqualTo("Vendedor Test Request");
        assertThat(entity.getId()).isNull();
    }

    @Test
    @DisplayName("toResponse() con entity válida -> mapea correctamente")
    void toResponse_conEntityValida_mapeaCorrectamente() {
        Vendedor entity = VentasTestFixtures.vendedorEntity(1L, "1");

        VendedorResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() con lista -> mapea correctamente")
    void toResponseList_conLista_mapeaCorrectamente() {
        List<Vendedor> entities = List.of(
            VentasTestFixtures.vendedorEntity(1L, "1"),
            VentasTestFixtures.vendedorEntity(2L, "1")
        );

        List<VendedorResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
    }
}
