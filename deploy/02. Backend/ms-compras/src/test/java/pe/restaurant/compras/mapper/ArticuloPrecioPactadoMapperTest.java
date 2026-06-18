package pe.restaurant.compras.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.compras.dto.ArticuloPrecioPactadoRequest;
import pe.restaurant.compras.dto.ArticuloPrecioPactadoResponse;
import pe.restaurant.compras.entity.ArticuloPrecioPactado;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("ArticuloPrecioPactadoMapper — Pruebas Unitarias")
class ArticuloPrecioPactadoMapperTest {

    private final ArticuloPrecioPactadoMapper mapper = Mappers.getMapper(ArticuloPrecioPactadoMapper.class);

    @Test
    @DisplayName("toEntity() mapea campos y omite id y flag")
    void toEntity_mapeaCamposYOmiteIdYFlag() {
        ArticuloPrecioPactadoRequest req = new ArticuloPrecioPactadoRequest(
                100L, 10L, new BigDecimal("50.00"), 1L,
                LocalDate.of(2026, 1, 1), LocalDate.of(2026, 12, 31));

        ArticuloPrecioPactado entity = mapper.toEntity(req);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getArticuloId()).isEqualTo(100L);
        assertThat(entity.getProveedorId()).isEqualTo(10L);
        assertThat(entity.getPrecio()).isEqualByComparingTo(new BigDecimal("50.00"));
        assertThat(entity.getMonedaId()).isEqualTo(1L);
        assertThat(entity.getFechaDesde()).isEqualTo(LocalDate.of(2026, 1, 1));
        assertThat(entity.getFechaHasta()).isEqualTo(LocalDate.of(2026, 12, 31));
    }

    @Test
    @DisplayName("toResponse() mapea todos campos")
    void toResponse_mapeaTodosCampos() {
        ArticuloPrecioPactado entity = new ArticuloPrecioPactado();
        entity.setId(1L);
        entity.setArticuloId(100L);
        entity.setProveedorId(10L);
        entity.setPrecio(new BigDecimal("75.50"));
        entity.setMonedaId(1L);
        entity.setFechaDesde(LocalDate.of(2026, 3, 1));
        entity.setFechaHasta(LocalDate.of(2026, 9, 30));
        entity.setFlagEstado("1");

        ArticuloPrecioPactadoResponse resp = mapper.toResponse(entity);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getArticuloId()).isEqualTo(100L);
        assertThat(resp.getProveedorId()).isEqualTo(10L);
        assertThat(resp.getPrecio()).isEqualByComparingTo(new BigDecimal("75.50"));
        assertThat(resp.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() convierte multiples")
    void toResponseList_convierteMultiples() {
        ArticuloPrecioPactado e1 = new ArticuloPrecioPactado();
        e1.setId(1L);
        e1.setArticuloId(100L);
        ArticuloPrecioPactado e2 = new ArticuloPrecioPactado();
        e2.setId(2L);
        e2.setArticuloId(200L);

        List<ArticuloPrecioPactadoResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
    }

    @Test
    @DisplayName("updateEntity() ignora nulls y preserva id y flag")
    void updateEntity_ignoraNullsYPreservaIdYFlag() {
        ArticuloPrecioPactado entity = new ArticuloPrecioPactado();
        entity.setId(1L);
        entity.setArticuloId(100L);
        entity.setProveedorId(10L);
        entity.setPrecio(new BigDecimal("50"));
        entity.setFlagEstado("1");

        ArticuloPrecioPactadoRequest req = new ArticuloPrecioPactadoRequest();
        req.setPrecio(new BigDecimal("99"));

        mapper.updateEntity(req, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getPrecio()).isEqualByComparingTo(new BigDecimal("99"));
        assertThat(entity.getArticuloId()).isEqualTo(100L);
    }

    @Test
    @DisplayName("toEntity() con null -> retorna null")
    void toEntity_conNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    @DisplayName("toResponse() con null -> retorna null")
    void toResponse_conNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() con null -> retorna null")
    void toResponseList_conNull_retornaNull() {
        assertThat(mapper.toResponseList(null)).isNull();
    }
}
