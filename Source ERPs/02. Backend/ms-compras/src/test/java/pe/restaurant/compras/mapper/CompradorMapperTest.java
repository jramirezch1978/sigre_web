package pe.restaurant.compras.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.compras.dto.CompradorRequest;
import pe.restaurant.compras.dto.CompradorResponse;
import pe.restaurant.compras.entity.Comprador;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class CompradorMapperTest {

    private final CompradorMapper mapper = Mappers.getMapper(CompradorMapper.class);

    @Test
    void toEntity_mapeaCamposYOmiteId() {
        CompradorRequest req = new CompradorRequest(5L, "Juan Pérez", "1");

        Comprador entity = mapper.toEntity(req);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getUsuarioId()).isEqualTo(5L);
        assertThat(entity.getNombre()).isEqualTo("Juan Pérez");
    }

    @Test
    void toResponse_mapeaTodosCampos() {
        Comprador entity = new Comprador(1L, 5L, "Juan Pérez", "1");

        CompradorResponse resp = mapper.toResponse(entity);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getUsuarioId()).isEqualTo(5L);
        assertThat(resp.getNombre()).isEqualTo("Juan Pérez");
        assertThat(resp.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponseList_convierteMultiples() {
        Comprador c1 = new Comprador(1L, 5L, "A", "1");
        Comprador c2 = new Comprador(2L, 6L, "B", "0");

        List<CompradorResponse> result = mapper.toResponseList(List.of(c1, c2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getNombre()).isEqualTo("A");
        assertThat(result.get(1).getNombre()).isEqualTo("B");
    }

    @Test
    void toResponseList_listaVacia() {
        List<CompradorResponse> result = mapper.toResponseList(List.of());
        assertThat(result).isEmpty();
    }

    @Test
    void updateEntity_soloActualizaCamposNoNull() {
        Comprador entity = new Comprador(1L, 5L, "Viejo", "1");
        CompradorRequest req = new CompradorRequest();
        req.setNombre("Nuevo");

        mapper.updateEntity(req, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getNombre()).isEqualTo("Nuevo");
        assertThat(entity.getUsuarioId()).isEqualTo(5L);
    }

    @Test
    void toEntity_conNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void toResponse_conNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_conNull_retornaNull() {
        assertThat(mapper.toResponseList(null)).isNull();
    }

    @Test
    void updateEntity_conRequestNull_preservaEntidad() {
        Comprador entity = new Comprador(1L, 5L, "Viejo", "1");

        mapper.updateEntity(null, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getUsuarioId()).isEqualTo(5L);
        assertThat(entity.getNombre()).isEqualTo("Viejo");
    }
}
