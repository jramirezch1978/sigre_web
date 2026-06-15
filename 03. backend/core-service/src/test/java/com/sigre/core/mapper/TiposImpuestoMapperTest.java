package com.sigre.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.core.dto.TiposImpuestoRequest;
import com.sigre.core.dto.TiposImpuestoResponse;
import com.sigre.core.entity.TiposImpuesto;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class TiposImpuestoMapperTest {

    private final TiposImpuestoMapper mapper = Mappers.getMapper(TiposImpuestoMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        TiposImpuesto entity = new TiposImpuesto();
        entity.setId(1L);
        entity.setTipoImpuesto("IGV");
        entity.setPlanContableDetId(100L);
        entity.setDescImpuesto("Impuesto General a las Ventas");
        entity.setTasaImpuesto(new BigDecimal("18.0000"));
        entity.setSigno("+");
        entity.setFlagDhCxp("D");
        entity.setFlagIgv("1");
        entity.setTipoCalculo(2);
        entity.setFlagEstado("1");

        TiposImpuestoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTipoImpuesto()).isEqualTo("IGV");
        assertThat(response.getPlanContableDetId()).isEqualTo(100L);
        assertThat(response.getDescImpuesto()).isEqualTo("Impuesto General a las Ventas");
        assertThat(response.getTasaImpuesto()).isEqualByComparingTo(new BigDecimal("18"));
        assertThat(response.getSigno()).isEqualTo("+");
        assertThat(response.getFlagDhCxp()).isEqualTo("D");
        assertThat(response.getFlagIgv()).isEqualTo("1");
        assertThat(response.getTipoCalculo()).isEqualTo(2);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        TiposImpuesto e1 = new TiposImpuesto();
        e1.setId(1L);
        e1.setTipoImpuesto("IGV");
        e1.setDescImpuesto("IGV");
        e1.setTasaImpuesto(new BigDecimal("18.0000"));
        e1.setFlagEstado("1");

        TiposImpuesto e2 = new TiposImpuesto();
        e2.setId(2L);
        e2.setTipoImpuesto("ISC");
        e2.setDescImpuesto("ISC");
        e2.setTasaImpuesto(new BigDecimal("10.0000"));
        e2.setFlagEstado("1");

        List<TiposImpuestoResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getTipoImpuesto()).isEqualTo("IGV");
        assertThat(responses.get(1).getTipoImpuesto()).isEqualTo("ISC");
    }

    @Test
    void toEntity_mapsAllFields() {
        TiposImpuestoRequest request = new TiposImpuestoRequest();
        request.setTipoImpuesto("IGV");
        request.setPlanContableDetId(100L);
        request.setDescImpuesto("Impuesto General a las Ventas");
        request.setTasaImpuesto(new BigDecimal("18.00"));
        request.setSigno("+");
        request.setFlagDhCxp("D");
        request.setFlagIgv("1");
        request.setTipoCalculo(1);

        TiposImpuesto entity = mapper.toEntity(request);

        assertThat(entity.getTipoImpuesto()).isEqualTo("IGV");
        assertThat(entity.getPlanContableDetId()).isEqualTo(100L);
        assertThat(entity.getDescImpuesto()).isEqualTo("Impuesto General a las Ventas");
        assertThat(entity.getTasaImpuesto()).isEqualByComparingTo(new BigDecimal("18.00"));
        assertThat(entity.getSigno()).isEqualTo("+");
        assertThat(entity.getFlagDhCxp()).isEqualTo("D");
        assertThat(entity.getFlagIgv()).isEqualTo("1");
        assertThat(entity.getTipoCalculo()).isEqualTo(1);
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        TiposImpuesto entity = new TiposImpuesto();
        entity.setId(1L);
        entity.setTipoImpuesto("IGV");
        entity.setDescImpuesto("IGV");
        entity.setTasaImpuesto(new BigDecimal("18.0000"));
        entity.setSigno("+");
        entity.setFlagDhCxp("D");
        entity.setFlagIgv("1");
        entity.setFlagEstado("1");

        TiposImpuestoRequest request = new TiposImpuestoRequest();
        request.setTipoImpuesto("ISC");
        request.setPlanContableDetId(200L);
        request.setDescImpuesto("Impuesto Selectivo al Consumo");
        request.setTasaImpuesto(new BigDecimal("10.00"));
        request.setSigno("+");
        request.setFlagDhCxp("H");
        request.setFlagIgv("0");
        request.setTipoCalculo(2);

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getTipoImpuesto()).isEqualTo("ISC");
        assertThat(entity.getPlanContableDetId()).isEqualTo(200L);
        assertThat(entity.getDescImpuesto()).isEqualTo("Impuesto Selectivo al Consumo");
        assertThat(entity.getTasaImpuesto()).isEqualByComparingTo(new BigDecimal("10.00"));
        assertThat(entity.getTipoCalculo()).isEqualTo(2);
    }
}
