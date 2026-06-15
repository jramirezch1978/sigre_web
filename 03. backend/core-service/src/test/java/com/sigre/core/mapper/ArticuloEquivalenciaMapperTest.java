package com.sigre.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.core.dto.ArticuloEquivalenciaRequest;
import com.sigre.core.dto.ArticuloEquivalenciaResponse;
import com.sigre.core.entity.ArticuloEquivalencia;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class ArticuloEquivalenciaMapperTest {

    private final ArticuloEquivalenciaMapper mapper = Mappers.getMapper(ArticuloEquivalenciaMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        ArticuloEquivalencia entity = new ArticuloEquivalencia();
        entity.setId(1L);
        entity.setArticuloId(10L);
        entity.setArticuloEquivalenteId(20L);
        entity.setFactor(new BigDecimal("2.500000"));
        entity.setFlagEstado("1");

        ArticuloEquivalenciaResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getArticuloId()).isEqualTo(10L);
        assertThat(response.getArticuloEquivalenteId()).isEqualTo(20L);
        assertThat(response.getFactor()).isEqualByComparingTo(new BigDecimal("2.5"));
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        ArticuloEquivalencia e1 = new ArticuloEquivalencia();
        e1.setId(1L);
        e1.setArticuloId(10L);
        e1.setArticuloEquivalenteId(20L);
        e1.setFactor(BigDecimal.ONE);
        e1.setFlagEstado("1");

        ArticuloEquivalencia e2 = new ArticuloEquivalencia();
        e2.setId(2L);
        e2.setArticuloId(11L);
        e2.setArticuloEquivalenteId(21L);
        e2.setFactor(new BigDecimal("3.000000"));
        e2.setFlagEstado("1");

        List<ArticuloEquivalenciaResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getArticuloId()).isEqualTo(10L);
        assertThat(responses.get(1).getArticuloId()).isEqualTo(11L);
    }

    @Test
    void toEntity_mapsAllFields() {
        ArticuloEquivalenciaRequest request = new ArticuloEquivalenciaRequest();
        request.setArticuloId(10L);
        request.setArticuloEquivalenteId(20L);
        request.setFactor(new BigDecimal("2.5"));

        ArticuloEquivalencia entity = mapper.toEntity(request);

        assertThat(entity.getArticuloId()).isEqualTo(10L);
        assertThat(entity.getArticuloEquivalenteId()).isEqualTo(20L);
        assertThat(entity.getFactor()).isEqualByComparingTo(new BigDecimal("2.5"));
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        ArticuloEquivalencia entity = new ArticuloEquivalencia();
        entity.setId(1L);
        entity.setArticuloId(10L);
        entity.setArticuloEquivalenteId(20L);
        entity.setFactor(BigDecimal.ONE);
        entity.setFlagEstado("1");

        ArticuloEquivalenciaRequest request = new ArticuloEquivalenciaRequest();
        request.setArticuloId(11L);
        request.setArticuloEquivalenteId(21L);
        request.setFactor(new BigDecimal("5.0"));

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getArticuloId()).isEqualTo(11L);
        assertThat(entity.getArticuloEquivalenteId()).isEqualTo(21L);
        assertThat(entity.getFactor()).isEqualByComparingTo(new BigDecimal("5.0"));
    }
}
