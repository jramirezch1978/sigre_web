package pe.restaurant.ventas.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.response.ZonaResponse;
import pe.restaurant.ventas.entity.Zona;
import pe.restaurant.ventas.mapper.ZonaMapper;
import pe.restaurant.ventas.repository.ZonaRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("ZonaServiceImpl — Pruebas Unitarias")
class ZonaServiceImplTest {

    @Mock
    private ZonaRepository repository;
    @Mock
    private ZonaMapper mapper;
    @InjectMocks
    private ZonaServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ==== findById ====

    @Test
    @DisplayName("findById() con ID existente -> retorna response mapeado")
    void findById_cuandoExiste_retornaResponse() {
        Zona z = zona(1L, "Salón", "1");
        when(repository.findByIdAndFlagEstado(1L, "1")).thenReturn(Optional.of(z));
        when(mapper.toResponse(z)).thenReturn(response(1L, "Salón"));

        assertThat(service.findById(1L).getNombre()).isEqualTo("Salón");
        verify(repository).findByIdAndFlagEstado(1L, "1");
    }

    @Test
    @DisplayName("findById() con ID inexistente -> lanza ResourceNotFoundException")
    void findById_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findByIdAndFlagEstado(99L, "1")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== findAll ====

    @Test
    @DisplayName("findAll() sin filtros -> retorna pagina")
    void findAll_sinFiltros_retornaPagina() {
        when(repository.findAll(Pageable.unpaged())).thenReturn(new PageImpl<>(List.of()));

        assertThat(service.findAll(Pageable.unpaged()).getContent()).isEmpty();
    }

    @Test
    @DisplayName("findAllWithFilters() con filtros -> usa findByFilters")
    void findAllWithFilters_conFiltros_usaFindByFilters() {
        when(repository.findByFilters(eq(1L), eq("Sal"), eq("1"), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of()));

        assertThat(service.findAllWithFilters(1L, "Sal", "1", Pageable.unpaged()).getContent()).isEmpty();
        verify(repository).findByFilters(1L, "Sal", "1", Pageable.unpaged());
    }

    @Test
    @DisplayName("findAllWithFilters() sin filtros -> usa findAll")
    void findAllWithFilters_sinFiltros_usaFindAll() {
        when(repository.findAll(Pageable.unpaged())).thenReturn(new PageImpl<>(List.of()));

        service.findAllWithFilters(null, null, null, Pageable.unpaged());
        verify(repository).findAll(Pageable.unpaged());
    }

    // ==== create ====

    @Test
    @DisplayName("create() con datos válidos -> persiste con flagEstado ACTIVO")
    void create_conDatosValidos_retornaCreado() {
        Zona input = zona(null, "Terraza", null);
        when(repository.existsBySucursalIdAndNombreAndFlagEstado(1L, "Terraza", "1")).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> {
            Zona e = inv.getArgument(0);
            e.setId(10L);
            return e;
        });

        Zona result = service.create(input);

        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getCreatedBy()).isEqualTo(1L);
        verify(repository).save(any());
    }

    @Test
    @DisplayName("create() con nombre duplicado -> lanza BusinessException")
    void create_cuandoNombreDuplicado_lanzaBusinessException() {
        Zona input = zona(null, "Dup", null);
        when(repository.existsBySucursalIdAndNombreAndFlagEstado(1L, "Dup", "1")).thenReturn(true);

        assertThatThrownBy(() -> service.create(input))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe una zona con el nombre");
    }

    // ==== update ====

    @Test
    @DisplayName("update() con datos válidos -> actualiza y retorna")
    void update_conDatosValidos_retornaActualizado() {
        Zona existing = zona(5L, "Old", "1");
        Zona patch = zona(null, "New", null);
        when(repository.findById(5L)).thenReturn(Optional.of(existing));
        when(repository.existsBySucursalIdAndNombreAndFlagEstadoAndIdNot(1L, "New", "1", 5L)).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        assertThat(service.update(5L, patch).getNombre()).isEqualTo("New");
        verify(repository).save(any());
    }

    @Test
    @DisplayName("update() con ID inexistente -> lanza ResourceNotFoundException")
    void update_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(5L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.update(5L, zona(null, "X", null)))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("5");
    }

    // ==== activate / deactivate ====

    @Test
    @DisplayName("activate() con ID existente -> cambia flagEstado a 1")
    void activate_cuandoExiste_cambiaFlagEstado() {
        Zona z = zona(3L, "Z3", "0");
        when(repository.findById(3L)).thenReturn(Optional.of(z));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        assertThat(service.activate(3L).getFlagEstado()).isEqualTo("1");
        verify(repository).save(any());
    }

    @Test
    @DisplayName("activate() con ID inexistente -> lanza ResourceNotFoundException")
    void activate_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.activate(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    @Test
    @DisplayName("deactivate() con ID existente -> cambia flagEstado a 0")
    void deactivate_cuandoExiste_cambiaFlagEstado() {
        Zona z = zona(4L, "Z4", "1");
        when(repository.findById(4L)).thenReturn(Optional.of(z));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        assertThat(service.deactivate(4L).getFlagEstado()).isEqualTo("0");
        verify(repository).save(any());
    }

    @Test
    @DisplayName("deactivate() con ID inexistente -> lanza ResourceNotFoundException")
    void deactivate_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.deactivate(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== delete ====

    @Test
    @DisplayName("delete() con ID existente -> elimina via repository")
    void delete_cuandoExiste_elimina() {
        Zona z = zona(6L, "Z6", "1");
        when(repository.findById(6L)).thenReturn(Optional.of(z));

        service.delete(6L);
        verify(repository).delete(z);
    }

    @Test
    @DisplayName("delete() con ID inexistente -> lanza ResourceNotFoundException")
    void delete_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.delete(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== findBySucursalId / findAllActivas ====

    @Test
    @DisplayName("findBySucursalId() con sucursal existente -> retorna lista mapeada")
    void findBySucursalId_conSucursalExistente_retornaLista() {
        when(repository.findBySucursalIdAndActivo(1L)).thenReturn(List.of(zona(1L, "Z1", "1")));
        when(mapper.toResponseList(any())).thenReturn(List.of(response(1L, "Z1")));

        assertThat(service.findBySucursalId(1L)).hasSize(1);
        verify(repository).findBySucursalIdAndActivo(1L);
    }

    @Test
    @DisplayName("findAllActivas() -> retorna lista mapeada")
    void findAllActivas_retornaLista() {
        when(repository.findAllActivas()).thenReturn(List.of(zona(1L, "Z1", "1")));
        when(mapper.toResponseList(any())).thenReturn(List.of(response(1L, "Z1")));

        assertThat(service.findAllActivas()).hasSize(1);
        verify(repository).findAllActivas();
    }

    // ==== helpers ====

    private static Zona zona(Long id, String nombre, String flag) {
        Zona z = new Zona();
        z.setId(id);
        z.setNombre(nombre);
        z.setCapacidad(20);
        Zona.Sucursal s = new Zona.Sucursal();
        s.setId(1L);
        z.setSucursal(s);
        if (flag != null) {
            z.setFlagEstado(flag);
        }
        return z;
    }

    private static ZonaResponse response(Long id, String nombre) {
        ZonaResponse r = new ZonaResponse();
        r.setId(id);
        r.setNombre(nombre);
        return r;
    }
}
