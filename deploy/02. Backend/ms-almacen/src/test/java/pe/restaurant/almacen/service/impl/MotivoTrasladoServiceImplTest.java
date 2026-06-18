package pe.restaurant.almacen.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.entity.MotivoTraslado;
import pe.restaurant.almacen.repository.MotivoTrasladoRepository;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MotivoTrasladoServiceImplTest {

    @Mock
    private MotivoTrasladoRepository repository;

    @InjectMocks
    private MotivoTrasladoServiceImpl service;

    @Test
    void findAll_delegatesToRepository() {
        Pageable pageable = PageRequest.of(0, 20);
        PageImpl<MotivoTraslado> page = new PageImpl<>(List.of(), pageable, 0);
        when(repository.findAll(pageable)).thenReturn(page);
        assertThat(service.findAll(pageable)).isSameAs(page);
        verify(repository).findAll(pageable);
    }

    @Test
    void findById_returnsWhenExists() {
        MotivoTraslado m = new MotivoTraslado();
        m.setId(3L);
        when(repository.findById(3L)).thenReturn(Optional.of(m));
        assertThat(service.findById(3L)).isSameAs(m);
    }

    @Test
    void findById_throwsWhenMissing() {
        when(repository.findById(9L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.findById(9L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("MotivoTraslado");
    }

    @Test
    void create_throwsWhenCodigoDuplicado() {
        MotivoTraslado in = new MotivoTraslado();
        in.setCodigo("MT01");
        in.setNombre("Transferencia");
        when(repository.existsByCodigoIgnoreCase("MT01")).thenReturn(true);
        assertThatThrownBy(() -> service.create(in))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe un motivo de traslado");
        verify(repository, never()).save(any());
    }

    @Test
    void create_persisteCuandoCodigoUnico() {
        MotivoTraslado in = new MotivoTraslado();
        in.setCodigo("MT02");
        in.setNombre("Otro");
        when(repository.existsByCodigoIgnoreCase("MT02")).thenReturn(false);
        when(repository.save(any(MotivoTraslado.class))).thenAnswer(i -> {
            MotivoTraslado e = i.getArgument(0);
            e.setId(10L);
            return e;
        });
        MotivoTraslado out = service.create(in);
        assertThat(out.getId()).isEqualTo(10L);
        verify(repository).save(in);
    }

    @Test
    void update_throwsWhenCodigoDuplicadoEnOtroRegistro() {
        MotivoTraslado existing = new MotivoTraslado();
        existing.setId(1L);
        existing.setCodigo("OLD");
        existing.setNombre("Viejo");
        MotivoTraslado patch = new MotivoTraslado();
        patch.setCodigo("DUP");
        patch.setNombre("Nuevo");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.existsByCodigoIgnoreCaseAndIdNot("DUP", 1L)).thenReturn(true);
        assertThatThrownBy(() -> service.update(1L, patch))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe un motivo de traslado");
        verify(repository, never()).save(any());
    }

    @Test
    void update_aplicaCodigoYNombre() {
        MotivoTraslado existing = new MotivoTraslado();
        existing.setId(2L);
        existing.setCodigo("A");
        existing.setNombre("Uno");
        MotivoTraslado patch = new MotivoTraslado();
        patch.setCodigo("B");
        patch.setNombre("Dos");
        when(repository.findById(2L)).thenReturn(Optional.of(existing));
        when(repository.existsByCodigoIgnoreCaseAndIdNot("B", 2L)).thenReturn(false);
        when(repository.save(existing)).thenReturn(existing);
        MotivoTraslado out = service.update(2L, patch);
        assertThat(out.getCodigo()).isEqualTo("B");
        assertThat(out.getNombre()).isEqualTo("Dos");
        verify(repository).save(existing);
    }

    @Test
    void activate_setsFlagEstadoActivo() {
        MotivoTraslado existing = new MotivoTraslado();
        existing.setId(5L);
        existing.setFlagEstado("0");
        when(repository.findById(5L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);
        MotivoTraslado out = service.activate(5L);
        assertThat(out.getFlagEstado()).isEqualTo("1");
        verify(repository).save(existing);
    }

    @Test
    void deactivate_setsFlagEstadoInactivo() {
        MotivoTraslado existing = new MotivoTraslado();
        existing.setId(6L);
        existing.setFlagEstado("1");
        when(repository.findById(6L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);
        MotivoTraslado out = service.deactivate(6L);
        assertThat(out.getFlagEstado()).isEqualTo("0");
        verify(repository).save(existing);
    }

    @Test
    void delete_eliminaCuandoExiste() {
        MotivoTraslado existing = new MotivoTraslado();
        existing.setId(7L);
        when(repository.findById(7L)).thenReturn(Optional.of(existing));
        service.delete(7L);
        verify(repository).delete(existing);
    }
}
