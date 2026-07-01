package com.sigre.core.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.core.dto.*;
import com.sigre.core.entity.*;
import com.sigre.core.mapper.*;
import com.sigre.core.repository.*;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class RelacionComercialServiceImplTest {

    @Mock private RelacionComercialRepository repository;
    @Mock private ContactoRepository contactoRepository;
    @Mock private CuentaBancariaRepository cuentaBancariaRepository;
    @Mock private EntidadTiendaRepository entidadTiendaRepository;
    @Mock private EntidadTransporteRepository entidadTransporteRepository;
    @Mock private ArticuloProveedorRepository articuloProveedorRepository;
    @Mock private EntidadContribuyenteTelefonoRepository telefonoRepository;
    @Mock private EntidadContribuyenteRepresentanteRepository representanteRepository;
    @Mock private MonedaRepository monedaRepository;
    @Mock private RelacionComercialMapper mapper;
    @Mock private EntidadTiendaMapper tiendaMapper;
    @Mock private EntidadTransporteMapper transporteMapper;
    @Mock private EntidadContribuyenteTelefonoMapper telefonoMapper;
    @Mock private EntidadContribuyenteRepresentanteMapper representanteMapper;
    @Mock private ArticuloProveedorMapper articuloProveedorMapper;

    @InjectMocks private RelacionComercialServiceImpl service;

    private RelacionComercial entity;

    @BeforeEach
    void setUp() {
        entity = new RelacionComercial();
        entity.setId(1L);
        entity.setTipoPersona("JURIDICA");
        entity.setTipoDocumento("6");
        entity.setNroDocumento("20123456789");
        entity.setRazonSocial("Proveedor SAC");
        entity.setNombreComercial("Proveedor Norte");
        entity.setDireccion("Av. Principal 123");
        entity.setTelefono("999888777");
        entity.setEmail("prov@mail.com");
        entity.setEsProveedor(true);
        entity.setEsCliente(false);
        entity.setFlagEstado("1");
    }

    @Nested
    class ListMethod {
        @SuppressWarnings("unchecked")
        @Test
        void noFilters() {
            when(repository.findAll(any(Specification.class), any(Pageable.class)))
                    .thenReturn(new PageImpl<>(List.of(entity)));
            var result = service.list(null, null, null, null, null, Pageable.unpaged());
            assertThat(result.getContent()).hasSize(1);
        }

        @SuppressWarnings("unchecked")
        @Test
        void withEsProveedorFilter() {
            when(repository.findAll(any(Specification.class), any(Pageable.class)))
                    .thenReturn(new PageImpl<>(List.of(entity)));
            var result = service.list(true, null, null, null, null, Pageable.unpaged());
            assertThat(result.getContent()).hasSize(1);
        }

        @SuppressWarnings("unchecked")
        @Test
        void withEsClienteFilter() {
            when(repository.findAll(any(Specification.class), any(Pageable.class)))
                    .thenReturn(new PageImpl<>(List.of(entity)));
            var result = service.list(null, true, null, null, null, Pageable.unpaged());
            assertThat(result.getContent()).hasSize(1);
        }

        @SuppressWarnings("unchecked")
        @Test
        void withNroDocumentoFilter() {
            when(repository.findAll(any(Specification.class), any(Pageable.class)))
                    .thenReturn(new PageImpl<>(List.of(entity)));
            var result = service.list(null, null, "201", null, null, Pageable.unpaged());
            assertThat(result.getContent()).hasSize(1);
        }

        @SuppressWarnings("unchecked")
        @Test
        void withRazonSocialFilter() {
            when(repository.findAll(any(Specification.class), any(Pageable.class)))
                    .thenReturn(new PageImpl<>(List.of(entity)));
            var result = service.list(null, null, null, "Proveedor", null, Pageable.unpaged());
            assertThat(result.getContent()).hasSize(1);
        }

        @SuppressWarnings("unchecked")
        @Test
        void blankNroDocumentoNotApplied() {
            when(repository.findAll(any(Specification.class), any(Pageable.class)))
                    .thenReturn(new PageImpl<>(List.of(entity)));
            var result = service.list(null, null, "  ", "  ", null, Pageable.unpaged());
            assertThat(result.getContent()).hasSize(1);
        }

        @SuppressWarnings("unchecked")
        @Test
        void allFiltersCombined() {
            when(repository.findAll(any(Specification.class), any(Pageable.class)))
                    .thenReturn(new PageImpl<>(List.of(entity)));
            var result = service.list(true, false, "201", "Prov", null, Pageable.unpaged());
            assertThat(result.getContent()).hasSize(1);
        }

        @SuppressWarnings("unchecked")
        @Test
        void activoTrueFilter() {
            when(repository.findAll(any(Specification.class), any(Pageable.class)))
                    .thenReturn(new PageImpl<>(List.of(entity)));
            var result = service.list(null, null, null, null, true, Pageable.unpaged());
            assertThat(result.getContent()).hasSize(1);
        }

        @SuppressWarnings("unchecked")
        @Test
        void activoFalseFilter() {
            when(repository.findAll(any(Specification.class), any(Pageable.class)))
                    .thenReturn(new PageImpl<>(List.of(entity)));
            var result = service.list(null, null, null, null, false, Pageable.unpaged());
            assertThat(result.getContent()).hasSize(1);
        }
    }

    @Nested
    class GetById {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            RelacionComercialResponse resp = new RelacionComercialResponse();
            resp.setId(1L);
            resp.setRazonSocial("Proveedor SAC");
            resp.setFlagEstado("1");
            when(mapper.toRelacionResponse(entity)).thenReturn(resp);
            when(contactoRepository.findByRelacionComercialIdAndFlagEstado(1L, "1")).thenReturn(List.of());
            when(cuentaBancariaRepository.findByRelacionComercialIdAndFlagEstado(1L, "1")).thenReturn(List.of());
            when(telefonoRepository.findByEntidadContribuyenteIdAndFlagEstado(1L, "1")).thenReturn(List.of());
            when(representanteRepository.findByEntidadContribuyenteIdAndFlagEstado(1L, "1")).thenReturn(List.of());
            when(telefonoMapper.toResponseList(any())).thenReturn(List.of());
            when(representanteMapper.toResponseList(any())).thenReturn(List.of());

            var result = service.getById(1L);
            assertThat(result.getRazonSocial()).isEqualTo("Proveedor SAC");
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
            var request = new RelacionComercialRequest("Nuevo", "Comercial Nuevo", 6L, "20999999999", "Calle 123", null, null, true, false, false, null, "1");
            when(repository.existsByNroDocumento("20999999999")).thenReturn(false);
            when(repository.save(any(RelacionComercial.class))).thenReturn(entity);
            RelacionComercialResponse resp = new RelacionComercialResponse();
            resp.setId(1L);
            when(mapper.toRelacionResponse(entity)).thenReturn(resp);

            var result = service.create(request);
            assertThat(result.getId()).isEqualTo(1L);
            verify(repository).save(argThat(e ->
                    "Comercial Nuevo".equals(e.getNombreComercial())
                            && "Calle 123".equals(e.getDireccion())));
        }

        @Test
        void throwsConflictWhenDuplicateDocument() {
            var request = new RelacionComercialRequest("Dup", null, 6L, "20123456789", null, null, null, true, false, false, null, "1");
            when(repository.existsByNroDocumento("20123456789")).thenReturn(true);

            assertThatThrownBy(() -> service.create(request))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> assertThat(((BusinessException) ex).getStatus()).isEqualTo(HttpStatus.CONFLICT));
        }

        @Test
        void setsDefaultFlagEstadoWhenNull() {
            var request = new RelacionComercialRequest("Prov", null, 6L, "20111111111", null, null, null, null, null, null, null, null);
            when(repository.existsByNroDocumento("20111111111")).thenReturn(false);
            when(repository.save(any(RelacionComercial.class))).thenAnswer(i -> i.getArgument(0));
            when(mapper.toRelacionResponse(any())).thenReturn(new RelacionComercialResponse());

            service.create(request);
            verify(repository).save(argThat(e -> "1".equals(e.getFlagEstado())));
        }

        @Test
        void setsTipoDocumentoNullWhenIdNull() {
            var request = new RelacionComercialRequest("Prov", null, null, "20111111111", null, null, null, true, false, false, null, "1");
            when(repository.existsByNroDocumento("20111111111")).thenReturn(false);
            when(repository.save(any(RelacionComercial.class))).thenAnswer(i -> i.getArgument(0));
            when(mapper.toRelacionResponse(any())).thenReturn(new RelacionComercialResponse());

            service.create(request);
            verify(repository).save(argThat(e -> e.getTipoDocumento() == null));
        }
    }

    @Nested
    class Update {
        @Test
        void success() {
            var request = new RelacionComercialRequest("Updated", "Nuevo Comercial", 6L, "20123456789", "Av. Cambio 456", "999", "mail@x.com", true, true, false, null, "1");
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(repository.existsByNroDocumentoAndIdNot("20123456789", 1L)).thenReturn(false);
            when(repository.save(any())).thenReturn(entity);
            RelacionComercialResponse resp = new RelacionComercialResponse();
            resp.setId(1L);
            when(mapper.toRelacionResponse(any())).thenReturn(resp);

            var result = service.update(1L, request);
            assertThat(result.getId()).isEqualTo(1L);
            verify(repository).save(argThat(e ->
                    "Nuevo Comercial".equals(e.getNombreComercial())
                            && "Av. Cambio 456".equals(e.getDireccion())));
        }

        @Test
        void throwsConflictWhenDuplicate() {
            var request = new RelacionComercialRequest("Dup", null, 6L, "20999999999", null, null, null, true, false, false, null, "1");
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(repository.existsByNroDocumentoAndIdNot("20999999999", 1L)).thenReturn(true);

            assertThatThrownBy(() -> service.update(1L, request))
                    .isInstanceOf(BusinessException.class);
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.update(99L, new RelacionComercialRequest()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void setsDefaultFlagEstadoWhenNull() {
            var request = new RelacionComercialRequest("Upd", null, 6L, "20123456789", null, null, null, null, null, null, null, null);
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(repository.existsByNroDocumentoAndIdNot("20123456789", 1L)).thenReturn(false);
            when(repository.save(any())).thenReturn(entity);
            when(mapper.toRelacionResponse(any())).thenReturn(new RelacionComercialResponse());

            service.update(1L, request);
            verify(repository).save(argThat(e -> "1".equals(e.getFlagEstado())));
        }

        @Test
        void setsTipoDocumentoNullWhenIdNull() {
            var request = new RelacionComercialRequest("Upd", null, null, "20123456789", null, null, null, true, false, false, null, "1");
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(repository.existsByNroDocumentoAndIdNot("20123456789", 1L)).thenReturn(false);
            when(repository.save(any())).thenReturn(entity);
            when(mapper.toRelacionResponse(any())).thenReturn(new RelacionComercialResponse());

            service.update(1L, request);
            verify(repository).save(argThat(e -> e.getTipoDocumento() == null));
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
    class ListContactos {
        @Test
        void returnsContactos() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            Contacto c = new Contacto();
            c.setId(1L);
            when(contactoRepository.findByRelacionComercialIdAndFlagEstado(1L, "1")).thenReturn(List.of(c));
            ContactoResponse resp = new ContactoResponse();
            resp.setId(1L);
            when(mapper.toContactoResponse(c)).thenReturn(resp);

            assertThat(service.listContactos(1L)).hasSize(1);
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.listContactos(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class CreateContacto {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(contactoRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            ContactoResponse resp = new ContactoResponse();
            resp.setId(1L);
            when(mapper.toContactoResponse(any())).thenReturn(resp);

            var request = new ContactoRequest();
            request.setNombre("Juan");
            request.setCargo("Gerente");
            var result = service.createContacto(1L, request);
            assertThat(result.getId()).isEqualTo(1L);
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.createContacto(99L, new ContactoRequest()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsConflictWhenDuplicate() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(contactoRepository.existsByRelacionComercialIdAndNombreIgnoreCaseAndFlagEstado(
                    1L, "Juan", "1")).thenReturn(true);

            var request = new ContactoRequest();
            request.setNombre("Juan");

            assertThatThrownBy(() -> service.createContacto(1L, request))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> assertThat(((BusinessException) ex).getStatus())
                            .isEqualTo(HttpStatus.CONFLICT));
            verify(contactoRepository, never()).save(any());
        }
    }

    @Nested
    class ListCuentas {
        @Test
        void returnsCuentas() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            CuentaBancaria cb = new CuentaBancaria();
            cb.setId(1L);
            when(cuentaBancariaRepository.findByRelacionComercialIdAndFlagEstado(1L, "1")).thenReturn(List.of(cb));
            CuentaBancariaResponse resp = new CuentaBancariaResponse();
            resp.setId(1L);
            when(mapper.toCuentaResponse(cb)).thenReturn(resp);

            assertThat(service.listCuentas(1L)).hasSize(1);
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.listCuentas(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class CreateCuenta {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(monedaRepository.existsById(1L)).thenReturn(true);
            when(cuentaBancariaRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            CuentaBancariaResponse resp = new CuentaBancariaResponse();
            resp.setId(1L);
            when(mapper.toCuentaResponse(any())).thenReturn(resp);

            CuentaBancariaRequest request = new CuentaBancariaRequest();
            request.setCodBanco("001");
            request.setNumeroCuenta("12345");
            request.setMonedaId(1L);
            var result = service.createCuenta(1L, request);
            assertThat(result.getId()).isEqualTo(1L);
        }

        @Test
        void throwsWhenMonedaNotFound() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(monedaRepository.existsById(99L)).thenReturn(false);

            CuentaBancariaRequest request = new CuentaBancariaRequest();
            request.setMonedaId(99L);
            assertThatThrownBy(() -> service.createCuenta(1L, request))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void successWhenMonedaIdNull() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(cuentaBancariaRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            CuentaBancariaResponse resp = new CuentaBancariaResponse();
            when(mapper.toCuentaResponse(any())).thenReturn(resp);

            CuentaBancariaRequest request = new CuentaBancariaRequest();
            request.setCodBanco("002");
            request.setNumeroCuenta("67890");
            request.setMonedaId(null);
            service.createCuenta(1L, request);
            verify(cuentaBancariaRepository).save(any());
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.createCuenta(99L, new CuentaBancariaRequest()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class UpdateContacto {
        private Contacto existingContacto() {
            RelacionComercial rel = new RelacionComercial();
            rel.setId(1L);
            Contacto c = new Contacto();
            c.setId(5L);
            c.setNombre("Juan");
            c.setRelacionComercial(rel);
            return c;
        }

        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(contactoRepository.findById(5L)).thenReturn(Optional.of(existingContacto()));
            when(contactoRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            ContactoResponse resp = new ContactoResponse();
            resp.setId(5L);
            when(mapper.toContactoResponse(any())).thenReturn(resp);

            var request = new ContactoRequest();
            request.setNombre("Juan Perez");
            request.setCargo("Gerente de Compras");
            request.setTelefono("999888777");
            request.setEmail("jperez@empresa.com");

            var result = service.updateContacto(1L, 5L, request);
            assertThat(result.getId()).isEqualTo(5L);
            verify(contactoRepository).save(any());
        }

        @Test
        void throwsNotFoundWhenContactoMissing() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(contactoRepository.findById(5L)).thenReturn(Optional.empty());

            var request = new ContactoRequest();
            request.setNombre("Juan");
            assertThatThrownBy(() -> service.updateContacto(1L, 5L, request))
                    .isInstanceOf(ResourceNotFoundException.class);
            verify(contactoRepository, never()).save(any());
        }

        @Test
        void throwsNotFoundWhenContactoBelongsToOtherRelacion() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            RelacionComercial otra = new RelacionComercial();
            otra.setId(2L);
            Contacto c = new Contacto();
            c.setId(5L);
            c.setRelacionComercial(otra);
            when(contactoRepository.findById(5L)).thenReturn(Optional.of(c));

            var request = new ContactoRequest();
            request.setNombre("Juan");
            assertThatThrownBy(() -> service.updateContacto(1L, 5L, request))
                    .isInstanceOf(ResourceNotFoundException.class);
            verify(contactoRepository, never()).save(any());
        }

        @Test
        void throwsConflictWhenRenamedToExisting() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(contactoRepository.findById(5L)).thenReturn(Optional.of(existingContacto()));
            when(contactoRepository.existsByRelacionComercialIdAndNombreIgnoreCaseAndFlagEstado(
                    1L, "Otro", "1")).thenReturn(true);

            var request = new ContactoRequest();
            request.setNombre("Otro");
            assertThatThrownBy(() -> service.updateContacto(1L, 5L, request))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> assertThat(((BusinessException) ex).getStatus())
                            .isEqualTo(HttpStatus.CONFLICT));
            verify(contactoRepository, never()).save(any());
        }
    }

    @Nested
    class UpdateCuenta {
        private CuentaBancaria existingCuenta() {
            RelacionComercial rel = new RelacionComercial();
            rel.setId(1L);
            CuentaBancaria cb = new CuentaBancaria();
            cb.setId(7L);
            cb.setRelacionComercial(rel);
            return cb;
        }

        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(cuentaBancariaRepository.findById(7L)).thenReturn(Optional.of(existingCuenta()));
            when(monedaRepository.existsById(1L)).thenReturn(true);
            when(cuentaBancariaRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            CuentaBancariaResponse resp = new CuentaBancariaResponse();
            resp.setId(7L);
            when(mapper.toCuentaResponse(any())).thenReturn(resp);

            CuentaBancariaRequest request = new CuentaBancariaRequest();
            request.setCodBanco("002");
            request.setNumeroCuenta("1234567890");
            request.setCci("00200212345678901234");
            request.setMonedaId(1L);
            request.setTipoCuenta("CORRIENTE");

            var result = service.updateCuenta(1L, 7L, request);
            assertThat(result.getId()).isEqualTo(7L);
            verify(cuentaBancariaRepository).save(any());
        }

        @Test
        void throwsNotFoundWhenCuentaMissing() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(cuentaBancariaRepository.findById(7L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.updateCuenta(1L, 7L, new CuentaBancariaRequest()))
                    .isInstanceOf(ResourceNotFoundException.class);
            verify(cuentaBancariaRepository, never()).save(any());
        }

        @Test
        void throwsNotFoundWhenCuentaBelongsToOtherRelacion() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            RelacionComercial otra = new RelacionComercial();
            otra.setId(2L);
            CuentaBancaria cb = new CuentaBancaria();
            cb.setId(7L);
            cb.setRelacionComercial(otra);
            when(cuentaBancariaRepository.findById(7L)).thenReturn(Optional.of(cb));

            assertThatThrownBy(() -> service.updateCuenta(1L, 7L, new CuentaBancariaRequest()))
                    .isInstanceOf(ResourceNotFoundException.class);
            verify(cuentaBancariaRepository, never()).save(any());
        }

        @Test
        void throwsWhenMonedaNotFound() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(cuentaBancariaRepository.findById(7L)).thenReturn(Optional.of(existingCuenta()));
            when(monedaRepository.existsById(99L)).thenReturn(false);

            CuentaBancariaRequest request = new CuentaBancariaRequest();
            request.setMonedaId(99L);
            assertThatThrownBy(() -> service.updateCuenta(1L, 7L, request))
                    .isInstanceOf(ResourceNotFoundException.class);
            verify(cuentaBancariaRepository, never()).save(any());
        }
    }

    @Nested
    class DeleteCuenta {
        @Test
        void marcaInactiva() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            RelacionComercial rel = new RelacionComercial();
            rel.setId(1L);
            CuentaBancaria cb = new CuentaBancaria();
            cb.setId(7L);
            cb.setRelacionComercial(rel);
            cb.setFlagEstado("1");
            when(cuentaBancariaRepository.findById(7L)).thenReturn(Optional.of(cb));
            when(cuentaBancariaRepository.save(any())).thenAnswer(i -> i.getArgument(0));

            service.deleteCuenta(1L, 7L);
            assertThat(cb.getFlagEstado()).isEqualTo("0");
            verify(cuentaBancariaRepository).save(cb);
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(cuentaBancariaRepository.findById(7L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.deleteCuenta(1L, 7L))
                    .isInstanceOf(ResourceNotFoundException.class);
            verify(cuentaBancariaRepository, never()).save(any());
        }
    }

    @Nested
    class ListTiendas {
        @Test
        void returnsTiendas() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(entidadTiendaRepository.findByEntidadContribuyenteId(1L)).thenReturn(List.of());
            when(tiendaMapper.toResponseList(any())).thenReturn(List.of());

            assertThat(service.listTiendas(1L)).isEmpty();
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.listTiendas(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class CreateTienda {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            EntidadTienda tienda = new EntidadTienda();
            EntidadTiendaRequest request = new EntidadTiendaRequest();
            when(tiendaMapper.toEntity(request)).thenReturn(tienda);
            EntidadTiendaResponse resp = new EntidadTiendaResponse();
            when(entidadTiendaRepository.save(tienda)).thenReturn(tienda);
            when(tiendaMapper.toResponse(tienda)).thenReturn(resp);

            var result = service.createTienda(1L, request);
            assertThat(result).isNotNull();
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.createTienda(99L, new EntidadTiendaRequest()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class ListTransportes {
        @Test
        void returnsTransportes() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(entidadTransporteRepository.findByEntidadContribuyenteId(1L)).thenReturn(List.of());
            when(transporteMapper.toResponseList(any())).thenReturn(List.of());

            assertThat(service.listTransportes(1L)).isEmpty();
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.listTransportes(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class CreateTransporte {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            EntidadTransporte transporte = new EntidadTransporte();
            EntidadTransporteRequest request = new EntidadTransporteRequest();
            when(transporteMapper.toEntity(request)).thenReturn(transporte);
            when(entidadTransporteRepository.save(transporte)).thenReturn(transporte);
            when(transporteMapper.toResponse(transporte)).thenReturn(new EntidadTransporteResponse());

            var result = service.createTransporte(1L, request);
            assertThat(result).isNotNull();
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.createTransporte(99L, new EntidadTransporteRequest()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class ListArticulos {
        @Test
        void returnsArticulos() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            ArticuloProveedor ap = new ArticuloProveedor();
            ap.setId(1L);
            when(articuloProveedorRepository.findByProveedorIdAndFlagEstado(1L, "1")).thenReturn(List.of(ap));
            when(articuloProveedorMapper.toResponse(ap)).thenReturn(new ArticuloProveedorResponse());

            assertThat(service.listArticulos(1L)).hasSize(1);
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.listArticulos(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class CreateArticulo {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(articuloProveedorRepository.findByArticuloIdAndProveedorId(5L, 1L)).thenReturn(Optional.empty());
            when(articuloProveedorRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(articuloProveedorMapper.toResponse(any())).thenReturn(new ArticuloProveedorResponse());

            var result = service.createArticulo(1L, 5L);
            assertThat(result).isNotNull();
        }

        @Test
        void throwsConflictWhenAlreadyAssociated() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            ArticuloProveedor existing = new ArticuloProveedor();
            when(articuloProveedorRepository.findByArticuloIdAndProveedorId(5L, 1L)).thenReturn(Optional.of(existing));

            assertThatThrownBy(() -> service.createArticulo(1L, 5L))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("ya está asociado");
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.createArticulo(99L, 5L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class ListTelefonos {
        @Test
        void returnsTelefonos() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(telefonoRepository.findByEntidadContribuyenteIdAndFlagEstado(1L, "1")).thenReturn(List.of());
            when(telefonoMapper.toResponseList(any())).thenReturn(List.of());

            assertThat(service.listTelefonos(1L)).isEmpty();
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.listTelefonos(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class CreateTelefono {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            EntidadContribuyenteTelefono tel = new EntidadContribuyenteTelefono();
            EntidadContribuyenteTelefonoRequest request = new EntidadContribuyenteTelefonoRequest();
            when(telefonoMapper.toEntity(request)).thenReturn(tel);
            when(telefonoRepository.findByEntidadContribuyenteId(1L)).thenReturn(List.of());
            when(telefonoRepository.save(tel)).thenReturn(tel);
            when(telefonoMapper.toResponse(tel)).thenReturn(new EntidadContribuyenteTelefonoResponse());

            var result = service.createTelefono(1L, request);
            assertThat(result).isNotNull();
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.createTelefono(99L, new EntidadContribuyenteTelefonoRequest()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class ListRepresentantes {
        @Test
        void returnsRepresentantes() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            when(representanteRepository.findByEntidadContribuyenteIdAndFlagEstado(1L, "1")).thenReturn(List.of());
            when(representanteMapper.toResponseList(any())).thenReturn(List.of());

            assertThat(service.listRepresentantes(1L)).isEmpty();
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.listRepresentantes(99L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class CreateRepresentante {
        @Test
        void success() {
            when(repository.findById(1L)).thenReturn(Optional.of(entity));
            EntidadContribuyenteRepresentante rep = new EntidadContribuyenteRepresentante();
            EntidadContribuyenteRepresentanteRequest request = new EntidadContribuyenteRepresentanteRequest();
            when(representanteMapper.toEntity(request)).thenReturn(rep);
            when(representanteRepository.findByEntidadContribuyenteId(1L)).thenReturn(List.of());
            when(representanteRepository.save(rep)).thenReturn(rep);
            when(representanteMapper.toResponse(rep)).thenReturn(new EntidadContribuyenteRepresentanteResponse());

            var result = service.createRepresentante(1L, request);
            assertThat(result).isNotNull();
        }

        @Test
        void throwsNotFound() {
            when(repository.findById(99L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.createRepresentante(99L, new EntidadContribuyenteRepresentanteRequest()))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
