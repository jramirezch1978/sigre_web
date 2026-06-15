package com.sigre.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.core.dto.ParametroSistemaRequest;
import com.sigre.core.dto.ParametroSistemaResponse;
import com.sigre.core.entity.ParametroSistema;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class ParametroSistemaMapperTest {

    private final ParametroSistemaMapper mapper = Mappers.getMapper(ParametroSistemaMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        ParametroSistema entity = new ParametroSistema();
        entity.setId(1L);
        entity.setCodigo("IGV_TASA");
        entity.setNombre("Tasa IGV");
        entity.setModulo("VENTAS");
        entity.setValor("18");
        entity.setTipoDato("NUMERICO");
        entity.setFlagEstado("1");

        ParametroSistemaResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("IGV_TASA");
        assertThat(response.getNombre()).isEqualTo("Tasa IGV");
        assertThat(response.getModulo()).isEqualTo("VENTAS");
        assertThat(response.getValor()).isEqualTo("18");
        assertThat(response.getTipoDato()).isEqualTo("NUMERICO");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        ParametroSistema e1 = new ParametroSistema();
        e1.setId(1L);
        e1.setCodigo("IGV_TASA");
        e1.setNombre("Tasa IGV");
        e1.setFlagEstado("1");

        ParametroSistema e2 = new ParametroSistema();
        e2.setId(2L);
        e2.setCodigo("MONEDA_DEF");
        e2.setNombre("Moneda Default");
        e2.setFlagEstado("1");

        List<ParametroSistemaResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("IGV_TASA");
        assertThat(responses.get(1).getCodigo()).isEqualTo("MONEDA_DEF");
    }

    @Test
    void toEntity_mapsAllFields() {
        ParametroSistemaRequest request = new ParametroSistemaRequest();
        request.setCodigo("IGV_TASA");
        request.setNombre("Tasa IGV");
        request.setModulo("VENTAS");
        request.setValor("18");
        request.setTipoDato("NUMERICO");
        request.setFlagEstado("1");

        ParametroSistema entity = mapper.toEntity(request);

        assertThat(entity.getCodigo()).isEqualTo("IGV_TASA");
        assertThat(entity.getNombre()).isEqualTo("Tasa IGV");
        assertThat(entity.getModulo()).isEqualTo("VENTAS");
        assertThat(entity.getValor()).isEqualTo("18");
        assertThat(entity.getTipoDato()).isEqualTo("NUMERICO");
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        ParametroSistema entity = new ParametroSistema();
        entity.setId(1L);
        entity.setCodigo("IGV_TASA");
        entity.setNombre("Tasa IGV");
        entity.setModulo("VENTAS");
        entity.setValor("18");
        entity.setTipoDato("NUMERICO");
        entity.setFlagEstado("1");

        ParametroSistemaRequest request = new ParametroSistemaRequest();
        request.setCodigo("IGV_TASA");
        request.setNombre("Tasa IGV Actualizada");
        request.setModulo("VENTAS");
        request.setValor("18.00");
        request.setTipoDato("DECIMAL");
        request.setFlagEstado("1");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getNombre()).isEqualTo("Tasa IGV Actualizada");
        assertThat(entity.getValor()).isEqualTo("18.00");
        assertThat(entity.getTipoDato()).isEqualTo("DECIMAL");
    }
}
