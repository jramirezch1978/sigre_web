package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.ArticuloCategRequest;
import pe.restaurant.core.dto.ArticuloCategResponse;
import pe.restaurant.core.entity.ArticuloCateg;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class ArticuloCategMapperTest {

    private final ArticuloCategMapper mapper = Mappers.getMapper(ArticuloCategMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        ArticuloCateg entity = new ArticuloCateg();
        entity.setId(1L);
        entity.setCatArt("CAT001");
        entity.setDescCateg("Categoria Uno");
        entity.setFlagEstado("1");

        ArticuloCategResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCatArt()).isEqualTo("CAT001");
        assertThat(response.getDescCateg()).isEqualTo("Categoria Uno");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        ArticuloCateg e1 = new ArticuloCateg();
        e1.setId(1L);
        e1.setCatArt("CAT001");
        e1.setDescCateg("Categoria Uno");
        e1.setFlagEstado("1");

        ArticuloCateg e2 = new ArticuloCateg();
        e2.setId(2L);
        e2.setCatArt("CAT002");
        e2.setDescCateg("Categoria Dos");
        e2.setFlagEstado("1");

        List<ArticuloCategResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCatArt()).isEqualTo("CAT001");
        assertThat(responses.get(1).getCatArt()).isEqualTo("CAT002");
    }

    @Test
    void toEntity_mapsAllFields() {
        ArticuloCategRequest request = new ArticuloCategRequest();
        request.setCatArt("CAT001");
        request.setDescCateg("Categoria Uno");

        ArticuloCateg entity = mapper.toEntity(request);

        assertThat(entity.getCatArt()).isEqualTo("CAT001");
        assertThat(entity.getDescCateg()).isEqualTo("Categoria Uno");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        ArticuloCateg entity = new ArticuloCateg();
        entity.setId(1L);
        entity.setCatArt("CAT001");
        entity.setDescCateg("Categoria Uno");
        entity.setFlagEstado("1");

        ArticuloCategRequest request = new ArticuloCategRequest();
        request.setCatArt("CAT002");
        request.setDescCateg("Categoria Dos");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCatArt()).isEqualTo("CAT002");
        assertThat(entity.getDescCateg()).isEqualTo("Categoria Dos");
    }
}
