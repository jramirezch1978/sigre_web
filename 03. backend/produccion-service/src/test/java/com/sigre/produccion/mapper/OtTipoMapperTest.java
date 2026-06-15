package com.sigre.produccion.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.produccion.dto.request.OtTipoRequest;
import com.sigre.produccion.dto.response.OtTipoResponse;
import com.sigre.produccion.entity.OtTipo;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class OtTipoMapperTest {

    private final OtTipoMapper mapper = Mappers.getMapper(OtTipoMapper.class);

    @Test
    void toEntity_copiaCodigoYNombre_eIgnoraAuditoriaYFlagEstadoYId() {
        OtTipoRequest req = new OtTipoRequest("MANT", "Mantenimiento");
        OtTipo out = mapper.toEntity(req);
        assertThat(out.getCodigo()).isEqualTo("MANT");
        assertThat(out.getNombre()).isEqualTo("Mantenimiento");
        assertThat(out.getId()).isNull();
        assertThat(out.getCreatedBy()).isNull();
        assertThat(out.getFecCreacion()).isNull();
        assertThat(out.getUpdatedBy()).isNull();
        assertThat(out.getFecModificacion()).isNull();
        // flagEstado lo asigna el service o el default de la entity ("1").
        assertThat(out.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_copiaTodosLosCamposIncluyendoAuditoria() {
        OtTipo entity = new OtTipo();
        entity.setId(7L);
        entity.setCodigo("PROD");
        entity.setNombre("Produccion");
        entity.setFlagEstado("1");
        entity.setCreatedBy(10L);
        entity.setFecCreacion(Instant.parse("2026-05-22T14:00:00Z"));
        entity.setUpdatedBy(11L);
        entity.setFecModificacion(Instant.parse("2026-05-22T15:00:00Z"));

        OtTipoResponse out = mapper.toResponse(entity);

        assertThat(out.getId()).isEqualTo(7L);
        assertThat(out.getCodigo()).isEqualTo("PROD");
        assertThat(out.getNombre()).isEqualTo("Produccion");
        assertThat(out.getFlagEstado()).isEqualTo("1");
        assertThat(out.getCreatedBy()).isEqualTo(10L);
        assertThat(out.getFecCreacion()).isEqualTo(Instant.parse("2026-05-22T14:00:00Z"));
        assertThat(out.getUpdatedBy()).isEqualTo(11L);
        assertThat(out.getFecModificacion()).isEqualTo(Instant.parse("2026-05-22T15:00:00Z"));
    }

    @Test
    void toResponseList_mapeaCadaElemento() {
        OtTipo a = new OtTipo();
        a.setId(1L);
        a.setCodigo("A");
        OtTipo b = new OtTipo();
        b.setId(2L);
        b.setCodigo("B");

        List<OtTipoResponse> out = mapper.toResponseList(List.of(a, b));
        assertThat(out).extracting(OtTipoResponse::getId).containsExactly(1L, 2L);
        assertThat(out).extracting(OtTipoResponse::getCodigo).containsExactly("A", "B");
    }

    @Test
    void updateEntity_actualizaCodigoYNombre_yPreservaAuditoriaYId() {
        OtTipo entity = new OtTipo();
        entity.setId(9L);
        entity.setCodigo("VIEJO");
        entity.setNombre("Viejo");
        entity.setFlagEstado("1");
        entity.setCreatedBy(5L);
        Instant fec = Instant.parse("2026-05-01T10:00:00Z");
        entity.setFecCreacion(fec);

        OtTipoRequest req = new OtTipoRequest("NUEVO", "Nuevo");
        mapper.updateEntity(req, entity);

        assertThat(entity.getCodigo()).isEqualTo("NUEVO");
        assertThat(entity.getNombre()).isEqualTo("Nuevo");
        assertThat(entity.getId()).isEqualTo(9L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getCreatedBy()).isEqualTo(5L);
        assertThat(entity.getFecCreacion()).isEqualTo(fec);
    }
}
