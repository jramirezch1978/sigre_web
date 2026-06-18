package pe.restaurant.almacen.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import pe.restaurant.almacen.dto.SolSalidaLineaRequest;
import pe.restaurant.almacen.dto.SolSalidaRequest;
import pe.restaurant.almacen.entity.Almacen;
import pe.restaurant.almacen.entity.SolSalida;
import pe.restaurant.almacen.entity.SolSalidaDet;
import pe.restaurant.almacen.repository.AlmacenRepository;
import pe.restaurant.almacen.repository.SolSalidaDetRepository;
import pe.restaurant.almacen.repository.SolSalidaRepository;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.service.NumeradorDocumentoService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SolicitudSalidaServiceImplTest {

    @Mock
    private SolSalidaRepository solSalidaRepository;
    @Mock
    private SolSalidaDetRepository solSalidaDetRepository;
    @Mock
    private AlmacenRepository almacenRepository;
    @Mock
    private NumeradorDocumentoService numeradorDocumentoService;
    @Mock
    private JdbcTemplate jdbcTemplate;

    @InjectMocks
    private SolicitudSalidaServiceImpl service;

    private SolSalidaRequest requestBase;
    private Almacen almacen;

    @BeforeEach
    void setUp() {
        almacen = new Almacen();
        almacen.setId(20L);
        almacen.setSucursalId(1L);

        SolSalidaLineaRequest linea = new SolSalidaLineaRequest();
        linea.setArticuloId(100L);
        linea.setCantidad(new BigDecimal("3"));

        requestBase = new SolSalidaRequest();
        requestBase.setAlmacenId(20L);
        requestBase.setFecha(LocalDate.of(2026, 4, 29));
        requestBase.setSolicitanteId(5L);
        requestBase.setObservacion("Obs");
        requestBase.setLineas(List.of(linea));

        lenient().when(jdbcTemplate.queryForObject(
                eq("SELECT COUNT(*)::int FROM core.articulo WHERE id = ?"), eq(Integer.class), eq(100L)))
                .thenReturn(1);
    }

    @Nested
    @DisplayName("crear")
    class Crear {

        @Test
        void persisteCabeceraDetalleYDevuelveCompleto() {
            when(almacenRepository.existsById(20L)).thenReturn(true);
            when(almacenRepository.findById(20L)).thenReturn(Optional.of(almacen));
            when(numeradorDocumentoService.siguienteNroDocumento("almacen.sol_salida", 1L, 2026)).thenReturn("SS-00001");
            when(solSalidaRepository.save(any(SolSalida.class))).thenAnswer(inv -> {
                SolSalida s = inv.getArgument(0);
                s.setId(77L);
                return s;
            });
            when(solSalidaDetRepository.findBySolSalidaIdOrderById(77L)).thenAnswer(inv -> {
                SolSalidaDet d = new SolSalidaDet();
                d.setId(1L);
                d.setSolSalidaId(77L);
                d.setArticuloId(100L);
                d.setCantidad(new BigDecimal("3"));
                return List.of(d);
            });

            var response = service.crear(requestBase);

            assertThat(response.getId()).isEqualTo(77L);
            assertThat(response.getNumero()).isEqualTo("SS-00001");
            assertThat(response.getLineas()).hasSize(1);
            assertThat(response.getLineas().get(0).getArticuloId()).isEqualTo(100L);
            verify(solSalidaDetRepository).save(any(SolSalidaDet.class));
        }

        @Test
        void lanzaSiAlmacenNoExiste() {
            when(almacenRepository.existsById(20L)).thenReturn(false);

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(ResourceNotFoundException.class)
                    .hasMessageContaining("Almacen");
        }

        @Test
        void lanzaSiCantidadNoPositiva() {
            when(almacenRepository.existsById(20L)).thenReturn(true);
            SolSalidaLineaRequest mal = new SolSalidaLineaRequest();
            mal.setArticuloId(100L);
            mal.setCantidad(BigDecimal.ZERO);
            requestBase.setLineas(List.of(mal));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", "ALM-SS-001")
                    .hasFieldOrPropertyWithValue("status", HttpStatus.UNPROCESSABLE_ENTITY);
        }

        @Test
        void lanzaSiArticuloNoExisteEnCore() {
            when(almacenRepository.existsById(20L)).thenReturn(true);
            when(jdbcTemplate.queryForObject(
                    eq("SELECT COUNT(*)::int FROM core.articulo WHERE id = ?"), eq(Integer.class), eq(100L)))
                    .thenReturn(0);

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(ResourceNotFoundException.class)
                    .hasMessageContaining("Articulo");
        }
    }

    @Nested
    @DisplayName("actualizar")
    class Actualizar {

        @Test
        void soloPermiteEnBorrador() {
            SolSalida s = new SolSalida();
            s.setId(1L);
            s.setFlagEstado("3");
            when(solSalidaRepository.findById(1L)).thenReturn(Optional.of(s));

            assertThatThrownBy(() -> service.actualizar(1L, requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", "ALM-SS-002");
        }
    }

    @Nested
    @DisplayName("eliminar")
    class Eliminar {

        @Test
        void soloPermiteEnBorrador() {
            SolSalida s = new SolSalida();
            s.setId(1L);
            s.setFlagEstado("2");
            when(solSalidaRepository.findById(1L)).thenReturn(Optional.of(s));

            assertThatThrownBy(() -> service.eliminar(1L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", "ALM-SS-003");
        }
    }

    @Nested
    @DisplayName("cambiarEstado")
    class CambiarEstado {

        @Test
        void rechazaEstadoVacio() {
            assertThatThrownBy(() -> service.cambiarEstado(1L, "  "))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", "ALM-SS-004");
        }

        @Test
        void cambiaFlagEstado() {
            SolSalida s = new SolSalida();
            s.setId(1L);
            s.setFlagEstado("1");
            when(solSalidaRepository.findById(1L)).thenReturn(Optional.of(s));
            when(solSalidaRepository.save(any(SolSalida.class))).thenAnswer(i -> i.getArgument(0));
            when(solSalidaDetRepository.findBySolSalidaIdOrderById(1L)).thenReturn(List.of());

            var out = service.cambiarEstado(1L, "2");

            assertThat(out.getFlagEstado()).isEqualTo("2");
        }
    }

    @Test
    void buscarDelegaEnRepositorioSinLineasEnListado() {
        SolSalida s = new SolSalida();
        s.setId(1L);
        s.setAlmacenId(20L);
        s.setNumero("N1");
        s.setFecha(LocalDate.now());
        s.setFlagEstado("1");
        Pageable pg = PageRequest.of(0, 10);
        when(solSalidaRepository.findAll(any(Specification.class), eq(pg)))
                .thenReturn(new PageImpl<>(List.of(s)));

        var page = service.buscar(20L, null, pg);

        assertThat(page.getContent()).hasSize(1);
        assertThat(page.getContent().get(0).getLineas()).isEmpty();
    }

    @Test
    void obtenerNoEncontrado() {
        when(solSalidaRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtener(999L)).isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void obtener_ok() {
        SolSalida s = new SolSalida();
        s.setId(2L);
        s.setFlagEstado("1");
        SolSalidaDet d = new SolSalidaDet();
        d.setArticuloId(100L);
        when(solSalidaRepository.findById(2L)).thenReturn(Optional.of(s));
        when(solSalidaDetRepository.findBySolSalidaIdOrderById(2L)).thenReturn(List.of(d));

        assertThat(service.obtener(2L).getLineas()).hasSize(1);
    }

    @Test
    void actualizar_ok() {
        SolSalida s = new SolSalida();
        s.setId(3L);
        s.setFlagEstado("1");
        when(solSalidaRepository.findById(3L)).thenReturn(Optional.of(s));
        when(almacenRepository.existsById(20L)).thenReturn(true);
        when(solSalidaRepository.save(any(SolSalida.class))).thenAnswer(i -> i.getArgument(0));
        when(solSalidaDetRepository.findBySolSalidaIdOrderById(3L)).thenReturn(List.of());

        var out = service.actualizar(3L, requestBase);

        assertThat(out.getId()).isEqualTo(3L);
        verify(solSalidaDetRepository).deleteBySolSalidaId(3L);
    }

    @Test
    void eliminar_ok() {
        SolSalida s = new SolSalida();
        s.setId(4L);
        s.setFlagEstado("1");
        when(solSalidaRepository.findById(4L)).thenReturn(Optional.of(s));

        service.eliminar(4L);

        verify(solSalidaDetRepository).deleteBySolSalidaId(4L);
        verify(solSalidaRepository).delete(s);
    }
}
