package pe.restaurant.finanzas.mapper;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import org.springframework.test.util.ReflectionTestUtils;
import pe.restaurant.finanzas.dto.request.ConciliacionBancariaRequest;
import pe.restaurant.finanzas.dto.response.ConciliacionBancariaResponse;
import pe.restaurant.finanzas.entity.ConciliacionBancaria;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@DisplayName("Pruebas Unitarias - ConciliacionBancariaMapper")
class ConciliacionBancariaMapperTest {

    private ConciliacionBancariaMapper mapper;
    private ConciliacionBancaria entity;
    private ConciliacionBancariaRequest request;

    @BeforeEach
    void setUp() {
        ConciliacionDetMapper detMapper = Mappers.getMapper(ConciliacionDetMapper.class);
        ConciliacionBancariaMapperImpl impl = new ConciliacionBancariaMapperImpl();
        ReflectionTestUtils.setField(impl, "conciliacionDetMapper", detMapper);
        mapper = impl;

        entity = new ConciliacionBancaria();
        entity.setId(1L);
        entity.setBancoCntaId(10L);
        entity.setPeriodoAnio(2026);
        entity.setPeriodoMes(5);
        entity.setSaldoBanco(new BigDecimal("10000.00"));
        entity.setSaldoLibros(new BigDecimal("10000.00"));
        entity.setDiferencia(BigDecimal.ZERO);
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.now());
        entity.setDetalles(new ArrayList<>());

        request = new ConciliacionBancariaRequest();
        request.setBancoCntaId(10L);
        request.setPeriodoAnio(2026);
        request.setPeriodoMes(5);
        request.setSaldoBanco(new BigDecimal("10000.00"));
        request.setSaldoLibros(new BigDecimal("10000.00"));
    }

    // ==== toEntity — escenarios felices ====

    @Test
    @DisplayName("toEntity() con request valido -> retorna entity")
    void toEntity_conRequestValido_retornaEntity() {
        ConciliacionBancaria result = mapper.toEntity(request);

        assertThat(result).isNotNull();
        assertThat(result.getBancoCntaId()).isEqualTo(10L);
        assertThat(result.getPeriodoAnio()).isEqualTo(2026);
        assertThat(result.getPeriodoMes()).isEqualTo(5);
        assertThat(result.getSaldoBanco()).isEqualByComparingTo(new BigDecimal("10000.00"));
        assertThat(result.getSaldoLibros()).isEqualByComparingTo(new BigDecimal("10000.00"));
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
        ConciliacionBancariaResponse result = mapper.toResponse(entity);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getBancoCntaId()).isEqualTo(10L);
        assertThat(result.getPeriodoAnio()).isEqualTo(2026);
        assertThat(result.getPeriodoMes()).isEqualTo(5);
        assertThat(result.getSaldoBanco()).isEqualByComparingTo(new BigDecimal("10000.00"));
        assertThat(result.getSaldoLibros()).isEqualByComparingTo(new BigDecimal("10000.00"));
        assertThat(result.getDiferencia()).isEqualByComparingTo(BigDecimal.ZERO);
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
        List<ConciliacionBancaria> list = List.of(entity, entity);
        List<ConciliacionBancariaResponse> result = mapper.toResponseList(list);

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("toResponseList() con lista vacia -> retorna lista vacia")
    void toResponseList_conListaVacia_retornaListaVacia() {
        List<ConciliacionBancariaResponse> result = mapper.toResponseList(new ArrayList<>());

        assertThat(result).isEmpty();
    }
}
