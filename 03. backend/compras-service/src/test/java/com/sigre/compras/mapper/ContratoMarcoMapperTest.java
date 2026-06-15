package com.sigre.compras.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.compras.dto.ContratoMarcoRequest;
import com.sigre.compras.entity.ContratoMarco;

import java.time.LocalDate;
import java.time.OffsetDateTime;

import static org.assertj.core.api.Assertions.assertThat;

class ContratoMarcoMapperTest {

    private final ContratoMarcoMapper mapper = Mappers.getMapper(ContratoMarcoMapper.class);

    @Test
    void toEntity_mapeaCamposYOmiteCamposIgnorados() {
        ContratoMarcoRequest req = new ContratoMarcoRequest();
        req.setProveedorId(10L);
        req.setFechaInicio(LocalDate.of(2026, 1, 1));
        req.setFechaFin(LocalDate.of(2027, 1, 1));
        req.setCondiciones("Pago 30 días");

        ContratoMarco entity = mapper.toEntity(req);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getNroContrato()).isNull();
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getProveedorId()).isEqualTo(10L);
        assertThat(entity.getFechaInicio()).isEqualTo(LocalDate.of(2026, 1, 1));
        assertThat(entity.getFechaFin()).isEqualTo(LocalDate.of(2027, 1, 1));
        assertThat(entity.getCondiciones()).isEqualTo("Pago 30 días");
    }

    @Test
    void updateEntity_preservaCamposIgnoradosYActualizaResto() {
        ContratoMarco entity = new ContratoMarco();
        entity.setId(1L);
        entity.setNroContrato("CM-001");
        entity.setProveedorId(10L);
        entity.setFechaInicio(LocalDate.of(2026, 1, 1));
        entity.setFechaFin(LocalDate.of(2027, 1, 1));
        entity.setCondiciones("Original");
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(OffsetDateTime.now());

        ContratoMarcoRequest req = new ContratoMarcoRequest();
        req.setProveedorId(20L);
        req.setCondiciones("Actualizado");
        req.setFechaInicio(LocalDate.of(2026, 6, 1));
        req.setFechaFin(LocalDate.of(2028, 6, 1));

        mapper.updateEntity(req, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getNroContrato()).isEqualTo("CM-001");
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getCreatedBy()).isEqualTo(1L);
        assertThat(entity.getProveedorId()).isEqualTo(20L);
        assertThat(entity.getCondiciones()).isEqualTo("Actualizado");
    }

    @Test
    void toEntity_conNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_conRequestNull_preservaEntidad() {
        ContratoMarco entity = new ContratoMarco();
        entity.setId(1L);
        entity.setNroContrato("CM-001");
        entity.setCondiciones("Original");

        mapper.updateEntity(null, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getNroContrato()).isEqualTo("CM-001");
        assertThat(entity.getCondiciones()).isEqualTo("Original");
    }
}
