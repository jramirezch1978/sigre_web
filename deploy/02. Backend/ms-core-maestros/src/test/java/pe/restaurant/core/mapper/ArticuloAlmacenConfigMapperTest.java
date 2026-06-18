package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.ArticuloAlmacenConfigRequest;
import pe.restaurant.core.dto.ArticuloAlmacenConfigResponse;
import pe.restaurant.core.entity.ArticuloAlmacenConfig;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.assertThat;

class ArticuloAlmacenConfigMapperTest {

    private final ArticuloAlmacenConfigMapper mapper = Mappers.getMapper(ArticuloAlmacenConfigMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        ArticuloAlmacenConfig entity = new ArticuloAlmacenConfig();
        entity.setId(1L);
        entity.setArticuloId(10L);
        entity.setAlmacenId(20L);
        entity.setStockMin(new BigDecimal("5.00"));
        entity.setStockMax(new BigDecimal("100.00"));

        ArticuloAlmacenConfigResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getArticuloId()).isEqualTo(10L);
        assertThat(response.getAlmacenId()).isEqualTo(20L);
        assertThat(response.getStockMin()).isEqualByComparingTo(new BigDecimal("5.00"));
        assertThat(response.getStockMax()).isEqualByComparingTo(new BigDecimal("100.00"));
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toEntity_mapsAllFields() {
        ArticuloAlmacenConfigRequest request = new ArticuloAlmacenConfigRequest();
        request.setAlmacenId(20L);
        request.setStockMin(new BigDecimal("5.00"));
        request.setStockMax(new BigDecimal("100.00"));

        ArticuloAlmacenConfig entity = mapper.toEntity(request);

        assertThat(entity.getAlmacenId()).isEqualTo(20L);
        assertThat(entity.getStockMin()).isEqualByComparingTo(new BigDecimal("5.00"));
        assertThat(entity.getStockMax()).isEqualByComparingTo(new BigDecimal("100.00"));
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        ArticuloAlmacenConfig entity = new ArticuloAlmacenConfig();
        entity.setId(1L);
        entity.setArticuloId(10L);
        entity.setAlmacenId(20L);
        entity.setStockMin(new BigDecimal("5.00"));
        entity.setStockMax(new BigDecimal("100.00"));

        ArticuloAlmacenConfigRequest request = new ArticuloAlmacenConfigRequest();
        request.setAlmacenId(30L);
        request.setStockMin(new BigDecimal("10.00"));
        request.setStockMax(new BigDecimal("200.00"));

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getAlmacenId()).isEqualTo(30L);
        assertThat(entity.getStockMin()).isEqualByComparingTo(new BigDecimal("10.00"));
        assertThat(entity.getStockMax()).isEqualByComparingTo(new BigDecimal("200.00"));
    }
}
