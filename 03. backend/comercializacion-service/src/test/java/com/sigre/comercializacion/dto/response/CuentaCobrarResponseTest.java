package com.sigre.comercializacion.dto.response;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import com.sigre.comercializacion.VentasTestFixtures;
import com.sigre.comercializacion.entity.CuentaCobrar;
import com.sigre.comercializacion.entity.CuentaCobrarDet;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("CuentaCobrarResponse — Pruebas Unitarias")
class CuentaCobrarResponseTest {

    // ==================== TESTS DE CUENTA COBRAR RESPONSE ====================

    @Test
    @DisplayName("fromEntity() con entity válida -> mapea correctamente")
    void fromEntity_conEntityValida_mapeaCorrectamente() {
        // Arrange
        CuentaCobrar entity = VentasTestFixtures.cuentaCobrarEntity(1L, "1");
        entity.setFechaEmision(LocalDate.of(2026, 5, 22));
        entity.setFechaVencimiento(LocalDate.of(2026, 6, 22));
        entity.setMonedaId(1L);
        entity.setTotal(new BigDecimal("1000.00"));
        entity.setSaldo(new BigDecimal("500.00"));
        entity.setCntblAsientoId(123L);
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.parse("2026-05-22T15:00:00Z")); // UTC
        entity.setUpdatedBy(2L);
        entity.setFecModificacion(Instant.parse("2026-05-22T16:00:00Z")); // UTC

        // Act
        CuentaCobrarResponse response = CuentaCobrarResponse.fromEntity(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getSucursalId()).isEqualTo(1L);
        assertThat(response.getSucursalNombre()).isEqualTo("Sucursal 1");
        assertThat(response.getClienteId()).isEqualTo(1L);
        assertThat(response.getClienteRazonSocial()).isEqualTo("Cliente 1");
        assertThat(response.getDocTipoId()).isEqualTo(1L);
        assertThat(response.getDocTipoNombre()).isEqualTo("DocTipo 1");
        assertThat(response.getSerie()).isEqualTo("CXB");
        assertThat(response.getNumero()).isEqualTo("00001");
        assertThat(response.getFechaEmision()).isEqualTo("2026-05-22");
        assertThat(response.getFechaVencimiento()).isEqualTo("2026-06-22");
        assertThat(response.getMonedaId()).isEqualTo(1L);
        assertThat(response.getMonedaSimbolo()).isEqualTo("S/");
        assertThat(response.getTotal()).isEqualByComparingTo("1000.00");
        assertThat(response.getSaldo()).isEqualByComparingTo("500.00");
        assertThat(response.getCntblAsientoId()).isEqualTo(123L);
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(1L);
        assertThat(response.getFecCreacion()).isEqualTo("22/05/2026 10:00:00"); // America/Lima (UTC-5)
        assertThat(response.getUpdatedBy()).isEqualTo(2L);
        assertThat(response.getFecModificacion()).isEqualTo("22/05/2026 11:00:00"); // America/Lima (UTC-5)
        assertThat(response.getMovimientos()).isNull();
    }

    @Test
    @DisplayName("fromEntity() con entity nula -> retorna null")
    void fromEntity_conEntityNula_retornaNull() {
        // Act
        CuentaCobrarResponse response = CuentaCobrarResponse.fromEntity(null);

        // Assert
        assertThat(response).isNull();
    }

    @Test
    @DisplayName("fromEntity() con entity sin fechas -> maneja nulos correctamente")
    void fromEntity_conEntitySinFechas_manejaNulosCorrectamente() {
        // Arrange
        CuentaCobrar entity = VentasTestFixtures.cuentaCobrarEntity(1L, "1");
        entity.setFechaEmision(null);
        entity.setFechaVencimiento(null);
        entity.setFecCreacion(null);
        entity.setFecModificacion(null);

        // Act
        CuentaCobrarResponse response = CuentaCobrarResponse.fromEntity(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getFechaEmision()).isNull();
        assertThat(response.getFechaVencimiento()).isNull();
        assertThat(response.getFecCreacion()).isNull();
        assertThat(response.getFecModificacion()).isNull();
    }

    @Test
    @DisplayName("fromEntity() con monedaId nula -> sin símbolo")
    void fromEntity_conMonedaIdNula_sinSimbolo() {
        // Arrange
        CuentaCobrar entity = VentasTestFixtures.cuentaCobrarEntity(1L, "1");
        entity.setMonedaId(null);

        // Act
        CuentaCobrarResponse response = CuentaCobrarResponse.fromEntity(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getMonedaId()).isNull();
        assertThat(response.getMonedaSimbolo()).isEqualTo("");
    }

    @Test
    @DisplayName("fromEntity() con cntblAsientoId nulo -> maneja correctamente")
    void fromEntity_conCntblAsientoIdNulo_manejaCorrectamente() {
        // Arrange
        CuentaCobrar entity = VentasTestFixtures.cuentaCobrarEntity(1L, "1");
        entity.setCntblAsientoId(null);

        // Act
        CuentaCobrarResponse response = CuentaCobrarResponse.fromEntity(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getCntblAsientoId()).isNull();
    }

    // ==================== TESTS DE CUENTA COBRAR DET RESPONSE ====================

    @Test
    @DisplayName("CuentaCobrarDetResponse.fromEntity() con entity válida -> mapea correctamente")
    void cuentaCobrarDetResponseFromEntity_conEntityValida_mapeaCorrectamente() {
        // Arrange
        CuentaCobrar entity = VentasTestFixtures.cuentaCobrarEntity(1L, "1");
        CuentaCobrarDet detEntity = VentasTestFixtures.cuentaCobrarDetEntity(1L, entity, 1L);
        detEntity.setFechaMov(LocalDate.of(2026, 5, 22));
        detEntity.setTipoMov(CuentaCobrarDet.TipoMovimiento.CARGO);
        detEntity.setReferencia("Venta principal");
        detEntity.setCreatedBy(1L);
        detEntity.setFecCreacion(Instant.parse("2026-05-22T15:00:00Z")); // UTC
        detEntity.setUpdatedBy(2L);
        detEntity.setFecModificacion(Instant.parse("2026-05-22T16:00:00Z")); // UTC

        // Act
        CuentaCobrarResponse.CuentaCobrarDetResponse response = 
            CuentaCobrarResponse.CuentaCobrarDetResponse.fromEntity(detEntity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getConceptoFinancieroId()).isEqualTo(1L);
        assertThat(response.getFechaMov()).isEqualTo("2026-05-22");
        assertThat(response.getTipoMov()).isEqualTo("CARGO");
        assertThat(response.getMonto()).isEqualByComparingTo("100.00");
        assertThat(response.getReferencia()).isEqualTo("Venta principal");
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(1L);
        assertThat(response.getFecCreacion()).isEqualTo("22/05/2026 10:00:00"); // America/Lima (UTC-5)
        assertThat(response.getUpdatedBy()).isEqualTo(2L);
        assertThat(response.getFecModificacion()).isEqualTo("22/05/2026 11:00:00"); // America/Lima (UTC-5)
    }

    @Test
    @DisplayName("CuentaCobrarDetResponse.fromEntity() con entity nula -> retorna null")
    void cuentaCobrarDetResponseFromEntity_conEntityNula_retornaNull() {
        // Act
        CuentaCobrarResponse.CuentaCobrarDetResponse response = 
            CuentaCobrarResponse.CuentaCobrarDetResponse.fromEntity(null);

        // Assert
        assertThat(response).isNull();
    }

    @Test
    @DisplayName("CuentaCobrarDetResponse.fromEntity() con tipoMov nulo -> maneja correctamente")
    void cuentaCobrarDetResponseFromEntity_conTipoMovNulo_manejaCorrectamente() {
        // Arrange
        CuentaCobrar entity = VentasTestFixtures.cuentaCobrarEntity(1L, "1");
        CuentaCobrarDet detEntity = VentasTestFixtures.cuentaCobrarDetEntity(1L, entity, 1L);
        detEntity.setTipoMov(null);

        // Act
        CuentaCobrarResponse.CuentaCobrarDetResponse response = 
            CuentaCobrarResponse.CuentaCobrarDetResponse.fromEntity(detEntity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getTipoMov()).isNull();
    }

    @Test
    @DisplayName("CuentaCobrarDetResponse.fromEntity() sin fechas -> maneja nulos")
    void cuentaCobrarDetResponseFromEntity_sinFechas_manejaNulos() {
        // Arrange
        CuentaCobrar entity = VentasTestFixtures.cuentaCobrarEntity(1L, "1");
        CuentaCobrarDet detEntity = VentasTestFixtures.cuentaCobrarDetEntity(1L, entity, 1L);
        detEntity.setFechaMov(null);
        detEntity.setFecCreacion(null);
        detEntity.setFecModificacion(null);

        // Act
        CuentaCobrarResponse.CuentaCobrarDetResponse response = 
            CuentaCobrarResponse.CuentaCobrarDetResponse.fromEntity(detEntity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getFechaMov()).isNull();
        assertThat(response.getFecCreacion()).isNull();
        assertThat(response.getFecModificacion()).isNull();
    }

    // ==================== TESTS DE CUENTA COBRAR LIST ITEM RESPONSE ====================

    @Test
    @DisplayName("CuentaCobrarListItemResponse.fromEntity() con entity válida -> mapea correctamente")
    void cuentaCobrarListItemResponseFromEntity_conEntityValida_mapeaCorrectamente() {
        // Arrange
        CuentaCobrar entity = VentasTestFixtures.cuentaCobrarEntity(1L, "1");
        entity.setFechaEmision(LocalDate.of(2026, 5, 22));
        entity.setFechaVencimiento(LocalDate.of(2026, 6, 22));
        entity.setMonedaId(2L);
        entity.setTotal(new BigDecimal("1000.00"));
        entity.setSaldo(new BigDecimal("500.00"));
        entity.setCntblAsientoId(123L);
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.parse("2026-05-22T15:00:00Z")); // UTC
        entity.setUpdatedBy(2L);
        entity.setFecModificacion(Instant.parse("2026-05-22T16:00:00Z")); // UTC

        // Act
        CuentaCobrarResponse.CuentaCobrarListItemResponse response = 
            CuentaCobrarResponse.CuentaCobrarListItemResponse.fromEntity(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getSucursalId()).isEqualTo(1L);
        assertThat(response.getSucursalNombre()).isEqualTo("Sucursal 1");
        assertThat(response.getClienteId()).isEqualTo(1L);
        assertThat(response.getClienteRazonSocial()).isEqualTo("Cliente 1");
        assertThat(response.getDocTipoId()).isEqualTo(1L);
        assertThat(response.getDocTipoNombre()).isEqualTo("DocTipo 1");
        assertThat(response.getSerie()).isEqualTo("CXB");
        assertThat(response.getNumero()).isEqualTo("00001");
        assertThat(response.getFechaEmision()).isEqualTo("2026-05-22");
        assertThat(response.getFechaVencimiento()).isEqualTo("2026-06-22");
        assertThat(response.getMonedaId()).isEqualTo(2L);
        assertThat(response.getMonedaSimbolo()).isEqualTo("S/");
        assertThat(response.getTotal()).isEqualByComparingTo("1000.00");
        assertThat(response.getSaldo()).isEqualByComparingTo("500.00");
        assertThat(response.getCntblAsientoId()).isEqualTo(123L);
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(1L);
        assertThat(response.getFecCreacion()).isEqualTo("22/05/2026 10:00:00"); // America/Lima (UTC-5)
        assertThat(response.getUpdatedBy()).isEqualTo(2L);
        assertThat(response.getFecModificacion()).isEqualTo("22/05/2026 11:00:00"); // America/Lima (UTC-5)
    }

    @Test
    @DisplayName("CuentaCobrarListItemResponse.fromEntity() con entity nula -> retorna null")
    void cuentaCobrarListItemResponseFromEntity_conEntityNula_retornaNull() {
        // Act
        CuentaCobrarResponse.CuentaCobrarListItemResponse response = 
            CuentaCobrarResponse.CuentaCobrarListItemResponse.fromEntity(null);

        // Assert
        assertThat(response).isNull();
    }

    @Test
    @DisplayName("CuentaCobrarListItemResponse.fromEntity() sin fechas -> maneja nulos")
    void cuentaCobrarListItemResponseFromEntity_sinFechas_manejaNulos() {
        // Arrange
        CuentaCobrar entity = VentasTestFixtures.cuentaCobrarEntity(1L, "1");
        entity.setFechaEmision(null);
        entity.setFechaVencimiento(null);
        entity.setFecCreacion(null);
        entity.setFecModificacion(null);

        // Act
        CuentaCobrarResponse.CuentaCobrarListItemResponse response = 
            CuentaCobrarResponse.CuentaCobrarListItemResponse.fromEntity(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getFechaEmision()).isNull();
        assertThat(response.getFechaVencimiento()).isNull();
        assertThat(response.getFecCreacion()).isNull();
        assertThat(response.getFecModificacion()).isNull();
    }

    @Test
    @DisplayName("CuentaCobrarListItemResponse.fromEntity() con monedaId nula -> sin símbolo")
    void cuentaCobrarListItemResponseFromEntity_conMonedaIdNula_sinSimbolo() {
        // Arrange
        CuentaCobrar entity = VentasTestFixtures.cuentaCobrarEntity(1L, "1");
        entity.setMonedaId(null);

        // Act
        CuentaCobrarResponse.CuentaCobrarListItemResponse response = 
            CuentaCobrarResponse.CuentaCobrarListItemResponse.fromEntity(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getMonedaId()).isNull();
        assertThat(response.getMonedaSimbolo()).isEqualTo("");
    }

    // ==================== TESTS DE INTEGRACIÓN ====================

    @Test
    @DisplayName("fromEntity() con entity completa y movimientos -> mapeo completo")
    void fromEntity_conEntityCompletaYMovimientos_mapeoCompleto() {
        // Arrange
        CuentaCobrar entity = VentasTestFixtures.cuentaCobrarEntity(1L, "1");
        entity.setFechaEmision(LocalDate.of(2026, 5, 22));
        entity.setFechaVencimiento(LocalDate.of(2026, 6, 22));
        entity.setMonedaId(1L);
        entity.setTotal(new BigDecimal("1000.00"));
        entity.setSaldo(new BigDecimal("500.00"));
        entity.setCntblAsientoId(123L);
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.parse("2026-05-22T15:00:00Z")); // UTC
        entity.setUpdatedBy(2L);
        entity.setFecModificacion(Instant.parse("2026-05-22T16:00:00Z")); // UTC

        // Act
        CuentaCobrarResponse response = CuentaCobrarResponse.fromEntity(entity);

        // Assert - Verificar que todos los campos principales se mapeen
        assertThat(response).isNotNull();
        assertThat(response.getId()).isNotNull();
        assertThat(response.getSucursalId()).isNotNull();
        assertThat(response.getSucursalNombre()).isNotNull();
        assertThat(response.getClienteId()).isNotNull();
        assertThat(response.getClienteRazonSocial()).isNotNull();
        assertThat(response.getDocTipoId()).isNotNull();
        assertThat(response.getDocTipoNombre()).isNotNull();
        assertThat(response.getSerie()).isNotNull();
        assertThat(response.getNumero()).isNotNull();
        assertThat(response.getMonedaId()).isNotNull();
        assertThat(response.getMonedaSimbolo()).isNotNull();
        assertThat(response.getTotal()).isNotNull();
        assertThat(response.getSaldo()).isNotNull();
        assertThat(response.getFlagEstado()).isNotNull();
        assertThat(response.getCreatedBy()).isNotNull();
        assertThat(response.getUpdatedBy()).isNotNull();
        assertThat(response.getMovimientos()).isNull(); // fromEntity no incluye movimientos
    }

    @Test
    @DisplayName("Prueba de formato de timestamps -> verifica formato correcto")
    void pruebaFormatoTimestamps_verificaFormatoCorrecto() {
        // Arrange
        CuentaCobrar entity = VentasTestFixtures.cuentaCobrarEntity(1L, "1");
        entity.setFecCreacion(Instant.parse("2026-05-22T17:30:45Z")); // UTC
        entity.setFecModificacion(Instant.parse("2026-05-22T18:45:30Z")); // UTC

        // Act
        CuentaCobrarResponse response = CuentaCobrarResponse.fromEntity(entity);

        // Assert - Verificar formato dd/MM/yyyy HH:mm:ss (America/Lima = UTC-5)
        assertThat(response.getFecCreacion()).isEqualTo("22/05/2026 12:30:45");
        assertThat(response.getFecModificacion()).isEqualTo("22/05/2026 13:45:30");
    }
}
