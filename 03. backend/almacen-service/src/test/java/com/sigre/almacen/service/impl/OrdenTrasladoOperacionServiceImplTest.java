package com.sigre.almacen.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.jdbc.core.JdbcTemplate;
import com.sigre.almacen.dto.OrdenTrasladoLineaRequest;
import com.sigre.almacen.dto.OrdenTrasladoRequest;
import com.sigre.almacen.entity.Almacen;
import com.sigre.almacen.entity.OrdenTraslado;
import com.sigre.almacen.entity.OrdenTrasladoDet;
import com.sigre.almacen.repository.AlmacenRepository;
import com.sigre.almacen.repository.ArticuloRefRepository;
import com.sigre.almacen.repository.OrdenTrasladoDetRepository;
import com.sigre.almacen.repository.OrdenTrasladoRepository;
import com.sigre.almacen.service.EmpresaInfoService;
import com.sigre.common.service.NumeradorDocumentoService;

import java.time.LocalDate;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import org.springframework.http.HttpStatus;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class OrdenTrasladoOperacionServiceImplTest {

    @Mock
    private OrdenTrasladoRepository ordenTrasladoRepository;
    @Mock
    private OrdenTrasladoDetRepository ordenTrasladoDetRepository;
    @Mock
    private AlmacenRepository almacenRepository;
    @Mock
    private ArticuloRefRepository articuloRefRepository;
    @Mock
    private NumeradorDocumentoService numeradorDocumentoService;
    @Mock
    private EmpresaInfoService empresaInfoService;
    @Mock
    private JdbcTemplate jdbcTemplate;

    @InjectMocks
    private OrdenTrasladoOperacionServiceImpl service;

    @BeforeEach
    void stubLineasVacias() {
        when(ordenTrasladoDetRepository.findByOrdenTrasladoIdOrderById(anyLong())).thenReturn(Collections.emptyList());
    }

    private static OrdenTraslado ordenActiva() {
        OrdenTraslado ot = new OrdenTraslado();
        ot.setId(1L);
        ot.setFlagEstado("1");
        ot.setAlmacenOrigenId(10L);
        ot.setAlmacenDestinoId(20L);
        ot.setNumero("OT-1");
        ot.setFecha(LocalDate.of(2026, 5, 2));
        return ot;
    }

    @Test
    void buscar_devuelvePaginaSinLineas() {
        OrdenTraslado ot = ordenActiva();
        when(ordenTrasladoRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(ot)));

        var page = service.buscar(10L, 20L, "1", null, null, Pageable.unpaged());

        assertThat(page.getContent()).hasSize(1);
        assertThat(page.getContent().get(0).getLineas()).isEmpty();
    }

    @Test
    void obtener_ok() {
        OrdenTraslado ot = ordenActiva();
        when(ordenTrasladoRepository.findById(1L)).thenReturn(Optional.of(ot));
        when(ordenTrasladoDetRepository.findByOrdenTrasladoIdOrderById(1L))
                .thenReturn(List.of(detalle(100L)));

        assertThat(service.obtener(1L).getLineas()).hasSize(1);
    }

    @Test
    void exportarExcel_sinRegistros_generaXlsxZip() {
        when(ordenTrasladoRepository.findAll(any(Specification.class))).thenReturn(Collections.emptyList());

        byte[] bytes = service.exportarExcel(null, null, null, null, null);

        assertThat(bytes.length).isGreaterThan(8);
        assertThat(bytes[0]).isEqualTo((byte) 0x50);
        assertThat(bytes[1]).isEqualTo((byte) 0x4B);
    }

    @Test
    void aprobar_desdeActiva() {
        OrdenTraslado ot = ordenActiva();
        when(ordenTrasladoRepository.findById(1L)).thenReturn(Optional.of(ot));
        when(ordenTrasladoRepository.save(any(OrdenTraslado.class))).thenAnswer(i -> i.getArgument(0));

        assertThat(service.aprobar(1L).getFlagEstado()).isEqualTo("1");
    }

    @Test
    void rechazar_desdeActiva() {
        OrdenTraslado ot = ordenActiva();
        when(ordenTrasladoRepository.findById(1L)).thenReturn(Optional.of(ot));
        when(ordenTrasladoRepository.save(any(OrdenTraslado.class))).thenAnswer(i -> i.getArgument(0));

        assertThat(service.rechazar(1L).getFlagEstado()).isEqualTo("0");
    }

    @Test
    void anular_desdeActiva() {
        OrdenTraslado ot = ordenActiva();
        when(ordenTrasladoRepository.findById(1L)).thenReturn(Optional.of(ot));
        when(ordenTrasladoRepository.save(any(OrdenTraslado.class))).thenAnswer(i -> i.getArgument(0));

        assertThat(service.anular(1L).getFlagEstado()).isEqualTo("0");
    }

    @Test
    void cerrar_desdeActiva() {
        OrdenTraslado ot = ordenActiva();
        when(ordenTrasladoRepository.findById(1L)).thenReturn(Optional.of(ot));
        when(ordenTrasladoRepository.save(any(OrdenTraslado.class))).thenAnswer(i -> i.getArgument(0));

        assertThat(service.cerrar(1L).getFlagEstado()).isEqualTo("2");
    }

    @Test
    void crear_mismoAlmacenOrigenDestino_falla() {
        OrdenTrasladoRequest req = requestBasico(10L, 10L);
        when(almacenRepository.existsById(10L)).thenReturn(true);

        assertThatThrownBy(() -> service.crear(req))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-OT-005");
    }

    @Test
    void crear_ok() {
        OrdenTrasladoRequest req = requestBasico(10L, 20L);
        when(almacenRepository.existsById(10L)).thenReturn(true);
        when(almacenRepository.existsById(20L)).thenReturn(true);
        Almacen origen = new Almacen();
        origen.setSucursalId(3L);
        when(almacenRepository.findById(10L)).thenReturn(Optional.of(origen));
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(100L))).thenReturn(1);
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), eq(3L), anyInt())).thenReturn("OT-99");
        when(ordenTrasladoRepository.save(any(OrdenTraslado.class))).thenAnswer(inv -> {
            OrdenTraslado ot = inv.getArgument(0);
            ot.setId(99L);
            return ot;
        });
        when(ordenTrasladoDetRepository.findByOrdenTrasladoIdOrderById(99L)).thenReturn(List.of(detalle(100L)));

        var resp = service.crear(req);

        assertThat(resp.getId()).isEqualTo(99L);
        assertThat(resp.getNumero()).isEqualTo("OT-99");
        verify(ordenTrasladoDetRepository).save(any(OrdenTrasladoDet.class));
    }

    @Test
    void aprobar_ordenNoActiva_falla() {
        OrdenTraslado ot = ordenActiva();
        ot.setFlagEstado("2");
        when(ordenTrasladoRepository.findById(1L)).thenReturn(Optional.of(ot));

        assertThatThrownBy(() -> service.aprobar(1L))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-OT-006")
                .hasFieldOrPropertyWithValue("status", HttpStatus.CONFLICT);
    }

    @Test
    void obtener_noExiste_falla() {
        when(ordenTrasladoRepository.findById(404L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtener(404L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void crear_cantidadNull_falla() {
        OrdenTrasladoRequest req = requestBasico(10L, 20L);
        req.getLineas().get(0).setCantidad(null);
        when(almacenRepository.existsById(10L)).thenReturn(true);
        when(almacenRepository.existsById(20L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(100L))).thenReturn(1);

        assertThatThrownBy(() -> service.crear(req))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-OT-001");
    }

    @Test
    void crear_cantidadCero_falla() {
        OrdenTrasladoRequest req = requestBasico(10L, 20L);
        req.getLineas().get(0).setCantidad(BigDecimal.ZERO);
        when(almacenRepository.existsById(10L)).thenReturn(true);
        when(almacenRepository.existsById(20L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(100L))).thenReturn(1);

        assertThatThrownBy(() -> service.crear(req))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-OT-001");
        verify(ordenTrasladoRepository, never()).save(any());
    }

    @Test
    void crear_almacenDestinoInexistente_falla() {
        OrdenTrasladoRequest req = requestBasico(10L, 20L);
        when(almacenRepository.existsById(10L)).thenReturn(true);
        when(almacenRepository.existsById(20L)).thenReturn(false);

        assertThatThrownBy(() -> service.crear(req))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void crear_articuloInexistente_falla() {
        OrdenTrasladoRequest req = requestBasico(10L, 20L);
        when(almacenRepository.existsById(10L)).thenReturn(true);
        when(almacenRepository.existsById(20L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(100L))).thenReturn(0);

        assertThatThrownBy(() -> service.crear(req))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void actualizar_ok() {
        OrdenTraslado ot = ordenActiva();
        OrdenTrasladoRequest req = requestBasico(10L, 20L);
        when(ordenTrasladoRepository.findById(1L)).thenReturn(Optional.of(ot));
        when(almacenRepository.existsById(10L)).thenReturn(true);
        when(almacenRepository.existsById(20L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(100L))).thenReturn(1);
        when(ordenTrasladoRepository.save(any(OrdenTraslado.class))).thenAnswer(i -> i.getArgument(0));
        when(ordenTrasladoDetRepository.findByOrdenTrasladoIdOrderById(1L)).thenReturn(List.of(detalle(100L)));

        var resp = service.actualizar(1L, req);

        assertThat(resp.getAlmacenOrigenId()).isEqualTo(10L);
        verify(ordenTrasladoDetRepository).deleteByOrdenTrasladoId(1L);
        verify(ordenTrasladoDetRepository).save(any(OrdenTrasladoDet.class));
    }

    @Test
    void actualizar_cantidadCero_falla() {
        OrdenTraslado ot = ordenActiva();
        OrdenTrasladoRequest req = requestBasico(10L, 20L);
        req.getLineas().get(0).setCantidad(BigDecimal.ZERO);
        when(ordenTrasladoRepository.findById(1L)).thenReturn(Optional.of(ot));
        when(almacenRepository.existsById(10L)).thenReturn(true);
        when(almacenRepository.existsById(20L)).thenReturn(true);
        when(jdbcTemplate.queryForObject(anyString(), eq(Integer.class), eq(100L))).thenReturn(1);

        assertThatThrownBy(() -> service.actualizar(1L, req))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-OT-001");
    }

    @Test
    void actualizar_ordenNoActiva_falla() {
        OrdenTraslado ot = ordenActiva();
        ot.setFlagEstado("0");
        when(ordenTrasladoRepository.findById(1L)).thenReturn(Optional.of(ot));

        assertThatThrownBy(() -> service.actualizar(1L, requestBasico(10L, 20L)))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-OT-002");
    }

    @Test
    void cambiarEstado_ok() {
        OrdenTraslado ot = ordenActiva();
        when(ordenTrasladoRepository.findById(1L)).thenReturn(Optional.of(ot));
        when(ordenTrasladoRepository.save(any(OrdenTraslado.class))).thenAnswer(i -> i.getArgument(0));

        assertThat(service.cambiarEstado(1L, " 3 ").getFlagEstado()).isEqualTo("3");
    }

    @Test
    void crear_almacenOrigenInexistente_falla() {
        OrdenTrasladoRequest req = requestBasico(10L, 20L);
        when(almacenRepository.existsById(10L)).thenReturn(false);

        assertThatThrownBy(() -> service.crear(req))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void cambiarEstado_estadoVacio_falla() {
        assertThatThrownBy(() -> service.cambiarEstado(1L, "  "))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-OT-004");
    }

    @Test
    void anular_ordenNoActiva_falla() {
        OrdenTraslado ot = ordenActiva();
        ot.setFlagEstado("2");
        when(ordenTrasladoRepository.findById(1L)).thenReturn(Optional.of(ot));

        assertThatThrownBy(() -> service.anular(1L))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-OT-006");
    }

    @Test
    void cambiarEstado_ordenNoExiste_falla() {
        when(ordenTrasladoRepository.findById(404L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.cambiarEstado(404L, "2"))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void cambiarEstado_ordenNoActiva_falla() {
        OrdenTraslado ot = ordenActiva();
        ot.setFlagEstado("0");
        when(ordenTrasladoRepository.findById(1L)).thenReturn(Optional.of(ot));

        assertThatThrownBy(() -> service.cambiarEstado(1L, "2"))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-OT-006");
    }

    @Test
    void actualizar_ordenNoExiste_falla() {
        when(ordenTrasladoRepository.findById(404L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(404L, requestBasico(10L, 20L)))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void rechazar_ordenNoActiva_falla() {
        OrdenTraslado ot = ordenActiva();
        ot.setFlagEstado("2");
        when(ordenTrasladoRepository.findById(1L)).thenReturn(Optional.of(ot));

        assertThatThrownBy(() -> service.rechazar(1L))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-OT-006");
    }

    @Test
    void exportarExcel_conRegistros_generaXlsx() {
        OrdenTraslado ot = ordenActiva();
        when(ordenTrasladoRepository.findAll(any(Specification.class))).thenReturn(List.of(ot));

        byte[] bytes = service.exportarExcel(10L, 20L, "1", LocalDate.of(2026, 1, 1), LocalDate.of(2026, 12, 31));

        assertThat(bytes.length).isGreaterThan(8);
        assertThat(bytes[0]).isEqualTo((byte) 0x50);
    }

    private static OrdenTrasladoRequest requestBasico(long origen, long destino) {
        OrdenTrasladoLineaRequest linea = new OrdenTrasladoLineaRequest();
        linea.setArticuloId(100L);
        linea.setCantidad(new BigDecimal("5"));
        OrdenTrasladoRequest req = new OrdenTrasladoRequest();
        req.setAlmacenOrigenId(origen);
        req.setAlmacenDestinoId(destino);
        req.setFecha(LocalDate.of(2026, 5, 16));
        req.setLineas(List.of(linea));
        return req;
    }

    private static OrdenTrasladoDet detalle(long articuloId) {
        OrdenTrasladoDet det = new OrdenTrasladoDet();
        det.setId(1L);
        det.setArticuloId(articuloId);
        det.setCantidad(new BigDecimal("5"));
        det.setCantidadDespachada(BigDecimal.ZERO);
        det.setCantidadRecibida(BigDecimal.ZERO);
        return det;
    }
}
