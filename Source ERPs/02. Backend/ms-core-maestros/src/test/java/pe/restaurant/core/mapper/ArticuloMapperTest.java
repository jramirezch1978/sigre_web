package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.ArticuloRequest;
import pe.restaurant.core.dto.ArticuloResponse;
import pe.restaurant.core.entity.Articulo;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class ArticuloMapperTest {

    private final ArticuloMapper mapper = Mappers.getMapper(ArticuloMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        Articulo entity = new Articulo();
        entity.setId(1L);
        entity.setCodigo("ART001");
        entity.setNombre("Articulo Uno");
        entity.setDescripcion("Descripcion del articulo");
        entity.setUnidadMedidaId(5L);
        entity.setArticuloCategId(10L);
        entity.setArticuloSubCategId(20L);
        entity.setArticuloClaseId(30L);
        entity.setNaturalezaContableId(40L);
        entity.setMarcaId(50L);
        entity.setColorId(60L);
        entity.setFlagEstado("1");

        ArticuloResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("ART001");
        assertThat(response.getNombre()).isEqualTo("Articulo Uno");
        assertThat(response.getDescripcion()).isEqualTo("Descripcion del articulo");
        assertThat(response.getUnidadMedidaId()).isEqualTo(5L);
        assertThat(response.getArticuloCategId()).isEqualTo(10L);
        assertThat(response.getArticuloSubCategId()).isEqualTo(20L);
        assertThat(response.getArticuloClaseId()).isEqualTo(30L);
        assertThat(response.getNaturalezaContableId()).isEqualTo(40L);
        assertThat(response.getMarcaId()).isEqualTo(50L);
        assertThat(response.getColorId()).isEqualTo(60L);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        Articulo e1 = new Articulo();
        e1.setId(1L);
        e1.setCodigo("ART001");
        e1.setNombre("Articulo Uno");
        e1.setFlagEstado("1");

        Articulo e2 = new Articulo();
        e2.setId(2L);
        e2.setCodigo("ART002");
        e2.setNombre("Articulo Dos");
        e2.setFlagEstado("1");

        List<ArticuloResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("ART001");
        assertThat(responses.get(1).getCodigo()).isEqualTo("ART002");
    }

    @Test
    void toEntity_mapsAllFields() {
        ArticuloRequest request = new ArticuloRequest();
        request.setCodigo("ART001");
        request.setNombre("Articulo Uno");
        request.setTipo("PRODUCTO");
        request.setDescripcion("Descripcion");
        request.setUnidadMedidaId(5L);
        request.setArticuloCategId(10L);
        request.setArticuloSubCategId(20L);
        request.setArticuloClaseId(30L);
        request.setNaturalezaContableId(40L);
        request.setMarcaId(50L);
        request.setColorId(60L);
        request.setFlagEstado("1");

        Articulo entity = mapper.toEntity(request);

        assertThat(entity.getCodigo()).isEqualTo("ART001");
        assertThat(entity.getNombre()).isEqualTo("Articulo Uno");
        assertThat(entity.getTipo()).isEqualTo("PRODUCTO");
        assertThat(entity.getDescripcion()).isEqualTo("Descripcion");
        assertThat(entity.getUnidadMedidaId()).isEqualTo(5L);
        assertThat(entity.getArticuloCategId()).isEqualTo(10L);
        assertThat(entity.getArticuloSubCategId()).isEqualTo(20L);
        assertThat(entity.getArticuloClaseId()).isEqualTo(30L);
        assertThat(entity.getNaturalezaContableId()).isEqualTo(40L);
        assertThat(entity.getMarcaId()).isEqualTo(50L);
        assertThat(entity.getColorId()).isEqualTo(60L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        Articulo entity = new Articulo();
        entity.setId(1L);
        entity.setCodigo("ART001");
        entity.setNombre("Articulo Uno");
        entity.setTipo("PRODUCTO");
        entity.setFlagEstado("1");

        ArticuloRequest request = new ArticuloRequest();
        request.setCodigo("ART002");
        request.setNombre("Articulo Dos");
        request.setTipo("SERVICIO");
        request.setDescripcion("Nueva descripcion");
        request.setUnidadMedidaId(7L);
        request.setArticuloCategId(11L);
        request.setArticuloSubCategId(21L);
        request.setArticuloClaseId(31L);
        request.setNaturalezaContableId(41L);
        request.setMarcaId(51L);
        request.setColorId(61L);
        request.setFlagEstado("0");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("ART002");
        assertThat(entity.getNombre()).isEqualTo("Articulo Dos");
        assertThat(entity.getTipo()).isEqualTo("SERVICIO");
        assertThat(entity.getDescripcion()).isEqualTo("Nueva descripcion");
        assertThat(entity.getUnidadMedidaId()).isEqualTo(7L);
    }
}
