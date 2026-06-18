package pe.restaurant.compras.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.compras.dto.*;
import pe.restaurant.compras.entity.Cotizacion;
import pe.restaurant.compras.entity.CotizacionDet;
import pe.restaurant.compras.mapper.CotizacionMapper;
import pe.restaurant.compras.repository.ArticuloRefRepository;
import pe.restaurant.compras.repository.CotizacionRepository;
import pe.restaurant.compras.repository.EntidadContribuyenteRefRepository;
import pe.restaurant.compras.repository.MonedaRefRepository;
import pe.restaurant.compras.service.OrdenCompraService;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static pe.restaurant.compras.ComprasTestFixtures.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CotizacionServiceImpl — Pruebas Unitarias")
class CotizacionServiceImplTest {

    @Mock private CotizacionRepository cotizacionRepository;
    @Mock private CotizacionMapper cotizacionMapper;
    @Mock private EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    @Mock private MonedaRefRepository monedaRefRepository;
    @Mock private ArticuloRefRepository articuloRefRepository;
    @Mock private OrdenCompraService ordenCompraService;

    @InjectMocks private CotizacionServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        TenantContext.setSucursalId(1L);
        lenient().when(entidadContribuyenteRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(monedaRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(articuloRefRepository.findById(anyLong())).thenReturn(Optional.empty());
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ── listar ──

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    @SuppressWarnings("unchecked")
    void listar_sinFiltros_retornaPagina() {
        Cotizacion c = cotizacion(1L, "1");
        Page<Cotizacion> page = new PageImpl<>(List.of(c));

        when(cotizacionRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        Page<CotizacionResponse> result = service.listar(null, null, null, null, Pageable.unpaged());

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("listar() con proveedor id -> filtra")
    @SuppressWarnings("unchecked")
    void listar_conProveedorId_filtra() {
        Page<Cotizacion> page = new PageImpl<>(List.of());
        when(cotizacionRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        service.listar(10L, null, null, null, Pageable.unpaged());

        verify(cotizacionRepository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() con estado -> filtra")
    @SuppressWarnings("unchecked")
    void listar_conEstado_filtra() {
        Page<Cotizacion> page = new PageImpl<>(List.of());
        when(cotizacionRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        service.listar(null, "REGISTRADA", null, null, Pageable.unpaged());

        verify(cotizacionRepository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() estado blank -> ignora filtro")
    @SuppressWarnings("unchecked")
    void listar_estadoBlank_ignoraFiltro() {
        Page<Cotizacion> page = new PageImpl<>(List.of());
        when(cotizacionRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        service.listar(null, "  ", null, null, Pageable.unpaged());

        verify(cotizacionRepository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() sin sucursal -> no filtra por sucursal")
    @SuppressWarnings("unchecked")
    void listar_sinSucursal_noFiltraPorSucursal() {
        TenantContext.setSucursalId(null);
        Page<Cotizacion> page = new PageImpl<>(List.of());
        when(cotizacionRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        service.listar(null, null, null, null, Pageable.unpaged());

        verify(cotizacionRepository).findAll(any(Specification.class), any(Pageable.class));
    }

    // ── obtener ──

    @Test
    @DisplayName("obtener() existente -> retorna detalle")
    void obtener_existente_retornaDetalle() {
        Cotizacion c = cotizacion(1L, "1");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));

        CotizacionDetalleResponse result = service.obtener(1L);

        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("obtener() no existente -> lanza excepción")
    void obtener_noExistente_lanzaExcepcion() {
        when(cotizacionRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtener(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── crear ──

    @Test
    @DisplayName("crear() con líneas -> guarda correctamente")
    void crear_conLineas_guardaCorrectamente() {
        mockProveedorActivo(10L);
        when(monedaRefRepository.existsById(1L)).thenReturn(true);
        when(articuloRefRepository.existsById(100L)).thenReturn(true);

        Cotizacion entity = new Cotizacion();
        entity.setProveedorId(10L);
        entity.setFecha(LocalDate.now());
        entity.setMonedaId(1L);
        when(cotizacionMapper.toEntity(any(CotizacionRequest.class))).thenReturn(entity);

        CotizacionDet detEntity = new CotizacionDet();
        detEntity.setArticuloId(100L);
        detEntity.setCantidad(new BigDecimal("5"));
        detEntity.setPrecioUnitario(new BigDecimal("100"));
        detEntity.setDescuento(BigDecimal.ZERO);
        when(cotizacionMapper.toDetEntity(any(CotizacionDetRequest.class))).thenReturn(detEntity);

        Cotizacion saved = cotizacion(1L, "1");
        when(cotizacionRepository.save(any(Cotizacion.class))).thenReturn(saved);

        CotizacionRequest request = cotizacionRequest();
        CotizacionDetalleResponse result = service.crear(request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(cotizacionMapper).toEntity(request);
        verify(cotizacionMapper).toDetEntity(any(CotizacionDetRequest.class));
        verify(cotizacionRepository).save(any(Cotizacion.class));
    }

    @Test
    @DisplayName("crear() proveedor inexistente -> lanza excepción")
    void crear_proveedorInexistente_lanzaExcepcion() {
        CotizacionRequest request = cotizacionRequest();

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Proveedor");
    }

    @Test
    @DisplayName("crear() moneda inexistente -> lanza excepción")
    void crear_monedaInexistente_lanzaExcepcion() {
        mockProveedorActivo(10L);
        when(monedaRefRepository.existsById(1L)).thenReturn(false);

        CotizacionRequest request = cotizacionRequest();

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Moneda");
    }

    @Test
    @DisplayName("crear() artículo inexistente -> lanza excepción")
    void crear_articuloInexistente_lanzaExcepcion() {
        mockProveedorActivo(10L);
        when(monedaRefRepository.existsById(1L)).thenReturn(true);
        when(articuloRefRepository.existsById(100L)).thenReturn(false);

        Cotizacion entity = new Cotizacion();
        entity.setProveedorId(10L);
        entity.setFecha(LocalDate.now());
        entity.setMonedaId(1L);
        when(cotizacionMapper.toEntity(any(CotizacionRequest.class))).thenReturn(entity);

        CotizacionRequest request = cotizacionRequest();

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Artículo");
    }

    @Test
    @DisplayName("crear() sin moneda id -> no valida moneda")
    void crear_sinMonedaId_noValidaMoneda() {
        mockProveedorActivo(10L);
        when(articuloRefRepository.existsById(100L)).thenReturn(true);

        Cotizacion entity = new Cotizacion();
        entity.setProveedorId(10L);
        entity.setFecha(LocalDate.now());
        when(cotizacionMapper.toEntity(any(CotizacionRequest.class))).thenReturn(entity);

        CotizacionDet detEntity = new CotizacionDet();
        detEntity.setArticuloId(100L);
        detEntity.setCantidad(new BigDecimal("5"));
        detEntity.setPrecioUnitario(new BigDecimal("100"));
        when(cotizacionMapper.toDetEntity(any(CotizacionDetRequest.class))).thenReturn(detEntity);

        Cotizacion saved = cotizacion(2L, "1");
        when(cotizacionRepository.save(any(Cotizacion.class))).thenReturn(saved);

        CotizacionRequest req = cotizacionRequest();
        req.setMonedaId(null);
        CotizacionDetalleResponse result = service.crear(req);

        assertThat(result).isNotNull();
        verify(monedaRefRepository, never()).existsById(any());
    }

    @Test
    @DisplayName("crear() descuento null -> defaults cero")
    void crear_descuentoNull_defaultsCero() {
        mockProveedorActivo(10L);
        when(monedaRefRepository.existsById(1L)).thenReturn(true);
        when(articuloRefRepository.existsById(100L)).thenReturn(true);

        Cotizacion entity = new Cotizacion();
        entity.setProveedorId(10L);
        entity.setFecha(LocalDate.now());
        entity.setMonedaId(1L);
        when(cotizacionMapper.toEntity(any(CotizacionRequest.class))).thenReturn(entity);

        CotizacionDet detEntity = new CotizacionDet();
        detEntity.setArticuloId(100L);
        detEntity.setCantidad(new BigDecimal("5"));
        detEntity.setPrecioUnitario(new BigDecimal("100"));
        detEntity.setDescuento(null);
        when(cotizacionMapper.toDetEntity(any(CotizacionDetRequest.class))).thenReturn(detEntity);

        when(cotizacionRepository.save(any(Cotizacion.class))).thenAnswer(inv -> {
            Cotizacion c = inv.getArgument(0);
            c.setId(3L);
            return c;
        });

        CotizacionRequest req = cotizacionRequest();
        service.crear(req);

        verify(cotizacionRepository).save(argThat(c -> {
            CotizacionDet d = c.getLineas().get(0);
            assertThat(d.getDescuento()).isEqualByComparingTo(BigDecimal.ZERO);
            return true;
        }));
    }

    @Test
    @DisplayName("crear() proveedor count null -> lanza excepción")
    void crear_proveedorCountNull_lanzaExcepcion() {
        assertThatThrownBy(() -> service.crear(cotizacionRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Proveedor");
    }

    @Test
    @DisplayName("crear() calcula total correctamente")
    void crear_calculaTotal_correctamente() {
        mockProveedorActivo(10L);
        when(monedaRefRepository.existsById(1L)).thenReturn(true);
        when(articuloRefRepository.existsById(100L)).thenReturn(true);

        Cotizacion entity = new Cotizacion();
        entity.setProveedorId(10L);
        entity.setFecha(LocalDate.now());
        entity.setMonedaId(1L);
        when(cotizacionMapper.toEntity(any())).thenReturn(entity);

        CotizacionDet det = new CotizacionDet();
        det.setArticuloId(100L);
        det.setCantidad(new BigDecimal("10"));
        det.setPrecioUnitario(new BigDecimal("50"));
        det.setDescuento(new BigDecimal("25"));
        when(cotizacionMapper.toDetEntity(any())).thenReturn(det);

        when(cotizacionRepository.save(any())).thenAnswer(inv -> {
            Cotizacion c = inv.getArgument(0);
            c.setId(4L);
            return c;
        });

        service.crear(cotizacionRequest());

        verify(cotizacionRepository).save(argThat(c -> {
            assertThat(c.getTotal()).isEqualByComparingTo(new BigDecimal("475.0000"));
            return true;
        }));
    }

    // ── actualizar ──

    @Test
    @DisplayName("actualizar() registrada -> ok")
    void actualizar_registrada_ok() {
        Cotizacion existing = cotizacion(1L, "1");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(existing));

        mockProveedorActivo(10L);
        when(monedaRefRepository.existsById(1L)).thenReturn(true);
        when(articuloRefRepository.existsById(100L)).thenReturn(true);

        CotizacionDet detEntity = new CotizacionDet();
        detEntity.setArticuloId(100L);
        detEntity.setCantidad(new BigDecimal("5"));
        detEntity.setPrecioUnitario(new BigDecimal("100"));
        detEntity.setDescuento(BigDecimal.ZERO);
        when(cotizacionMapper.toDetEntity(any(CotizacionDetRequest.class))).thenReturn(detEntity);
        when(cotizacionRepository.save(any(Cotizacion.class))).thenReturn(existing);

        CotizacionRequest request = cotizacionRequest();
        CotizacionDetalleResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        verify(cotizacionMapper).updateEntity(eq(request), any(Cotizacion.class));
        verify(cotizacionRepository).save(any(Cotizacion.class));
    }

    @Test
    @DisplayName("actualizar() no registrada -> lanza excepción")
    void actualizar_noRegistrada_lanzaExcepcion() {
        Cotizacion existing = cotizacion(1L, "0");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(existing));

        assertThatThrownBy(() -> service.actualizar(1L, cotizacionRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    @Test
    @DisplayName("actualizar() no existe -> lanza excepción")
    void actualizar_noExiste_lanzaExcepcion() {
        when(cotizacionRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(99L, cotizacionRequest()))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("actualizar() sin moneda id -> no valida moneda")
    void actualizar_sinMonedaId_noValidaMoneda() {
        Cotizacion existing = cotizacion(1L, "1");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(existing));
        mockProveedorActivo(10L);
        when(articuloRefRepository.existsById(100L)).thenReturn(true);

        CotizacionDet detEntity = new CotizacionDet();
        detEntity.setArticuloId(100L);
        detEntity.setCantidad(new BigDecimal("5"));
        detEntity.setPrecioUnitario(new BigDecimal("100"));
        detEntity.setDescuento(BigDecimal.ZERO);
        when(cotizacionMapper.toDetEntity(any())).thenReturn(detEntity);
        when(cotizacionRepository.save(any())).thenReturn(existing);

        CotizacionRequest req = cotizacionRequest();
        req.setMonedaId(null);
        service.actualizar(1L, req);

        verify(monedaRefRepository, never()).existsById(any());
    }

    // ── seleccionar ──

    @Test
    @DisplayName("seleccionar() registrada -> cambia estado")
    void seleccionar_registrada_cambiaEstado() {
        Cotizacion c = cotizacion(1L, "1");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));
        when(cotizacionRepository.save(any(Cotizacion.class))).thenReturn(c);

        CotizacionDetalleResponse result = service.seleccionar(1L);

        assertThat(result).isNotNull();
        assertThat(c.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("seleccionar() no registrada -> lanza excepción")
    void seleccionar_noRegistrada_lanzaExcepcion() {
        Cotizacion c = cotizacion(1L, "0");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));

        assertThatThrownBy(() -> service.seleccionar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    @Test
    @DisplayName("seleccionar() no existe -> lanza excepción")
    void seleccionar_noExiste_lanzaExcepcion() {
        when(cotizacionRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.seleccionar(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("seleccionar() asigna updated by")
    void seleccionar_asignaUpdatedBy() {
        Cotizacion c = cotizacion(1L, "1");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));
        when(cotizacionRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        service.seleccionar(1L);

        verify(cotizacionRepository).save(argThat(e -> {
            assertThat(e.getUpdatedBy()).isEqualTo(1L);
            return true;
        }));
    }

    // ── descartar ──

    @Test
    @DisplayName("descartar() registrada -> cambia estado")
    void descartar_registrada_cambiaEstado() {
        Cotizacion c = cotizacion(1L, "1");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));
        when(cotizacionRepository.save(any(Cotizacion.class))).thenReturn(c);

        CotizacionDetalleResponse result = service.descartar(1L);

        assertThat(result).isNotNull();
        assertThat(c.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("descartar() no registrada -> lanza excepción")
    void descartar_noRegistrada_lanzaExcepcion() {
        Cotizacion c = cotizacion(1L, "0");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));

        assertThatThrownBy(() -> service.descartar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    @Test
    @DisplayName("descartar() no existe -> lanza excepción")
    void descartar_noExiste_lanzaExcepcion() {
        when(cotizacionRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.descartar(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── anular ──

    @Test
    @DisplayName("anular() registrada -> cambia estado y flag")
    void anular_registrada_cambiaEstadoYFlag() {
        Cotizacion c = cotizacion(1L, "1");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));
        when(cotizacionRepository.save(any(Cotizacion.class))).thenReturn(c);

        CotizacionDetalleResponse result = service.anular(1L, "Por error");

        assertThat(result).isNotNull();
        assertThat(c.getFlagEstado()).isEqualTo("0");
        assertThat(c.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("anular() convertida -> lanza excepción")
    void anular_convertida_lanzaExcepcion() {
        Cotizacion c = cotizacion(1L, "2");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));

        assertThatThrownBy(() -> service.anular(1L, "Motivo"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cerrada");
    }

    @Test
    @DisplayName("anular() no existe -> lanza excepción")
    void anular_noExiste_lanzaExcepcion() {
        when(cotizacionRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.anular(99L, "Motivo"))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("anular() seleccionada -> ok")
    void anular_seleccionada_ok() {
        Cotizacion c = cotizacion(1L, "1");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));
        when(cotizacionRepository.save(any())).thenReturn(c);

        CotizacionDetalleResponse result = service.anular(1L, "Cambio de proveedor");

        assertThat(c.getFlagEstado()).isEqualTo("0");
        assertThat(c.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("anular() descartada -> ok")
    void anular_descartada_ok() {
        Cotizacion c = cotizacion(1L, "0");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));
        when(cotizacionRepository.save(any())).thenReturn(c);

        service.anular(1L, "Cerrar cotización");

        assertThat(c.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("toResponse() con proveedor y moneda -> retorna datos")
    void toResponse_conProveedorYMoneda_retornaDatos() {
        pe.restaurant.compras.entity.EntidadContribuyenteRef prov = mock(pe.restaurant.compras.entity.EntidadContribuyenteRef.class);
        when(prov.getNombreCompleto()).thenReturn("Proveedor S.A.");
        when(prov.getNroDocumento()).thenReturn("20123456789");
        when(entidadContribuyenteRefRepository.findById(10L)).thenReturn(Optional.of(prov));

        pe.restaurant.compras.entity.MonedaRef moneda = mock(pe.restaurant.compras.entity.MonedaRef.class);
        when(moneda.getCodigo()).thenReturn("PEN");
        when(monedaRefRepository.findById(1L)).thenReturn(Optional.of(moneda));

        Cotizacion c = cotizacion(1L, "1");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));

        CotizacionDetalleResponse result = service.obtener(1L);

        assertThat(result.getProveedorRazonSocial()).isEqualTo("Proveedor S.A.");
        assertThat(result.getProveedorRuc()).isEqualTo("20123456789");
        assertThat(result.getMonedaCodigo()).isEqualTo("PEN");
    }

    @Test
    @DisplayName("toResponse() sin proveedor id ni moneda id -> retorna nulls")
    void toResponse_sinProveedorIdNiMonedaId_retornaNulls() {
        Cotizacion c = cotizacion(1L, "1");
        c.setProveedorId(null);
        c.setMonedaId(null);
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));

        CotizacionDetalleResponse result = service.obtener(1L);

        assertThat(result.getProveedorRazonSocial()).isNull();
        assertThat(result.getMonedaCodigo()).isNull();
    }

    @Test
    @DisplayName("toDetResponse() artículo encontrado -> retorna código")
    void toDetResponse_articuloEncontrado_retornaCodigo() {
        pe.restaurant.compras.entity.ArticuloRef artRef = mock(pe.restaurant.compras.entity.ArticuloRef.class);
        when(artRef.getCodigo()).thenReturn("ART-100");
        when(artRef.getNombre()).thenReturn("Arroz");
        when(articuloRefRepository.findById(100L)).thenReturn(Optional.of(artRef));

        Cotizacion c = cotizacion(1L, "1");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));

        CotizacionDetalleResponse result = service.obtener(1L);

        assertThat(result.getLineas()).isNotEmpty();
        assertThat(result.getLineas().get(0).getArticuloCodigo()).isEqualTo("ART-100");
        assertThat(result.getLineas().get(0).getArticuloDescripcion()).isEqualTo("Arroz");
    }

    // ── Helpers ──

    // ── Tests comparativo ──

    @Test
    @DisplayName("comparativo() sin cotizaciónes -> retorna lista vacia")
    void comparativo_sinCotizaciones_retornaListaVacia() {
        when(cotizacionRepository.findAll(any(Specification.class))).thenReturn(List.of());

        ComparativoCotizacionesResponse result = service.comparativo(List.of(10L), null, null);

        assertThat(result.getArticulos()).isEmpty();
    }

    @Test
    @DisplayName("comparativo() con cotizaciónes agrupa artículos")
    void comparativo_conCotizaciones_agrupaArticulos() {
        Cotizacion c = cotizacion(1L, "1");
        pe.restaurant.compras.entity.EntidadContribuyenteRef prov = mock(pe.restaurant.compras.entity.EntidadContribuyenteRef.class);
        when(prov.getNombreCompleto()).thenReturn("Proveedor S.A.");
        when(entidadContribuyenteRefRepository.findById(10L)).thenReturn(Optional.of(prov));

        pe.restaurant.compras.entity.ArticuloRef artRef = mock(pe.restaurant.compras.entity.ArticuloRef.class);
        when(artRef.getCodigo()).thenReturn("ART-100");
        when(artRef.getNombre()).thenReturn("Arroz");
        when(articuloRefRepository.findById(100L)).thenReturn(Optional.of(artRef));

        when(cotizacionRepository.findAll(any(Specification.class))).thenReturn(List.of(c));

        ComparativoCotizacionesResponse result = service.comparativo(null, LocalDate.now().minusDays(7), LocalDate.now());

        assertThat(result.getArticulos()).hasSize(1);
        assertThat(result.getArticulos().get(0).getArticuloId()).isEqualTo(100L);
        assertThat(result.getArticulos().get(0).getArticuloCodigo()).isEqualTo("ART-100");
    }

    @Test
    @DisplayName("comparativo() proveedor no encontrado razon social null")
    void comparativo_proveedorNoEncontrado_razonSocialNull() {
        Cotizacion c = cotizacion(1L, "1");
        when(entidadContribuyenteRefRepository.findById(10L)).thenReturn(Optional.empty());
        when(articuloRefRepository.findById(100L)).thenReturn(Optional.empty());
        when(cotizacionRepository.findAll(any(Specification.class))).thenReturn(List.of(c));

        ComparativoCotizacionesResponse result = service.comparativo(List.of(10L), null, null);

        assertThat(result.getArticulos()).hasSize(1);
        assertThat(result.getArticulos().get(0).getOfertas().get(0).getProveedorRazonSocial()).isNull();
    }

    // ── Tests convertirOc ──

    @Test
    @DisplayName("convertirOc() cotización activa -> crea orden compra")
    void convertirOc_cotizacionActiva_creaOrdenCompra() {
        Cotizacion c = cotizacion(1L, "1");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));
        when(cotizacionRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        OrdenCompraDetalleResponse expectedResp = new OrdenCompraDetalleResponse();
        expectedResp.setId(99L);
        when(ordenCompraService.crear(any())).thenReturn(expectedResp);

        ConvertirOcRequest request = ConvertirOcRequest.builder()
                .fechaEmision(LocalDate.now())
                .fechaEntrega(LocalDate.now().plusDays(7))
                .formaPagoId(1L)
                .observaciones("Desde cotización")
                .build();

        OrdenCompraDetalleResponse result = service.convertirOc(1L, request);

        assertThat(result.getId()).isEqualTo(99L);
        assertThat(c.getFlagEstado()).isEqualTo("2");
        verify(ordenCompraService).crear(any(OrdenCompraCabeceraRequest.class));
    }

    @Test
    @DisplayName("convertirOc() cotización inactiva -> lanza excepción")
    void convertirOc_cotizacionInactiva_lanzaExcepcion() {
        Cotizacion c = cotizacion(1L, "0");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));

        ConvertirOcRequest request = ConvertirOcRequest.builder()
                .fechaEmision(LocalDate.now())
                .build();

        assertThatThrownBy(() -> service.convertirOc(1L, request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cotización activa");
    }

    @Test
    @DisplayName("convertirOc() cotización no existe -> lanza excepción")
    void convertirOc_cotizacionNoExiste_lanzaExcepcion() {
        when(cotizacionRepository.findById(99L)).thenReturn(Optional.empty());

        ConvertirOcRequest request = ConvertirOcRequest.builder()
                .fechaEmision(LocalDate.now())
                .build();

        assertThatThrownBy(() -> service.convertirOc(99L, request))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("convertirOc() asigna updated by desde contexto")
    void convertirOc_asignaUpdatedByDesdeContexto() {
        Cotizacion c = cotizacion(1L, "1");
        when(cotizacionRepository.findById(1L)).thenReturn(Optional.of(c));
        when(cotizacionRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(ordenCompraService.crear(any())).thenReturn(new OrdenCompraDetalleResponse());

        ConvertirOcRequest request = ConvertirOcRequest.builder()
                .fechaEmision(LocalDate.now())
                .build();

        service.convertirOc(1L, request);

        assertThat(c.getUpdatedBy()).isEqualTo(1L);
    }

    private void mockProveedorActivo(Long proveedorId) {
        pe.restaurant.compras.entity.EntidadContribuyenteRef prov = mock(pe.restaurant.compras.entity.EntidadContribuyenteRef.class);
        when(prov.getFlagEstado()).thenReturn("1");
        when(entidadContribuyenteRefRepository.findById(proveedorId)).thenReturn(Optional.of(prov));
    }
}
