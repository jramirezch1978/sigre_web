package pe.restaurant.almacen.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import pe.restaurant.almacen.entity.Almacen;
import pe.restaurant.almacen.repository.AlmacenRepository;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Bloque A: validación FK sucursal_id y almacen_tipo_id en AlmacenServiceImpl.
 */
@ExtendWith(MockitoExtension.class)
class AlmacenServiceImplTest {

    @Mock
    private AlmacenRepository repository;
    @Mock
    private JdbcTemplate jdbcTemplate;
    @InjectMocks
    private AlmacenServiceImpl service;

    private Almacen almacen;

    @BeforeEach
    void setUp() {
        almacen = new Almacen();
        almacen.setSucursalId(10L);
        almacen.setAlmacenTipoId(3L);
        almacen.setCodigo("AL1");
        almacen.setNombre("Almacén 1");
        almacen.setFlagEstado("1");
    }

    @Nested
    @DisplayName("create() — validación de FKs")
    class CreateFk {
        @Test
        void rechazaSucursalInexistente() {
            when(jdbcTemplate.queryForObject(
                    eq("SELECT COUNT(*) FROM auth.sucursal WHERE id = ?"), eq(Integer.class), eq(10L)))
                    .thenReturn(0);
            assertThatThrownBy(() -> service.create(almacen))
                    .isInstanceOf(ResourceNotFoundException.class);
            verify(repository, never()).save(any());
        }

        @Test
        void rechazaAlmacenTipoInexistente() {
            when(jdbcTemplate.queryForObject(
                    eq("SELECT COUNT(*) FROM auth.sucursal WHERE id = ?"), eq(Integer.class), eq(10L)))
                    .thenReturn(1);
            when(jdbcTemplate.queryForObject(
                    eq("SELECT COUNT(*) FROM almacen.almacen_tipo WHERE id = ?"), eq(Integer.class), eq(3L)))
                    .thenReturn(0);
            assertThatThrownBy(() -> service.create(almacen))
                    .isInstanceOf(ResourceNotFoundException.class);
            verify(repository, never()).save(any());
        }

        @Test
        void create_lanzaSiCodigoDuplicado() {
            when(jdbcTemplate.queryForObject(
                    eq("SELECT COUNT(*) FROM auth.sucursal WHERE id = ?"), eq(Integer.class), eq(10L)))
                    .thenReturn(1);
            when(jdbcTemplate.queryForObject(
                    eq("SELECT COUNT(*) FROM almacen.almacen_tipo WHERE id = ?"), eq(Integer.class), eq(3L)))
                    .thenReturn(1);
            when(repository.existsBySucursalIdAndCodigoIgnoreCase(10L, "AL1")).thenReturn(true);

            assertThatThrownBy(() -> service.create(almacen))
                    .isInstanceOf(BusinessException.class);
            verify(repository, never()).save(any());
        }

        @Test
        void creaSiFksExistenYCodigoUnico() {
            when(jdbcTemplate.queryForObject(
                    eq("SELECT COUNT(*) FROM auth.sucursal WHERE id = ?"), eq(Integer.class), eq(10L)))
                    .thenReturn(1);
            when(jdbcTemplate.queryForObject(
                    eq("SELECT COUNT(*) FROM almacen.almacen_tipo WHERE id = ?"), eq(Integer.class), eq(3L)))
                    .thenReturn(1);
            when(repository.existsBySucursalIdAndCodigoIgnoreCase(10L, "AL1")).thenReturn(false);
            when(repository.save(any(Almacen.class))).thenAnswer(i -> {
                Almacen a = i.getArgument(0);
                a.setId(1L);
                return a;
            });
            Almacen saved = service.create(almacen);
            assertThat(saved.getId()).isEqualTo(1L);
            verify(repository).save(any(Almacen.class));
        }

        @Test
        void almacenTipoNulo_noConsultaAlmacenTipoPeroSigueValidandoSucursal() {
            almacen.setAlmacenTipoId(null);
            when(jdbcTemplate.queryForObject(
                    eq("SELECT COUNT(*) FROM auth.sucursal WHERE id = ?"), eq(Integer.class), eq(10L)))
                    .thenReturn(1);
            when(repository.existsBySucursalIdAndCodigoIgnoreCase(10L, "AL1")).thenReturn(false);
            when(repository.save(any(Almacen.class))).thenAnswer(i -> {
                Almacen a = i.getArgument(0);
                a.setId(2L);
                return a;
            });
            Almacen saved = service.create(almacen);
            assertThat(saved.getId()).isEqualTo(2L);
            verify(jdbcTemplate, times(1))
                    .queryForObject(eq("SELECT COUNT(*) FROM auth.sucursal WHERE id = ?"), eq(Integer.class), eq(10L));
        }
    }

    @Nested
    @DisplayName("findAll / findById")
    class Consultas {
        @Test
        void findAll_devuelvePagina() {
            Pageable pageable = Pageable.ofSize(10);
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(List.of(almacen)));

            Page<Almacen> page = service.findAll(pageable);

            assertThat(page.getContent()).hasSize(1);
            verify(repository).findAll(pageable);
        }

        @Test
        void findById_ok() {
            almacen.setId(5L);
            when(repository.findById(5L)).thenReturn(Optional.of(almacen));

            assertThat(service.findById(5L).getCodigo()).isEqualTo("AL1");
        }

        @Test
        void findById_notFound() {
            when(repository.findById(404L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.findById(404L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    @DisplayName("update / delete / activate")
    class Mutaciones {
        private void stubFksValidas() {
            when(jdbcTemplate.queryForObject(
                    eq("SELECT COUNT(*) FROM auth.sucursal WHERE id = ?"), eq(Integer.class), eq(10L)))
                    .thenReturn(1);
            when(jdbcTemplate.queryForObject(
                    eq("SELECT COUNT(*) FROM almacen.almacen_tipo WHERE id = ?"), eq(Integer.class), eq(3L)))
                    .thenReturn(1);
        }

        @Test
        void update_ok() {
            almacen.setId(1L);
            Almacen cambios = new Almacen();
            cambios.setSucursalId(10L);
            cambios.setAlmacenTipoId(3L);
            cambios.setCodigo("AL1");
            cambios.setNombre("Almacén renombrado");
            when(repository.findById(1L)).thenReturn(Optional.of(almacen));
            stubFksValidas();
            when(repository.existsBySucursalIdAndCodigoIgnoreCaseAndIdNot(10L, "AL1", 1L)).thenReturn(false);
            when(repository.save(any(Almacen.class))).thenAnswer(i -> i.getArgument(0));

            Almacen updated = service.update(1L, cambios);

            assertThat(updated.getNombre()).isEqualTo("Almacén renombrado");
            verify(repository).save(almacen);
        }

        @Test
        void update_lanzaSiCodigoDuplicado() {
            almacen.setId(1L);
            Almacen cambios = new Almacen();
            cambios.setSucursalId(10L);
            cambios.setAlmacenTipoId(3L);
            cambios.setCodigo("DUP");
            when(repository.findById(1L)).thenReturn(Optional.of(almacen));
            stubFksValidas();
            when(repository.existsBySucursalIdAndCodigoIgnoreCaseAndIdNot(10L, "DUP", 1L)).thenReturn(true);

            assertThatThrownBy(() -> service.update(1L, cambios))
                    .isInstanceOf(BusinessException.class);
            verify(repository, never()).save(any());
        }

        @Test
        void delete_ok() {
            almacen.setId(7L);
            when(repository.findById(7L)).thenReturn(Optional.of(almacen));

            service.delete(7L);

            verify(repository).delete(almacen);
        }

        @Test
        void activate_yDeactivate() {
            almacen.setId(8L);
            when(repository.findById(8L)).thenReturn(Optional.of(almacen));
            when(repository.save(any(Almacen.class))).thenAnswer(i -> i.getArgument(0));

            assertThat(service.activate(8L).getFlagEstado()).isEqualTo("1");
            assertThat(service.deactivate(8L).getFlagEstado()).isEqualTo("0");
        }
    }
}
