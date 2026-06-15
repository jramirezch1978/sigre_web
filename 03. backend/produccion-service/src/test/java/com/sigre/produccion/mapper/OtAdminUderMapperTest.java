package com.sigre.produccion.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.produccion.dto.response.OtAdminUderResponse;
import com.sigre.produccion.entity.OtAdminUder;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class OtAdminUderMapperTest {

    private final OtAdminUderMapper mapper = Mappers.getMapper(OtAdminUderMapper.class);

    @Test
    void toResponse_copiaTodosLosCamposIncluyendoAuditoria() {
        OtAdminUder entity = new OtAdminUder();
        entity.setId(50L);
        entity.setOtAdministracionId(1L);
        entity.setUsuarioId(10L);
        entity.setFlagEstado("1");
        entity.setCreatedBy(45L);
        entity.setFecCreacion(Instant.parse("2026-05-22T09:30:00Z"));

        OtAdminUderResponse out = mapper.toResponse(entity);

        assertThat(out.getId()).isEqualTo(50L);
        assertThat(out.getOtAdministracionId()).isEqualTo(1L);
        assertThat(out.getUsuarioId()).isEqualTo(10L);
        assertThat(out.getFlagEstado()).isEqualTo("1");
        assertThat(out.getCreatedBy()).isEqualTo(45L);
        assertThat(out.getFecCreacion()).isEqualTo(Instant.parse("2026-05-22T09:30:00Z"));
    }

    @Test
    void toResponseList_mapeaCadaElemento() {
        OtAdminUder a = new OtAdminUder();
        a.setId(1L);
        a.setUsuarioId(10L);
        OtAdminUder b = new OtAdminUder();
        b.setId(2L);
        b.setUsuarioId(11L);

        List<OtAdminUderResponse> out = mapper.toResponseList(List.of(a, b));
        assertThat(out).extracting(OtAdminUderResponse::getId).containsExactly(1L, 2L);
        assertThat(out).extracting(OtAdminUderResponse::getUsuarioId).containsExactly(10L, 11L);
    }
}
