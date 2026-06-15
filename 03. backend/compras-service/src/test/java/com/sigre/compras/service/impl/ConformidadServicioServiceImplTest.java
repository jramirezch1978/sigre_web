package com.sigre.compras.service.impl;

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
import com.sigre.compras.dto.*;
import com.sigre.compras.entity.ConformidadServicio;
import com.sigre.compras.entity.ConformidadServicioDet;
import com.sigre.compras.entity.EntidadContribuyenteRef;
import com.sigre.compras.entity.OrdenServicio;
import com.sigre.compras.mapper.ConformidadServicioMapper;
import com.sigre.compras.repository.ConformidadServicioRepository;
import com.sigre.compras.repository.EntidadContribuyenteRefRepository;
import com.sigre.compras.repository.OrdenServicioRepository;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static com.sigre.compras.ComprasTestFixtures.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ConformidadServicioServiceImpl — Pruebas Unitarias")
class ConformidadServicioServiceImplTest {

    @Mock private ConformidadServicioRepository repository;
    @Mock private ConformidadServicioMapper mapper;
    @Mock private OrdenServicioRepository ordenServicioRepository;
    @Mock private EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;

    @InjectMocks private ConformidadServicioServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(mapper.toResponse(any())).thenReturn(new ConformidadServicioResponse());
        lenient().when(mapper.toDetalleResponse(any())).thenReturn(new ConformidadServicioDetalleResponse());
        lenient().when(mapper.toDetEntity(any())).thenReturn(new ConformidadServicioDet());
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ── listar ──

    @Test
    @DisplayName("listar() con todos los filtros -> retorna página")
    @SuppressWarnings("unchecked")
    void listar_conTodosLosFiltros_retornaPagina() {
        ConformidadServicio cs = conformidadServicio(1L, false, "1");
        Page<ConformidadServicio> page = new PageImpl<>(List.of(cs));

        when(repository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        Page<ConformidadServicioResponse> result = service.listar(10L, false, "1", null, null, Pageable.unpaged());

        assertThat(result.getContent()).hasSize(1);
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    @SuppressWarnings("unchecked")
    void listar_sinFiltros_retornaPagina() {
        Page<ConformidadServicio> page = new PageImpl<>(List.of(conformidadServicio(1L, false, "1")));
        when(repository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        Page<ConformidadServicioResponse> result = service.listar(null, null, null, null, null, Pageable.unpaged());

        assertThat(result.getContent()).hasSize(1);
    }

    @Test
    @DisplayName("listar() solo orden servicio id -> filtra")
    @SuppressWarnings("unchecked")
    void listar_soloOrdenServicioId_filtra() {
        Page<ConformidadServicio> page = new PageImpl<>(List.of());
        when(repository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        service.listar(10L, null, null, null, null, Pageable.unpaged());

        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() solo aprobado -> filtra")
    @SuppressWarnings("unchecked")
    void listar_soloAprobado_filtra() {
        Page<ConformidadServicio> page = new PageImpl<>(List.of());
        when(repository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        service.listar(null, true, null, null, null, Pageable.unpaged());

        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() flag estado blank -> ignora filtro")
    @SuppressWarnings("unchecked")
    void listar_flagEstadoBlank_ignoraFiltro() {
        Page<ConformidadServicio> page = new PageImpl<>(List.of());
        when(repository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        service.listar(null, null, "  ", null, null, Pageable.unpaged());

        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    // ── obtener ──

    @Test
    @DisplayName("obtener() existente -> retorna detalle")
    void obtener_existente_retornaDetalle() {
        ConformidadServicio cs = conformidadServicio(1L, false, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(cs));

        ConformidadServicioDetalleResponse result = service.obtener(1L);

        assertThat(result).isNotNull();
        verify(mapper).toDetalleResponse(cs);
    }

    @Test
    @DisplayName("obtener() no existente -> lanza excepción")
    void obtener_noExistente_lanzaExcepcion() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtener(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── crear ──

    @Test
    @DisplayName("crear() ok -> guarda entidad")
    void crear_ok_guardaEntidad() {
        when(ordenServicioRepository.existsById(anyLong())).thenReturn(true);

        ConformidadServicio saved = conformidadServicio(1L, false, "1");
        when(repository.save(any(ConformidadServicio.class))).thenReturn(saved);

        ConformidadServicioRequest req = conformidadServicioRequest();
        ConformidadServicioDetalleResponse result = service.crear(req);

        assertThat(result).isNotNull();
        verify(repository).save(any(ConformidadServicio.class));
    }

    @Test
    @DisplayName("crear() orden servicio no existe -> lanza excepción")
    void crear_ordenServicioNoExiste_lanzaExcepcion() {
        when(ordenServicioRepository.existsById(10L)).thenReturn(false);

        ConformidadServicioRequest req = conformidadServicioRequest();

        assertThatThrownBy(() -> service.crear(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("no existe");
    }

    @Test
    @DisplayName("crear() orden servicio count null -> lanza excepción")
    void crear_ordenServicioCountNull_lanzaExcepcion() {
        when(ordenServicioRepository.existsById(10L)).thenReturn(false);

        assertThatThrownBy(() -> service.crear(conformidadServicioRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("no existe");
    }

    @Test
    @DisplayName("crear() calcular subtotal cantidad null -> retorna zero")
    void crear_calcularSubtotal_cantidadNull_retornaZero() {
        when(ordenServicioRepository.existsById(anyLong())).thenReturn(true);

        ConformidadServicioDet detEntity = new ConformidadServicioDet();
        when(mapper.toDetEntity(any())).thenReturn(detEntity);

        ConformidadServicio saved = conformidadServicio(2L, false, "1");
        when(repository.save(any(ConformidadServicio.class))).thenReturn(saved);

        ConformidadServicioRequest req = conformidadServicioRequest();
        req.getLineas().get(0).setCantidad(null);

        service.crear(req);

        verify(repository).save(argThat(entity -> {
            ConformidadServicioDet d = entity.getLineas().get(0);
            assertThat(d.getSubtotal()).isEqualByComparingTo(BigDecimal.ZERO);
            return true;
        }));
    }

    @Test
    @DisplayName("crear() calcular subtotal precio unitario null -> retorna zero")
    void crear_calcularSubtotal_precioUnitarioNull_retornaZero() {
        when(ordenServicioRepository.existsById(anyLong())).thenReturn(true);

        ConformidadServicioDet detEntity = new ConformidadServicioDet();
        when(mapper.toDetEntity(any())).thenReturn(detEntity);

        ConformidadServicio saved = conformidadServicio(3L, false, "1");
        when(repository.save(any(ConformidadServicio.class))).thenReturn(saved);

        ConformidadServicioRequest req = conformidadServicioRequest();
        req.getLineas().get(0).setPrecioUnitario(null);

        service.crear(req);

        verify(repository).save(argThat(entity -> {
            ConformidadServicioDet d = entity.getLineas().get(0);
            assertThat(d.getSubtotal()).isEqualByComparingTo(BigDecimal.ZERO);
            return true;
        }));
    }

    @Test
    @DisplayName("crear() calcular subtotal ambos presentes -> retorna producto")
    void crear_calcularSubtotal_ambosPresentes_retornaProducto() {
        when(ordenServicioRepository.existsById(anyLong())).thenReturn(true);

        ConformidadServicioDet detEntity = new ConformidadServicioDet();
        when(mapper.toDetEntity(any())).thenReturn(detEntity);

        when(repository.save(any(ConformidadServicio.class))).thenAnswer(inv -> {
            ConformidadServicio c = inv.getArgument(0);
            c.setId(4L);
            return c;
        });

        ConformidadServicioRequest req = conformidadServicioRequest();
        req.getLineas().get(0).setCantidad(new BigDecimal("3"));
        req.getLineas().get(0).setPrecioUnitario(new BigDecimal("200"));

        service.crear(req);

        verify(repository).save(argThat(entity -> {
            ConformidadServicioDet d = entity.getLineas().get(0);
            assertThat(d.getSubtotal()).isEqualByComparingTo(new BigDecimal("600"));
            return true;
        }));
    }

    // ── actualizar ──

    @Test
    @DisplayName("actualizar() no aprobada -> ok")
    void actualizar_noAprobada_ok() {
        ConformidadServicio existing = conformidadServicio(1L, false, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(ordenServicioRepository.existsById(anyLong())).thenReturn(true);
        when(repository.save(any(ConformidadServicio.class))).thenReturn(existing);

        ConformidadServicioRequest req = conformidadServicioRequest();
        ConformidadServicioDetalleResponse result = service.actualizar(1L, req);

        assertThat(result).isNotNull();
        verify(repository).save(any(ConformidadServicio.class));
    }

    @Test
    @DisplayName("actualizar() aprobada -> lanza excepción")
    void actualizar_aprobada_lanzaExcepcion() {
        ConformidadServicio existing = conformidadServicio(1L, true, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));

        assertThatThrownBy(() -> service.actualizar(1L, conformidadServicioRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("aprobada");
    }

    @Test
    @DisplayName("actualizar() anulada -> lanza excepción")
    void actualizar_anulada_lanzaExcepcion() {
        ConformidadServicio existing = conformidadServicio(1L, false, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));

        assertThatThrownBy(() -> service.actualizar(1L, conformidadServicioRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("anulada");
    }

    @Test
    @DisplayName("actualizar() no existe -> lanza excepción")
    void actualizar_noExiste_lanzaExcepcion() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(99L, conformidadServicioRequest()))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("actualizar() reemplaza líneas")
    void actualizar_reemplazaLineas() {
        ConformidadServicio existing = conformidadServicio(1L, false, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(ordenServicioRepository.existsById(anyLong())).thenReturn(true);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        ConformidadServicioRequest req = conformidadServicioRequest();
        ConformidadServicioDetRequest d2 = new ConformidadServicioDetRequest();
        d2.setSecuencia(2);
        d2.setDescripcion("Servicio B");
        d2.setCantidad(new BigDecimal("2"));
        d2.setPrecioUnitario(new BigDecimal("300"));
        req.setLineas(List.of(req.getLineas().get(0), d2));

        service.actualizar(1L, req);

        verify(repository).save(argThat(entity ->
                entity.getLineas().size() == 2));
    }

    // ── aprobar ──

    @Test
    @DisplayName("aprobar() pendiente -> ok")
    void aprobar_pendiente_ok() {
        ConformidadServicio cs = conformidadServicio(1L, false, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(cs));
        when(repository.save(any(ConformidadServicio.class))).thenReturn(cs);

        ConformidadServicioDetalleResponse result = service.aprobar(1L);

        assertThat(result).isNotNull();
        assertThat(cs.getAprobado()).isTrue();
        verify(repository).save(any(ConformidadServicio.class));
    }

    @Test
    @DisplayName("aprobar() ya aprobada -> lanza excepción")
    void aprobar_yaAprobada_lanzaExcepcion() {
        ConformidadServicio cs = conformidadServicio(1L, true, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(cs));

        assertThatThrownBy(() -> service.aprobar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("aprobada");
    }

    @Test
    @DisplayName("aprobar() anulada -> lanza excepción")
    void aprobar_anulada_lanzaExcepcion() {
        ConformidadServicio cs = conformidadServicio(1L, false, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(cs));

        assertThatThrownBy(() -> service.aprobar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("anulada");
    }

    @Test
    @DisplayName("aprobar() no existe -> lanza excepción")
    void aprobar_noExiste_lanzaExcepcion() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.aprobar(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("aprobar() asigna updated by")
    void aprobar_asignaUpdatedBy() {
        ConformidadServicio cs = conformidadServicio(1L, false, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(cs));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        service.aprobar(1L);

        verify(repository).save(argThat(e -> {
            assertThat(e.getUpdatedBy()).isEqualTo(1L);
            assertThat(e.getAprobado()).isTrue();
            return true;
        }));
    }

    // ── anular ──

    @Test
    @DisplayName("anular() activa -> ok")
    void anular_activa_ok() {
        ConformidadServicio cs = conformidadServicio(1L, false, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(cs));
        when(repository.save(any(ConformidadServicio.class))).thenReturn(cs);

        ConformidadServicioDetalleResponse result = service.anular(1L);

        assertThat(result).isNotNull();
        assertThat(cs.getFlagEstado()).isEqualTo("0");
        verify(repository).save(any(ConformidadServicio.class));
    }

    @Test
    @DisplayName("anular() ya anulada -> lanza excepción")
    void anular_yaAnulada_lanzaExcepcion() {
        ConformidadServicio cs = conformidadServicio(1L, false, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(cs));

        assertThatThrownBy(() -> service.anular(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("anulada");
    }

    @Test
    @DisplayName("anular() no existe -> lanza excepción")
    void anular_noExiste_lanzaExcepcion() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.anular(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("anular() asigna updated by y flag estado")
    void anular_asignaUpdatedByYFlagEstado() {
        ConformidadServicio cs = conformidadServicio(1L, false, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(cs));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        service.anular(1L);

        verify(repository).save(argThat(e -> {
            assertThat(e.getUpdatedBy()).isEqualTo(1L);
            assertThat(e.getFlagEstado()).isEqualTo("0");
            return true;
        }));
    }

    @Test
    @DisplayName("pendientes() sin conformidades aprobadas retorna ordenes pendientes")
    @SuppressWarnings("unchecked")
    void pendientes_sinConformidadesAprobadas_retornaOrdenesPendientes() {
        OrdenServicio os = ordenServicio(1L, "1");
        os.setFlagSolicitaActa("1");
        os.setProveedorId(10L);
        os.setFecRegistro(LocalDate.now());
        os.setMontoTotal(new BigDecimal("500"));

        EntidadContribuyenteRef proveedor = mock(EntidadContribuyenteRef.class);
        when(proveedor.getNombreCompleto()).thenReturn("Proveedor Test");
        when(repository.findOrdenServicioIdsConConformidadAprobada()).thenReturn(Collections.emptyList());
        when(ordenServicioRepository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(os)));
        when(entidadContribuyenteRefRepository.findById(10L)).thenReturn(Optional.of(proveedor));

        Page<OrdenServicioPendienteConformidadResponse> result =
                service.pendientes(10L, LocalDate.now().minusDays(1), LocalDate.now().plusDays(1), Pageable.unpaged());

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getProveedorRazonSocial()).isEqualTo("Proveedor Test");
    }

    @Test
    @DisplayName("pendientes() proveedor no encontrado retorna razon social null")
    @SuppressWarnings("unchecked")
    void pendientes_proveedorNoEncontrado_retornaNull() {
        OrdenServicio os = ordenServicio(2L, "1");
        os.setFlagSolicitaActa("1");
        os.setProveedorId(77L);
        when(repository.findOrdenServicioIdsConConformidadAprobada()).thenReturn(List.of(99L));
        when(ordenServicioRepository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(os)));
        when(entidadContribuyenteRefRepository.findById(77L)).thenReturn(Optional.empty());

        Page<OrdenServicioPendienteConformidadResponse> result =
                service.pendientes(null, null, null, Pageable.unpaged());

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getProveedorRazonSocial()).isNull();
    }

    @Test
    @DisplayName("generarPdf() activa incluye observacion y detalle")
    void generarPdf_activa_incluyeObservacionYDetalle() {
        ConformidadServicio cs = conformidadServicio(1L, true, "1");
        cs.setObservacion("Servicio conforme");
        when(repository.findById(1L)).thenReturn(Optional.of(cs));

        byte[] pdfBytes = service.generarPdf(1L);
        String pdf = new String(pdfBytes, java.nio.charset.StandardCharsets.UTF_8);

        assertThat(pdf).contains("ACTA DE CONFORMIDAD DE SERVICIO");
        assertThat(pdf).contains("Servicio conforme");
        assertThat(pdf).contains("DETALLE");
    }

    @Test
    @DisplayName("generarPdf() anulada lanza COM-410")
    void generarPdf_anulada_lanzaCOM410() {
        ConformidadServicio cs = conformidadServicio(1L, false, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(cs));

        assertThatThrownBy(() -> service.generarPdf(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("anulada");
    }

}
