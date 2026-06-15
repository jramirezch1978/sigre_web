package com.sigre.comercializacion.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.comercializacion.entity.ZonaReparto;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("ZonaRepartoMapper — Pruebas Unitarias")
class ZonaRepartoMapperTest {

    private final ZonaRepartoMapper mapper = Mappers.getMapper(ZonaRepartoMapper.class);

    @Test
    @DisplayName("toResponse() con entity válida -> mapea correctamente")
    void toResponse_conEntityValida_mapeaCorrectamente() {
        ZonaReparto entity = new ZonaReparto();
        entity.setId(1L);
        entity.setZonaReparto("ZR-001");
        entity.setDescZonaReparto("Zona Reparto Test");
        entity.setUbigeo("150101");
        entity.setFlagEstado("1");

        var response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getZonaReparto()).isEqualTo("ZR-001");
        assertThat(response.getDescZonaReparto()).isEqualTo("Zona Reparto Test");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponse() con null -> retorna null")
    void toResponse_conNull_retornaNull() {
        var response = mapper.toResponse(null);
        assertThat(response).isNull();
    }
}
