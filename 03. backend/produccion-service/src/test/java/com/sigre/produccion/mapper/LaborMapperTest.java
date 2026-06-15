package com.sigre.produccion.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.produccion.dto.request.LaborRequest;
import com.sigre.produccion.dto.response.LaborResponse;
import com.sigre.produccion.entity.Labor;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class LaborMapperTest {

    private final LaborMapper mapper = Mappers.getMapper(LaborMapper.class);

    @Test
    void toEntity_copiaCamposNegocio_eIgnoraIdYAuditoriaYFlagEstado() {
        LaborRequest req = new LaborRequest("LAB-COSECHA", "Labor de cosecha");
        Labor out = mapper.toEntity(req);
        assertThat(out.getCodigo()).isEqualTo("LAB-COSECHA");
        assertThat(out.getNombre()).isEqualTo("Labor de cosecha");
        assertThat(out.getId()).isNull();
        assertThat(out.getCreatedBy()).isNull();
        assertThat(out.getFecCreacion()).isNull();
        assertThat(out.getUpdatedBy()).isNull();
        assertThat(out.getFecModificacion()).isNull();
        assertThat(out.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_copiaTodosLosCamposIncluyendoAuditoria() {
        Labor entity = new Labor();
        entity.setId(7L);
        entity.setCodigo("LAB-SIEMBRA");
        entity.setNombre("Labor de siembra");
        entity.setFlagEstado("1");
        entity.setCreatedBy(45L);
        entity.setFecCreacion(Instant.parse("2026-05-22T09:15:00Z"));
        entity.setUpdatedBy(46L);
        entity.setFecModificacion(Instant.parse("2026-05-22T11:00:00Z"));

        LaborResponse out = mapper.toResponse(entity);
        assertThat(out.getId()).isEqualTo(7L);
        assertThat(out.getCodigo()).isEqualTo("LAB-SIEMBRA");
        assertThat(out.getNombre()).isEqualTo("Labor de siembra");
        assertThat(out.getFlagEstado()).isEqualTo("1");
        assertThat(out.getCreatedBy()).isEqualTo(45L);
        assertThat(out.getFecCreacion()).isEqualTo(Instant.parse("2026-05-22T09:15:00Z"));
        assertThat(out.getUpdatedBy()).isEqualTo(46L);
        assertThat(out.getFecModificacion()).isEqualTo(Instant.parse("2026-05-22T11:00:00Z"));
    }

    @Test
    void toResponseList_mapeaCadaElemento() {
        Labor a = new Labor();
        a.setId(1L);
        a.setCodigo("A");
        Labor b = new Labor();
        b.setId(2L);
        b.setCodigo("B");

        List<LaborResponse> out = mapper.toResponseList(List.of(a, b));
        assertThat(out).extracting(LaborResponse::getId).containsExactly(1L, 2L);
        assertThat(out).extracting(LaborResponse::getCodigo).containsExactly("A", "B");
    }

    @Test
    void updateEntity_actualizaCamposNegocio_yPreservaIdYAuditoriaYFlagEstado() {
        Labor entity = new Labor();
        entity.setId(9L);
        entity.setCodigo("VIEJO");
        entity.setNombre("Viejo");
        entity.setFlagEstado("1");
        entity.setCreatedBy(5L);
        Instant fec = Instant.parse("2026-05-01T10:00:00Z");
        entity.setFecCreacion(fec);

        LaborRequest req = new LaborRequest("NUEVO", "Nuevo");
        mapper.updateEntity(req, entity);

        assertThat(entity.getCodigo()).isEqualTo("NUEVO");
        assertThat(entity.getNombre()).isEqualTo("Nuevo");
        assertThat(entity.getId()).isEqualTo(9L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getCreatedBy()).isEqualTo(5L);
        assertThat(entity.getFecCreacion()).isEqualTo(fec);
    }
}
