package com.sigre.compras.service;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;
import com.sigre.compras.dto.OrdenServicioCabeceraRequest;
import com.sigre.compras.dto.OrdenServicioLineaRequest;
import com.sigre.compras.entity.*;
import com.sigre.compras.repository.*;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.TenantContext;

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
@DisplayName("OrdenServicioValidator — Pruebas Unitarias")
class OrdenServicioValidatorTest {

    @Mock private CompradorRepository compradorRepository;
    @Mock private AprobadorConfiguradoRepository aprobadorConfiguradoRepository;
    @Mock private EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    @Mock private MonedaRefRepository monedaRefRepository;
    @Mock private SucursalRefRepository sucursalRefRepository;
    @Mock private ConfiguracionRefRepository configuracionRefRepository;
    @Mock private JdbcTemplate jdbcTemplate;
    @InjectMocks private OrdenServicioValidator validator;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(entidadContribuyenteRefRepository.existsById(anyLong())).thenReturn(true);
        lenient().when(monedaRefRepository.existsById(anyLong())).thenReturn(true);
        lenient().when(sucursalRefRepository.existsById(anyLong())).thenReturn(true);
        lenient().when(jdbcTemplate.queryForObject(
                eq("SELECT id FROM core.doc_tipo WHERE codigo = ? AND flag_estado = '1'"),
                eq(Long.class), eq("OS")))
                .thenReturn(2L);
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
    @DisplayName("verificarCompradorActivo() no existe -> lanza COM-102")
    void verificarCompradorActivo_noExiste_lanzaCOM102() {
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
    @DisplayName("validarCabecera() moneda extranjera sin tipo cambio -> lanza COM-103")
    void validarCabecera_monedaExtranjera_sinTipoCambio_lanzaCOM103() {
        OrdenServicioCabeceraRequest req = buildCabeceraRequest();
        req.setMonedaId(2L);
        req.setTipoCambio(null);

        assertThatThrownBy(() -> validator.validarCabecera(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("tipo de cambio");
    }

    @Test
    @DisplayName("validarCabecera() moneda extranjera con tipo cambio -> ok")
    void validarCabecera_monedaExtranjera_conTipoCambio_ok() {
        OrdenServicioCabeceraRequest req = buildCabeceraRequest();
        req.setMonedaId(2L);
        req.setTipoCambio(new BigDecimal("3.72"));

        validator.validarCabecera(req);
    }

    @Test
    @DisplayName("validarCabecera() moneda pen -> ok")
    void validarCabecera_monedaPEN_ok() {
        OrdenServicioCabeceraRequest req = buildCabeceraRequest();
        req.setMonedaId(1L);

        validator.validarCabecera(req);
    }

    @Test
    @DisplayName("validarCabecera() proveedor no existe -> lanza error")
    void validarCabecera_proveedorNoExiste_lanzaError() {
        OrdenServicioCabeceraRequest req = buildCabeceraRequest();
        when(entidadContribuyenteRefRepository.existsById(1L)).thenReturn(false);

        assertThatThrownBy(() -> validator.validarCabecera(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("no existe");
    }

    // ── validarDetalle ──

    @Test
    @DisplayName("validarDetalle() lista null -> lanza COM-106")
    void validarDetalle_listaNull_lanzaCOM106() {
        assertThatThrownBy(() -> validator.validarDetalle(null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("al menos una línea");
    }

    @Test
    @DisplayName("validarDetalle() lista vacia -> lanza COM-106")
    void validarDetalle_listaVacia_lanzaCOM106() {
        assertThatThrownBy(() -> validator.validarDetalle(Collections.emptyList()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("al menos una línea");
    }

    @Test
    @DisplayName("validarDetalle() importe cero -> lanza COM-108")
    void validarDetalle_importeCero_lanzaCOM108() {
        OrdenServicioLineaRequest l = buildLineaRequest();
        l.setImporte(BigDecimal.ZERO);

        when(jdbcTemplate.queryForObject(contains("flag_estado FROM compras.servicio"), eq(String.class), eq(1L)))
                .thenReturn("1");

        assertThatThrownBy(() -> validator.validarDetalle(List.of(l)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("importe");
    }

    @Test
    @DisplayName("validarDetalle() sin fec proyect -> lanza COM-109")
    void validarDetalle_sinFecProyect_lanzaCOM109() {
        OrdenServicioLineaRequest l = buildLineaRequest();
        l.setFecProyect(null);

        when(jdbcTemplate.queryForObject(contains("flag_estado FROM compras.servicio"), eq(String.class), eq(1L)))
                .thenReturn("1");

        assertThatThrownBy(() -> validator.validarDetalle(List.of(l)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("fecha proyectada");
    }

    @Test
    @DisplayName("validarDetalle() imp 2 sin imp 1 -> lanza COM-111")
    void validarDetalle_imp2SinImp1_lanzaCOM111() {
        OrdenServicioLineaRequest l = buildLineaRequest();
        l.setTiposImpuestoId(null);
        l.setTiposImpuesto2Id(2L);

        when(jdbcTemplate.queryForObject(contains("flag_estado FROM compras.servicio"), eq(String.class), eq(1L)))
                .thenReturn("1");

        assertThatThrownBy(() -> validator.validarDetalle(List.of(l)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("impuesto 2 sin impuesto 1");
    }

    @Test
    @DisplayName("validarDetalle() dscto porcentaje mayor 100 -> lanza COM-112")
    void validarDetalle_dsctoPorcentajeMayor100_lanzaCOM112() {
        OrdenServicioLineaRequest l = buildLineaRequest();
        l.setDsctoPorcentaje(new BigDecimal("101"));

        when(jdbcTemplate.queryForObject(contains("flag_estado FROM compras.servicio"), eq(String.class), eq(1L)))
                .thenReturn("1");

        assertThatThrownBy(() -> validator.validarDetalle(List.of(l)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("100%");
    }

    @Test
    @DisplayName("validarDetalle() ok")
    void validarDetalle_ok() {
        OrdenServicioLineaRequest l = buildLineaRequest();

        when(jdbcTemplate.queryForObject(contains("flag_estado FROM compras.servicio"), eq(String.class), eq(1L)))
                .thenReturn("1");

        validator.validarDetalle(List.of(l));
    }

    // ── verificarPrecios ──

    @Test
    @DisplayName("verificarPrecios() importe cero -> lanza COM-117")
    void verificarPrecios_importeCero_lanzaCOM117() {
        OrdenServicio os = new OrdenServicio();
        os.setFlagEstado("1");
        OrdenServicioDet l = new OrdenServicioDet();
        l.setFlagEstado("1");
        l.setServicioId(1L);
        l.setImporte(BigDecimal.ZERO);
        os.addLinea(l);

        assertThatThrownBy(() -> validator.verificarPrecios(os))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("importe cero");
    }

    @Test
    @DisplayName("verificarPrecios() os inactiva -> no valida")
    void verificarPrecios_osInactiva_noValida() {
        OrdenServicio os = new OrdenServicio();
        os.setFlagEstado("0");
        OrdenServicioDet l = new OrdenServicioDet();
        l.setFlagEstado("1");
        l.setImporte(BigDecimal.ZERO);
        os.addLinea(l);

        validator.verificarPrecios(os);
    }

    @Test
    @DisplayName("verificarPrecios() línea inactiva -> ignorada")
    void verificarPrecios_lineaInactiva_ignorada() {
        OrdenServicio os = new OrdenServicio();
        os.setFlagEstado("1");
        OrdenServicioDet l = new OrdenServicioDet();
        l.setFlagEstado("0");
        l.setImporte(BigDecimal.ZERO);
        os.addLinea(l);

        validator.verificarPrecios(os);
    }

    @Test
    @DisplayName("verificarPrecios() ok")
    void verificarPrecios_ok() {
        OrdenServicio os = new OrdenServicio();
        os.setFlagEstado("1");
        OrdenServicioDet l = new OrdenServicioDet();
        l.setFlagEstado("1");
        l.setServicioId(1L);
        l.setImporte(new BigDecimal("1000"));
        os.addLinea(l);

        validator.verificarPrecios(os);
    }

    // ── validarAprobadorConfigurado ──

    @Test
    @DisplayName("validarAprobadorConfigurado() no existe -> lanza COM-130")
    void validarAprobadorConfigurado_noExiste_lanzaCOM130() {
        when(aprobadorConfiguradoRepository.findAll()).thenReturn(Collections.emptyList());

        assertThatThrownBy(() -> validator.validarAprobadorConfigurado(1L, new BigDecimal("1000")))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("aprobador configurado");
    }

    @Test
    @DisplayName("validarAprobadorConfigurado() fuera de rango -> lanza COM-131")
    void validarAprobadorConfigurado_fueraDeRango_lanzaCOM131() {
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

    // ── Helpers ──

    private OrdenServicioCabeceraRequest buildCabeceraRequest() {
        OrdenServicioCabeceraRequest r = new OrdenServicioCabeceraRequest();
        r.setSucursalId(1L);
        r.setProveedorId(1L);
        r.setMonedaId(1L);
        r.setCodOrigen("OS");
        r.setFecRegistro(LocalDate.now());
        r.setFormaPagoId(1L);
        OrdenServicioLineaRequest linea = buildLineaRequest();
        r.setLineas(List.of(linea));
        return r;
    }

    private OrdenServicioLineaRequest buildLineaRequest() {
        OrdenServicioLineaRequest l = new OrdenServicioLineaRequest();
        l.setServicioId(1L);
        l.setImporte(new BigDecimal("1000"));
        l.setFecProyect(LocalDate.now().plusDays(15));
        return l;
    }

    private AprobadorConfigurado buildAprobador(Long aprobadorId, BigDecimal min, BigDecimal max) {
        AprobadorConfigurado a = new AprobadorConfigurado();
        a.setDocTipoId(2L);
        a.setAprobadorId(aprobadorId);
        a.setFlagEstado("1");
        a.setMontoMinimo(min);
        a.setMontoMaximo(max);
        return a;
    }
}
