package com.sigre.compras.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.compras.dto.AprobadorConfiguradoRequest;
import com.sigre.compras.dto.AprobadorConfiguradoResponse;
import com.sigre.compras.entity.AprobadorConfigurado;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AprobadorConfiguradoMapperTest {

    private final AprobadorConfiguradoMapper mapper = Mappers.getMapper(AprobadorConfiguradoMapper.class);

    @Test
    void toEntity_mapeaCamposYOmiteIdYFlag() {
        AprobadorConfiguradoRequest req = new AprobadorConfiguradoRequest(
                1L, 1, 10L, BigDecimal.ZERO, new BigDecimal("100000"));

        AprobadorConfigurado entity = mapper.toEntity(req);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getDocTipoId()).isEqualTo(1L);
        assertThat(entity.getNivel()).isEqualTo(1);
        assertThat(entity.getAprobadorId()).isEqualTo(10L);
        assertThat(entity.getMontoMinimo()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(entity.getMontoMaximo()).isEqualByComparingTo(new BigDecimal("100000"));
    }

    @Test
    void toResponse_mapeaTodosCampos() {
        AprobadorConfigurado entity = new AprobadorConfigurado();
        entity.setId(1L);
        entity.setDocTipoId(2L);
        entity.setNivel(2);
        entity.setAprobadorId(20L);
        entity.setMontoMinimo(new BigDecimal("1000"));
        entity.setMontoMaximo(new BigDecimal("50000"));
        entity.setFlagEstado("1");

        AprobadorConfiguradoResponse resp = mapper.toResponse(entity);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getDocTipoId()).isEqualTo(2L);
        assertThat(resp.getNivel()).isEqualTo(2);
        assertThat(resp.getAprobadorId()).isEqualTo(20L);
        assertThat(resp.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponseList_convierteMultiples() {
        AprobadorConfigurado a1 = new AprobadorConfigurado();
        a1.setId(1L);
        a1.setDocTipoId(1L);
        AprobadorConfigurado a2 = new AprobadorConfigurado();
        a2.setId(2L);
        a2.setDocTipoId(2L);

        List<AprobadorConfiguradoResponse> result = mapper.toResponseList(List.of(a1, a2));

        assertThat(result).hasSize(2);
    }

    @Test
    void updateEntity_ignoraNullsYPreservaIdYFlag() {
        AprobadorConfigurado entity = new AprobadorConfigurado();
        entity.setId(1L);
        entity.setDocTipoId(1L);
        entity.setNivel(1);
        entity.setAprobadorId(10L);
        entity.setFlagEstado("1");

        AprobadorConfiguradoRequest req = new AprobadorConfiguradoRequest();
        req.setNivel(3);

        mapper.updateEntity(req, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getNivel()).isEqualTo(3);
        assertThat(entity.getDocTipoId()).isEqualTo(1L);
    }

    @Test
    void toEntity_conNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void toResponseList_conNull_retornaNull() {
        assertThat(mapper.toResponseList(null)).isNull();
    }

    @Test
    void updateEntity_conRequestNull_preservaEntidad() {
        AprobadorConfigurado entity = new AprobadorConfigurado();
        entity.setId(9L);
        entity.setNivel(2);
        entity.setFlagEstado("1");

        mapper.updateEntity(null, entity);

        assertThat(entity.getId()).isEqualTo(9L);
        assertThat(entity.getNivel()).isEqualTo(2);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }
}
