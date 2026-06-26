package pe.restaurant.compras.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.compras.dto.CompradorCategoriaResponse;
import pe.restaurant.compras.entity.CompradorCategoria;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class CompradorCategoriaMapperTest {

    private final CompradorCategoriaMapper mapper = Mappers.getMapper(CompradorCategoriaMapper.class);

    @Test
    void toResponse_mapeaTodosCampos() {
        CompradorCategoria entity = new CompradorCategoria(1L, 5L, 10L);

        CompradorCategoriaResponse resp = mapper.toResponse(entity);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getCompradorId()).isEqualTo(5L);
        assertThat(resp.getArticuloCategId()).isEqualTo(10L);
    }

    @Test
    void toResponseList_convierteMultiples() {
        CompradorCategoria c1 = new CompradorCategoria(1L, 5L, 10L);
        CompradorCategoria c2 = new CompradorCategoria(2L, 5L, 20L);

        List<CompradorCategoriaResponse> result = mapper.toResponseList(List.of(c1, c2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getArticuloCategId()).isEqualTo(10L);
        assertThat(result.get(1).getArticuloCategId()).isEqualTo(20L);
    }

    @Test
    void toResponseList_listaVacia() {
        List<CompradorCategoriaResponse> result = mapper.toResponseList(List.of());
        assertThat(result).isEmpty();
    }

    @Test
    void toResponse_conNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_conNull_retornaNull() {
        assertThat(mapper.toResponseList(null)).isNull();
    }
}
