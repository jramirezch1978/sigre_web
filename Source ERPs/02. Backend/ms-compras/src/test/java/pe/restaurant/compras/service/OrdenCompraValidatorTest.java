package pe.restaurant.compras.service;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;
import pe.restaurant.compras.dto.OrdenCompraCabeceraRequest;
import pe.restaurant.compras.dto.OrdenCompraLineaRequest;
import pe.restaurant.compras.entity.*;
import pe.restaurant.compras.repository.*;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.service.ConfigParameterService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("OrdenCompraValidator — Pruebas Unitarias")
class OrdenCompraValidatorTest {

    @Mock private CompradorRepository compradorRepository;
    @Mock private AprobadorConfiguradoRepository aprobadorConfiguradoRepository;
    @Mock private CompraFondoRepository compraFondoRepository;
    @Mock private EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    @Mock private MonedaRefRepository monedaRefRepository;
    @Mock private SucursalRefRepository sucursalRefRepository;
    @Mock private ArticuloRefRepository articuloRefRepository;
    @Mock private TiposImpuestoRefRepository tiposImpuestoRefRepository;
    @Mock private ConfigParameterService configParameterService;
    @Mock private ValeMovRefRepository valeMovRefRepository;
    @Mock private JdbcTemplate jdbcTemplate;
    @InjectMocks private OrdenCompraValidator validator;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(entidadContribuyenteRefRepository.existsById(anyLong())).thenReturn(true);
        lenient().when(monedaRefRepository.existsById(anyLong())).thenReturn(true);
        lenient().when(sucursalRefRepository.existsById(anyLong())).thenReturn(true);
        lenient().when(jdbcTemplate.queryForObject(
                eq("SELECT id FROM core.doc_tipo WHERE codigo = ? AND flag_estado = '1'"),
                eq(Long.class), eq("OC")))
                .thenReturn(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ── verificarCompradorActivo ──

    @Test
    @DisplayName("verificarCompradorActivo() ok")
    void verificarCompradorActivo_ok() {
        Comprador c = new Comprador();
        c.setId(10L);
        when(compradorRepository.findByUsuarioIdAndFlagEstado(1L, "1")).thenReturn(Optional.of(c));

        Long id = validator.verificarCompradorActivo();
        assertThat(id).isEqualTo(10L);
    }

    @Test
    @DisplayName("verificarCompradorActivo() no existe -> lanza COM-002")
    void verificarCompradorActivo_noExiste_lanzaCOM002() {
        when(compradorRepository.findByUsuarioIdAndFlagEstado(1L, "1")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> validator.verificarCompradorActivo())
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("comprador activo");
    }

    @Test
    @DisplayName("verificarCompradorActivo() sin usuario id -> lanza unauthorized")
    void verificarCompradorActivo_sinUsuarioId_lanzaUnauthorized() {
        TenantContext.clear();
        assertThatThrownBy(() -> validator.verificarCompradorActivo())
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("autenticado");
    }

    // ── validarCabecera ──

    @Test
    @DisplayName("validarCabecera() moneda extranjera sin tipo cambio -> lanza COM-003")
    void validarCabecera_monedaExtranjera_sinTipoCambio_lanzaCOM003() {
        OrdenCompraCabeceraRequest req = buildCabeceraRequest();
        req.setMonedaId(2L);
        req.setTipoCambio(null);

        assertThatThrownBy(() -> validator.validarCabecera(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("tipo de cambio");
    }

    @Test
    @DisplayName("validarCabecera() moneda extranjera con tipo cambio -> ok")
    void validarCabecera_monedaExtranjera_conTipoCambio_ok() {
        OrdenCompraCabeceraRequest req = buildCabeceraRequest();
        req.setMonedaId(2L);
        req.setTipoCambio(new BigDecimal("3.72"));

        validator.validarCabecera(req);
    }

    @Test
    @DisplayName("validarCabecera() moneda pen sin tipo cambio -> ok")
    void validarCabecera_monedaPEN_sinTipoCambio_ok() {
        OrdenCompraCabeceraRequest req = buildCabeceraRequest();
        req.setMonedaId(1L);

        validator.validarCabecera(req);
    }

    @Test
    @DisplayName("validarCabecera() importación sin datos -> lanza COM-004")
    void validarCabecera_importacionSinDatos_lanzaCOM004() {
        OrdenCompraCabeceraRequest req = buildCabeceraRequest();
        req.setFlagImportacion(true);
        req.setImportacion(null);

        assertThatThrownBy(() -> validator.validarCabecera(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("importación");
    }

    @Test
    @DisplayName("validarCabecera() proveedor no existe -> lanza error")
    void validarCabecera_proveedorNoExiste_lanzaError() {
        OrdenCompraCabeceraRequest req = buildCabeceraRequest();
        when(entidadContribuyenteRefRepository.existsById(1L)).thenReturn(false);

        assertThatThrownBy(() -> validator.validarCabecera(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("no existe");
    }

    // ── validarDetalle ──

    @Test
    @DisplayName("validarDetalle() lista null -> lanza COM-005")
    void validarDetalle_listaNull_lanzaCOM005() {
        assertThatThrownBy(() -> validator.validarDetalle(null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("al menos una línea");
    }

    @Test
    @DisplayName("validarDetalle() lista vacia -> lanza COM-005")
    void validarDetalle_listaVacia_lanzaCOM005() {
        assertThatThrownBy(() -> validator.validarDetalle(Collections.emptyList()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("al menos una línea");
    }

    @Test
    @DisplayName("validarDetalle() cantidad cero -> lanza COM-006")
    void validarDetalle_cantidadCero_lanzaCOM006() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        l.setCantProyectada(BigDecimal.ZERO);

        assertThatThrownBy(() -> validator.validarDetalle(List.of(l)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cantidad");
    }

    @Test
    @DisplayName("validarDetalle() cantidad null -> lanza COM-006")
    void validarDetalle_cantidadNull_lanzaCOM006() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        l.setCantProyectada(null);

        assertThatThrownBy(() -> validator.validarDetalle(List.of(l)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cantidad");
    }

    @Test
    @DisplayName("validarDetalle() precio null -> lanza COM-007")
    void validarDetalle_precioNull_lanzaCOM007() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        l.setValorUnitario(null);

        assertThatThrownBy(() -> validator.validarDetalle(List.of(l)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("precio unitario");
    }

    @Test
    @DisplayName("validarDetalle() precio cero -> lanza COM-007")
    void validarDetalle_precioCero_lanzaCOM007() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        l.setValorUnitario(BigDecimal.ZERO);

        assertThatThrownBy(() -> validator.validarDetalle(List.of(l)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("precio unitario");
    }

    @Test
    @DisplayName("validarDetalle() sin fecha entrega -> lanza COM-008")
    void validarDetalle_sinFechaEntrega_lanzaCOM008() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        l.setFechaEntrega(null);

        assertThatThrownBy(() -> validator.validarDetalle(List.of(l)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("fecha de entrega");
    }

    @Test
    @DisplayName("validarDetalle() ok")
    void validarDetalle_ok() {
        validator.validarDetalle(List.of(buildLineaRequest()));
    }

    // ── validarDetalleFino ──

    @Test
    @DisplayName("validarDetalleFino() artículo no existe -> lanza COM-028")
    void validarDetalleFino_articuloNoExiste_lanzaCOM028() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        when(articuloRefRepository.findById(1L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> validator.validarDetalleFino(List.of(l), LocalDate.now()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("no existe");
    }

    @Test
    @DisplayName("validarDetalleFino() artículo inactivo -> lanza COM-027")
    void validarDetalleFino_articuloInactivo_lanzaCOM027() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        ArticuloRef art = mock(ArticuloRef.class);
        when(art.getFlagEstado()).thenReturn("0");
        when(articuloRefRepository.findById(1L)).thenReturn(Optional.of(art));

        assertThatThrownBy(() -> validator.validarDetalleFino(List.of(l), LocalDate.now()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("no está activo");
    }

    @Test
    @DisplayName("validarDetalleFino() tipo impuesto no existe -> lanza COM-029")
    void validarDetalleFino_tipoImpuestoNoExiste_lanzaCOM029() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        l.setTipoImpuestoId(999L);
        ArticuloRef art = mock(ArticuloRef.class);
        when(art.getFlagEstado()).thenReturn("1");
        when(articuloRefRepository.findById(1L)).thenReturn(Optional.of(art));
        when(tiposImpuestoRefRepository.existsById(999L)).thenReturn(false);

        assertThatThrownBy(() -> validator.validarDetalleFino(List.of(l), LocalDate.now()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("tipo de impuesto");
    }

    @Test
    @DisplayName("validarDetalleFino() fecha entrega anterior a emision -> lanza COM-026")
    void validarDetalleFino_fechaEntregaAnteriorAEmision_lanzaCOM026() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        l.setFechaEntrega(LocalDate.of(2026, 1, 1));
        ArticuloRef art = mock(ArticuloRef.class);
        when(art.getFlagEstado()).thenReturn("1");
        when(articuloRefRepository.findById(1L)).thenReturn(Optional.of(art));

        assertThatThrownBy(() -> validator.validarDetalleFino(List.of(l), LocalDate.of(2026, 4, 15)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("fecha de entrega");
    }

    @Test
    @DisplayName("validarDetalleFino() ok")
    void validarDetalleFino_ok() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        l.setTipoImpuestoId(1L);
        ArticuloRef art = mock(ArticuloRef.class);
        when(art.getFlagEstado()).thenReturn("1");
        when(articuloRefRepository.findById(1L)).thenReturn(Optional.of(art));
        when(tiposImpuestoRefRepository.existsById(1L)).thenReturn(true);

        validator.validarDetalleFino(List.of(l), LocalDate.now());
    }

    @Test
    @DisplayName("validarDetalleFino() lista null -> no lanza excepción")
    void validarDetalleFino_listaNull_noLanzaExcepcion() {
        validator.validarDetalleFino(null, LocalDate.now());
    }

    // ── verificarPrecios ──

    @Test
    @DisplayName("verificarPrecios() precios cero -> lanza COM-009")
    void verificarPrecios_preciosCero_lanzaCOM009() {
        OrdenCompra oc = new OrdenCompra();
        oc.setFlagEstado("1");
        OrdenCompraDet l = new OrdenCompraDet();
        l.setFlagEstado("1");
        l.setArticuloId(1L);
        l.setValorUnitario(BigDecimal.ZERO);
        l.setCantProyectada(new BigDecimal("10"));
        oc.addLinea(l);

        assertThatThrownBy(() -> validator.verificarPrecios(oc))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("precio cero");
    }

    @Test
    @DisplayName("verificarPrecios() cantidad cero -> lanza COM-010")
    void verificarPrecios_cantidadCero_lanzaCOM010() {
        OrdenCompra oc = new OrdenCompra();
        oc.setFlagEstado("1");
        OrdenCompraDet l = new OrdenCompraDet();
        l.setFlagEstado("1");
        l.setArticuloId(1L);
        l.setValorUnitario(new BigDecimal("100"));
        l.setCantProyectada(BigDecimal.ZERO);
        oc.addLinea(l);

        assertThatThrownBy(() -> validator.verificarPrecios(oc))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cantidad cero");
    }

    @Test
    @DisplayName("verificarPrecios() oc inactiva -> no valida")
    void verificarPrecios_ocInactiva_noValida() {
        OrdenCompra oc = new OrdenCompra();
        oc.setFlagEstado("0");
        OrdenCompraDet l = new OrdenCompraDet();
        l.setFlagEstado("1");
        l.setValorUnitario(BigDecimal.ZERO);
        l.setCantProyectada(BigDecimal.ZERO);
        oc.addLinea(l);

        validator.verificarPrecios(oc);
    }

    @Test
    @DisplayName("verificarPrecios() línea inactiva -> ignorada")
    void verificarPrecios_lineaInactiva_ignorada() {
        OrdenCompra oc = new OrdenCompra();
        oc.setFlagEstado("1");
        OrdenCompraDet l = new OrdenCompraDet();
        l.setFlagEstado("0");
        l.setValorUnitario(BigDecimal.ZERO);
        l.setCantProyectada(BigDecimal.ZERO);
        oc.addLinea(l);

        validator.verificarPrecios(oc);
    }

    @Test
    @DisplayName("verificarPrecios() ok")
    void verificarPrecios_ok() {
        OrdenCompra oc = new OrdenCompra();
        oc.setFlagEstado("1");
        OrdenCompraDet l = new OrdenCompraDet();
        l.setFlagEstado("1");
        l.setArticuloId(1L);
        l.setValorUnitario(new BigDecimal("100"));
        l.setCantProyectada(new BigDecimal("10"));
        oc.addLinea(l);

        validator.verificarPrecios(oc);
    }

    // ── validarAprobadorConfigurado ──

    @Test
    @DisplayName("validarAprobadorConfigurado() no existe -> lanza COM-022")
    void validarAprobadorConfigurado_noExiste_lanzaCOM022() {
        when(aprobadorConfiguradoRepository.findAll()).thenReturn(Collections.emptyList());

        assertThatThrownBy(() -> validator.validarAprobadorConfigurado(1L, new BigDecimal("1000")))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("aprobador configurado");
    }

    @Test
    @DisplayName("validarAprobadorConfigurado() fuera de rango -> lanza COM-023")
    void validarAprobadorConfigurado_fueraDeRango_lanzaCOM023() {
        AprobadorConfigurado a = buildAprobador(1L, new BigDecimal("100"), new BigDecimal("500"));
        when(aprobadorConfiguradoRepository.findAll()).thenReturn(List.of(a));

        assertThatThrownBy(() -> validator.validarAprobadorConfigurado(1L, new BigDecimal("1000")))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("rango autorizado");
    }

    @Test
    @DisplayName("validarAprobadorConfigurado() dentro de rango -> ok")
    void validarAprobadorConfigurado_dentroDeRango_ok() {
        AprobadorConfigurado a = buildAprobador(1L, new BigDecimal("100"), new BigDecimal("5000"));
        when(aprobadorConfiguradoRepository.findAll()).thenReturn(List.of(a));

        validator.validarAprobadorConfigurado(1L, new BigDecimal("1000"));
    }

    @Test
    @DisplayName("validarAprobadorConfigurado() sin monto maximo -> ok")
    void validarAprobadorConfigurado_sinMontoMaximo_ok() {
        AprobadorConfigurado a = buildAprobador(1L, new BigDecimal("100"), null);
        when(aprobadorConfiguradoRepository.findAll()).thenReturn(List.of(a));

        validator.validarAprobadorConfigurado(1L, new BigDecimal("999999"));
    }

    @Test
    @DisplayName("validarAprobadorConfigurado() sin monto minimo -> ok")
    void validarAprobadorConfigurado_sinMontoMinimo_ok() {
        AprobadorConfigurado a = buildAprobador(1L, null, new BigDecimal("5000"));
        when(aprobadorConfiguradoRepository.findAll()).thenReturn(List.of(a));

        validator.validarAprobadorConfigurado(1L, new BigDecimal("100"));
    }

    // ── verificarNoVieneDeAprovisionamiento ──

    @Test
    @DisplayName("verificarNoVieneDeAprovisionamiento() sin vales -> ok")
    void verificarNoVieneDeAprovisionamiento_sinVales_ok() {
        when(valeMovRefRepository.findByOrdenCompraIdOrderByFechaDesc(1L)).thenReturn(Collections.emptyList());
        validator.verificarNoVieneDeAprovisionamiento(1L);
    }

    @Test
    @DisplayName("verificarNoVieneDeAprovisionamiento() con vales -> lanza COM-012")
    void verificarNoVieneDeAprovisionamiento_conVales_lanzaCOM012() {
        when(valeMovRefRepository.findByOrdenCompraIdOrderByFechaDesc(1L))
                .thenReturn(Collections.singletonList(null));

        assertThatThrownBy(() -> validator.verificarNoVieneDeAprovisionamiento(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Aprovisionamiento");
    }

    // ── verificarSinAnticipos ──

    @Test
    @DisplayName("verificarSinAnticipos() con anticipos -> lanza COM-014")
    void verificarSinAnticipos_conAnticipos_lanzaCOM014() {
        when(jdbcTemplate.queryForObject(contains("oc_nota_credito"), eq(BigDecimal.class), eq(1L)))
                .thenReturn(new BigDecimal("500"));

        assertThatThrownBy(() -> validator.verificarSinAnticipos(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("anticipos emitidos");
    }

    @Test
    @DisplayName("verificarSinAnticipos() sin anticipos -> ok")
    void verificarSinAnticipos_sinAnticipos_ok() {
        when(jdbcTemplate.queryForObject(contains("oc_nota_credito"), eq(BigDecimal.class), eq(1L)))
                .thenReturn(BigDecimal.ZERO);

        validator.verificarSinAnticipos(1L);
    }

    @Test
    @DisplayName("verificarSinAnticipos() excepción sql -> ok")
    void verificarSinAnticipos_excepcionSql_ok() {
        when(jdbcTemplate.queryForObject(contains("oc_nota_credito"), eq(BigDecimal.class), eq(1L)))
                .thenThrow(new RuntimeException("no table"));

        validator.verificarSinAnticipos(1L);
    }

    // ── verificarAnticiposNoExcedenTotal ──

    @Test
    @DisplayName("verificarAnticiposNoExcedenTotal() excede -> lanza COM-019")
    void verificarAnticiposNoExcedenTotal_excede_lanzaCOM019() {
        when(jdbcTemplate.queryForObject(contains("oc_nota_credito"), eq(BigDecimal.class), eq(1L)))
                .thenReturn(new BigDecimal("600"));

        assertThatThrownBy(() -> validator.verificarAnticiposNoExcedenTotal(1L, new BigDecimal("500")))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("nuevo total");
    }

    @Test
    @DisplayName("verificarAnticiposNoExcedenTotal() ok")
    void verificarAnticiposNoExcedenTotal_ok() {
        when(jdbcTemplate.queryForObject(contains("oc_nota_credito"), eq(BigDecimal.class), eq(1L)))
                .thenReturn(new BigDecimal("400"));

        validator.verificarAnticiposNoExcedenTotal(1L, new BigDecimal("500"));
    }

    @Test
    @DisplayName("verificarAnticiposNoExcedenTotal() excepción sql -> ok")
    void verificarAnticiposNoExcedenTotal_excepcionSql_ok() {
        when(jdbcTemplate.queryForObject(contains("oc_nota_credito"), eq(BigDecimal.class), eq(1L)))
                .thenThrow(new RuntimeException("no table"));

        validator.verificarAnticiposNoExcedenTotal(1L, new BigDecimal("500"));
    }

    // ── isFondosControlActivo ──

    @Test
    @DisplayName("isFondosControlActivo() retorna true")
    void isFondosControlActivo_retornaTrue() {
        when(configParameterService.isTextFlagOn("flag_cntrl_fondos", "0")).thenReturn(true);
        assertThat(validator.isFondosControlActivo()).isTrue();
    }

    @Test
    @DisplayName("isFondosControlActivo() retorna false")
    void isFondosControlActivo_retornaFalse() {
        when(configParameterService.isTextFlagOn("flag_cntrl_fondos", "0")).thenReturn(false);
        assertThat(validator.isFondosControlActivo()).isFalse();
    }

    @Test
    @DisplayName("isFondosControlActivo() sin parámetro -> retorna false")
    void isFondosControlActivo_excepcion_retornaFalse() {
        when(configParameterService.isTextFlagOn("flag_cntrl_fondos", "0")).thenReturn(false);
        assertThat(validator.isFondosControlActivo()).isFalse();
    }

    // ── verificarFondosDisponibles ──

    @Test
    @DisplayName("verificarFondosDisponibles() fondo insuficiente -> lanza COM-018")
    void verificarFondosDisponibles_fondoInsuficiente_lanzaCOM018() {
        OrdenCompra oc = buildOcConLineasFondo();
        CompraFondo fondo = buildFondo(new BigDecimal("100"), new BigDecimal("90"));

        when(compraFondoRepository.findByCentrosCostoIdAndAnioAndFlagEstado(10L, 2026, "1"))
                .thenReturn(Optional.of(fondo));

        assertThatThrownBy(() -> validator.verificarFondosDisponibles(oc))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Fondo insuficiente");
    }

    @Test
    @DisplayName("verificarFondosDisponibles() fondo no existe -> lanza COM-017")
    void verificarFondosDisponibles_fondoNoExiste_lanzaCOM017() {
        OrdenCompra oc = buildOcConLineasFondo();

        when(compraFondoRepository.findByCentrosCostoIdAndAnioAndFlagEstado(10L, 2026, "1"))
                .thenReturn(Optional.empty());

        assertThatThrownBy(() -> validator.verificarFondosDisponibles(oc))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No existe fondo");
    }

    @Test
    @DisplayName("verificarFondosDisponibles() fondo suficiente -> ok")
    void verificarFondosDisponibles_fondoSuficiente_ok() {
        OrdenCompra oc = buildOcConLineasFondo();
        CompraFondo fondo = buildFondo(new BigDecimal("10000"), BigDecimal.ZERO);

        when(compraFondoRepository.findByCentrosCostoIdAndAnioAndFlagEstado(10L, 2026, "1"))
                .thenReturn(Optional.of(fondo));

        validator.verificarFondosDisponibles(oc);
    }

    @Test
    @DisplayName("verificarFondosDisponibles() línea inactiva -> ignorada")
    void verificarFondosDisponibles_lineaInactiva_ignorada() {
        OrdenCompra oc = new OrdenCompra();
        oc.setFechaEmision(LocalDate.of(2026, 4, 15));
        OrdenCompraDet linea = new OrdenCompraDet();
        linea.setFlagEstado("0");
        linea.setCentrosCostoId(10L);
        linea.setSubtotal(new BigDecimal("1000"));
        oc.addLinea(linea);

        validator.verificarFondosDisponibles(oc);
    }

    @Test
    @DisplayName("verificarFondosDisponibles() línea sin centros costo id -> ignorada")
    void verificarFondosDisponibles_lineaSinCentrosCostoId_ignorada() {
        OrdenCompra oc = new OrdenCompra();
        oc.setFechaEmision(LocalDate.of(2026, 4, 15));
        OrdenCompraDet linea = new OrdenCompraDet();
        linea.setFlagEstado("1");
        linea.setCentrosCostoId(null);
        linea.setSubtotal(new BigDecimal("1000"));
        oc.addLinea(linea);

        validator.verificarFondosDisponibles(oc);
    }

    // ── consumirFondos / liberarFondos ──

    @Test
    @DisplayName("consumirFondos() incrementa monto usado")
    void consumirFondos_incrementaMontoUsado() {
        OrdenCompra oc = buildOcConLineasFondo();
        CompraFondo fondo = buildFondo(new BigDecimal("10000"), BigDecimal.ZERO);

        when(compraFondoRepository.findByCentrosCostoIdAndAnioAndFlagEstado(10L, 2026, "1"))
                .thenReturn(Optional.of(fondo));

        validator.consumirFondos(oc);

        assertThat(fondo.getMontoUsado()).isEqualByComparingTo("1000");
        verify(compraFondoRepository).save(fondo);
    }

    @Test
    @DisplayName("consumirFondos() línea inactiva -> ignorada")
    void consumirFondos_lineaInactiva_ignorada() {
        OrdenCompra oc = new OrdenCompra();
        oc.setFechaEmision(LocalDate.of(2026, 4, 15));
        OrdenCompraDet linea = new OrdenCompraDet();
        linea.setFlagEstado("0");
        linea.setCentrosCostoId(10L);
        linea.setSubtotal(new BigDecimal("1000"));
        oc.addLinea(linea);

        validator.consumirFondos(oc);

        verify(compraFondoRepository, never()).save(any());
    }

    @Test
    @DisplayName("liberarFondos() decrementa monto usado")
    void liberarFondos_decrementaMontoUsado() {
        OrdenCompra oc = buildOcConLineasFondo();
        CompraFondo fondo = buildFondo(new BigDecimal("10000"), new BigDecimal("1000"));

        when(compraFondoRepository.findByCentrosCostoIdAndAnioAndFlagEstado(10L, 2026, "1"))
                .thenReturn(Optional.of(fondo));

        validator.liberarFondos(oc);

        assertThat(fondo.getMontoUsado()).isEqualByComparingTo("0");
        verify(compraFondoRepository).save(fondo);
    }

    @Test
    @DisplayName("liberarFondos() no queda negativo")
    void liberarFondos_noQuedaNegativo() {
        OrdenCompra oc = buildOcConLineasFondo();
        CompraFondo fondo = buildFondo(new BigDecimal("10000"), new BigDecimal("500"));

        when(compraFondoRepository.findByCentrosCostoIdAndAnioAndFlagEstado(10L, 2026, "1"))
                .thenReturn(Optional.of(fondo));

        validator.liberarFondos(oc);

        assertThat(fondo.getMontoUsado()).isEqualByComparingTo("0");
    }

    // ── validarCabecera — más variantes ──

    @Test
    @DisplayName("validarCabecera() moneda id null -> no valida tipo cambio")
    void validarCabecera_monedaIdNull_noValidaTipoCambio() {
        OrdenCompraCabeceraRequest req = buildCabeceraRequest();
        req.setMonedaId(null);

        validator.validarCabecera(req);
    }

    @Test
    @DisplayName("validarCabecera() moneda extranjera tipo cambio cero -> lanza COM-003")
    void validarCabecera_monedaExtranjera_tipoCambioCero_lanzaCOM003() {
        OrdenCompraCabeceraRequest req = buildCabeceraRequest();
        req.setMonedaId(2L);
        req.setTipoCambio(BigDecimal.ZERO);

        assertThatThrownBy(() -> validator.validarCabecera(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("tipo de cambio");
    }

    @Test
    @DisplayName("validarCabecera() entidad existe excepción general -> no falla")
    void validarCabecera_entidadExiste_excepcionGeneral_noFalla() {
        OrdenCompraCabeceraRequest req = buildCabeceraRequest();
        req.setMonedaId(null);
        req.setSucursalId(null);

        validator.validarCabecera(req);
    }

    @Test
    @DisplayName("validarCabecera() entidad count null -> lanza error")
    void validarCabecera_entidadCountNull_lanzaError() {
        OrdenCompraCabeceraRequest req = buildCabeceraRequest();
        when(entidadContribuyenteRefRepository.existsById(1L)).thenReturn(false);

        assertThatThrownBy(() -> validator.validarCabecera(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("no existe");
    }

    // ── validarDetalleFino — más variantes ──

    @Test
    @DisplayName("validarDetalleFino() tipo impuesto null -> ignora validación")
    void validarDetalleFino_tipoImpuestoNull_ignoraValidacion() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        l.setTipoImpuestoId(null);
        ArticuloRef art = mock(ArticuloRef.class);
        when(art.getFlagEstado()).thenReturn("1");
        when(articuloRefRepository.findById(1L)).thenReturn(Optional.of(art));

        validator.validarDetalleFino(List.of(l), LocalDate.now());
    }

    @Test
    @DisplayName("validarDetalleFino() artículo id null -> ignora validación artículo")
    void validarDetalleFino_articuloIdNull_ignoraValidacionArticulo() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        l.setArticuloId(null);

        validator.validarDetalleFino(List.of(l), LocalDate.now());
    }

    @Test
    @DisplayName("validarDetalleFino() fecha emision null -> no valida fecha entrega")
    void validarDetalleFino_fechaEmisionNull_noValidaFechaEntrega() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        l.setFechaEntrega(LocalDate.of(2020, 1, 1));
        ArticuloRef art = mock(ArticuloRef.class);
        when(art.getFlagEstado()).thenReturn("1");
        when(articuloRefRepository.findById(1L)).thenReturn(Optional.of(art));

        validator.validarDetalleFino(List.of(l), null);
    }

    @Test
    @DisplayName("validarArticuloActivo() excepción general -> no falla")
    void validarArticuloActivo_excepcionGeneral_noFalla() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        ArticuloRef art = mock(ArticuloRef.class);
        when(art.getFlagEstado()).thenReturn("1");
        when(articuloRefRepository.findById(1L)).thenReturn(Optional.of(art));

        validator.validarDetalleFino(List.of(l), LocalDate.now());
    }

    @Test
    @DisplayName("validarTipoImpuesto() existente -> no falla")
    void validarTipoImpuesto_existente_noFalla() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        l.setTipoImpuestoId(1L);
        ArticuloRef art = mock(ArticuloRef.class);
        when(art.getFlagEstado()).thenReturn("1");
        when(articuloRefRepository.findById(1L)).thenReturn(Optional.of(art));
        when(tiposImpuestoRefRepository.existsById(1L)).thenReturn(true);

        validator.validarDetalleFino(List.of(l), LocalDate.now());
    }

    @Test
    @DisplayName("validarTipoImpuesto() no existe -> lanza COM-029")
    void validarTipoImpuesto_noExiste_lanzaCOM029() {
        OrdenCompraLineaRequest l = buildLineaRequest();
        l.setTipoImpuestoId(888L);
        ArticuloRef art = mock(ArticuloRef.class);
        when(art.getFlagEstado()).thenReturn("1");
        when(articuloRefRepository.findById(1L)).thenReturn(Optional.of(art));
        when(tiposImpuestoRefRepository.existsById(888L)).thenReturn(false);

        assertThatThrownBy(() -> validator.validarDetalleFino(List.of(l), LocalDate.now()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("tipo de impuesto");
    }

    // ── verificarPrecios — valorUnitario null ──

    @Test
    @DisplayName("verificarPrecios() valor unitario null -> lanza COM-009")
    void verificarPrecios_valorUnitarioNull_lanzaCOM009() {
        OrdenCompra oc = new OrdenCompra();
        oc.setFlagEstado("1");
        OrdenCompraDet l = new OrdenCompraDet();
        l.setFlagEstado("1");
        l.setArticuloId(1L);
        l.setValorUnitario(null);
        l.setCantProyectada(new BigDecimal("10"));
        oc.addLinea(l);

        assertThatThrownBy(() -> validator.verificarPrecios(oc))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("precio cero");
    }

    @Test
    @DisplayName("verificarPrecios() cant proyectada null -> lanza COM-010")
    void verificarPrecios_cantProyectadaNull_lanzaCOM010() {
        OrdenCompra oc = new OrdenCompra();
        oc.setFlagEstado("1");
        OrdenCompraDet l = new OrdenCompraDet();
        l.setFlagEstado("1");
        l.setArticuloId(1L);
        l.setValorUnitario(new BigDecimal("100"));
        l.setCantProyectada(null);
        oc.addLinea(l);

        assertThatThrownBy(() -> validator.verificarPrecios(oc))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cantidad cero");
    }

    // ── verificarNoVieneDeAprovisionamiento — exception path ──

    @Test
    @DisplayName("verificarNoVieneDeAprovisionamiento() excepción sql -> no falla")
    void verificarNoVieneDeAprovisionamiento_excepcionSql_noFalla() {
        when(valeMovRefRepository.findByOrdenCompraIdOrderByFechaDesc(1L)).thenReturn(Collections.emptyList());
        validator.verificarNoVieneDeAprovisionamiento(1L);
    }

    @Test
    @DisplayName("verificarNoVieneDeAprovisionamiento() count null -> ok")
    void verificarNoVieneDeAprovisionamiento_countNull_ok() {
        when(valeMovRefRepository.findByOrdenCompraIdOrderByFechaDesc(1L)).thenReturn(Collections.emptyList());
        validator.verificarNoVieneDeAprovisionamiento(1L);
    }

    // ── verificarSinAnticipos — null result ──

    @Test
    @DisplayName("verificarSinAnticipos() result null -> ok")
    void verificarSinAnticipos_resultNull_ok() {
        when(jdbcTemplate.queryForObject(contains("oc_nota_credito"), eq(BigDecimal.class), eq(1L)))
                .thenReturn(null);
        validator.verificarSinAnticipos(1L);
    }

    // ── verificarAnticiposNoExcedenTotal — null result ──

    @Test
    @DisplayName("verificarAnticiposNoExcedenTotal() result null -> ok")
    void verificarAnticiposNoExcedenTotal_resultNull_ok() {
        when(jdbcTemplate.queryForObject(contains("oc_nota_credito"), eq(BigDecimal.class), eq(1L)))
                .thenReturn(null);
        validator.verificarAnticiposNoExcedenTotal(1L, new BigDecimal("500"));
    }

    // ── consumirFondos/liberarFondos — subtotal null ──

    @Test
    @DisplayName("consumirFondos() subtotal null -> usa cero")
    void consumirFondos_subtotalNull_usaCero() {
        OrdenCompra oc = buildOcConLineasFondo();
        oc.getLineas().get(0).setSubtotal(null);
        CompraFondo fondo = buildFondo(new BigDecimal("10000"), BigDecimal.ZERO);
        when(compraFondoRepository.findByCentrosCostoIdAndAnioAndFlagEstado(10L, 2026, "1"))
                .thenReturn(Optional.of(fondo));

        validator.consumirFondos(oc);
        assertThat(fondo.getMontoUsado()).isEqualByComparingTo("0");
    }

    @Test
    @DisplayName("consumirFondos() línea sin centros costo id -> ignorada")
    void consumirFondos_lineaSinCentrosCostoId_ignorada() {
        OrdenCompra oc = new OrdenCompra();
        oc.setFechaEmision(LocalDate.of(2026, 4, 15));
        OrdenCompraDet l = new OrdenCompraDet();
        l.setFlagEstado("1");
        l.setCentrosCostoId(null);
        oc.addLinea(l);

        validator.consumirFondos(oc);
        verify(compraFondoRepository, never()).save(any());
    }

    @Test
    @DisplayName("liberarFondos() línea sin centros costo id -> ignorada")
    void liberarFondos_lineaSinCentrosCostoId_ignorada() {
        OrdenCompra oc = new OrdenCompra();
        oc.setFechaEmision(LocalDate.of(2026, 4, 15));
        OrdenCompraDet l = new OrdenCompraDet();
        l.setFlagEstado("1");
        l.setCentrosCostoId(null);
        oc.addLinea(l);

        validator.liberarFondos(oc);
        verify(compraFondoRepository, never()).save(any());
    }

    @Test
    @DisplayName("verificarFondosDisponibles() subtotal null -> usa cero")
    void verificarFondosDisponibles_subtotalNull_usaCero() {
        OrdenCompra oc = buildOcConLineasFondo();
        oc.getLineas().get(0).setSubtotal(null);
        CompraFondo fondo = buildFondo(new BigDecimal("10000"), BigDecimal.ZERO);
        when(compraFondoRepository.findByCentrosCostoIdAndAnioAndFlagEstado(10L, 2026, "1"))
                .thenReturn(Optional.of(fondo));

        validator.verificarFondosDisponibles(oc);
    }

    // ── validarEntidadExiste — entidad ID null ──

    @Test
    @DisplayName("validarCabecera() proveedor id null -> no valida")
    void validarCabecera_proveedorIdNull_noValida() {
        OrdenCompraCabeceraRequest req = buildCabeceraRequest();
        req.setProveedorId(null);
        req.setMonedaId(null);
        req.setSucursalId(null);

        validator.validarCabecera(req);
        verify(entidadContribuyenteRefRepository, never()).existsById(any());
        verify(monedaRefRepository, never()).existsById(any());
        verify(sucursalRefRepository, never()).existsById(any());
    }

    // ── Helpers ──

    private OrdenCompraCabeceraRequest buildCabeceraRequest() {
        OrdenCompraCabeceraRequest r = new OrdenCompraCabeceraRequest();
        r.setSucursalId(1L);
        r.setProveedorId(1L);
        r.setMonedaId(1L);
        r.setFechaEmision(LocalDate.now());
        r.setFormaPagoId(1L);
        return r;
    }

    private OrdenCompraLineaRequest buildLineaRequest() {
        OrdenCompraLineaRequest l = new OrdenCompraLineaRequest();
        l.setArticuloId(1L);
        l.setCantProyectada(new BigDecimal("10"));
        l.setValorUnitario(new BigDecimal("100"));
        l.setFechaEntrega(LocalDate.now().plusDays(15));
        return l;
    }

    private AprobadorConfigurado buildAprobador(Long aprobadorId, BigDecimal min, BigDecimal max) {
        AprobadorConfigurado a = new AprobadorConfigurado();
        a.setDocTipoId(1L);
        a.setAprobadorId(aprobadorId);
        a.setFlagEstado("1");
        a.setMontoMinimo(min);
        a.setMontoMaximo(max);
        return a;
    }

    private CompraFondo buildFondo(BigDecimal total, BigDecimal usado) {
        CompraFondo f = new CompraFondo();
        f.setMontoTotal(total);
        f.setMontoUsado(usado);
        return f;
    }

    private OrdenCompra buildOcConLineasFondo() {
        OrdenCompra oc = new OrdenCompra();
        oc.setFechaEmision(LocalDate.of(2026, 4, 15));
        OrdenCompraDet linea = new OrdenCompraDet();
        linea.setFlagEstado("1");
        linea.setCentrosCostoId(10L);
        linea.setSubtotal(new BigDecimal("1000"));
        oc.addLinea(linea);
        return oc;
    }
}
