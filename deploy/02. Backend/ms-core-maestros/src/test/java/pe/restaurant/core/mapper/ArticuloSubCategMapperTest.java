package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.ArticuloSubCategRequest;
import pe.restaurant.core.dto.ArticuloSubCategResponse;
import pe.restaurant.core.entity.ArticuloSubCateg;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class ArticuloSubCategMapperTest {

    private final ArticuloSubCategMapper mapper = Mappers.getMapper(ArticuloSubCategMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        ArticuloSubCateg entity = new ArticuloSubCateg();
        entity.setId(1L);
        entity.setCodSubCat("SUB01");
        entity.setDescSubcateg("Subcategoria Uno");
        entity.setArticuloCategId(10L);
        entity.setFlagEstado("1");

        ArticuloSubCategResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodSubCat()).isEqualTo("SUB01");
        assertThat(response.getDescSubcateg()).isEqualTo("Subcategoria Uno");
        assertThat(response.getArticuloCategId()).isEqualTo(10L);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        ArticuloSubCateg e1 = new ArticuloSubCateg();
        e1.setId(1L);
        e1.setCodSubCat("SUB01");
        e1.setDescSubcateg("Subcategoria Uno");
        e1.setArticuloCategId(10L);
        e1.setFlagEstado("1");

        ArticuloSubCateg e2 = new ArticuloSubCateg();
        e2.setId(2L);
        e2.setCodSubCat("SUB02");
        e2.setDescSubcateg("Subcategoria Dos");
        e2.setArticuloCategId(10L);
        e2.setFlagEstado("1");

        List<ArticuloSubCategResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodSubCat()).isEqualTo("SUB01");
        assertThat(responses.get(1).getCodSubCat()).isEqualTo("SUB02");
    }

    @Test
    void toEntity_mapsAllFields() {
        ArticuloSubCategRequest request = new ArticuloSubCategRequest();
        request.setCodSubCat("SUB01");
        request.setDescSubcateg("Subcategoria Uno");
        request.setArticuloCategId(10L);

        ArticuloSubCateg entity = mapper.toEntity(request);

        assertThat(entity.getCodSubCat()).isEqualTo("SUB01");
        assertThat(entity.getDescSubcateg()).isEqualTo("Subcategoria Uno");
        assertThat(entity.getArticuloCategId()).isEqualTo(10L);
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        ArticuloSubCateg entity = new ArticuloSubCateg();
        entity.setId(1L);
        entity.setCodSubCat("SUB01");
        entity.setDescSubcateg("Subcategoria Uno");
        entity.setArticuloCategId(10L);
        entity.setFlagEstado("1");

        ArticuloSubCategRequest request = new ArticuloSubCategRequest();
        request.setCodSubCat("SUB02");
        request.setDescSubcateg("Subcategoria Dos");
        request.setArticuloCategId(20L);

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodSubCat()).isEqualTo("SUB02");
        assertThat(entity.getDescSubcateg()).isEqualTo("Subcategoria Dos");
        assertThat(entity.getArticuloCategId()).isEqualTo(20L);
    }
}
