package pe.restaurant.activos.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.dto.AfMaestroDesdeCompraRequest;
import pe.restaurant.activos.dto.AfMaestroDesdeFacturaCompraRequest;
import pe.restaurant.activos.dto.AfMaestroDesdeRecepcionRequest;
import pe.restaurant.activos.dto.AfMaestroResponse;
import pe.restaurant.activos.dto.IntegracionContabilidadResult;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.mapper.AfMaestroMapper;
import pe.restaurant.activos.service.ComprasIntegracionService;
import pe.restaurant.activos.service.ContabilidadIntegracionService;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AfIntegracionControllerTest {

    @Mock
    private ContabilidadIntegracionService contabilidadIntegracionService;
    @Mock
    private ComprasIntegracionService comprasIntegracionService;
    @Mock
    private AfMaestroMapper maestroMapper;

    @InjectMocks
    private AfIntegracionController controller;

    private IntegracionContabilidadResult result(long asientoId) {
        return IntegracionContabilidadResult.builder().asientoId(asientoId).yaExistia(false).build();
    }

    @Test
    void contabilizarDepreciacion() {
        when(contabilidadIntegracionService.contabilizarDepreciacion(10L)).thenReturn(result(1L));
        assertThat(controller.contabilizarDepreciacion(10L).getData().getAsientoId()).isEqualTo(1L);
    }

    @Test
    void contabilizarDevengo() {
        when(contabilidadIntegracionService.contabilizarDevengoPrima(20L)).thenReturn(result(2L));
        var resp = controller.contabilizarDevengo(20L);
        assertThat(resp.isSuccess()).isTrue();
        assertThat(resp.getData().getAsientoId()).isEqualTo(2L);
    }

    @Test
    void contabilizarVenta() {
        when(contabilidadIntegracionService.contabilizarVenta(30L)).thenReturn(result(3L));
        var resp = controller.contabilizarVenta(30L);
        assertThat(resp.isSuccess()).isTrue();
        assertThat(resp.getData().getAsientoId()).isEqualTo(3L);
    }

    @Test
    void contabilizarValuacion() {
        when(contabilidadIntegracionService.contabilizarValuacion(40L)).thenReturn(result(4L));
        var resp = controller.contabilizarValuacion(40L);
        assertThat(resp.isSuccess()).isTrue();
        assertThat(resp.getData().getAsientoId()).isEqualTo(4L);
    }

    @Test
    void contabilizarAlta() {
        when(contabilidadIntegracionService.contabilizarAltaActivo(50L)).thenReturn(result(5L));
        var resp = controller.contabilizarAlta(50L);
        assertThat(resp.isSuccess()).isTrue();
        assertThat(resp.getData().getAsientoId()).isEqualTo(5L);
    }

    @Test
    void contabilizarAdaptacion() {
        when(contabilidadIntegracionService.contabilizarAdaptacion(60L)).thenReturn(result(6L));
        var resp = controller.contabilizarAdaptacion(60L);
        assertThat(resp.isSuccess()).isTrue();
        assertThat(resp.getData().getAsientoId()).isEqualTo(6L);
    }

    @Test
    void contabilizarBaja() {
        when(contabilidadIntegracionService.contabilizarBajaActivo(70L)).thenReturn(result(7L));
        var resp = controller.contabilizarBaja(70L);
        assertThat(resp.isSuccess()).isTrue();
        assertThat(resp.getData().getAsientoId()).isEqualTo(7L);
    }

    @Test
    void trazabilidad() {
        when(contabilidadIntegracionService.consultarTrazabilidad("VENTA", 90L)).thenReturn(result(9L));
        var resp = controller.trazabilidad("VENTA", 90L);
        assertThat(resp.isSuccess()).isTrue();
        assertThat(resp.getData().getAsientoId()).isEqualTo(9L);
    }

    @Test
    void crearMaestroDesdeOrdenCompra() {
        AfMaestro entity = new AfMaestro();
        entity.setId(5L);
        AfMaestroResponse response = new AfMaestroResponse();
        response.setId(5L);
        var req = new AfMaestroDesdeCompraRequest();
        req.setOrdenCompraId(1L);
        req.setOrdenCompraLineaId(2L);
        req.setCodigo("AF-1");
        req.setAfSubClaseId(1L);
        req.setValorAdquisicion(BigDecimal.TEN);
        req.setValorResidual(BigDecimal.ZERO);
        when(comprasIntegracionService.crearMaestroDesdeOrdenCompra(req)).thenReturn(entity);
        when(maestroMapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.crearMaestroDesdeOrdenCompra(req).getData().getId()).isEqualTo(5L);
    }

    @Test
    void crearMaestroDesdeRecepcion() {
        AfMaestro entity = new AfMaestro();
        entity.setId(6L);
        AfMaestroResponse response = new AfMaestroResponse();
        response.setId(6L);
        var req = new AfMaestroDesdeRecepcionRequest();
        req.setOrdenCompraId(1L);
        req.setRecepcionId(10L);
        req.setOrdenCompraLineaId(2L);
        req.setCodigo("AF-REC-001");
        req.setAfSubClaseId(1L);
        req.setValorAdquisicion(BigDecimal.TEN);
        req.setValorResidual(BigDecimal.ZERO);
        when(comprasIntegracionService.crearMaestroDesdeRecepcion(req)).thenReturn(entity);
        when(maestroMapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.crearMaestroDesdeRecepcion(req).getData().getId()).isEqualTo(6L);
    }

    @Test
    void crearMaestroDesdeFactura() {
        AfMaestro entity = new AfMaestro();
        entity.setId(7L);
        AfMaestroResponse response = new AfMaestroResponse();
        response.setId(7L);

        var req = new AfMaestroDesdeFacturaCompraRequest();
        req.setOrdenCompraId(1L);
        req.setOrdenCompraLineaId(2L);
        req.setFacturaSerie("F001");
        req.setFacturaNumero("000123");
        req.setFacturaFecha(LocalDate.of(2026, 4, 1));
        req.setCodigo("AF-FAC-001");
        req.setAfSubClaseId(1L);
        req.setValorAdquisicion(BigDecimal.TEN);
        req.setValorResidual(BigDecimal.ZERO);

        when(comprasIntegracionService.crearMaestroDesdeFacturaCompra(req)).thenReturn(entity);
        when(maestroMapper.toResponse(entity)).thenReturn(response);

        var resp = controller.crearMaestroDesdeFactura(req);
        assertThat(resp.isSuccess()).isTrue();
        assertThat(resp.getData().getId()).isEqualTo(7L);
    }
}
