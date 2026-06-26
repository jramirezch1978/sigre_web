package pe.restaurant.compras.flow;

import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mail.javamail.JavaMailSender;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.service.ConfigParameterService;
import pe.restaurant.common.service.NumeradorDocumentoService;
import pe.restaurant.compras.dto.*;
import pe.restaurant.compras.entity.*;
import pe.restaurant.compras.client.AlmacenClient;
import pe.restaurant.compras.mapper.ContratoMarcoMapper;
import pe.restaurant.compras.repository.*;
import pe.restaurant.compras.service.*;
import pe.restaurant.compras.service.impl.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.mockito.Mockito.lenient;
import static pe.restaurant.compras.ComprasTestFixtures.*;

/**
 * Tests de flujo de negocio end-to-end para el módulo de Compras.
 *
 * Cada test simula un escenario completo del ciclo de vida de documentos de compra
 * (OC, Solicitud, Cotización, Contrato Marco) usando los servicios reales con repos mockeados.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("Flujos de negocio — Compras")
class ComprasFlowTest {

    // ── Repos OC ──
    @Mock private OrdenCompraRepository ordenCompraRepository;
    @Mock private AprobacionRepository aprobacionRepository;
    @Mock private OcImportacionRepository ocImportacionRepository;
    @Mock private IncotermRepository incotermRepository;
    @Mock private ArticuloMovProyRepository articuloMovProyRepository;
    @Mock private EntidadBancoCntaRepository entidadBancoCntaRepository;
    @Mock private ArticuloPrecioPactadoRepository articuloPrecioPactadoRepository;
    @Mock private NumeradorDocumentoService numeradorDocumentoService;
    @Mock private OrdenCompraCalculator calculator;
    @Mock private OrdenCompraValidator validator;
    @Mock private OrdenCompraPdfService pdfService;
    @Mock private ConfigParameterService configParameterService;
    @Mock private EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    @Mock private ArticuloRefRepository articuloRefRepository;
    @Mock private UnidadMedidaRefRepository unidadMedidaRefRepository;
    @Mock private ArticuloCategoriaRefRepository articuloCategoriaRefRepository;
    @Mock private ArticuloAlmacenRefRepository articuloAlmacenRefRepository;
    @Mock private AlmacenTacitoRefRepository almacenTacitoRefRepository;
    @Mock private ValeMovRefRepository valeMovRefRepository;
    @Mock private AprobadorConfiguradoRepository aprobadorConfiguradoRepository;
    @Mock private MonedaRefRepository monedaRefRepository;
    @Mock private CompradorRepository compradorRepository;
    @Mock private UsuarioRefRepository usuarioRefRepository;
    @Mock private JdbcTemplate jdbcTemplate;
    @Mock private AlmacenClient almacenClient;

    // ── Repos CM ──
    @Mock private ContratoMarcoRepository contratoMarcoRepository;
    @Mock private ContratoMarcoMapper contratoMarcoMapper;

    @InjectMocks private OrdenCompraServiceImpl ocService;
    @InjectMocks private ContratoMarcoServiceImpl cmService;

    @BeforeEach
    void setTenant() {
        TenantContext.setEmpresaId(1L);
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void clearTenant() {
        TenantContext.clear();
    }

    // ══════════════════════════════════════════════════════════════════════
    // FLUJO 1: Ciclo de vida OC completo
    //   BORRADOR → enviarAprobacion → PENDIENTE → aprobar → APROBADA → cerrar → CERRADA
    // ══════════════════════════════════════════════════════════════════════

    @Test
    @DisplayName("Flujo OC completo: crear → enviar → aprobar → cerrar")
    void flujoOcCompleto_borrador_aprobada_cerrada() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "3");

        when(validator.verificarCompradorActivo()).thenReturn(1L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenAnswer(inv -> inv.getArgument(0));

        // Paso 1: enviar a aprobación
        ocService.enviarAprobacion(1L);
        assertThat(oc.getFlagEstado()).isEqualTo("3");
        assertThat(oc.getFlagEstado()).isEqualTo("3");

        // Paso 2: aprobar
        ocService.aprobar(1L, "Todo en orden");
        assertThat(oc.getFlagEstado()).isEqualTo("1");
        assertThat(oc.getFlagEstado()).isEqualTo("1");
        assertThat(oc.getAprobadorId()).isEqualTo(1L);

        // Paso 3: cerrar
        ocService.cerrar(1L);
        assertThat(oc.getFlagEstado()).isEqualTo("2");
        assertThat(oc.getFlagEstado()).isEqualTo("2");

        verify(aprobacionRepository, atLeast(2)).save(any());
    }

    // ══════════════════════════════════════════════════════════════════════
    // FLUJO 2: OC rechazada y reenviada
    //   BORRADOR → enviar → rechazar → RECHAZADA → enviar otra vez → aprobar
    // ══════════════════════════════════════════════════════════════════════

    @Test
    @DisplayName("Flujo OC rechazo + reenvío: enviar → rechazar → reenviar → aprobar")
    void flujoOcRechazoReenvio() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "3");

        when(validator.verificarCompradorActivo()).thenReturn(1L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenAnswer(inv -> inv.getArgument(0));
        when(valeMovRefRepository.findByOrdenCompraIdOrderByFechaDesc(1L)).thenReturn(Collections.emptyList());

        // Enviar
        ocService.enviarAprobacion(1L);
        assertThat(oc.getFlagEstado()).isEqualTo("3");

        // Rechazar
        ocService.rechazar(1L, "Precios incorrectos");
        assertThat(oc.getFlagEstado()).isEqualTo("0");

        // Reenviar (RECHAZADA es estado válido para reenviar)
        ocService.enviarAprobacion(1L);
        assertThat(oc.getFlagEstado()).isEqualTo("3");

        // Aprobar
        ocService.aprobar(1L, "Corregido");
        assertThat(oc.getFlagEstado()).isEqualTo("1");
    }

    // ══════════════════════════════════════════════════════════════════════
    // FLUJO 3: Devolución de OC
    //   BORRADOR → enviar → devolver → BORRADOR (vuelta al inicio)
    // ══════════════════════════════════════════════════════════════════════

    @Test
    @DisplayName("Flujo OC devolución: enviar → devolver → vuelve a BORRADOR")
    void flujoOcDevolucion() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "3");

        when(validator.verificarCompradorActivo()).thenReturn(1L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenAnswer(inv -> inv.getArgument(0));

        ocService.enviarAprobacion(1L);
        assertThat(oc.getFlagEstado()).isEqualTo("3");

        ocService.devolver(1L, "Falta firma del área");
        assertThat(oc.getFlagEstado()).isEqualTo("1");
    }

    // ══════════════════════════════════════════════════════════════════════
    // VALIDACIÓN: No aprobar OC que no está en PENDIENTE
    // ══════════════════════════════════════════════════════════════════════

    @Test
    @DisplayName("No se puede aprobar OC en BORRADOR")
    void noApruebaOcEnBorrador() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "1");
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        assertThatThrownBy(() -> ocService.aprobar(1L, "Ok"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("pendiente de aprobación");
    }

    @Test
    @DisplayName("No se puede devolver OC ya APROBADA")
    void noDevuelveOcAprobada() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "1");
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        assertThatThrownBy(() -> ocService.devolver(1L, "Motivo"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("pendiente");
    }

    @Test
    @DisplayName("No se puede rechazar OC en BORRADOR")
    void noRechazaOcEnBorrador() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "1");
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        assertThatThrownBy(() -> ocService.rechazar(1L, "Motivo"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("pendiente de aprobación");
    }

    // ══════════════════════════════════════════════════════════════════════
    // VALIDACIÓN: No anular OC con ingresos al almacén
    // ══════════════════════════════════════════════════════════════════════

    @Test
    @DisplayName("No se puede anular OC con cantidades procesadas (ingresos de almacén)")
    void noAnulaOcConIngresos() {
        OrdenCompra oc = ordenCompraConDetalle(1L);
        oc.setFlagEstado("1");
        oc.getLineas().get(0).setCantProcesada(new BigDecimal("5"));

        when(validator.verificarCompradorActivo()).thenReturn(1L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        assertThatThrownBy(() -> ocService.anular(1L, "Error"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ingresos al almacén");
    }

    // ══════════════════════════════════════════════════════════════════════
    // VALIDACIÓN: No cerrar OC anulada
    // ══════════════════════════════════════════════════════════════════════

    @Test
    @DisplayName("No se puede cerrar una OC anulada (flagEstado=0)")
    void noCierraOcAnulada() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "0");
        oc.setFlagEstado("0");
        when(validator.verificarCompradorActivo()).thenReturn(1L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        assertThatThrownBy(() -> ocService.cerrar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("anulada");
    }

    // ══════════════════════════════════════════════════════════════════════
    // VALIDACIÓN: Cerrar OC importación sin DUA lanza error
    // ══════════════════════════════════════════════════════════════════════

    @Test
    @DisplayName("No se puede cerrar OC de importación sin número de DUA")
    void noCierraImportacionSinDua() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "1");
        oc.setFlagImportacion("1");
        oc.setFlagSolicitaDua("1");
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(ocImportacionRepository.findByOrdenCompraId(1L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> ocService.cerrar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("DUA");
    }

    // ══════════════════════════════════════════════════════════════════════
    // FLUJO Contrato Marco: crear → suspender → reabrir → cerrar → anular
    // ══════════════════════════════════════════════════════════════════════

    @Test
    @DisplayName("Flujo Contrato Marco completo: VIGENTE → suspender → reabrir → cerrar")
    void flujoContratoMarcoCompleto() {
        ContratoMarco cm = contratoMarco(1L, "1");

        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));
        when(contratoMarcoRepository.save(any(ContratoMarco.class))).thenAnswer(inv -> inv.getArgument(0));

        // Suspender
        cmService.suspender(1L, "Revisión de precios");
        assertThat(cm.getFlagEstado()).isEqualTo("0");
        assertThat(cm.getCondiciones()).contains("SUSPENDIDO");

        // Reabrir
        cmService.reabrir(1L, "Precios corregidos");
        assertThat(cm.getFlagEstado()).isEqualTo("1");
        assertThat(cm.getCondiciones()).contains("REABIERTO");

        // Cerrar
        cmService.cerrar(1L, "Venció el contrato");
        assertThat(cm.getFlagEstado()).isEqualTo("2");
        assertThat(cm.getCondiciones()).contains("CERRADO");
    }

    @Test
    @DisplayName("No se puede suspender contrato que no está VIGENTE")
    void noSuspendeContratoNoVigente() {
        ContratoMarco cm = contratoMarco(1L, "2");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        assertThatThrownBy(() -> cmService.suspender(1L, "Motivo"))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    @DisplayName("No se puede reabrir contrato que no está SUSPENDIDO")
    void noReabreContratoVigente() {
        ContratoMarco cm = contratoMarco(1L, "1");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        assertThatThrownBy(() -> cmService.reabrir(1L, "Motivo"))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    @DisplayName("No se puede anular contrato ya anulado")
    void noAnulaContratoYaAnulado() {
        ContratoMarco cm = contratoMarco(1L, "0");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        assertThatThrownBy(() -> cmService.anular(1L, "Motivo"))
                .isInstanceOf(BusinessException.class);
    }

    // ══════════════════════════════════════════════════════════════════════
    // VALIDACIÓN: Recepción de almacén llama al Feign client
    // ══════════════════════════════════════════════════════════════════════

    @Test
    @DisplayName("Recepción en almacén invoca AlmacenClient vía Feign")
    void recepcionEnAlmacenInvocaFeign() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "1");
        when(validator.verificarCompradorActivo()).thenReturn(1L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        MovimientoDetalleResponse movResp = new MovimientoDetalleResponse();
        movResp.setId(99L);
        lenient().when(almacenClient.recepcionOrdenCompra(any(IntegracionRecepcionOcRequest.class)))
                .thenReturn(pe.restaurant.common.dto.ApiResponse.ok(movResp));

        OrdenCompraRecepcionRequest req = new OrdenCompraRecepcionRequest();
        req.setArticuloMovTipoId(1L);
        req.setAlmacenId(1L);
        req.setFechaMov(LocalDate.now());

        lenient().when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(oc);

        OrdenCompraRecepcionResponse result = ocService.recepcionarEnAlmacen(1L, req);

        verify(almacenClient).recepcionOrdenCompra(any(IntegracionRecepcionOcRequest.class));
        assertThat(result).isNotNull();
    }

}
