package pe.restaurant.finanzas.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.finanzas.client.CoreMaestrosClient;
import pe.restaurant.finanzas.dto.request.CalcularImpuestosRequest;
import pe.restaurant.finanzas.dto.request.ImpuestoItemRequest;
import pe.restaurant.finanzas.dto.request.ItemCalculoRequest;
import pe.restaurant.finanzas.dto.response.CalcularImpuestosResponse;
import pe.restaurant.finanzas.dto.response.ItemCalculoResponse;
import pe.restaurant.finanzas.dto.response.PaisResponse;
import pe.restaurant.finanzas.dto.response.SucursalResponse;
import pe.restaurant.finanzas.dto.response.TiposImpuestoResponse;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CalculoImpuestosServiceImplTest {

    @Mock
    private CoreMaestrosClient coreMaestrosClient;

    private CalculoImpuestosServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new CalculoImpuestosServiceImpl(coreMaestrosClient);
    }

    private void mockPaisResolucion(Long sucursalId, Long paisId, String codigoPais) {
        SucursalResponse sucursal = new SucursalResponse();
        sucursal.setId(sucursalId);
        sucursal.setPaisId(paisId);
        when(coreMaestrosClient.obtenerSucursalPorId(sucursalId))
                .thenReturn(ApiResponse.ok(sucursal));

        PaisResponse pais = new PaisResponse();
        pais.setId(paisId);
        pais.setCodigo(codigoPais);
        pais.setNombre(codigoPais.equals("PE") ? "Perú" : codigoPais.equals("CL") ? "Chile" : "Otro");
        when(coreMaestrosClient.obtenerPaisPorId(paisId))
                .thenReturn(ApiResponse.ok(pais));
    }

    private void mockImpuesto(Long tipoImpuestoId, BigDecimal tasa, String descripcion,
                              boolean esFiscalizado, Integer tipoCalculo) {
        TiposImpuestoResponse impuesto = new TiposImpuestoResponse();
        impuesto.setId(tipoImpuestoId);
        impuesto.setDescImpuesto(descripcion);
        impuesto.setTasaImpuesto(tasa);
        impuesto.setFlagIgv(esFiscalizado ? "1" : "0");
        impuesto.setTipoCalculo(tipoCalculo);
        when(coreMaestrosClient.obtenerImpuestoPorId(tipoImpuestoId))
                .thenReturn(ApiResponse.ok(impuesto));
    }

    @Test
    void calcular_conUnItemGravado_retornaCalculosCorrectos() {
        try (MockedStatic<TenantContext> tenantContext = mockStatic(TenantContext.class)) {
            tenantContext.when(TenantContext::getSucursalId).thenReturn(1L);

            mockPaisResolucion(1L, 1L, "PE");
            mockImpuesto(1L, new BigDecimal("18.00"), "IGV", true, 1);

            CalcularImpuestosRequest request = new CalcularImpuestosRequest();
            request.setItems(List.of(
                    new ItemCalculoRequest(1, new BigDecimal("118.00"), new BigDecimal("2"),
                            true, BigDecimal.ZERO, "$", // dsctoTipo
                            List.of(new ImpuestoItemRequest(1L, 1)),
                            null)
            ));

            CalcularImpuestosResponse response = service.calcular(request);

            assertEquals("PE", response.getPais());
            assertNotNull(response.getItems());
            assertEquals(1, response.getItems().size());

            ItemCalculoResponse item = response.getItems().get(0);
            assertEquals(1, item.getItem());
            // 118 * 2 = 236 total, base = 236 / 1.18 = 200, IGV = 36
            assertEquals(0, new BigDecimal("200.00").compareTo(item.getBaseImponible()));
            assertEquals(0, new BigDecimal("236.00").compareTo(item.getMontoTotal()));
            assertTrue(item.isEsGravado());

            assertEquals(1, item.getImpuestos().size());
            assertEquals(0, new BigDecimal("36.00").compareTo(item.getImpuestos().get(0).getImporte()));

            assertNotNull(response.getConsolidado());
            assertEquals(0, new BigDecimal("200.00").compareTo(response.getConsolidado().getSubtotal()));
            assertEquals(0, new BigDecimal("36.00").compareTo(response.getConsolidado().getTotalIgv()));
        }
    }

    @Test
    void calcular_sucursalSinPais_lanzaExcepcion() {
        try (MockedStatic<TenantContext> tenantContext = mockStatic(TenantContext.class)) {
            tenantContext.when(TenantContext::getSucursalId).thenReturn(1L);

            SucursalResponse sucursal = new SucursalResponse();
            sucursal.setId(1L);
            sucursal.setPaisId(null);
            when(coreMaestrosClient.obtenerSucursalPorId(1L))
                    .thenReturn(ApiResponse.ok(sucursal));

            CalcularImpuestosRequest request = new CalcularImpuestosRequest();
            request.setItems(List.of(
                    new ItemCalculoRequest(1, BigDecimal.TEN, BigDecimal.ONE, true, BigDecimal.ZERO, "$", List.of(), null)
            ));

            assertThrows(BusinessException.class,
                    () -> service.calcular(request));
        }
    }

    @Test
    void calcular_sucursalNula_lanzaExcepcion() {
        try (MockedStatic<TenantContext> tenantContext = mockStatic(TenantContext.class)) {
            tenantContext.when(TenantContext::getSucursalId).thenReturn(null);

            CalcularImpuestosRequest request = new CalcularImpuestosRequest();
            request.setItems(List.of(
                    new ItemCalculoRequest(1, BigDecimal.TEN, BigDecimal.ONE, true, BigDecimal.ZERO, "$", List.of(), null)
            ));

            assertThrows(BusinessException.class,
                    () -> service.calcular(request));
        }
    }

    @Test
    void calcular_conPaisNoSoportado_usaDefault() {
        try (MockedStatic<TenantContext> tenantContext = mockStatic(TenantContext.class)) {
            tenantContext.when(TenantContext::getSucursalId).thenReturn(1L);

            mockPaisResolucion(1L, 1L, "CO");
            mockImpuesto(1L, new BigDecimal("19.00"), "IVA", true, 1);

            CalcularImpuestosRequest request = new CalcularImpuestosRequest();
            request.setItems(List.of(
                    new ItemCalculoRequest(1, new BigDecimal("100.00"), BigDecimal.ONE,
                            false, BigDecimal.ZERO, "$", // dsctoTipo
                            List.of(new ImpuestoItemRequest(1L, 1)),
                            null)
            ));

            CalcularImpuestosResponse response = service.calcular(request);

            assertEquals("DEFAULT", response.getPais());
            assertNull(response.getDetraccion());
        }
    }
}
