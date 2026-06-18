package pe.restaurant.ventas.mapper;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import pe.restaurant.ventas.entity.CierreCaja;
import pe.restaurant.ventas.entity.DescuentoPromocion;
import pe.restaurant.ventas.entity.OrdenVenta;
import pe.restaurant.ventas.entity.OrdenVentaDet;
import pe.restaurant.ventas.entity.Proforma;
import pe.restaurant.ventas.entity.ProformaDet;
import pe.restaurant.ventas.testdata.VentasFase4TestDataFactory;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import pe.restaurant.ventas.VentasTestFixtures;
import pe.restaurant.ventas.dto.response.*;
import pe.restaurant.ventas.entity.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("VentasResponseMapper — Pruebas Unitarias")
class VentasResponseMapperTest {

    private VentasResponseMapper mapper;

    @BeforeEach
    void setUp() {
        mapper = new VentasResponseMapper();
    }

    @Test
    void toOrdenVentaResponse_mapsDetallesAndTotals() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStubConDetalles(1L, 2L);
        ov.setMontoFacturado(new BigDecimal("5"));
        ov.setFlagEstado("1");
        var resp = mapper.toOrdenVentaResponse(ov);
        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getDetalles()).hasSize(1);
        assertThat(resp.getDetalles().get(0).getArticuloId()).isEqualTo(50L);
        assertThat(resp.getMontoTotal()).isEqualByComparingTo("20.0000");
    }

    @Test
    void toOrdenVentaResponse_sinDetalles() {
        OrdenVenta ov = VentasFase4TestDataFactory.ordenVentaStub(2L);
        ov.getDetalles().clear();
        assertThat(mapper.toOrdenVentaResponse(ov).getDetalles()).isEmpty();
    }

    @Test
    void toProformaResponse_mapsDetalles() {
        Proforma p = VentasFase4TestDataFactory.proformaStub(3L);
        p.setSubtotal(new BigDecimal("100"));
        p.setIgv(new BigDecimal("18"));
        p.setTotal(new BigDecimal("118"));
        ProformaDet det = new ProformaDet();
        det.setId(10L);
        det.setArticuloId(5L);
        det.setDescripcion("Item");
        det.setCantidad(BigDecimal.ONE);
        det.setPrecioUnitario(new BigDecimal("100"));
        det.setDescuento(BigDecimal.ZERO);
        det.setSubtotal(new BigDecimal("100"));
        p.getDetalles().add(det);
        var resp = mapper.toProformaResponse(p);
        assertThat(resp.getDetalles()).hasSize(1);
        assertThat(resp.getTotal()).isEqualByComparingTo("118");
    }

    @Test
    void toCierreCajaResponse_abiertoYcerrado() {
        CierreCaja abierto = VentasFase4TestDataFactory.cierreAbiertoStub(1L, 10L);
        assertThat(mapper.toCierreCajaResponse(abierto).getEstadoCierre()).isEqualTo("OPEN");

        CierreCaja cerrado = VentasFase4TestDataFactory.cierreAbiertoStub(2L, 10L);
        cerrado.setFechaCierre(Instant.now());
        assertThat(mapper.toCierreCajaResponse(cerrado).getEstadoCierre()).isEqualTo("CLOSED");
    }

    @Test
    void toDescuentoResponse_vigencias() {
        DescuentoPromocion activo = VentasFase4TestDataFactory.descuentoStub(1L, "1");
        activo.setFechaInicio(LocalDate.now().minusDays(1));
        activo.setFechaFin(LocalDate.now().plusDays(30));
        assertThat(mapper.toDescuentoResponse(activo).getVigenciaDerivada()).isEqualTo("ON");

        DescuentoPromocion inactivo = VentasFase4TestDataFactory.descuentoStub(2L, "0");
        assertThat(mapper.toDescuentoResponse(inactivo).getVigenciaDerivada()).isEqualTo("OFF");

        DescuentoPromocion futuro = VentasFase4TestDataFactory.descuentoStub(3L, "1");
        futuro.setFechaInicio(LocalDate.now().plusDays(5));
        assertThat(mapper.toDescuentoResponse(futuro).getVigenciaDerivada()).isEqualTo("SCHEDULED");

        DescuentoPromocion vencido = VentasFase4TestDataFactory.descuentoStub(4L, "1");
        vencido.setFechaInicio(LocalDate.now().minusMonths(2));
        vencido.setFechaFin(LocalDate.now().minusDays(1));
        assertThat(mapper.toDescuentoResponse(vencido).getVigenciaDerivada()).isEqualTo("EXPIRED");
    }
    // ==================== TESTS DE ORDEN VENTA ====================

    @Test
    @DisplayName("toOrdenVentaResponse() con entity válida -> mapea correctamente")
    void toOrdenVentaResponse_conEntityValida_mapeaCorrectamente() {
        // Arrange
        OrdenVenta entity = VentasTestFixtures.ordenVentaEntity(1L, "1");
        
        // Agregar detalles
        OrdenVentaDet detalle1 = VentasTestFixtures.ordenVentaDetEntity(1L, entity, 100L);
        OrdenVentaDet detalle2 = VentasTestFixtures.ordenVentaDetEntity(2L, entity, 200L);
        entity.setDetalles(List.of(detalle1, detalle2));

        // Act
        OrdenVentaResponse response = mapper.toOrdenVentaResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getSucursalId()).isEqualTo(1L);
        assertThat(response.getNroOrdenVenta()).isEqualTo("OV-TEST-0001");
        assertThat(response.getClienteId()).isEqualTo(2L);
        assertThat(response.getVendedorId()).isNull();
        assertThat(response.getFechaEmision()).isEqualTo(LocalDate.now());
        assertThat(response.getMontoTotal()).isEqualByComparingTo("100.00");
        assertThat(response.getFlagEstado()).isEqualTo("1");

        // Validar detalles
        assertThat(response.getDetalles()).hasSize(2);
        OrdenVentaDetResponse detResponse1 = response.getDetalles().get(0);
        assertThat(detResponse1.getId()).isEqualTo(1L);
        assertThat(detResponse1.getArticuloId()).isEqualTo(100L);
        assertThat(detResponse1.getLineaNro()).isEqualTo(1);
        assertThat(detResponse1.getCantProyectada()).isEqualByComparingTo("5.00");
        assertThat(detResponse1.getValorUnitario()).isEqualByComparingTo("20.00");
        assertThat(detResponse1.getSubtotal()).isEqualByComparingTo("100.00");
        assertThat(detResponse1.getAlmacenId()).isEqualTo(1L);
        assertThat(detResponse1.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toOrdenVentaResponse() con entity nula -> retorna null")
    void toOrdenVentaResponse_conEntityNula_retornaNull() {
        // Act
        OrdenVentaResponse response = mapper.toOrdenVentaResponse(null);

        // Assert
        assertThat(response).isNull();
    }

    @Test
    @DisplayName("toOrdenVentaResponse() sin detalles -> mapea correctamente")
    void toOrdenVentaResponse_sinDetalles_mapeaCorrectamente() {
        // Arrange
        OrdenVenta entity = VentasTestFixtures.ordenVentaEntity(1L, "1");
        entity.setDetalles(null);

        // Act
        OrdenVentaResponse response = mapper.toOrdenVentaResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getDetalles()).isNull();
    }

    // ==================== TESTS DE PROFORMA ====================

    @Test
    @DisplayName("toProformaResponseForList() con entity válida -> mapea sin detalles")
    void toProformaResponseForList_conEntityValida_mapeaSinDetalles() {
        // Arrange
        Proforma entity = VentasTestFixtures.proformaEntity(1L, "1");

        // Act
        ProformaResponse response = mapper.toProformaResponseForList(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getSucursalId()).isEqualTo(1L);
        assertThat(response.getClienteId()).isEqualTo(2L);
        assertThat(response.getNumero()).isEqualTo("PF-TEST-0001");
        assertThat(response.getFecha()).isEqualTo(LocalDate.now());
        assertThat(response.getFechaValidez()).isEqualTo(LocalDate.now().plusDays(30));
        assertThat(response.getMonedaId()).isEqualTo(1L);
        assertThat(response.getSubtotal()).isEqualByComparingTo("100.00");
        assertThat(response.getIgv()).isEqualByComparingTo("18.00");
        assertThat(response.getTotal()).isEqualByComparingTo("118.00");
        assertThat(response.getFlagEstado()).isEqualTo("1");
        
        // Para listado, detalles deben ser null
        assertThat(response.getDetalles()).isNull();
    }

    @Test
    @DisplayName("toProformaResponse() con entity válida -> mapea con detalles")
    void toProformaResponse_conEntityValida_mapeaConDetalles() {
        // Arrange
        Proforma entity = VentasTestFixtures.proformaEntity(1L, "1");
        
        // Agregar detalles - crear manualmente ya que no existe fixture
        ProformaDet detalle1 = new ProformaDet();
        detalle1.setId(1L);
        detalle1.setProforma(entity);
        detalle1.setArticuloId(100L);
        detalle1.setDescripcion("Artículo Test");
        detalle1.setCantidad(new BigDecimal("2"));
        detalle1.setPrecioUnitario(new BigDecimal("425.00"));
        detalle1.setDescuento(BigDecimal.ZERO);
        detalle1.setSubtotal(new BigDecimal("850.00"));
        
        ProformaDet detalle2 = new ProformaDet();
        detalle2.setId(2L);
        detalle2.setProforma(entity);
        detalle2.setArticuloId(200L);
        detalle2.setDescripcion("Artículo Test 2");
        detalle2.setCantidad(new BigDecimal("1"));
        detalle2.setPrecioUnitario(new BigDecimal("425.00"));
        detalle2.setDescuento(BigDecimal.ZERO);
        detalle2.setSubtotal(new BigDecimal("425.00"));
        entity.setDetalles(List.of(detalle1, detalle2));

        // Act
        ProformaResponse response = mapper.toProformaResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getDetalles()).hasSize(2);
        
        ProformaDetResponse detResponse1 = response.getDetalles().get(0);
        assertThat(detResponse1.getId()).isEqualTo(1L);
        assertThat(detResponse1.getArticuloId()).isEqualTo(100L);
        assertThat(detResponse1.getDescripcion()).isEqualTo("Artículo Test");
        assertThat(detResponse1.getCantidad()).isEqualByComparingTo("2");
        assertThat(detResponse1.getPrecioUnitario()).isEqualByComparingTo("425.00");
        assertThat(detResponse1.getDescuento()).isEqualByComparingTo("0.00");
        assertThat(detResponse1.getSubtotal()).isEqualByComparingTo("850.00");
    }

    @Test
    @DisplayName("toProformaResponse() con entity nula -> retorna null")
    void toProformaResponse_conEntityNula_retornaNull() {
        // Act
        ProformaResponse response = mapper.toProformaResponse(null);

        // Assert
        assertThat(response).isNull();
    }

    // ==================== TESTS DE CIERRE CAJA ====================

    @Test
    @DisplayName("toCierreCajaResponse() con entity válida (OPEN) -> mapea correctamente")
    void toCierreCajaResponse_conEntityValidaOpen_mapeaCorrectamente() {
        // Arrange
        CierreCaja entity = VentasTestFixtures.cierreCajaEntity(1L, "1");
        entity.setFechaCierre(null); // Estado OPEN

        // Act
        CierreCajaResponse response = mapper.toCierreCajaResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTurnoId()).isEqualTo(1L);
        assertThat(response.getVentasEfectivo()).isEqualByComparingTo("100.00");
        assertThat(response.getVentasTarjeta()).isEqualByComparingTo("50.00");
        assertThat(response.getVentasDigital()).isEqualByComparingTo("25.00");
        assertThat(response.getVentasTotal()).isEqualByComparingTo("175.00");
        assertThat(response.getPropinasTotal()).isEqualByComparingTo("10.00");
        assertThat(response.getFondoInicial()).isEqualByComparingTo("50.00");
        assertThat(response.getFondoFinal()).isNull();
        assertThat(response.getDiferencia()).isEqualByComparingTo("0.00");
        assertThat(response.getObservaciones()).isNull();
        assertThat(response.getFechaCierre()).isNull();
        assertThat(response.getEstadoCierre()).isEqualTo("OPEN");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toCierreCajaResponse() con entity válida (CLOSED) -> mapea correctamente")
    void toCierreCajaResponse_conEntityValidaClosed_mapeaCorrectamente() {
        // Arrange
        CierreCaja entity = VentasTestFixtures.cierreCajaEntity(1L, "1");
        entity.setFechaCierre(Instant.parse("2026-05-22T16:00:00Z")); // Estado CLOSED

        // Act
        CierreCajaResponse response = mapper.toCierreCajaResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getFechaCierre()).isEqualTo(Instant.parse("2026-05-22T16:00:00Z"));
        assertThat(response.getEstadoCierre()).isEqualTo("CLOSED");
    }

    @Test
    @DisplayName("toCierreCajaResponse() con entity nula -> retorna null")
    void toCierreCajaResponse_conEntityNula_retornaNull() {
        // Act
        CierreCajaResponse response = mapper.toCierreCajaResponse(null);

        // Assert
        assertThat(response).isNull();
    }

    // ==================== TESTS DE DESCUENTO PROMOCIÓN ====================

    @Test
    @DisplayName("toDescuentoResponse() con promoción activa vigente -> retorna ON")
    void toDescuentoResponse_conPromocionActivaVigente_retornaOn() {
        // Arrange
        DescuentoPromocion entity = VentasTestFixtures.descuentoPromocionEntity(1L, "1");
        entity.setFechaInicio(LocalDate.now().minusDays(1)); // Ayer
        entity.setFechaFin(LocalDate.now().plusDays(1)); // Mañana

        // Act
        DescuentoPromocionResponse response = mapper.toDescuentoResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("PROMO-TEST-1");
        assertThat(response.getTipo()).isEqualTo("PCT");
        assertThat(response.getValor()).isEqualByComparingTo("10.00");
        assertThat(response.getFechaInicio()).isEqualTo(entity.getFechaInicio());
        assertThat(response.getFechaFin()).isEqualTo(entity.getFechaFin());
        assertThat(response.getDiasAplicacion()).isNull();
        assertThat(response.getMontoMinimo()).isNull();
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getVigenciaDerivada()).isEqualTo("ON");
    }

    @Test
    @DisplayName("toDescuentoResponse() con promoción futura -> retorna SCHEDULED")
    void toDescuentoResponse_conPromocionFutura_retornaScheduled() {
        // Arrange
        DescuentoPromocion entity = VentasTestFixtures.descuentoPromocionEntity(1L, "1");
        entity.setFechaInicio(LocalDate.now().plusDays(1)); // Mañana
        entity.setFechaFin(LocalDate.now().plusDays(10));

        // Act
        DescuentoPromocionResponse response = mapper.toDescuentoResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getVigenciaDerivada()).isEqualTo("SCHEDULED");
    }

    @Test
    @DisplayName("toDescuentoResponse() con promoción expirada -> retorna EXPIRED")
    void toDescuentoResponse_conPromocionExpirada_retornaExpired() {
        // Arrange
        DescuentoPromocion entity = VentasTestFixtures.descuentoPromocionEntity(1L, "1");
        entity.setFechaInicio(LocalDate.now().minusDays(10));
        entity.setFechaFin(LocalDate.now().minusDays(1)); // Ayer

        // Act
        DescuentoPromocionResponse response = mapper.toDescuentoResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getVigenciaDerivada()).isEqualTo("EXPIRED");
    }

    @Test
    @DisplayName("toDescuentoResponse() con promoción inactiva -> retorna OFF")
    void toDescuentoResponse_conPromocionInactiva_retornaOff() {
        // Arrange
        DescuentoPromocion entity = VentasTestFixtures.descuentoPromocionEntity(1L, "0"); // Inactiva
        entity.setFechaInicio(LocalDate.now().minusDays(1));
        entity.setFechaFin(LocalDate.now().plusDays(1));

        // Act
        DescuentoPromocionResponse response = mapper.toDescuentoResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getFlagEstado()).isEqualTo("0");
        assertThat(response.getVigenciaDerivada()).isEqualTo("OFF");
    }

    @Test
    @DisplayName("toDescuentoResponse() con entity nula -> retorna null")
    void toDescuentoResponse_conEntityNula_retornaNull() {
        // Act
        DescuentoPromocionResponse response = mapper.toDescuentoResponse(null);

        // Assert
        assertThat(response).isNull();
    }

    @Test
    @DisplayName("toDescuentoResponse() sin fechas -> retorna ON si está activa")
    void toDescuentoResponse_sinFechas_retornaOnSiEstaActiva() {
        // Arrange
        DescuentoPromocion entity = new DescuentoPromocion();
        entity.setId(1L);
        entity.setNombre("Promoción Test");
        entity.setTipo("PORCENTAJE");
        entity.setValor(new BigDecimal("10.00"));
        entity.setFechaInicio(null);
        entity.setFechaFin(null);
        entity.setFlagEstado("1");

        // Act
        DescuentoPromocionResponse response = mapper.toDescuentoResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getVigenciaDerivada()).isEqualTo("ON");
    }

    // ==================== TESTS DE VALIDACIÓN DE CAMPOS ====================

    @Test
    @DisplayName("mapeo completo de OrdenVenta con todos los campos -> todos los campos se mapean correctamente")
    void mapeoCompletoOrdenVenta_todosCamposSeMapeanCorrectamente() {
        // Arrange
        OrdenVenta entity = VentasTestFixtures.ordenVentaEntity(1L, "1");
        entity.setDetalles(List.of(VentasTestFixtures.ordenVentaDetEntity(1L, entity, 100L)));

        // Act
        OrdenVentaResponse response = mapper.toOrdenVentaResponse(entity);

        // Assert - Verificar todos los campos principales
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getSucursalId()).isEqualTo(1L);
        assertThat(response.getNroOrdenVenta()).isEqualTo("OV-TEST-0001");
        assertThat(response.getClienteId()).isEqualTo(2L);
        assertThat(response.getVendedorId()).isNull();
        assertThat(response.getFechaEmision()).isEqualTo(LocalDate.now());
        assertThat(response.getMontoTotal()).isEqualByComparingTo("100.00");
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getDetalles()).hasSize(1);
    }

    @Test
    @DisplayName("mapeo completo de Proforma con todos los campos -> todos los campos se mapean correctamente")
    void mapeoCompletoProforma_todosCamposSeMapeanCorrectamente() {
        // Arrange
        Proforma entity = VentasTestFixtures.proformaEntity(1L, "1");
        // Crear detalle manualmente
        ProformaDet detalle = new ProformaDet();
        detalle.setId(1L);
        detalle.setProforma(entity);
        detalle.setArticuloId(100L);
        detalle.setDescripcion("Artículo Test");
        detalle.setCantidad(new BigDecimal("2"));
        detalle.setPrecioUnitario(new BigDecimal("425.00"));
        detalle.setDescuento(BigDecimal.ZERO);
        detalle.setSubtotal(new BigDecimal("850.00"));
        entity.setDetalles(List.of(detalle));

        // Act
        ProformaResponse response = mapper.toProformaResponse(entity);

        // Assert - Verificar todos los campos principales
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getSucursalId()).isEqualTo(1L);
        assertThat(response.getClienteId()).isEqualTo(2L);
        assertThat(response.getNumero()).isEqualTo("PF-TEST-0001");
        assertThat(response.getFecha()).isEqualTo(LocalDate.now());
        assertThat(response.getFechaValidez()).isEqualTo(LocalDate.now().plusDays(30));
        assertThat(response.getMonedaId()).isEqualTo(1L);
        assertThat(response.getSubtotal()).isEqualByComparingTo("100.00");
        assertThat(response.getIgv()).isEqualByComparingTo("18.00");
        assertThat(response.getTotal()).isEqualByComparingTo("118.00");
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getDetalles()).hasSize(1);
    }
}
