package pe.restaurant.finanzas.mapper;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.finanzas.dto.request.RetencionRequest;
import pe.restaurant.finanzas.dto.response.RetencionResponse;
import pe.restaurant.finanzas.entity.Retencion;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@DisplayName("Pruebas Unitarias - RetencionMapper")
class RetencionMapperTest {

    private RetencionMapper mapper;
    private Retencion entity;
    private RetencionRequest request;

    @BeforeEach
    void setUp() {
        mapper = Mappers.getMapper(RetencionMapper.class);

        entity = new Retencion();
        entity.setId(1L);
        entity.setCntasPagarId(100L);
        entity.setNroCertificado("RET-001");
        entity.setFechaEmision(LocalDate.of(2026, 5, 1));
        entity.setProveedorId(50L);
        entity.setNroRegCajaBan(2001L);
        entity.setImporteDoc(new BigDecimal("1000.00"));
        entity.setSaldoSol(BigDecimal.ZERO);
        entity.setSaldoDol(BigDecimal.ZERO);
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.now());

        request = new RetencionRequest();
        request.setCntasPagarId(100L);
        request.setNroCertificado("RET-001");
        request.setFechaEmision(LocalDate.of(2026, 5, 1));
        request.setProveedorId(50L);
        request.setNroRegCajaBan(2001L);
        request.setImporteDoc(new BigDecimal("1000.00"));
    }

    // ==== toEntity — escenarios felices ====

    @Test
    @DisplayName("toEntity() con request valido -> retorna entity")
    void toEntity_conRequestValido_retornaEntity() {
        Retencion result = mapper.toEntity(request);

        assertThat(result).isNotNull();
        assertThat(result.getCntasPagarId()).isEqualTo(100L);
        assertThat(result.getNroCertificado()).isEqualTo("RET-001");
        assertThat(result.getFechaEmision()).isEqualTo(LocalDate.of(2026, 5, 1));
        assertThat(result.getProveedorId()).isEqualTo(50L);
        assertThat(result.getNroRegCajaBan()).isEqualTo(2001L);
        assertThat(result.getImporteDoc()).isEqualByComparingTo(new BigDecimal("1000.00"));
    }

    // ==== toEntity — edge cases ====

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    // ==== toResponse — escenarios felices ====

    @Test
    @DisplayName("toResponse() con entity valida -> retorna response")
    void toResponse_conEntityValida_retornaResponse() {
        RetencionResponse result = mapper.toResponse(entity);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getCntasPagarId()).isEqualTo(100L);
        assertThat(result.getNroCertificado()).isEqualTo("RET-001");
        assertThat(result.getFechaEmision()).isEqualTo(LocalDate.of(2026, 5, 1));
        assertThat(result.getProveedorId()).isEqualTo(50L);
        assertThat(result.getNroRegCajaBan()).isEqualTo(2001L);
        assertThat(result.getImporteDoc()).isEqualByComparingTo(new BigDecimal("1000.00"));
    }

    // ==== toResponse — edge cases ====

    @Test
    @DisplayName("toResponse() con entity null -> retorna null")
    void toResponse_conEntityNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    // ==== toResponseList ====

    @Test
    @DisplayName("toResponseList() con lista valida -> retorna lista")
    void toResponseList_conListaValida_retornaLista() {
        List<RetencionResponse> result = mapper.toResponseList(List.of(entity, entity));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("toResponseList() con lista vacia -> retorna lista vacia")
    void toResponseList_conListaVacia_retornaListaVacia() {
        assertThat(mapper.toResponseList(new ArrayList<>())).isEmpty();
    }
}
