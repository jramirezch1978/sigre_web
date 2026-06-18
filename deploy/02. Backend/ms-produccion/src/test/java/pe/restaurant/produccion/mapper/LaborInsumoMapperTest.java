package pe.restaurant.produccion.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.produccion.dto.response.LaborInsumoResponse;
import pe.restaurant.produccion.entity.LaborInsumo;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class LaborInsumoMapperTest {

    private final LaborInsumoMapper mapper = Mappers.getMapper(LaborInsumoMapper.class);

    @Test
    void toResponse_copiaTodosLosCamposIncluyendoAuditoria() {
        LaborInsumo entity = new LaborInsumo();
        entity.setId(50L);
        entity.setLaborId(1L);
        entity.setArticuloId(100L);
        entity.setCreatedBy(45L);
        entity.setFecCreacion(Instant.parse("2026-05-22T09:30:00Z"));

        LaborInsumoResponse out = mapper.toResponse(entity);
        assertThat(out.getId()).isEqualTo(50L);
        assertThat(out.getLaborId()).isEqualTo(1L);
        assertThat(out.getArticuloId()).isEqualTo(100L);
        assertThat(out.getCreatedBy()).isEqualTo(45L);
        assertThat(out.getFecCreacion()).isEqualTo(Instant.parse("2026-05-22T09:30:00Z"));
    }

    @Test
    void toResponseList_mapeaCadaElemento() {
        LaborInsumo a = new LaborInsumo();
        a.setId(1L);
        a.setArticuloId(100L);
        LaborInsumo b = new LaborInsumo();
        b.setId(2L);
        b.setArticuloId(101L);

        List<LaborInsumoResponse> out = mapper.toResponseList(List.of(a, b));
        assertThat(out).extracting(LaborInsumoResponse::getId).containsExactly(1L, 2L);
        assertThat(out).extracting(LaborInsumoResponse::getArticuloId).containsExactly(100L, 101L);
    }
}
