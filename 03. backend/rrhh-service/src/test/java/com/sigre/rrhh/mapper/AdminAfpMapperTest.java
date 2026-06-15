package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.dto.request.AdminAfpRequest;
import com.sigre.rrhh.dto.response.AdminAfpResponse;
import com.sigre.rrhh.entity.AdminAfp;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests unitarios para AdminAfpMapper.
 * 
 * <p>Cubre las conversiones entre Entity y DTOs usando MapStruct.</p>
 * 
 * @author Sistema de RRHH
 * @version 1.0
 */
@DisplayName("Pruebas Unitarias - AdminAfpMapper")
class AdminAfpMapperTest {

    private AdminAfpMapper mapper;
    private AdminAfp entity;
    private AdminAfpRequest request;

    @BeforeEach
    void setUp() {
        mapper = Mappers.getMapper(AdminAfpMapper.class);
        
        entity = new AdminAfp();
        entity.setId(1L);
        entity.setNombre("AFP Integra");
        entity.setComisionPorcentaje(new BigDecimal("1.5500"));
        entity.setPrimaSeguro(new BigDecimal("1.3600"));
        entity.setAporteObligatorio(new BigDecimal("10.0000"));
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.parse("2026-06-15T10:00:00Z"));
        entity.setUpdatedBy(2L);
        entity.setFecModificacion(Instant.parse("2026-06-16T15:30:00Z"));

        request = new AdminAfpRequest();
        request.setNombre("AFP Prima");
        request.setComisionPorcentaje(new BigDecimal("1.6000"));
        request.setPrimaSeguro(new BigDecimal("1.3600"));
        request.setAporteObligatorio(new BigDecimal("10.0000"));
    }

    // ==== toEntity() ====

    @Test
    @DisplayName("toEntity() -> convierte Request a Entity")
    void toEntity_convierteRequestAEntity() {
        AdminAfp result = mapper.toEntity(request);

        assertThat(result).isNotNull();
        assertThat(result.getNombre()).isEqualTo("AFP Prima");
        assertThat(result.getComisionPorcentaje()).isEqualTo(new BigDecimal("1.6000"));
        assertThat(result.getPrimaSeguro()).isEqualTo(new BigDecimal("1.3600"));
        assertThat(result.getAporteObligatorio()).isEqualTo(new BigDecimal("10.0000"));
        // Los campos de auditoría deben ser nulos (se llenan automáticamente)
        assertThat(result.getId()).isNull();
        assertThat(result.getCreatedBy()).isNull();
        assertThat(result.getFecCreacion()).isNull();
    }

    // ==== toResponse() ====

    @Test
    @DisplayName("toResponse() -> convierte Entity a Response")
    void toResponse_convierteEntityAResponse() {
        AdminAfpResponse result = mapper.toResponse(entity);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNombre()).isEqualTo("AFP Integra");
        assertThat(result.getComisionPorcentaje()).isEqualTo(new BigDecimal("1.5500"));
        assertThat(result.getPrimaSeguro()).isEqualTo(new BigDecimal("1.3600"));
        assertThat(result.getAporteObligatorio()).isEqualTo(new BigDecimal("10.0000"));
        assertThat(result.getCreatedBy()).isEqualTo(1L);
        assertThat(result.getUpdatedBy()).isEqualTo(2L);
        // Las fechas deben estar formateadas como string
        assertThat(result.getFecCreacion()).isNotNull();
        assertThat(result.getFecModificacion()).isNotNull();
    }

    @Test
    @DisplayName("toResponse() con fechas nulas -> maneja nulos correctamente")
    void toResponse_conFechasNulas_manejaNulosCorrectamente() {
        AdminAfp entitySinFechas = new AdminAfp();
        entitySinFechas.setId(1L);
        entitySinFechas.setNombre("AFP Test");

        AdminAfpResponse result = mapper.toResponse(entitySinFechas);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNombre()).isEqualTo("AFP Test");
        assertThat(result.getFecCreacion()).isNull();
        assertThat(result.getFecModificacion()).isNull();
    }

    // ==== toResponseList() ====

    @Test
    @DisplayName("toResponseList() -> convierte lista de Entity a lista de Response")
    void toResponseList_convierteListaEntityAListaResponse() {
        List<AdminAfp> entities = List.of(entity);
        List<AdminAfpResponse> results = mapper.toResponseList(entities);

        assertThat(results).isNotNull();
        assertThat(results).hasSize(1);
        assertThat(results.get(0).getId()).isEqualTo(1L);
        assertThat(results.get(0).getNombre()).isEqualTo("AFP Integra");
    }

    @Test
    @DisplayName("toResponseList() con lista vacía -> retorna lista vacía")
    void toResponseList_conListaVacia_retornaListaVacia() {
        List<AdminAfp> entities = List.of();
        List<AdminAfpResponse> results = mapper.toResponseList(entities);

        assertThat(results).isNotNull();
        assertThat(results).isEmpty();
    }

    // ==== updateEntity() ====

    @Test
    @DisplayName("updateEntity() -> actualiza Entity desde Request")
    void updateEntity_actualizaEntityDesdeRequest() {
        AdminAfp targetEntity = new AdminAfp();
        targetEntity.setId(1L);
        targetEntity.setNombre("AFP Original");
        targetEntity.setComisionPorcentaje(new BigDecimal("1.0000"));
        targetEntity.setCreatedBy(1L);
        targetEntity.setFecCreacion(Instant.parse("2026-06-15T10:00:00Z"));

        mapper.updateEntity(request, targetEntity);

        assertThat(targetEntity.getNombre()).isEqualTo("AFP Prima");
        assertThat(targetEntity.getComisionPorcentaje()).isEqualTo(new BigDecimal("1.6000"));
        assertThat(targetEntity.getPrimaSeguro()).isEqualTo(new BigDecimal("1.3600"));
        assertThat(targetEntity.getAporteObligatorio()).isEqualTo(new BigDecimal("10.0000"));
        // Los campos de auditoría originales deben mantenerse
        assertThat(targetEntity.getId()).isEqualTo(1L);
        assertThat(targetEntity.getCreatedBy()).isEqualTo(1L);
        assertThat(targetEntity.getFecCreacion()).isEqualTo(Instant.parse("2026-06-15T10:00:00Z"));
    }

}
