package pe.restaurant.almacen.flow;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.jdbc.core.JdbcTemplate;
import pe.restaurant.almacen.config.AlmacenIntegracionProperties;
import pe.restaurant.almacen.dto.MovimientoCabeceraRequest;
import pe.restaurant.almacen.dto.MovimientoDetalleResponse;
import pe.restaurant.almacen.entity.ArticuloMovTipo;
import pe.restaurant.almacen.entity.OrdenTraslado;
import pe.restaurant.almacen.entity.OrdenTrasladoDet;
import pe.restaurant.almacen.entity.ValeMov;
import pe.restaurant.almacen.repository.*;
import pe.restaurant.almacen.service.RecepcionTresViasValidator;
import pe.restaurant.almacen.service.ValeMovService;
import pe.restaurant.almacen.service.impl.IntegracionAlmacenServiceImpl;
import pe.restaurant.almacen.service.impl.OrdenTrasladoOperacionServiceImpl;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.service.NumeradorDocumentoService;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static pe.restaurant.almacen.TestDataFactory.*;

/**
 * Flujos de negocio con servicios reales y repos mockeados (patrón {@code ComprasFlowTest}).
 */
@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
@DisplayName("Flujos de negocio — Almacén")
class AlmacenFlowTest {

    @Mock private ValeMovService valeMovService;
    @Mock private JdbcTemplate jdbcTemplate;
    @Mock private ArticuloMovTipoRepository articuloMovTipoRepository;
    @Mock private OrdenTrasladoRepository ordenTrasladoRepository;
    @Mock private OrdenTrasladoDetRepository ordenTrasladoDetRepository;
    @Mock private AlmacenRepository almacenRepository;
    @Mock private ValeMovRepository valeMovRepository;
    @Mock private RecepcionTresViasValidator recepcionTresViasValidator;
    @Mock private AlmacenIntegracionProperties integracionProperties;
    @Mock private ArticuloRefRepository articuloRefRepository;
    @Mock private NumeradorDocumentoService numeradorDocumentoService;

    @InjectMocks private IntegracionAlmacenServiceImpl integracionService;
    @InjectMocks private OrdenTrasladoOperacionServiceImpl ordenTrasladoService;

    @BeforeEach
    void tenant() {
        TenantContext.setEmpresaId(1L);
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(1L);
        when(integracionProperties.isValidarTresVias()).thenReturn(false);
        when(ordenTrasladoDetRepository.findByOrdenTrasladoIdOrderById(anyLong())).thenReturn(List.of());
    }

    @AfterEach
    void clearTenant() {
        TenantContext.clear();
    }

    @Test
    @DisplayName("Flujo recepción OC: validar tipo → crear vale ingreso")
    void flujoRecepcionOc_creaVale() {
        when(articuloMovTipoRepository.findById(5L)).thenReturn(Optional.of(articuloMovTipoIngreso(5L)));
        when(jdbcTemplate.queryForList(anyString(), eq(1L))).thenAnswer(inv -> {
            String sql = inv.getArgument(0);
            if (sql.contains("FROM compras.orden_compra WHERE")) {
                return List.of(filaOrdenCompraJdbc(1L, 99L));
            }
            if (sql.contains("FROM compras.orden_compra_det")) {
                return List.of(filaOrdenCompraDetJdbc(10L, 100L, 20L, new BigDecimal("10"), new BigDecimal("5.00")));
            }
            return List.of();
        });
        when(valeMovService.crear(any(MovimientoCabeceraRequest.class)))
                .thenReturn(movimientoDetalleResponse(700L));

        var req = integracionRecepcionOcRequest();
        MovimientoDetalleResponse out = integracionService.recepcionarOrdenCompra(req);

        assertThat(out.getId()).isEqualTo(700L);
        ArgumentCaptor<MovimientoCabeceraRequest> cap = ArgumentCaptor.forClass(MovimientoCabeceraRequest.class);
        verify(valeMovService).crear(cap.capture());
        assertThat(cap.getValue().getOrdenCompraId()).isEqualTo(1L);
        assertThat(cap.getValue().getTipoReferenciaOrigen()).isEqualTo("I");
    }

    @Test
    @DisplayName("Flujo orden traslado: aprobar → ejecutar integración (vale salida)")
    void flujoOrdenTraslado_aprobarYEjecutar() {
        OrdenTraslado ot = ordenTraslado(1L);
        when(ordenTrasladoRepository.findById(1L)).thenReturn(Optional.of(ot));
        when(ordenTrasladoRepository.findByIdForUpdate(1L)).thenReturn(Optional.of(ot));

        assertThat(ordenTrasladoService.aprobar(1L).getFlagEstado()).isEqualTo("1");

        OrdenTrasladoDet det = ordenTrasladoDet(1L, 100L, new BigDecimal("5"));
        when(ordenTrasladoDetRepository.findByOrdenTrasladoIdOrderById(1L)).thenReturn(List.of(det));
        when(articuloMovTipoRepository.findById(3L)).thenReturn(Optional.of(articuloMovTipoTrasladoSalida(3L, true)));
        when(almacenRepository.findById(10L)).thenReturn(Optional.of(almacen(10L)));
        when(valeMovService.crear(any())).thenReturn(movimientoDetalleResponse(800L));
        when(valeMovRepository.findFirstByOrdenTrasladoIdAndIdGreaterThanOrderByIdAsc(1L, 800L))
                .thenReturn(Optional.of(valeMov(901L)));
        when(valeMovService.obtener(901L)).thenReturn(movimientoDetalleResponse(901L));

        var resultado = integracionService.ejecutarTraslado(integracionTrasladoEjecutarRequest());

        assertThat(resultado.getMovimientoSalida().getId()).isEqualTo(800L);
        assertThat(resultado.getMovimientoIngreso().getId()).isEqualTo(901L);
        verify(valeMovService).crear(any());
        verify(valeMovService).obtener(901L);
    }
}
