package com.sigre.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.core.dto.MonedaRequest;
import com.sigre.core.dto.MonedaResponse;
import com.sigre.core.entity.Moneda;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class MonedaMapperTest {

    private final MonedaMapper mapper = Mappers.getMapper(MonedaMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        Moneda entity = new Moneda();
        entity.setId(1L);
        entity.setCodigo("PEN");
        entity.setSiglaMoneda("SOL");
        entity.setNombre("Sol Peruano");
        entity.setSimbolo("S/");
        entity.setDecimales(2);
        entity.setFlagEstado("1");

        MonedaResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("PEN");
        assertThat(response.getSiglaMoneda()).isEqualTo("SOL");
        assertThat(response.getNombre()).isEqualTo("Sol Peruano");
        assertThat(response.getSimbolo()).isEqualTo("S/");
        assertThat(response.getDecimales()).isEqualTo(2);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        Moneda e1 = new Moneda();
        e1.setId(1L);
        e1.setCodigo("PEN");
        e1.setNombre("Sol Peruano");
        e1.setFlagEstado("1");

        Moneda e2 = new Moneda();
        e2.setId(2L);
        e2.setCodigo("USD");
        e2.setNombre("Dolar Americano");
        e2.setFlagEstado("1");

        List<MonedaResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("PEN");
        assertThat(responses.get(1).getCodigo()).isEqualTo("USD");
    }

    @Test
    void toEntity_mapsAllFields() {
        MonedaRequest request = new MonedaRequest();
        request.setCodigo("PEN");
        request.setSiglaMoneda("SOL");
        request.setNombre("Sol Peruano");
        request.setSimbolo("S/");
        request.setDecimales(2);
        request.setFlagEstado("1");

        Moneda entity = mapper.toEntity(request);

        assertThat(entity.getCodigo()).isEqualTo("PEN");
        assertThat(entity.getSiglaMoneda()).isEqualTo("SOL");
        assertThat(entity.getNombre()).isEqualTo("Sol Peruano");
        assertThat(entity.getSimbolo()).isEqualTo("S/");
        assertThat(entity.getDecimales()).isEqualTo(2);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        Moneda entity = new Moneda();
        entity.setId(1L);
        entity.setCodigo("PEN");
        entity.setNombre("Sol Peruano");
        entity.setFlagEstado("1");

        MonedaRequest request = new MonedaRequest();
        request.setCodigo("USD");
        request.setSiglaMoneda("DOL");
        request.setNombre("Dolar Americano");
        request.setSimbolo("$");
        request.setDecimales(2);
        request.setFlagEstado("1");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("USD");
        assertThat(entity.getSiglaMoneda()).isEqualTo("DOL");
        assertThat(entity.getNombre()).isEqualTo("Dolar Americano");
        assertThat(entity.getSimbolo()).isEqualTo("$");
    }
}
