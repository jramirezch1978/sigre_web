package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.ArticuloProveedorResponse;
import pe.restaurant.core.entity.ArticuloProveedor;

import static org.assertj.core.api.Assertions.assertThat;

class ArticuloProveedorMapperTest {

    private final ArticuloProveedorMapper mapper = Mappers.getMapper(ArticuloProveedorMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        ArticuloProveedor entity = new ArticuloProveedor();
        entity.setId(1L);
        entity.setArticuloId(10L);
        entity.setProveedorId(20L);
        entity.setFlagEstado("1");

        ArticuloProveedorResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getArticuloId()).isEqualTo(10L);
        assertThat(response.getProveedorId()).isEqualTo(20L);
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }
}
