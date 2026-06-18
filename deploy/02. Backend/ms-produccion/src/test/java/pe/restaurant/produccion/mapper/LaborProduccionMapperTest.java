package pe.restaurant.produccion.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.produccion.dto.response.LaborProduccionResponse;
import pe.restaurant.produccion.entity.LaborProduccion;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class LaborProduccionMapperTest {

    private final LaborProduccionMapper mapper = Mappers.getMapper(LaborProduccionMapper.class);

    @Test
    void toResponse_copiaTodosLosCamposIncluyendoAuditoria() {
        LaborProduccion entity = new LaborProduccion();
        entity.setId(60L);
        entity.setLaborId(1L);
        entity.setArticuloId(200L);
        entity.setCreatedBy(45L);
        entity.setFecCreacion(Instant.parse("2026-05-22T09:40:00Z"));

        LaborProduccionResponse out = mapper.toResponse(entity);
        assertThat(out.getId()).isEqualTo(60L);
        assertThat(out.getLaborId()).isEqualTo(1L);
        assertThat(out.getArticuloId()).isEqualTo(200L);
        assertThat(out.getCreatedBy()).isEqualTo(45L);
        assertThat(out.getFecCreacion()).isEqualTo(Instant.parse("2026-05-22T09:40:00Z"));
    }

    @Test
    void toResponseList_mapeaCadaElemento() {
        LaborProduccion a = new LaborProduccion();
        a.setId(1L);
        a.setArticuloId(200L);
        LaborProduccion b = new LaborProduccion();
        b.setId(2L);
        b.setArticuloId(201L);

        List<LaborProduccionResponse> out = mapper.toResponseList(List.of(a, b));
        assertThat(out).extracting(LaborProduccionResponse::getId).containsExactly(1L, 2L);
        assertThat(out).extracting(LaborProduccionResponse::getArticuloId).containsExactly(200L, 201L);
    }
}
