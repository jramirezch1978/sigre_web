package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.rrhh.dto.request.ConceptoPlanillaCreateRequest;
import pe.restaurant.rrhh.dto.request.ConceptoPlanillaUpdateRequest;
import pe.restaurant.rrhh.dto.response.ConceptoPlanillaResponse;
import pe.restaurant.rrhh.entity.ConceptoPlanilla;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static pe.restaurant.rrhh.constants.ConceptoPlanillaConstants.*;

/**
 * Tests unitarios para ConceptoPlanillaMapper.
 * Valida las conversiones entre entidades y DTOs.
 */
@DisplayName("Pruebas Unitarias - ConceptoPlanillaMapper")
class ConceptoPlanillaMapperTest {

    private final ConceptoPlanillaMapper mapper = Mappers.getMapper(ConceptoPlanillaMapper.class);

    @Test
    @DisplayName("toResponse() mapea correctamente entity a response")
    void toResponse_mapeaCorrectamente() {
        ConceptoPlanilla entity = new ConceptoPlanilla();
        entity.setId(1L);
        entity.setCodigo("ING-001");
        entity.setNombre("Sueldo Básico");
        entity.setTipo(TIPO_INGRESO);
        entity.setFormula(null);
        entity.setValorFijo(new BigDecimal("1500.00"));
        entity.setAfectoQuinta(true);
        entity.setAfectoEssalud(true);
        entity.setAplicaTodos(true);

        ConceptoPlanillaResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("ING-001");
        assertThat(response.getNombre()).isEqualTo("Sueldo Básico");
        assertThat(response.getTipo()).isEqualTo(TIPO_INGRESO);
        assertThat(response.getValorFijo()).isEqualByComparingTo(new BigDecimal("1500.00"));
        assertThat(response.getAfectoQuinta()).isTrue();
        assertThat(response.getAfectoEssalud()).isTrue();
        assertThat(response.getAplicaTodos()).isTrue();
    }

    @Test
    @DisplayName("toEntity() mapea correctamente request a entity")
    void toEntity_mapeaCorrectamente() {
        ConceptoPlanillaCreateRequest request = new ConceptoPlanillaCreateRequest();
        request.setCodigo("DESC-001");
        request.setNombre("AFP");
        request.setTipo(TIPO_DESCUENTO);
        request.setFormula("SUELDO_BASICO * 0.13");
        request.setValorFijo(null);
        request.setAfectoQuinta(false);
        request.setAfectoEssalud(false);
        request.setAplicaTodos(true);

        ConceptoPlanilla entity = mapper.toEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getCodigo()).isEqualTo("DESC-001");
        assertThat(entity.getNombre()).isEqualTo("AFP");
        assertThat(entity.getTipo()).isEqualTo(TIPO_DESCUENTO);
        assertThat(entity.getFormula()).isEqualTo("SUELDO_BASICO * 0.13");
        assertThat(entity.getValorFijo()).isNull();
        assertThat(entity.getAfectoQuinta()).isFalse();
        assertThat(entity.getAfectoEssalud()).isFalse();
        assertThat(entity.getAplicaTodos()).isTrue();
    }

    @Test
    @DisplayName("toEntity() con valores nulos mapea correctamente")
    void toEntity_conValoresNulos_mapeaCorrectamente() {
        ConceptoPlanillaCreateRequest request = new ConceptoPlanillaCreateRequest();
        request.setCodigo("APO-001");
        request.setNombre("EsSalud");
        request.setTipo(TIPO_APORTE);
        request.setFormula(null);
        request.setValorFijo(null);
        request.setAfectoQuinta(false);
        request.setAfectoEssalud(false);
        request.setAplicaTodos(true);

        ConceptoPlanilla entity = mapper.toEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getFormula()).isNull();
        assertThat(entity.getValorFijo()).isNull();
    }

    @Test
    @DisplayName("toResponse() con entidad null -> retorna null")
    void toResponse_conEntidadNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() convierte lista de entidades a DTOs")
    void toResponseList_convierteListaADTOs() {
        ConceptoPlanilla e1 = new ConceptoPlanilla();
        e1.setId(1L);
        e1.setCodigo("ING-001");
        ConceptoPlanilla e2 = new ConceptoPlanilla();
        e2.setId(2L);
        e2.setCodigo("DESC-001");

        List<ConceptoPlanillaResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    @Test
    @DisplayName("toResponse() con fecCreacion no nulo -> mapea correctamente")
    void toResponse_conFecCreacionNoNulo_mapeaCorrectamente() {
        ConceptoPlanilla entity = new ConceptoPlanilla();
        entity.setId(1L);
        entity.setCodigo("ING-001");
        entity.setNombre("Sueldo Básico");
        entity.setFecCreacion(Instant.parse("2026-01-15T10:00:00Z"));

        ConceptoPlanillaResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("toResponseList() con lista null -> retorna null")
    void toResponseList_conListaNull_retornaNull() {
        assertThat(mapper.toResponseList(null)).isNull();
    }

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    @DisplayName("updateEntity() con request null -> no lanza excepción")
    void updateEntity_conRequestNull_noLanzaExcepcion() {
        ConceptoPlanilla entity = new ConceptoPlanilla();
        entity.setCodigo("ING-001");
        mapper.updateEntity(entity, null);
        assertThat(entity.getCodigo()).isEqualTo("ING-001");
    }

    @Test
    @DisplayName("updateEntity() actualiza correctamente sin modificar código")
    void updateEntity_actualizaCorrectamenteSinModificarCodigo() {
        ConceptoPlanilla entity = new ConceptoPlanilla();
        entity.setId(1L);
        entity.setCodigo("ING-001");
        entity.setNombre("Sueldo Básico");
        entity.setTipo(TIPO_INGRESO);

        ConceptoPlanillaUpdateRequest request = new ConceptoPlanillaUpdateRequest();
        request.setNombre("Sueldo Básico Mensual");
        request.setTipo(TIPO_INGRESO);
        request.setFormula(null);
        request.setValorFijo(new BigDecimal("2000.00"));
        request.setAfectoQuinta(true);
        request.setAfectoEssalud(true);
        request.setAplicaTodos(false);

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("ING-001"); // No debe cambiar
        assertThat(entity.getNombre()).isEqualTo("Sueldo Básico Mensual");
        assertThat(entity.getValorFijo()).isEqualByComparingTo(new BigDecimal("2000.00"));
        assertThat(entity.getAplicaTodos()).isFalse();
    }
}
