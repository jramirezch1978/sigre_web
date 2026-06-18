package pe.restaurant.core.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.dto.*;
import pe.restaurant.core.entity.Articulo;
import pe.restaurant.core.entity.ArticuloAlmacenConfig;
import pe.restaurant.core.entity.ArticuloProveedor;
import pe.restaurant.core.mapper.ArticuloAlmacenConfigMapper;
import pe.restaurant.core.mapper.ArticuloImpuestoMapper;
import pe.restaurant.core.mapper.ArticuloMapper;
import pe.restaurant.core.mapper.ArticuloProveedorMapper;
import pe.restaurant.core.repository.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ArticuloServiceImplTest {

    @Mock private ArticuloRepository repository;
    @Mock private ArticuloProveedorRepository proveedorRepository;
    @Mock private ArticuloImpuestoRepository impuestoRepository;
    @Mock private TiposImpuestoRepository tiposImpuestoRepository;
    @Mock private ArticuloAlmacenConfigRepository almacenConfigRepository;
    @Mock private UnidadMedidaRepository unidadMedidaRepository;
    @Mock private ArticuloCategRepository articuloCategRepository;
    @Mock private ArticuloSubCategRepository articuloSubCategRepository;
    @Mock private RelacionComercialRepository relacionComercialRepository;
    @Mock private JdbcTemplate jdbcTemplate;
    @Mock private ArticuloMapper mapper;
    @Mock private ArticuloProveedorMapper proveedorMapper;
    @Mock private ArticuloImpuestoMapper impuestoMapper;
    @Mock private ArticuloAlmacenConfigMapper almacenConfigMapper;

    @InjectMocks private ArticuloServiceImpl service;

    private Articulo entity;
    private final Pageable pageable = PageRequest.of(0, 20);

    @BeforeEach
    void setUp() {
        entity = new Articulo();
        entity.setId(1L);
        entity.setCodigo("A01");
        entity.setNombre("Articulo 1");
        entity.setUnidadMedidaId(1L);
        entity.setFlagEstado("1");
    }

    @Nested
    class ListMethod {
        @Test
        void withNullFilters() {
            when(repository.findByCodigoContainingIgnoreCaseAndNombreContainingIgnoreCase("", "", pageable))
                    .thenReturn(new PageImpl<>(List.of(entity)));

            var result = service.list(null, null, null, pageable);
            assertThat(result.getContent()).hasSize(1);
        }

        @Test
        void withCodeFilter() {
            when(repository.findByCodigoContainingIgnoreCaseAndNombreContainingIgnoreCase("A01", "", pageable))
                    .thenReturn(new PageImpl<>(List.of(entity)));

            var result = service.list("A01", null, null, pageable);
            assertThat(result.getContent()).hasSize(1);
        }

        @Test
        void withNameFilter() {
            when(repository.findByCodigoContainingIgnoreCaseAndNombreContainingIgnoreCase("", "Articulo", pageable))
                    .thenReturn(new PageImpl<>(List.of(entity)));

            var result = service.list(null, "Articulo", null, pageable);
            assertThat(result.getContent()).hasSize(1);
        }

        @Test
        void withBothFilters() {
            when(repository.findByCodigoContainingIgnoreCaseAndNombreContainingIgnoreCase("A01", "Art", pageable))
                    .thenReturn(new PageImpl<>(List.of(entity)));

            var result = service.list("A01", "Art", null, pageable);
            assertThat(result.getContent()).hasSize(1);
        }
    }

    @Nested
    class GetById {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            ArticuloResponse resp = new ArticuloResponse();
            resp.setId(1L);
            resp.setCodigo("A01");
            resp.setNombre("Articulo 1");
            when(mapper.toResponse(entity)).thenReturn(resp);
            when(impuestoRepository.findByArticuloIdOrderByOrdenAsc(1L)).thenReturn(List.of());

            var result = service.getById(1L);
            assertThat(result.getCodigo()).isEqualTo("A01");
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.getById(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Create {
        @Test
        void success() {
            ArticuloRequest request = new ArticuloRequest("A02", "Nuevo", "BIEN", null, 1L, null, null, null, null, null, null, "1");
            when(repository.existsByCodigoIgnoreCase("A02")).thenReturn(false);
            when(unidadMedidaRepository.existsById(1L)).thenReturn(true);
            when(mapper.toEntity(request)).thenReturn(entity);
            when(repository.save(entity)).thenReturn(entity);
            ArticuloResponse resp = new ArticuloResponse();
            resp.setId(1L);
            when(mapper.toResponse(entity)).thenReturn(resp);
            when(tiposImpuestoRepository.findByTipoImpuesto("IGV18")).thenReturn(Optional.empty());

            var result = service.create(request);
            assertThat(result.getId()).isEqualTo(1L);
        }

        @Test
        void throwsConflictWhenDuplicateCodigo() {
            ArticuloRequest request = new ArticuloRequest("A01", "Dup", "BIEN", null, 1L, null, null, null, null, null, null, "1");
            when(repository.existsByCodigoIgnoreCase("A01")).thenReturn(true);

            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(BusinessException.class);
        }

        @Test
        void throwsWhenUnidadMedidaNotFound() {
            ArticuloRequest request = new ArticuloRequest("A03", "Test", "BIEN", null, 99L, null, null, null, null, null, null, "1");
            when(repository.existsByCodigoIgnoreCase("A03")).thenReturn(false);
            when(unidadMedidaRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenCategoriaNotFound() {
            ArticuloRequest request = new ArticuloRequest("A03", "Test", "BIEN", null, 1L, 99L, null, null, null, null, null, "1");
            when(repository.existsByCodigoIgnoreCase("A03")).thenReturn(false);
            when(unidadMedidaRepository.existsById(1L)).thenReturn(true);
            when(articuloCategRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenSubCategoriaNotFound() {
            ArticuloRequest request = new ArticuloRequest("A03", "Test", "BIEN", null, 1L, 1L, 99L, null, null, null, null, "1");
            when(repository.existsByCodigoIgnoreCase("A03")).thenReturn(false);
            when(unidadMedidaRepository.existsById(1L)).thenReturn(true);
            when(articuloCategRepository.existsById(1L)).thenReturn(true);
            when(articuloSubCategRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenMarcaNotFound() {
            ArticuloRequest request = new ArticuloRequest("A03", "Test", "BIEN", null, 1L, null, null, null, null, 99L, null, "1");
            when(repository.existsByCodigoIgnoreCase("A03")).thenReturn(false);
            when(unidadMedidaRepository.existsById(1L)).thenReturn(true);
            when(jdbcTemplate.queryForObject(contains("core.marca"), eq(Integer.class), eq(99L))).thenReturn(0);

            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenMarcaCountNull() {
            ArticuloRequest request = new ArticuloRequest("A03", "Test", "BIEN", null, 1L, null, null, null, null, 99L, null, "1");
            when(repository.existsByCodigoIgnoreCase("A03")).thenReturn(false);
            when(unidadMedidaRepository.existsById(1L)).thenReturn(true);
            when(jdbcTemplate.queryForObject(contains("core.marca"), eq(Integer.class), eq(99L))).thenReturn(null);

            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenColorNotFound() {
            ArticuloRequest request = new ArticuloRequest("A03", "Test", "BIEN", null, 1L, null, null, null, null, null, 99L, "1");
            when(repository.existsByCodigoIgnoreCase("A03")).thenReturn(false);
            when(unidadMedidaRepository.existsById(1L)).thenReturn(true);
            when(jdbcTemplate.queryForObject(contains("core.color"), eq(Integer.class), eq(99L))).thenReturn(0);

            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenColorCountNull() {
            ArticuloRequest request = new ArticuloRequest("A03", "Test", "BIEN", null, 1L, null, null, null, null, null, 99L, "1");
            when(repository.existsByCodigoIgnoreCase("A03")).thenReturn(false);
            when(unidadMedidaRepository.existsById(1L)).thenReturn(true);
            when(jdbcTemplate.queryForObject(contains("core.color"), eq(Integer.class), eq(99L))).thenReturn(null);

            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void successWithAllForeignKeys() {
            ArticuloRequest request = new ArticuloRequest("A03", "Full", "BIEN", null, 1L, 1L, 1L, null, null, 1L, 1L, "1");
            when(repository.existsByCodigoIgnoreCase("A03")).thenReturn(false);
            when(unidadMedidaRepository.existsById(1L)).thenReturn(true);
            when(articuloCategRepository.existsById(1L)).thenReturn(true);
            when(articuloSubCategRepository.existsById(1L)).thenReturn(true);
            when(jdbcTemplate.queryForObject(contains("core.marca"), eq(Integer.class), eq(1L))).thenReturn(1);
            when(jdbcTemplate.queryForObject(contains("core.color"), eq(Integer.class), eq(1L))).thenReturn(1);
            when(mapper.toEntity(request)).thenReturn(entity);
            when(repository.save(entity)).thenReturn(entity);
            when(mapper.toResponse(entity)).thenReturn(new ArticuloResponse());
            when(tiposImpuestoRepository.findByTipoImpuesto("IGV18")).thenReturn(Optional.empty());

            var result = service.create(request);
            assertThat(result).isNotNull();
        }
    }

    @Nested
    class Update {
        @Test
        void success() {
            ArticuloRequest request = new ArticuloRequest("A01", "Updated", "BIEN", null, 1L, null, null, null, null, null, null, "1");
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(repository.existsByCodigoIgnoreCaseAndIdNot("A01", 1L)).thenReturn(false);
            when(unidadMedidaRepository.existsById(1L)).thenReturn(true);
            when(repository.save(entity)).thenReturn(entity);
            when(mapper.toResponse(entity)).thenReturn(new ArticuloResponse());

            var result = service.update(1L, request);
            assertThat(result).isNotNull();
            verify(mapper).updateEntity(request, entity);
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, new ArticuloRequest()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsConflictWhenDuplicateCodigo() {
            ArticuloRequest request = new ArticuloRequest("A02", "Name", "BIEN", null, 1L, null, null, null, null, null, null, "1");
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(repository.existsByCodigoIgnoreCaseAndIdNot("A02", 1L)).thenReturn(true);

            assertThatThrownBy(() -> service.update(1L, request))
                    .isInstanceOf(BusinessException.class);
        }
    }

    @Nested
    class Delete {
        @Test
        void deletesSuccessfully() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            service.delete(1L);
            verify(repository).deleteById(1L);
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.delete(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Activate {
        @Test
        void setsEstadoTo1() {
            entity.setFlagEstado("0");
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(repository.save(entity)).thenReturn(entity);

            var result = service.activate(1L);
            assertThat(result.getFlagEstado()).isEqualTo("1");
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.activate(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Deactivate {
        @Test
        void setsEstadoTo0() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(repository.save(entity)).thenReturn(entity);

            var result = service.deactivate(1L);
            assertThat(result.getFlagEstado()).isEqualTo("0");
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivate(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class ListProveedores {
        @Test
        void returnsProveedores() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            ArticuloProveedor ap = new ArticuloProveedor();
            ap.setId(1L);
            when(proveedorRepository.findByArticuloIdAndFlagEstado(1L, "1")).thenReturn(List.of(ap));
            when(proveedorMapper.toResponse(ap)).thenReturn(new ArticuloProveedorResponse());

            assertThat(service.listProveedores(1L)).hasSize(1);
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.listProveedores(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class CreateProveedor {
        @Test
        void successNewEntity() {
            ArticuloProveedorRequest request = new ArticuloProveedorRequest();
            request.setProveedorId(5L);
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(relacionComercialRepository.existsById(5L)).thenReturn(true);
            when(proveedorRepository.findByArticuloIdAndProveedorId(1L, 5L)).thenReturn(Optional.empty());
            when(proveedorRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(proveedorMapper.toResponse(any())).thenReturn(new ArticuloProveedorResponse());

            var result = service.createProveedor(1L, request);
            assertThat(result).isNotNull();
        }

        @Test
        void successExistingEntity() {
            ArticuloProveedorRequest request = new ArticuloProveedorRequest();
            request.setProveedorId(5L);
            ArticuloProveedor existing = new ArticuloProveedor();
            existing.setId(10L);
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(relacionComercialRepository.existsById(5L)).thenReturn(true);
            when(proveedorRepository.findByArticuloIdAndProveedorId(1L, 5L)).thenReturn(Optional.of(existing));
            when(proveedorRepository.save(existing)).thenReturn(existing);
            when(proveedorMapper.toResponse(existing)).thenReturn(new ArticuloProveedorResponse());

            var result = service.createProveedor(1L, request);
            assertThat(result).isNotNull();
        }

        @Test
        void throwsWhenProveedorNotFound() {
            ArticuloProveedorRequest request = new ArticuloProveedorRequest();
            request.setProveedorId(99L);
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(relacionComercialRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.createProveedor(1L, request))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenArticuloNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.createProveedor(99L, new ArticuloProveedorRequest()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class ListAlmacenesConfig {
        @Test
        void returnsConfigs() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            ArticuloAlmacenConfig config = new ArticuloAlmacenConfig();
            when(almacenConfigRepository.findByArticuloId(1L)).thenReturn(List.of(config));
            when(almacenConfigMapper.toResponse(config)).thenReturn(new ArticuloAlmacenConfigResponse());

            assertThat(service.listAlmacenesConfig(1L)).hasSize(1);
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.listAlmacenesConfig(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class UpsertAlmacenConfig {
        @Test
        void successNewConfig() {
            ArticuloAlmacenConfigRequest request = new ArticuloAlmacenConfigRequest();
            request.setAlmacenId(5L);
            request.setStockMin(BigDecimal.ONE);
            request.setStockMax(BigDecimal.TEN);
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(jdbcTemplate.queryForObject(contains("almacen.almacen"), eq(Integer.class), eq(5L))).thenReturn(1);
            when(almacenConfigRepository.findByArticuloIdAndAlmacenId(1L, 5L)).thenReturn(Optional.empty());
            when(almacenConfigRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(almacenConfigMapper.toResponse(any())).thenReturn(new ArticuloAlmacenConfigResponse());

            var result = service.upsertAlmacenConfig(1L, request);
            assertThat(result).isNotNull();
        }

        @Test
        void successExistingConfig() {
            ArticuloAlmacenConfigRequest request = new ArticuloAlmacenConfigRequest();
            request.setAlmacenId(5L);
            request.setStockMin(BigDecimal.ONE);
            request.setStockMax(BigDecimal.TEN);
            ArticuloAlmacenConfig existing = new ArticuloAlmacenConfig();
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(jdbcTemplate.queryForObject(contains("almacen.almacen"), eq(Integer.class), eq(5L))).thenReturn(1);
            when(almacenConfigRepository.findByArticuloIdAndAlmacenId(1L, 5L)).thenReturn(Optional.of(existing));
            when(almacenConfigRepository.save(existing)).thenReturn(existing);
            when(almacenConfigMapper.toResponse(existing)).thenReturn(new ArticuloAlmacenConfigResponse());

            var result = service.upsertAlmacenConfig(1L, request);
            assertThat(result).isNotNull();
        }

        @Test
        void throwsWhenAlmacenNotFound() {
            ArticuloAlmacenConfigRequest request = new ArticuloAlmacenConfigRequest();
            request.setAlmacenId(99L);
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(jdbcTemplate.queryForObject(contains("almacen.almacen"), eq(Integer.class), eq(99L))).thenReturn(0);

            assertThatThrownBy(() -> service.upsertAlmacenConfig(1L, request))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenAlmacenCountNull() {
            ArticuloAlmacenConfigRequest request = new ArticuloAlmacenConfigRequest();
            request.setAlmacenId(99L);
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(jdbcTemplate.queryForObject(contains("almacen.almacen"), eq(Integer.class), eq(99L))).thenReturn(null);

            assertThatThrownBy(() -> service.upsertAlmacenConfig(1L, request))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenArticuloNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.upsertAlmacenConfig(99L, new ArticuloAlmacenConfigRequest()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
