package pe.restaurant.ventas.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import pe.restaurant.ventas.VentasTestFixtures;
import pe.restaurant.ventas.dto.response.CuentaCobrarResponse;
import pe.restaurant.ventas.entity.CuentaCobrar;
import pe.restaurant.ventas.entity.CuentaCobrarDet;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("CuentaCobrarMapper — Pruebas Unitarias")
class CuentaCobrarMapperTest {

    private final CuentaCobrarMapper mapper = new CuentaCobrarMapper();

    @Test
    @DisplayName("toResponse() con entity y movimientos válidos -> mapea correctamente")
    void toResponse_conEntityYMovimientosValidos_mapeaCorrectamente() {
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

        CuentaCobrarDet movimiento = VentasTestFixtures.cuentaCobrarDetEntity(1L, entity, 1L);
        movimiento.setFechaMov(LocalDate.of(2026, 5, 22));
        movimiento.setTipoMov(CuentaCobrarDet.TipoMovimiento.CARGO);
        movimiento.setReferencia("Venta principal");
        movimiento.setCreatedBy(1L);
        movimiento.setFecCreacion(Instant.parse("2026-05-22T15:00:00Z")); // UTC

        List<CuentaCobrarDet> movimientos = List.of(movimiento);

        // Act
        CuentaCobrarResponse response = mapper.toResponse(entity, movimientos);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getSucursalId()).isEqualTo(1L);
        assertThat(response.getSucursalNombre()).isEqualTo("Sucursal 1");
        assertThat(response.getClienteId()).isEqualTo(1L);
        assertThat(response.getClienteRazonSocial()).isEqualTo("Cliente 1");
        assertThat(response.getDocTipoId()).isEqualTo(1L);
        assertThat(response.getDocTipoNombre()).isEqualTo("Boleta");
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
        assertThat(response.getFecCreacion()).isEqualTo("22/05/2026 10:00:00");
        assertThat(response.getUpdatedBy()).isEqualTo(2L);
        assertThat(response.getFecModificacion()).isEqualTo("22/05/2026 11:00:00");

        // Validar movimientos
        assertThat(response.getMovimientos()).hasSize(1);
        CuentaCobrarResponse.CuentaCobrarDetResponse movResponse = response.getMovimientos().get(0);
        assertThat(movResponse.getId()).isEqualTo(1L);
        assertThat(movResponse.getConceptoFinancieroId()).isEqualTo(1L);
        assertThat(movResponse.getFechaMov()).isEqualTo("2026-05-22");
        assertThat(movResponse.getTipoMov()).isEqualTo("CARGO");
        assertThat(movResponse.getMonto()).isEqualByComparingTo("100.00");
        assertThat(movResponse.getReferencia()).isEqualTo("Venta principal");
        assertThat(movResponse.getFlagEstado()).isEqualTo("1");
        assertThat(movResponse.getCreatedBy()).isEqualTo(1L);
        assertThat(movResponse.getFecCreacion()).isEqualTo("22/05/2026 10:00:00");
    }

    @Test
    @DisplayName("toResponse() con entity nula -> retorna null")
    void toResponse_conEntityNula_retornaNull() {
        // Act
        CuentaCobrarResponse response = mapper.toResponse(null, List.of());

        // Assert
        assertThat(response).isNull();
    }

    @Test
    @DisplayName("toResponse() con movimientos nulos -> retorna response sin movimientos")
    void toResponse_conMovimientosNulos_retornaResponseSinMovimientos() {
        // Arrange
        CuentaCobrar entity = VentasTestFixtures.cuentaCobrarEntity(1L, "1");

        // Act
        CuentaCobrarResponse response = mapper.toResponse(entity, null);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getMovimientos()).isEmpty();
    }

    @Test
    @DisplayName("toResponse() con movimientos vacíos -> retorna response sin movimientos")
    void toResponse_conMovimientosVacios_retornaResponseSinMovimientos() {
        // Arrange
        CuentaCobrar entity = VentasTestFixtures.cuentaCobrarEntity(1L, "1");

        // Act
        CuentaCobrarResponse response = mapper.toResponse(entity, List.of());

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getMovimientos()).isEmpty();
    }

    @Test
    @DisplayName("toListItemResponse() con entity válida -> mapea correctamente")
    void toListItemResponse_conEntityValida_mapeaCorrectamente() {
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
        CuentaCobrarResponse.CuentaCobrarListItemResponse response = mapper.toListItemResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getSucursalId()).isEqualTo(1L);
        assertThat(response.getSucursalNombre()).isEqualTo("Sucursal 1");
        assertThat(response.getClienteId()).isEqualTo(1L);
        assertThat(response.getClienteRazonSocial()).isEqualTo("Cliente 1");
        assertThat(response.getDocTipoId()).isEqualTo(1L);
        assertThat(response.getDocTipoNombre()).isEqualTo("Boleta");
        assertThat(response.getSerie()).isEqualTo("CXB");
        assertThat(response.getNumero()).isEqualTo("00001");
        assertThat(response.getFechaEmision()).isEqualTo("2026-05-22");
        assertThat(response.getFechaVencimiento()).isEqualTo("2026-06-22");
        assertThat(response.getMonedaId()).isEqualTo(2L);
        assertThat(response.getMonedaSimbolo()).isEqualTo("$");
        assertThat(response.getTotal()).isEqualByComparingTo("1000.00");
        assertThat(response.getSaldo()).isEqualByComparingTo("500.00");
        assertThat(response.getCntblAsientoId()).isEqualTo(123L);
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(1L);
        assertThat(response.getFecCreacion()).isEqualTo("22/05/2026 10:00:00");
        assertThat(response.getUpdatedBy()).isEqualTo(2L);
        assertThat(response.getFecModificacion()).isEqualTo("22/05/2026 11:00:00");
    }

    @Test
    @DisplayName("toListItemResponse() con entity nula -> retorna null")
    void toListItemResponse_conEntityNula_retornaNull() {
        // Act
        CuentaCobrarResponse.CuentaCobrarListItemResponse response = mapper.toListItemResponse(null);

        // Assert
        assertThat(response).isNull();
    }

    @Test
    @DisplayName("toListItemResponseList() con lista válida -> mapea correctamente")
    void toListItemResponseList_conListaValida_mapeaCorrectamente() {
        // Arrange
        CuentaCobrar entity1 = VentasTestFixtures.cuentaCobrarEntity(1L, "1");
        CuentaCobrar entity2 = VentasTestFixtures.cuentaCobrarEntity(2L, "1");
        List<CuentaCobrar> entities = List.of(entity1, entity2);

        // Act
        List<CuentaCobrarResponse.CuentaCobrarListItemResponse> responses = mapper.toListItemResponseList(entities);

        // Assert
        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    @Test
    @DisplayName("toListItemResponseList() con lista nula -> retorna lista vacía")
    void toListItemResponseList_conListaNula_retornaListaVacia() {
        // Act
        List<CuentaCobrarResponse.CuentaCobrarListItemResponse> responses = mapper.toListItemResponseList(null);

        // Assert
        assertThat(responses).isEmpty();
    }

    @Test
    @DisplayName("toListItemResponseList() con lista vacía -> retorna lista vacía")
    void toListItemResponseList_conListaVacia_retornaListaVacia() {
        // Act
        List<CuentaCobrarResponse.CuentaCobrarListItemResponse> responses = mapper.toListItemResponseList(List.of());

        // Assert
        assertThat(responses).isEmpty();
    }

    @Test
    @DisplayName("Formateo de nombres de documentos -> mapea correctamente según ID")
    void formatoNombresDocumentos_mapeaCorrectamenteSegunId() {
        // Arrange
        CuentaCobrar entityBoleta = VentasTestFixtures.cuentaCobrarEntity(1L, "1");
        entityBoleta.setDocTipoId(1L);

        CuentaCobrar entityFactura = VentasTestFixtures.cuentaCobrarEntity(2L, "1");
        entityFactura.setDocTipoId(2L);

        CuentaCobrar entityNotaCredito = VentasTestFixtures.cuentaCobrarEntity(3L, "1");
        entityNotaCredito.setDocTipoId(3L);

        CuentaCobrar entityNotaDebito = VentasTestFixtures.cuentaCobrarEntity(4L, "1");
        entityNotaDebito.setDocTipoId(4L);

        CuentaCobrar entityOtro = VentasTestFixtures.cuentaCobrarEntity(5L, "1");
        entityOtro.setDocTipoId(99L);

        // Act & Assert
        assertThat(mapper.toListItemResponse(entityBoleta).getDocTipoNombre()).isEqualTo("Boleta");
        assertThat(mapper.toListItemResponse(entityFactura).getDocTipoNombre()).isEqualTo("Factura");
        assertThat(mapper.toListItemResponse(entityNotaCredito).getDocTipoNombre()).isEqualTo("Nota de Crédito");
        assertThat(mapper.toListItemResponse(entityNotaDebito).getDocTipoNombre()).isEqualTo("Nota de Débito");
        assertThat(mapper.toListItemResponse(entityOtro).getDocTipoNombre()).isEqualTo("DocTipo 99");
    }

    @Test
    @DisplayName("Formateo de símbolos de moneda -> mapea correctamente según ID")
    void formatoSimbolosMoneda_mapeaCorrectamenteSegunId() {
        // Arrange
        CuentaCobrar entitySoles = VentasTestFixtures.cuentaCobrarEntity(1L, "1");
        entitySoles.setMonedaId(1L);

        CuentaCobrar entityDolares = VentasTestFixtures.cuentaCobrarEntity(2L, "1");
        entityDolares.setMonedaId(2L);

        CuentaCobrar entityEuros = VentasTestFixtures.cuentaCobrarEntity(3L, "1");
        entityEuros.setMonedaId(3L);

        CuentaCobrar entityOtro = VentasTestFixtures.cuentaCobrarEntity(4L, "1");
        entityOtro.setMonedaId(99L);

        // Act & Assert
        assertThat(mapper.toListItemResponse(entitySoles).getMonedaSimbolo()).isEqualTo("S/");
        assertThat(mapper.toListItemResponse(entityDolares).getMonedaSimbolo()).isEqualTo("$");
        assertThat(mapper.toListItemResponse(entityEuros).getMonedaSimbolo()).isEqualTo("€");
        assertThat(mapper.toListItemResponse(entityOtro).getMonedaSimbolo()).isEqualTo("");
    }

    @Test
    @DisplayName("Campos nulos -> maneja correctamente")
    void camposNulos_manejaCorrectamente() {
        // Arrange
        CuentaCobrar entity = new CuentaCobrar();
        entity.setId(1L);
        // Todos los demás campos son nulos

        // Act
        CuentaCobrarResponse.CuentaCobrarListItemResponse response = mapper.toListItemResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getSucursalNombre()).isNull();
        assertThat(response.getClienteRazonSocial()).isNull();
        assertThat(response.getDocTipoNombre()).isNull();
        assertThat(response.getMonedaSimbolo()).isNull();
        assertThat(response.getFechaEmision()).isNull();
        assertThat(response.getFechaVencimiento()).isNull();
        assertThat(response.getFecCreacion()).isNull();
        assertThat(response.getFecModificacion()).isNull();
    }
}
