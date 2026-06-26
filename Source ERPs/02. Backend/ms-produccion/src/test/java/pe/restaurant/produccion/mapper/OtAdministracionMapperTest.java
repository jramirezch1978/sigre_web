package pe.restaurant.produccion.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.produccion.dto.request.OtAdministracionRequest;
import pe.restaurant.produccion.dto.response.OtAdministracionResponse;
import pe.restaurant.produccion.entity.OtAdministracion;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class OtAdministracionMapperTest {

    private final OtAdministracionMapper mapper = Mappers.getMapper(OtAdministracionMapper.class);

    @Test
    void toEntity_copiaCamposNegocio_eIgnoraIdYAuditoriaYFlagEstado() {
        OtAdministracionRequest req = new OtAdministracionRequest("ADM-CAMPO", "Administracion", "D");
        OtAdministracion out = mapper.toEntity(req);
        assertThat(out.getCodigo()).isEqualTo("ADM-CAMPO");
        assertThat(out.getNombre()).isEqualTo("Administracion");
        assertThat(out.getFlagTipoCosto()).isEqualTo("D");
        assertThat(out.getId()).isNull();
        assertThat(out.getCreatedBy()).isNull();
        assertThat(out.getFecCreacion()).isNull();
        assertThat(out.getUpdatedBy()).isNull();
        assertThat(out.getFecModificacion()).isNull();
        // default de la entity
        assertThat(out.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_copiaTodosLosCamposIncluyendoAuditoria() {
        OtAdministracion entity = new OtAdministracion();
        entity.setId(7L);
        entity.setCodigo("ADM-PLANTA");
        entity.setNombre("Administracion de planta");
        entity.setFlagTipoCosto("I");
        entity.setFlagEstado("1");
        entity.setCreatedBy(45L);
        entity.setFecCreacion(Instant.parse("2026-05-22T09:15:00Z"));
        entity.setUpdatedBy(46L);
        entity.setFecModificacion(Instant.parse("2026-05-22T11:00:00Z"));

        OtAdministracionResponse out = mapper.toResponse(entity);
        assertThat(out.getId()).isEqualTo(7L);
        assertThat(out.getCodigo()).isEqualTo("ADM-PLANTA");
        assertThat(out.getNombre()).isEqualTo("Administracion de planta");
        assertThat(out.getFlagTipoCosto()).isEqualTo("I");
        assertThat(out.getFlagEstado()).isEqualTo("1");
        assertThat(out.getCreatedBy()).isEqualTo(45L);
        assertThat(out.getFecCreacion()).isEqualTo(Instant.parse("2026-05-22T09:15:00Z"));
        assertThat(out.getUpdatedBy()).isEqualTo(46L);
        assertThat(out.getFecModificacion()).isEqualTo(Instant.parse("2026-05-22T11:00:00Z"));
    }

    @Test
    void toResponseList_mapeaCadaElemento() {
        OtAdministracion a = new OtAdministracion();
        a.setId(1L);
        a.setCodigo("A");
        OtAdministracion b = new OtAdministracion();
        b.setId(2L);
        b.setCodigo("B");

        List<OtAdministracionResponse> out = mapper.toResponseList(List.of(a, b));
        assertThat(out).extracting(OtAdministracionResponse::getId).containsExactly(1L, 2L);
        assertThat(out).extracting(OtAdministracionResponse::getCodigo).containsExactly("A", "B");
    }

    @Test
    void updateEntity_actualizaCamposNegocio_yPreservaAuditoriaYIdYFlagEstado() {
        OtAdministracion entity = new OtAdministracion();
        entity.setId(9L);
        entity.setCodigo("VIEJO");
        entity.setNombre("Viejo");
        entity.setFlagTipoCosto("D");
        entity.setFlagEstado("1");
        entity.setCreatedBy(5L);
        Instant fec = Instant.parse("2026-05-01T10:00:00Z");
        entity.setFecCreacion(fec);

        OtAdministracionRequest req = new OtAdministracionRequest("NUEVO", "Nuevo", "I");
        mapper.updateEntity(req, entity);

        assertThat(entity.getCodigo()).isEqualTo("NUEVO");
        assertThat(entity.getNombre()).isEqualTo("Nuevo");
        assertThat(entity.getFlagTipoCosto()).isEqualTo("I");
        assertThat(entity.getId()).isEqualTo(9L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getCreatedBy()).isEqualTo(5L);
        assertThat(entity.getFecCreacion()).isEqualTo(fec);
    }
}
