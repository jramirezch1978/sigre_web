package pe.restaurant.core.service.impl;

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
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.entity.Departamento;
import pe.restaurant.core.entity.Distrito;
import pe.restaurant.core.entity.Pais;
import pe.restaurant.core.entity.Provincia;
import pe.restaurant.core.repository.DepartamentoRepository;
import pe.restaurant.core.repository.DistritoRepository;
import pe.restaurant.core.repository.PaisRepository;
import pe.restaurant.core.repository.ProvinciaRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class GeografiaServiceImplTest {

    @Mock private PaisRepository paisRepository;
    @Mock private DepartamentoRepository departamentoRepository;
    @Mock private ProvinciaRepository provinciaRepository;
    @Mock private DistritoRepository distritoRepository;

    @InjectMocks private GeografiaServiceImpl service;

    private final Pageable pageable = PageRequest.of(0, 20);

    // â”€â”€ Pais â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    @Nested
    class FindAllPaises {
        @Test
        void returnsPage() {
            var pais = new Pais("PE", "Peru", null, null, null);
            when(paisRepository.findAll(pageable)).thenReturn(new PageImpl<>(List.of(pais)));

            Page<Pais> result = service.findAllPaises(pageable);
            assertThat(result.getContent()).hasSize(1);
            assertThat(result.getContent().get(0).getNombre()).isEqualTo("Peru");
        }
    }

    @Nested
    class FindPaisById {
        @Test
        void returnsWhenExists() {
            var pais = new Pais("PE", "Peru", null, null, null);
            when(paisRepository.findById(1L)).thenReturn(Optional.of(pais));

            assertThat(service.findPaisById(1L).getCodigo()).isEqualTo("PE");
        }

        @Test
        void throwsWhenNotFound() {
            when(paisRepository.findById(99L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.findPaisById(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class CreatePais {
        @Test
        void success() {
            var pais = new Pais("AR", "Argentina", null, null, null);
            when(paisRepository.existsByCodigoIgnoreCase("AR")).thenReturn(false);
            var savedPais = new Pais("AR", "Argentina", null, null, null);
            savedPais.setId(2L);
            when(paisRepository.save(pais)).thenReturn(savedPais);

            Pais result = service.createPais(pais);
            assertThat(result.getId()).isEqualTo(2L);
            verify(paisRepository).save(pais);
        }

        @Test
        void throwsWhenDuplicateCodigo() {
            var pais = new Pais("PE", "Peru2", null, null, null);
            when(paisRepository.existsByCodigoIgnoreCase("PE")).thenReturn(true);

            assertThatThrownBy(() -> service.createPais(pais))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Ya existe un pais con codigo");
        }
    }

    @Nested
    class UpdatePais {
        @Test
        void success() {
            var existing = new Pais("PE", "Peru", null, null, null);
            var update = new Pais("PE", "Perú", null, null, null);
            when(paisRepository.findById(1L)).thenReturn(Optional.of(existing));
            when(paisRepository.existsByCodigoIgnoreCaseAndIdNot("PE", 1L)).thenReturn(false);
            when(paisRepository.save(update)).thenReturn(update);

            Pais result = service.updatePais(1L, update);
            assertThat(result.getCodigo()).isEqualTo("PE");
            verify(paisRepository).save(update);
        }

        @Test
        void throwsWhenNotFound() {
            when(paisRepository.findById(99L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.updatePais(99L, new Pais()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenDuplicateCodigo() {
            var existing = new Pais("PE", "Peru", null, null, null);
            var update = new Pais("AR", "Argentina", null, null, null);
            when(paisRepository.findById(1L)).thenReturn(Optional.of(existing));
            when(paisRepository.existsByCodigoIgnoreCaseAndIdNot("AR", 1L)).thenReturn(true);

            assertThatThrownBy(() -> service.updatePais(1L, update))
                    .isInstanceOf(BusinessException.class);
        }
    }

    @Nested
    class ActivatePais {
        @Test
        void setsEstadoTo1() {
            var pais = new Pais("PE", "Peru", null, null, null);
            when(paisRepository.findById(1L)).thenReturn(Optional.of(pais));
            when(paisRepository.save(pais)).thenReturn(pais);

            Pais result = service.activatePais(1L);
            assertThat(result.getFlagEstado()).isEqualTo("1");
        }

        @Test
        void throwsWhenNotFound() {
            when(paisRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.activatePais(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class DeactivatePais {
        @Test
        void setsEstadoTo0() {
            var pais = new Pais("PE", "Peru", null, null, null);
            when(paisRepository.findById(1L)).thenReturn(Optional.of(pais));
            when(paisRepository.save(pais)).thenReturn(pais);

            Pais result = service.deactivatePais(1L);
            assertThat(result.getFlagEstado()).isEqualTo("0");
        }

        @Test
        void throwsWhenNotFound() {
            when(paisRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivatePais(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class DeletePais {
        @Test
        void deletesSuccessfully() {
            var pais = new Pais("PE", "Peru", null, null, null);
            when(paisRepository.findById(1L)).thenReturn(Optional.of(pais));

            service.deletePais(1L);
            verify(paisRepository).deleteById(1L);
        }

        @Test
        void throwsWhenNotFound() {
            when(paisRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deletePais(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    // â”€â”€ Departamento â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    @Nested
    class FindAllDepartamentos {
        @Test
        void withPaisIdFilter() {
            var depto = new Departamento(1L, "15", "Lima");
            when(departamentoRepository.findByPaisId(1L, pageable))
                    .thenReturn(new PageImpl<>(List.of(depto)));

            Page<Departamento> result = service.findAllDepartamentos(1L, pageable);
            assertThat(result.getContent()).hasSize(1);
            verify(departamentoRepository).findByPaisId(1L, pageable);
        }

        @Test
        void withoutFilter() {
            var depto = new Departamento(1L, "15", "Lima");
            when(departamentoRepository.findAll(pageable))
                    .thenReturn(new PageImpl<>(List.of(depto)));

            Page<Departamento> result = service.findAllDepartamentos(null, pageable);
            assertThat(result.getContent()).hasSize(1);
            verify(departamentoRepository).findAll(pageable);
        }
    }

    @Nested
    class FindDepartamentoById {
        @Test
        void returnsWhenExists() {
            var depto = new Departamento(1L, "15", "Lima");
            when(departamentoRepository.findById(1L)).thenReturn(Optional.of(depto));

            assertThat(service.findDepartamentoById(1L).getNombre()).isEqualTo("Lima");
        }

        @Test
        void throwsWhenNotFound() {
            when(departamentoRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findDepartamentoById(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class CreateDepartamento {
        @Test
        void success() {
            var depto = new Departamento(1L, "15", "Lima");
            when(paisRepository.existsById(1L)).thenReturn(true);
            when(departamentoRepository.existsByCodigoIgnoreCase("15")).thenReturn(false);
            var savedDepto = new Departamento(1L, "15", "Lima");
            savedDepto.setId(1L);
            when(departamentoRepository.save(depto)).thenReturn(savedDepto);

            Departamento result = service.createDepartamento(depto);
            assertThat(result.getId()).isEqualTo(1L);
        }

        @Test
        void throwsWhenPaisNotFound() {
            var depto = new Departamento(99L, "15", "Lima");
            when(paisRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.createDepartamento(depto))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenDuplicateCodigo() {
            var depto = new Departamento(1L, "15", "Lima");
            when(paisRepository.existsById(1L)).thenReturn(true);
            when(departamentoRepository.existsByCodigoIgnoreCase("15")).thenReturn(true);

            assertThatThrownBy(() -> service.createDepartamento(depto))
                    .isInstanceOf(BusinessException.class);
        }

        @Test
        void successWhenPaisIdNull() {
            var depto = new Departamento(null, "15", "Lima");
            when(departamentoRepository.existsByCodigoIgnoreCase("15")).thenReturn(false);
            var savedDepto = new Departamento(null, "15", "Lima");
            savedDepto.setId(1L);
            when(departamentoRepository.save(depto)).thenReturn(savedDepto);

            Departamento result = service.createDepartamento(depto);
            assertThat(result.getId()).isEqualTo(1L);
        }
    }

    @Nested
    class UpdateDepartamento {
        @Test
        void success() {
            var existing = new Departamento(1L, "15", "Lima");
            var update = new Departamento(1L, "15", "Lima Metropolitana");
            when(departamentoRepository.findById(1L)).thenReturn(Optional.of(existing));
            when(paisRepository.existsById(1L)).thenReturn(true);
            when(departamentoRepository.existsByCodigoIgnoreCaseAndIdNot("15", 1L)).thenReturn(false);
            when(departamentoRepository.save(update)).thenReturn(update);

            service.updateDepartamento(1L, update);
            verify(departamentoRepository).save(update);
        }

        @Test
        void throwsWhenNotFound() {
            when(departamentoRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.updateDepartamento(99L, new Departamento()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenPaisNotFound() {
            var existing = new Departamento(1L, "15", "Lima");
            var update = new Departamento(99L, "15", "Lima");
            when(departamentoRepository.findById(1L)).thenReturn(Optional.of(existing));
            when(paisRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.updateDepartamento(1L, update))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenDuplicateCodigo() {
            var existing = new Departamento(1L, "15", "Lima");
            var update = new Departamento(1L, "16", "Arequipa");
            when(departamentoRepository.findById(1L)).thenReturn(Optional.of(existing));
            when(paisRepository.existsById(1L)).thenReturn(true);
            when(departamentoRepository.existsByCodigoIgnoreCaseAndIdNot("16", 1L)).thenReturn(true);

            assertThatThrownBy(() -> service.updateDepartamento(1L, update))
                    .isInstanceOf(BusinessException.class);
        }

        @Test
        void successWhenPaisIdNull() {
            var existing = new Departamento(1L, "15", "Lima");
            var update = new Departamento(null, "15", "Lima");
            when(departamentoRepository.findById(1L)).thenReturn(Optional.of(existing));
            when(departamentoRepository.existsByCodigoIgnoreCaseAndIdNot("15", 1L)).thenReturn(false);
            when(departamentoRepository.save(update)).thenReturn(update);

            service.updateDepartamento(1L, update);
            verify(departamentoRepository).save(update);
        }
    }

    @Nested
    class ActivateDepartamento {
        @Test
        void setsEstadoTo1() {
            var depto = new Departamento(1L, "15", "Lima");
            when(departamentoRepository.findById(1L)).thenReturn(Optional.of(depto));
            when(departamentoRepository.save(depto)).thenReturn(depto);

            assertThat(service.activateDepartamento(1L).getFlagEstado()).isEqualTo("1");
        }

        @Test
        void throwsWhenNotFound() {
            when(departamentoRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.activateDepartamento(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class DeactivateDepartamento {
        @Test
        void setsEstadoTo0() {
            var depto = new Departamento(1L, "15", "Lima");
            when(departamentoRepository.findById(1L)).thenReturn(Optional.of(depto));
            when(departamentoRepository.save(depto)).thenReturn(depto);

            assertThat(service.deactivateDepartamento(1L).getFlagEstado()).isEqualTo("0");
        }

        @Test
        void throwsWhenNotFound() {
            when(departamentoRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivateDepartamento(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class DeleteDepartamento {
        @Test
        void deletesSuccessfully() {
            var depto = new Departamento(1L, "15", "Lima");
            when(departamentoRepository.findById(1L)).thenReturn(Optional.of(depto));

            service.deleteDepartamento(1L);
            verify(departamentoRepository).deleteById(1L);
        }

        @Test
        void throwsWhenNotFound() {
            when(departamentoRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deleteDepartamento(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    // â”€â”€ Provincia â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    @Nested
    class FindAllProvincias {
        @Test
        void withDepartamentoIdFilter() {
            var prov = new Provincia(1L, "1501", "Lima");
            when(provinciaRepository.findByDepartamentoId(1L, pageable))
                    .thenReturn(new PageImpl<>(List.of(prov)));

            Page<Provincia> result = service.findAllProvincias(1L, pageable);
            assertThat(result.getContent()).hasSize(1);
            verify(provinciaRepository).findByDepartamentoId(1L, pageable);
        }

        @Test
        void withoutFilter() {
            var prov = new Provincia(1L, "1501", "Lima");
            when(provinciaRepository.findAll(pageable))
                    .thenReturn(new PageImpl<>(List.of(prov)));

            Page<Provincia> result = service.findAllProvincias(null, pageable);
            assertThat(result.getContent()).hasSize(1);
            verify(provinciaRepository).findAll(pageable);
        }
    }

    @Nested
    class FindProvinciaById {
        @Test
        void returnsWhenExists() {
            var prov = new Provincia(1L, "1501", "Lima");
            when(provinciaRepository.findById(1L)).thenReturn(Optional.of(prov));

            assertThat(service.findProvinciaById(1L).getNombre()).isEqualTo("Lima");
        }

        @Test
        void throwsWhenNotFound() {
            when(provinciaRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findProvinciaById(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class CreateProvincia {
        @Test
        void success() {
            var prov = new Provincia(1L, "1501", "Lima");
            when(departamentoRepository.existsById(1L)).thenReturn(true);
            when(provinciaRepository.existsByCodigoIgnoreCase("1501")).thenReturn(false);
            var savedProv = new Provincia(1L, "1501", "Lima");
            savedProv.setId(1L);
            when(provinciaRepository.save(prov)).thenReturn(savedProv);

            assertThat(service.createProvincia(prov).getId()).isEqualTo(1L);
        }

        @Test
        void throwsWhenDepartamentoNotFound() {
            var prov = new Provincia(99L, "1501", "Lima");
            when(departamentoRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.createProvincia(prov))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenDuplicateCodigo() {
            var prov = new Provincia(1L, "1501", "Lima");
            when(departamentoRepository.existsById(1L)).thenReturn(true);
            when(provinciaRepository.existsByCodigoIgnoreCase("1501")).thenReturn(true);

            assertThatThrownBy(() -> service.createProvincia(prov))
                    .isInstanceOf(BusinessException.class);
        }

        @Test
        void successWhenDepartamentoIdNull() {
            var prov = new Provincia(null, "1501", "Lima");
            when(provinciaRepository.existsByCodigoIgnoreCase("1501")).thenReturn(false);
            var savedProv = new Provincia(null, "1501", "Lima");
            savedProv.setId(1L);
            when(provinciaRepository.save(prov)).thenReturn(savedProv);

            assertThat(service.createProvincia(prov).getId()).isEqualTo(1L);
        }
    }

    @Nested
    class UpdateProvincia {
        @Test
        void success() {
            var existing = new Provincia(1L, "1501", "Lima");
            var update = new Provincia(1L, "1501", "Lima Prov");
            when(provinciaRepository.findById(1L)).thenReturn(Optional.of(existing));
            when(departamentoRepository.existsById(1L)).thenReturn(true);
            when(provinciaRepository.existsByCodigoIgnoreCaseAndIdNot("1501", 1L)).thenReturn(false);
            when(provinciaRepository.save(update)).thenReturn(update);

            service.updateProvincia(1L, update);
            verify(provinciaRepository).save(update);
        }

        @Test
        void throwsWhenNotFound() {
            when(provinciaRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.updateProvincia(99L, new Provincia()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenDepartamentoNotFound() {
            var existing = new Provincia(1L, "1501", "Lima");
            var update = new Provincia(99L, "1501", "Lima");
            when(provinciaRepository.findById(1L)).thenReturn(Optional.of(existing));
            when(departamentoRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.updateProvincia(1L, update))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenDuplicateCodigo() {
            var existing = new Provincia(1L, "1501", "Lima");
            var update = new Provincia(1L, "1502", "Huaral");
            when(provinciaRepository.findById(1L)).thenReturn(Optional.of(existing));
            when(departamentoRepository.existsById(1L)).thenReturn(true);
            when(provinciaRepository.existsByCodigoIgnoreCaseAndIdNot("1502", 1L)).thenReturn(true);

            assertThatThrownBy(() -> service.updateProvincia(1L, update))
                    .isInstanceOf(BusinessException.class);
        }

        @Test
        void successWhenDepartamentoIdNull() {
            var existing = new Provincia(1L, "1501", "Lima");
            var update = new Provincia(null, "1501", "Lima");
            when(provinciaRepository.findById(1L)).thenReturn(Optional.of(existing));
            when(provinciaRepository.existsByCodigoIgnoreCaseAndIdNot("1501", 1L)).thenReturn(false);
            when(provinciaRepository.save(update)).thenReturn(update);

            service.updateProvincia(1L, update);
            verify(provinciaRepository).save(update);
        }
    }

    @Nested
    class ActivateProvincia {
        @Test
        void setsEstadoTo1() {
            var prov = new Provincia(1L, "1501", "Lima");
            when(provinciaRepository.findById(1L)).thenReturn(Optional.of(prov));
            when(provinciaRepository.save(prov)).thenReturn(prov);

            assertThat(service.activateProvincia(1L).getFlagEstado()).isEqualTo("1");
        }

        @Test
        void throwsWhenNotFound() {
            when(provinciaRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.activateProvincia(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class DeactivateProvincia {
        @Test
        void setsEstadoTo0() {
            var prov = new Provincia(1L, "1501", "Lima");
            when(provinciaRepository.findById(1L)).thenReturn(Optional.of(prov));
            when(provinciaRepository.save(prov)).thenReturn(prov);

            assertThat(service.deactivateProvincia(1L).getFlagEstado()).isEqualTo("0");
        }

        @Test
        void throwsWhenNotFound() {
            when(provinciaRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivateProvincia(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class DeleteProvincia {
        @Test
        void deletesSuccessfully() {
            var prov = new Provincia(1L, "1501", "Lima");
            when(provinciaRepository.findById(1L)).thenReturn(Optional.of(prov));

            service.deleteProvincia(1L);
            verify(provinciaRepository).deleteById(1L);
        }

        @Test
        void throwsWhenNotFound() {
            when(provinciaRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deleteProvincia(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    // â”€â”€ Distrito â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    @Nested
    class FindAllDistritos {
        @Test
        void withProvinciaIdFilter() {
            var dist = new Distrito(1L, "150101", "Lima Cercado");
            when(distritoRepository.findByProvinciaId(1L, pageable))
                    .thenReturn(new PageImpl<>(List.of(dist)));

            Page<Distrito> result = service.findAllDistritos(1L, pageable);
            assertThat(result.getContent()).hasSize(1);
            verify(distritoRepository).findByProvinciaId(1L, pageable);
        }

        @Test
        void withoutFilter() {
            var dist = new Distrito(1L, "150101", "Lima Cercado");
            when(distritoRepository.findAll(pageable))
                    .thenReturn(new PageImpl<>(List.of(dist)));

            Page<Distrito> result = service.findAllDistritos(null, pageable);
            assertThat(result.getContent()).hasSize(1);
            verify(distritoRepository).findAll(pageable);
        }
    }

    @Nested
    class FindDistritoById {
        @Test
        void returnsWhenExists() {
            var dist = new Distrito(1L, "150101", "Lima Cercado");
            when(distritoRepository.findById(1L)).thenReturn(Optional.of(dist));

            assertThat(service.findDistritoById(1L).getNombre()).isEqualTo("Lima Cercado");
        }

        @Test
        void throwsWhenNotFound() {
            when(distritoRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findDistritoById(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class CreateDistrito {
        @Test
        void success() {
            var dist = new Distrito(1L, "150101", "Lima Cercado");
            when(provinciaRepository.existsById(1L)).thenReturn(true);
            when(distritoRepository.existsByCodigoIgnoreCase("150101")).thenReturn(false);
            var savedDist = new Distrito(1L, "150101", "Lima Cercado");
            savedDist.setId(1L);
            when(distritoRepository.save(dist)).thenReturn(savedDist);

            assertThat(service.createDistrito(dist).getId()).isEqualTo(1L);
        }

        @Test
        void throwsWhenProvinciaNotFound() {
            var dist = new Distrito(99L, "150101", "Lima Cercado");
            when(provinciaRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.createDistrito(dist))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenDuplicateCodigo() {
            var dist = new Distrito(1L, "150101", "Lima Cercado");
            when(provinciaRepository.existsById(1L)).thenReturn(true);
            when(distritoRepository.existsByCodigoIgnoreCase("150101")).thenReturn(true);

            assertThatThrownBy(() -> service.createDistrito(dist))
                    .isInstanceOf(BusinessException.class);
        }

        @Test
        void successWhenProvinciaIdNull() {
            var dist = new Distrito(null, "150101", "Lima Cercado");
            when(distritoRepository.existsByCodigoIgnoreCase("150101")).thenReturn(false);
            var savedDist = new Distrito(null, "150101", "Lima Cercado");
            savedDist.setId(1L);
            when(distritoRepository.save(dist)).thenReturn(savedDist);

            assertThat(service.createDistrito(dist).getId()).isEqualTo(1L);
        }
    }

    @Nested
    class UpdateDistrito {
        @Test
        void success() {
            var existing = new Distrito(1L, "150101", "Lima Cercado");
            var update = new Distrito(1L, "150101", "Cercado de Lima");
            when(distritoRepository.findById(1L)).thenReturn(Optional.of(existing));
            when(provinciaRepository.existsById(1L)).thenReturn(true);
            when(distritoRepository.existsByCodigoIgnoreCaseAndIdNot("150101", 1L)).thenReturn(false);
            when(distritoRepository.save(update)).thenReturn(update);

            service.updateDistrito(1L, update);
            verify(distritoRepository).save(update);
        }

        @Test
        void throwsWhenNotFound() {
            when(distritoRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.updateDistrito(99L, new Distrito()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenProvinciaNotFound() {
            var existing = new Distrito(1L, "150101", "Lima Cercado");
            var update = new Distrito(99L, "150101", "Lima Cercado");
            when(distritoRepository.findById(1L)).thenReturn(Optional.of(existing));
            when(provinciaRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.updateDistrito(1L, update))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenDuplicateCodigo() {
            var existing = new Distrito(1L, "150101", "Lima Cercado");
            var update = new Distrito(1L, "150102", "Miraflores");
            when(distritoRepository.findById(1L)).thenReturn(Optional.of(existing));
            when(provinciaRepository.existsById(1L)).thenReturn(true);
            when(distritoRepository.existsByCodigoIgnoreCaseAndIdNot("150102", 1L)).thenReturn(true);

            assertThatThrownBy(() -> service.updateDistrito(1L, update))
                    .isInstanceOf(BusinessException.class);
        }

        @Test
        void successWhenProvinciaIdNull() {
            var existing = new Distrito(1L, "150101", "Lima Cercado");
            var update = new Distrito(null, "150101", "Lima Cercado");
            when(distritoRepository.findById(1L)).thenReturn(Optional.of(existing));
            when(distritoRepository.existsByCodigoIgnoreCaseAndIdNot("150101", 1L)).thenReturn(false);
            when(distritoRepository.save(update)).thenReturn(update);

            service.updateDistrito(1L, update);
            verify(distritoRepository).save(update);
        }
    }

    @Nested
    class ActivateDistrito {
        @Test
        void setsEstadoTo1() {
            var dist = new Distrito(1L, "150101", "Lima Cercado");
            when(distritoRepository.findById(1L)).thenReturn(Optional.of(dist));
            when(distritoRepository.save(dist)).thenReturn(dist);

            assertThat(service.activateDistrito(1L).getFlagEstado()).isEqualTo("1");
        }

        @Test
        void throwsWhenNotFound() {
            when(distritoRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.activateDistrito(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class DeactivateDistrito {
        @Test
        void setsEstadoTo0() {
            var dist = new Distrito(1L, "150101", "Lima Cercado");
            when(distritoRepository.findById(1L)).thenReturn(Optional.of(dist));
            when(distritoRepository.save(dist)).thenReturn(dist);

            assertThat(service.deactivateDistrito(1L).getFlagEstado()).isEqualTo("0");
        }

        @Test
        void throwsWhenNotFound() {
            when(distritoRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deactivateDistrito(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class DeleteDistrito {
        @Test
        void deletesSuccessfully() {
            var dist = new Distrito(1L, "150101", "Lima Cercado");
            when(distritoRepository.findById(1L)).thenReturn(Optional.of(dist));

            service.deleteDistrito(1L);
            verify(distritoRepository).deleteById(1L);
        }

        @Test
        void throwsWhenNotFound() {
            when(distritoRepository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.deleteDistrito(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }
}