package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.ConversionUnidadRequest;
import pe.restaurant.core.dto.ConversionUnidadResponse;
import pe.restaurant.core.entity.ConversionUnidad;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class ConversionUnidadMapperTest {

    private final ConversionUnidadMapper mapper = Mappers.getMapper(ConversionUnidadMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        ConversionUnidad entity = new ConversionUnidad();
        entity.setId(1L);
        entity.setUmOrigenId(10L);
        entity.setUmDestinoId(20L);
        entity.setFactorConversion(new BigDecimal("1.500000"));
        entity.setFlagEstado("1");
        entity.setArticuloId(30L);

        ConversionUnidadResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getUmOrigenId()).isEqualTo(10L);
        assertThat(response.getUmDestinoId()).isEqualTo(20L);
        assertThat(response.getFactorConversion()).isEqualByComparingTo(new BigDecimal("1.5"));
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getArticuloId()).isEqualTo(30L);
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        ConversionUnidad e1 = new ConversionUnidad();
        e1.setId(1L);
        e1.setUmOrigenId(10L);
        e1.setUmDestinoId(20L);
        e1.setFactorConversion(BigDecimal.ONE);
        e1.setFlagEstado("1");

        ConversionUnidad e2 = new ConversionUnidad();
        e2.setId(2L);
        e2.setUmOrigenId(11L);
        e2.setUmDestinoId(21L);
        e2.setFactorConversion(new BigDecimal("2.000000"));
        e2.setFlagEstado("1");

        List<ConversionUnidadResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getUmOrigenId()).isEqualTo(10L);
        assertThat(responses.get(1).getUmOrigenId()).isEqualTo(11L);
    }

    @Test
    void toEntity_mapsAllFields() {
        ConversionUnidadRequest request = new ConversionUnidadRequest();
        request.setArticuloId(30L);
        request.setUmOrigenId(10L);
        request.setUmDestinoId(20L);
        request.setFactorConversion(new BigDecimal("1.5"));

        ConversionUnidad entity = mapper.toEntity(request);

        assertThat(entity.getArticuloId()).isEqualTo(30L);
        assertThat(entity.getUmOrigenId()).isEqualTo(10L);
        assertThat(entity.getUmDestinoId()).isEqualTo(20L);
        assertThat(entity.getFactorConversion()).isEqualByComparingTo(new BigDecimal("1.5"));
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        ConversionUnidad entity = new ConversionUnidad();
        entity.setId(1L);
        entity.setUmOrigenId(10L);
        entity.setUmDestinoId(20L);
        entity.setFactorConversion(BigDecimal.ONE);
        entity.setFlagEstado("1");

        ConversionUnidadRequest request = new ConversionUnidadRequest();
        request.setArticuloId(31L);
        request.setUmOrigenId(11L);
        request.setUmDestinoId(21L);
        request.setFactorConversion(new BigDecimal("3.0"));

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getUmOrigenId()).isEqualTo(11L);
        assertThat(entity.getUmDestinoId()).isEqualTo(21L);
        assertThat(entity.getFactorConversion()).isEqualByComparingTo(new BigDecimal("3.0"));
    }
}
