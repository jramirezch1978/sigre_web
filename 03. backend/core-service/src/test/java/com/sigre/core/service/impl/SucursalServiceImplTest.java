package com.sigre.core.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.core.entity.Sucursal;
import com.sigre.core.repository.DepartamentoRepository;
import com.sigre.core.repository.DistritoRepository;
import com.sigre.core.repository.PaisRepository;
import com.sigre.core.repository.ProvinciaRepository;
import com.sigre.core.repository.SucursalRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class SucursalServiceImplTest {

    @Mock private SucursalRepository repository;
    @Mock private PaisRepository paisRepository;
    @Mock private DepartamentoRepository departamentoRepository;
    @Mock private ProvinciaRepository provinciaRepository;
    @Mock private DistritoRepository distritoRepository;

    @InjectMocks private SucursalServiceImpl service;

    private Sucursal sucursal;
    private final Pageable pageable = PageRequest.of(0, 20);

    @BeforeEach
    void setUp() {
        sucursal = new Sucursal();
        sucursal.setId(1L);
        sucursal.setCodigo("LM");
        sucursal.setNombre("Sucursal Central");
        sucursal.setCiudad("Lima");
        sucursal.setFlagEstado("1");
    }

    @Nested
    class FindAll {
        @Test
        void returnsPage() {
            when(repository.findAll(pageable)).thenReturn(new PageImpl<>(List.of(sucursal)));
            Page<Sucursal> result = service.findAll(pageable);
            assertThat(result.getContent()).hasSize(1);
            verify(repository).findAll(pageable);
        }
    }

    @Nested
    class FindById {
        @Test
        void returnsWhenExists() {
            when(repository.findById(1L)).thenReturn(Optional.of(sucursal));
            assertThat(service.findById(1L).getNombre()).isEqualTo("Sucursal Central");
        }

        @Test
        void throwsWhenNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Create {
        @Test
        void createsSuccessfully() {
            when(repository.save(sucursal)).thenReturn(sucursal);
            assertThat(service.create(sucursal).getNombre()).isEqualTo("Sucursal Central");
        }

        @Test
        void throwsWhenPaisNotFound() {
            sucursal.setPaisId(99L);
            when(paisRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.create(sucursal))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenDepartamentoNotFound() {
            sucursal.setDepartamentoId(99L);
            when(departamentoRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.create(sucursal))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenProvinciaNotFound() {
            sucursal.setProvinciaId(99L);
            when(provinciaRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.create(sucursal))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenDistritoNotFound() {
            sucursal.setDistritoId(99L);
            when(distritoRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.create(sucursal))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void successWithAllGeografia() {
            sucursal.setPaisId(1L);
            sucursal.setDepartamentoId(1L);
            sucursal.setProvinciaId(1L);
            sucursal.setDistritoId(1L);
            when(paisRepository.existsById(1L)).thenReturn(true);
            when(departamentoRepository.existsById(1L)).thenReturn(true);
            when(provinciaRepository.existsById(1L)).thenReturn(true);
            when(distritoRepository.existsById(1L)).thenReturn(true);
            when(repository.save(sucursal)).thenReturn(sucursal);

            assertThat(service.create(sucursal)).isNotNull();
        }

        @Test
        void successWithNullGeografia() {
            sucursal.setPaisId(null);
            sucursal.setDepartamentoId(null);
            sucursal.setProvinciaId(null);
            sucursal.setDistritoId(null);
            when(repository.save(sucursal)).thenReturn(sucursal);

            assertThat(service.create(sucursal)).isNotNull();
        }
    }

    @Nested
    class Update {
        @Test
        void updatesFields() {
            when(repository.findById(1L)).thenReturn(Optional.of(sucursal));
            when(repository.save(any())).thenReturn(sucursal);

            Sucursal updated = new Sucursal();
            updated.setCodigo("PI");
            updated.setNombre("Nuevo");
            updated.setDireccion("Av. Arequipa");
            updated.setCiudad("Arequipa");
            updated.setUbigeo("040101");
            updated.setFlagEstado("1");

            service.update(1L, updated);
            verify(repository).save(any());
        }

        @Test
        void throwsWhenNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, sucursal)).isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenPaisNotFound() {
            when(repository.findById(1L)).thenReturn(Optional.of(sucursal));
            Sucursal upd = new Sucursal();
            upd.setPaisId(99L);
            when(paisRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.update(1L, upd))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenDepartamentoNotFound() {
            when(repository.findById(1L)).thenReturn(Optional.of(sucursal));
            Sucursal upd = new Sucursal();
            upd.setDepartamentoId(99L);
            when(departamentoRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.update(1L, upd))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenProvinciaNotFound() {
            when(repository.findById(1L)).thenReturn(Optional.of(sucursal));
            Sucursal upd = new Sucursal();
            upd.setProvinciaId(99L);
            when(provinciaRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.update(1L, upd))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenDistritoNotFound() {
            when(repository.findById(1L)).thenReturn(Optional.of(sucursal));
            Sucursal upd = new Sucursal();
            upd.setDistritoId(99L);
            when(distritoRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.update(1L, upd))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Delete {
        @Test
        void deletesSuccessfully() {
            when(repository.findById(1L)).thenReturn(Optional.of(sucursal));
            service.delete(1L);
            verify(repository).deleteById(1L);
        }

        @Test
        void throwsWhenNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.delete(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Activate {
        @Test
        void setsEstadoTo1() {
            sucursal.setFlagEstado("0");
            when(repository.findById(1L)).thenReturn(Optional.of(sucursal));
            when(repository.save(sucursal)).thenReturn(sucursal);

            assertThat(service.activate(1L).getFlagEstado()).isEqualTo("1");
        }

        @Test
        void throwsWhenNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.activate(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Deactivate {
        @Test
        void setsEstadoTo0() {
            when(repository.findById(1L)).thenReturn(Optional.of(sucursal));
            when(repository.save(sucursal)).thenReturn(sucursal);

            assertThat(service.deactivate(1L).getFlagEstado()).isEqualTo("0");
        }

        @Test
        void throwsWhenNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivate(99L)).isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
