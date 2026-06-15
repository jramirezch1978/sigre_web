package com.sigre.comercializacion.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.comercializacion.entity.CanalDistribucion;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("CanalDistribucionMapper — Pruebas Unitarias")
class CanalDistribucionMapperTest {

    private final CanalDistribucionMapper mapper = Mappers.getMapper(CanalDistribucionMapper.class);

    @Test
    @DisplayName("toResponse() con entity válida -> mapea correctamente")
    void toResponse_conEntityValida_mapeaCorrectamente() {
        CanalDistribucion entity = new CanalDistribucion();
        entity.setId(1L);
        entity.setCodigo("CD-001");
        entity.setNombre("Canal Test");
        entity.setFlagEstado("1");

        var response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("CD-001");
        assertThat(response.getNombre()).isEqualTo("Canal Test");
    }

    @Test
    @DisplayName("toResponse() con null -> retorna null")
    void toResponse_conNull_retornaNull() {
        var response = mapper.toResponse(null);
        assertThat(response).isNull();
    }
}
