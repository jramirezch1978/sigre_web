package pe.restaurant.compras.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.compras.dto.ArticuloEstructuraRequest;
import pe.restaurant.compras.dto.ArticuloEstructuraResponse;
import pe.restaurant.compras.entity.ArticuloEstructura;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("ArticuloEstructuraMapper — Pruebas Unitarias")
class ArticuloEstructuraMapperTest {

    private final ArticuloEstructuraMapper mapper = Mappers.getMapper(ArticuloEstructuraMapper.class);

    @Test
    @DisplayName("toEntity() mapea campos y omite auditoria")
    void toEntity_mapeaCamposYOmiteAuditoria() {
        ArticuloEstructuraRequest req = new ArticuloEstructuraRequest(1L, 2L, new BigDecimal("5"));

        ArticuloEstructura entity = mapper.toEntity(req);

        assertThat(entity.getArticuloPadreId()).isEqualTo(1L);
        assertThat(entity.getArticuloHijoId()).isEqualTo(2L);
        assertThat(entity.getCantidad()).isEqualByComparingTo(new BigDecimal("5"));
        assertThat(entity.getCreatedBy()).isNull();
    }

    @Test
    @DisplayName("toResponse() mapea todos campos")
    void toResponse_mapeaTodosCampos() {
        ArticuloEstructura entity = new ArticuloEstructura();
        entity.setArticuloPadreId(1L);
        entity.setArticuloHijoId(2L);
        entity.setCantidad(new BigDecimal("3"));

        ArticuloEstructuraResponse resp = mapper.toResponse(entity);

        assertThat(resp.getArticuloPadreId()).isEqualTo(1L);
        assertThat(resp.getArticuloHijoId()).isEqualTo(2L);
        assertThat(resp.getCantidad()).isEqualByComparingTo(new BigDecimal("3"));
    }

    @Test
    @DisplayName("toResponseList() convierte multiples")
    void toResponseList_convierteMultiples() {
        ArticuloEstructura e1 = new ArticuloEstructura();
        e1.setArticuloPadreId(1L);
        e1.setArticuloHijoId(10L);
        e1.setCantidad(BigDecimal.ONE);
        ArticuloEstructura e2 = new ArticuloEstructura();
        e2.setArticuloPadreId(2L);
        e2.setArticuloHijoId(20L);
        e2.setCantidad(BigDecimal.TEN);

        List<ArticuloEstructuraResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getArticuloPadreId()).isEqualTo(1L);
        assertThat(result.get(1).getArticuloPadreId()).isEqualTo(2L);
    }

    @Test
    @DisplayName("updateEntity() ignora nulls y preserva auditoria")
    void updateEntity_ignoraNullsYPreservaAuditoria() {
        ArticuloEstructura entity = new ArticuloEstructura();
        entity.setArticuloPadreId(1L);
        entity.setArticuloHijoId(2L);
        entity.setCantidad(BigDecimal.ONE);

        ArticuloEstructuraRequest req = new ArticuloEstructuraRequest();
        req.setCantidad(new BigDecimal("99"));

        mapper.updateEntity(req, entity);

        assertThat(entity.getCantidad()).isEqualByComparingTo(new BigDecimal("99"));
    }

    @Test
    @DisplayName("toEntity() con null -> retorna null")
    void toEntity_conNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    @DisplayName("toResponse() con null -> retorna null")
    void toResponse_conNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() con null -> retorna null")
    void toResponseList_conNull_retornaNull() {
        assertThat(mapper.toResponseList(null)).isNull();
    }
}
