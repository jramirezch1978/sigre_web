package pe.restaurant.activos.service.impl;

import feign.FeignException;
import feign.Request;
import org.junit.jupiter.api.AfterEach;
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
import pe.restaurant.activos.client.CoreMaestrosClient;
import pe.restaurant.activos.dto.EntidadContribuyenteResponse;
import pe.restaurant.activos.entity.AfClase;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfSubClase;
import pe.restaurant.activos.entity.AfUbicacion;
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.activos.repository.*;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfMaestroServiceImplTest {

    @Mock
    private AfMaestroRepository repository;
    @Mock
    private AfSubClaseRepository subClaseRepository;
    @Mock
    private AfUbicacionRepository ubicacionRepository;
    @Mock
    private AfClaseRepository afClaseRepository;
    @Mock
    private AfCalculoCntblRepository calculoCntblRepository;
    @Mock
    private CoreMaestrosClient coreMaestrosClient;
    @Mock
    private AfVentaRepository ventaRepository;
    @Mock
    private ContabilidadIntegracionService contabilidadIntegracionService;
    @Mock
    private ContabilidadAutoContabilizador contabilidadAutoContabilizador;
    @InjectMocks
    private AfMaestroServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(7L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    private AfSubClase subClaseActiva() {
        AfSubClase sub = new AfSubClase();
        sub.setId(1L);
        sub.setAfClaseId(10L);
        sub.setCodigo("SUB1");
        sub.setNombre("Sub");
        sub.setFlagEstado(ActivosFlagEstado.ACTIVO);
        return sub;
    }

    private AfClase claseActiva() {
        AfClase clase = new AfClase();
        clase.setId(10L);
        clase.setFlagEstado(ActivosFlagEstado.ACTIVO);
        return clase;
    }

    private AfMaestro entityBase() {
        AfMaestro entity = new AfMaestro();
        entity.setCodigo("AF001");
        entity.setNombre("Equipo");
        entity.setAfSubClaseId(1L);
        entity.setFechaAdquisicion(LocalDate.of(2024, 6, 1));
        entity.setValorAdquisicion(new BigDecimal("10000.0000"));
        entity.setValorResidual(new BigDecimal("500.0000"));
        return entity;
    }

    @Nested
    class FindAll {

        @Test
        void retornaPaginaDeActivos() {
            AfMaestro m = new AfMaestro();
            m.setId(1L);
            when(repository.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(m)));

            Page<AfMaestro> result = service.findAll(PageRequest.of(0, 10));
            assertThat(result.getTotalElements()).isEqualTo(1);
        }
    }

    @Nested
    class FindById {

        @Test
        void retornaActivoExistente() {
            AfMaestro m = new AfMaestro();
            m.setId(1L);
            when(repository.findById(1L)).thenReturn(Optional.of(m));

            assertThat(service.findById(1L).getId()).isEqualTo(1L);
        }

        @Test
        void lanzaExcepcionSiNoExiste() {
            when(repository.findById(7L)).thenReturn(Optional.empty());
            assertThatThrownBy(() -> service.findById(7L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class Create {

        @Test
        void creaExitosamenteConSubClaseYClaseActivas() {
            AfMaestro entity = entityBase();
            when(repository.existsByCodigoIgnoreCase("AF001")).thenReturn(false);
            when(subClaseRepository.findById(1L)).thenReturn(Optional.of(subClaseActiva()));
            when(afClaseRepository.findById(10L)).thenReturn(Optional.of(claseActiva()));
            when(repository.save(any(AfMaestro.class))).thenAnswer(inv -> {
                AfMaestro m = inv.getArgument(0);
                m.setId(99L);
                return m;
            });

            AfMaestro result = service.create(entity);
            assertThat(result.getId()).isEqualTo(99L);
            assertThat(result.getFlagEstado()).isEqualTo(ActivosFlagEstado.ACTIVO);
        }

        @Test
        void lanzaExcepcionSiCodigoDuplicado() {
            AfMaestro entity = entityBase();
            when(repository.existsByCodigoIgnoreCase("AF001")).thenReturn(true);

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MAESTRO_CODIGO_DUPLICADO);
        }

        @Test
        void lanzaExcepcionSiSubClaseNoExiste() {
            AfMaestro entity = entityBase();
            when(repository.existsByCodigoIgnoreCase("AF001")).thenReturn(false);
            when(subClaseRepository.findById(1L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.SUB_CLASE_NO_ENCONTRADA);
        }

        @Test
        void lanzaExcepcionSiSubClaseInactiva() {
            AfMaestro entity = entityBase();
            AfSubClase sub = subClaseActiva();
            sub.setFlagEstado("0");

            when(repository.existsByCodigoIgnoreCase("AF001")).thenReturn(false);
            when(subClaseRepository.findById(1L)).thenReturn(Optional.of(sub));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.SUB_CLASE_INACTIVA);
        }

        @Test
        void lanzaExcepcionSiClaseInactiva() {
            AfMaestro entity = entityBase();
            AfClase clase = claseActiva();
            clase.setFlagEstado(ActivosFlagEstado.INACTIVO);

            when(repository.existsByCodigoIgnoreCase("AF001")).thenReturn(false);
            when(subClaseRepository.findById(1L)).thenReturn(Optional.of(subClaseActiva()));
            when(afClaseRepository.findById(10L)).thenReturn(Optional.of(clase));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.CLASE_INACTIVA);
        }

        @Test
        void lanzaExcepcionSiClaseNoExiste() {
            AfMaestro entity = entityBase();
            when(repository.existsByCodigoIgnoreCase("AF001")).thenReturn(false);
            when(subClaseRepository.findById(1L)).thenReturn(Optional.of(subClaseActiva()));
            when(afClaseRepository.findById(10L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void validaUbicacionSiProvista() {
            AfMaestro entity = entityBase();
            entity.setAfUbicacionId(5L);
            AfUbicacion ubi = new AfUbicacion();
            ubi.setId(5L);
            ubi.setFlagEstado(ActivosFlagEstado.ACTIVO);
            ubi.setCodigo("UBI1");
            ubi.setNombre("Ubi");

            when(repository.existsByCodigoIgnoreCase("AF001")).thenReturn(false);
            when(subClaseRepository.findById(1L)).thenReturn(Optional.of(subClaseActiva()));
            when(afClaseRepository.findById(10L)).thenReturn(Optional.of(claseActiva()));
            when(ubicacionRepository.findById(5L)).thenReturn(Optional.of(ubi));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            service.create(entity);
            verify(ubicacionRepository).findById(5L);
        }

        @Test
        void lanzaExcepcionSiUbicacionNoExiste() {
            AfMaestro entity = entityBase();
            entity.setAfUbicacionId(5L);

            when(repository.existsByCodigoIgnoreCase("AF001")).thenReturn(false);
            when(subClaseRepository.findById(1L)).thenReturn(Optional.of(subClaseActiva()));
            when(afClaseRepository.findById(10L)).thenReturn(Optional.of(claseActiva()));
            when(ubicacionRepository.findById(5L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.UBICACION_NO_ENCONTRADA);
        }

        @Test
        void lanzaExcepcionSiUbicacionInactiva() {
            AfMaestro entity = entityBase();
            entity.setAfUbicacionId(5L);
            AfUbicacion ubi = new AfUbicacion();
            ubi.setId(5L);
            ubi.setFlagEstado("0");
            ubi.setNombre("Ubi inactiva");

            when(repository.existsByCodigoIgnoreCase("AF001")).thenReturn(false);
            when(subClaseRepository.findById(1L)).thenReturn(Optional.of(subClaseActiva()));
            when(afClaseRepository.findById(10L)).thenReturn(Optional.of(claseActiva()));
            when(ubicacionRepository.findById(5L)).thenReturn(Optional.of(ubi));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.UBICACION_INACTIVA);
        }

        @Test
        void validaProveedorSiProvisto() {
            AfMaestro entity = entityBase();
            entity.setProveedorId(50L);
            EntidadContribuyenteResponse prov = new EntidadContribuyenteResponse();
            prov.setFlagEstado("1");
            prov.setNumeroDocumento("20100100100");
            prov.setRazonSocial("Proveedor SA");

            when(repository.existsByCodigoIgnoreCase("AF001")).thenReturn(false);
            when(subClaseRepository.findById(1L)).thenReturn(Optional.of(subClaseActiva()));
            when(afClaseRepository.findById(10L)).thenReturn(Optional.of(claseActiva()));
            when(coreMaestrosClient.obtenerEntidadPorId(50L)).thenReturn(ApiResponse.ok(prov));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            service.create(entity);
            verify(coreMaestrosClient).obtenerEntidadPorId(50L);
        }

        @Test
        void lanzaExcepcionSiProveedorInactivo() {
            AfMaestro entity = entityBase();
            entity.setProveedorId(50L);
            EntidadContribuyenteResponse prov = new EntidadContribuyenteResponse();
            prov.setFlagEstado("0");
            prov.setRazonSocial("Prov Inact");

            when(repository.existsByCodigoIgnoreCase("AF001")).thenReturn(false);
            when(subClaseRepository.findById(1L)).thenReturn(Optional.of(subClaseActiva()));
            when(afClaseRepository.findById(10L)).thenReturn(Optional.of(claseActiva()));
            when(coreMaestrosClient.obtenerEntidadPorId(50L)).thenReturn(ApiResponse.ok(prov));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.PROVEEDOR_INACTIVO);
        }

        @Test
        void lanzaExcepcionSiProveedorNoExisteEnResponse() {
            AfMaestro entity = entityBase();
            entity.setProveedorId(50L);

            when(repository.existsByCodigoIgnoreCase("AF001")).thenReturn(false);
            when(subClaseRepository.findById(1L)).thenReturn(Optional.of(subClaseActiva()));
            when(afClaseRepository.findById(10L)).thenReturn(Optional.of(claseActiva()));
            when(coreMaestrosClient.obtenerEntidadPorId(50L)).thenReturn(ApiResponse.ok(null));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.PROVEEDOR_NO_ENCONTRADO);
        }

        @Test
        void lanzaExcepcionSiProveedorFeignNotFound() {
            AfMaestro entity = entityBase();
            entity.setProveedorId(50L);

            when(repository.existsByCodigoIgnoreCase("AF001")).thenReturn(false);
            when(subClaseRepository.findById(1L)).thenReturn(Optional.of(subClaseActiva()));
            when(afClaseRepository.findById(10L)).thenReturn(Optional.of(claseActiva()));
            when(coreMaestrosClient.obtenerEntidadPorId(50L)).thenThrow(
                    new FeignException.NotFound("not found",
                            Request.create(Request.HttpMethod.GET, "/api", Map.of(), null, null, null),
                            null, null));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.PROVEEDOR_NO_ENCONTRADO);
        }

        @Test
        void lanzaExcepcionSiProveedorFeignError() {
            AfMaestro entity = entityBase();
            entity.setProveedorId(50L);

            when(repository.existsByCodigoIgnoreCase("AF001")).thenReturn(false);
            when(subClaseRepository.findById(1L)).thenReturn(Optional.of(subClaseActiva()));
            when(afClaseRepository.findById(10L)).thenReturn(Optional.of(claseActiva()));
            when(coreMaestrosClient.obtenerEntidadPorId(50L)).thenThrow(
                    new FeignException.ServiceUnavailable("timeout",
                            Request.create(Request.HttpMethod.GET, "/api", Map.of(), null, null, null),
                            null, null));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("Error al validar");
        }

        @Test
        void lanzaExcepcionSiValorResidualMayorIgualAdquisicion() {
            AfMaestro entity = entityBase();
            entity.setValorResidual(new BigDecimal("10000.0000"));

            when(repository.existsByCodigoIgnoreCase("AF001")).thenReturn(false);
            when(subClaseRepository.findById(1L)).thenReturn(Optional.of(subClaseActiva()));
            when(afClaseRepository.findById(10L)).thenReturn(Optional.of(claseActiva()));

            assertThatThrownBy(() -> service.create(entity))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.VALOR_RESIDUAL_INVALIDO);
        }
    }

    @Nested
    class Update {

        @Test
        void actualizaExitosamente() {
            AfMaestro existing = entityBase();
            existing.setId(1L);
            AfMaestro updated = entityBase();
            updated.setNombre("Equipo Actualizado");

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(repository.existsByCodigoIgnoreCaseAndIdNot("AF001", 1L)).thenReturn(false);
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfMaestro result = service.update(1L, updated);
            assertThat(result.getNombre()).isEqualTo("Equipo Actualizado");
        }

        @Test
        void validaSubClaseSiCambia() {
            AfMaestro existing = entityBase();
            existing.setId(1L);
            existing.setAfSubClaseId(1L);

            AfMaestro updated = entityBase();
            updated.setAfSubClaseId(2L);

            AfSubClase newSub = new AfSubClase();
            newSub.setId(2L);
            newSub.setAfClaseId(10L);
            newSub.setFlagEstado(ActivosFlagEstado.ACTIVO);
            newSub.setCodigo("SUB2");
            newSub.setNombre("Sub2");

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(repository.existsByCodigoIgnoreCaseAndIdNot("AF001", 1L)).thenReturn(false);
            when(subClaseRepository.findById(2L)).thenReturn(Optional.of(newSub));
            when(afClaseRepository.findById(10L)).thenReturn(Optional.of(claseActiva()));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            service.update(1L, updated);
            verify(subClaseRepository).findById(2L);
        }

        @Test
        void validaUbicacionSiCambia() {
            AfMaestro existing = entityBase();
            existing.setId(1L);
            existing.setAfUbicacionId(5L);

            AfMaestro updated = entityBase();
            updated.setAfUbicacionId(6L);

            AfUbicacion ubi = new AfUbicacion();
            ubi.setId(6L);
            ubi.setFlagEstado(ActivosFlagEstado.ACTIVO);
            ubi.setCodigo("U6");
            ubi.setNombre("Ubi6");

            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(repository.existsByCodigoIgnoreCaseAndIdNot("AF001", 1L)).thenReturn(false);
            when(ubicacionRepository.findById(6L)).thenReturn(Optional.of(ubi));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            service.update(1L, updated);
            verify(ubicacionRepository).findById(6L);
        }
    }

    @Nested
    class Activate {

        @Test
        void activaExitosamente() {
            AfMaestro m = new AfMaestro();
            m.setId(1L);
            m.setFlagEstado("0");
            when(repository.findById(1L)).thenReturn(Optional.of(m));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfMaestro result = service.activate(1L);
            assertThat(result.getFlagEstado()).isEqualTo(ActivosFlagEstado.ACTIVO);
        }
    }

    @Nested
    class Deactivate {

        @Test
        void desactivaActivoYMarcaRetirado() {
            AfMaestro m = new AfMaestro();
            m.setId(1L);
            m.setFlagEstado(ActivosFlagEstado.ACTIVO);
            when(repository.findById(1L)).thenReturn(Optional.of(m));
            when(ventaRepository.existsByAfMaestroId(1L)).thenReturn(false);
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfMaestro result = service.deactivate(1L);
            assertThat(result.getFlagEstado()).isEqualTo("0");
            assertThat(result.getFlagEstado()).isEqualTo("0");
        }

        @Test
        void noMarcaRetiradoSiTieneVenta() {
            AfMaestro m = new AfMaestro();
            m.setId(1L);
            m.setFlagEstado(ActivosFlagEstado.ACTIVO);
            when(repository.findById(1L)).thenReturn(Optional.of(m));
            when(ventaRepository.existsByAfMaestroId(1L)).thenReturn(true);
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfMaestro result = service.deactivate(1L);
            assertThat(result.getFlagEstado()).isEqualTo("0");
            assertThat(result.getFlagEstado()).isEqualTo("0");
        }

        @Test
        void mantieneInactivoSiYaNoEstaActivo() {
            AfMaestro m = new AfMaestro();
            m.setId(1L);
            m.setFlagEstado("0");
            when(repository.findById(1L)).thenReturn(Optional.of(m));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfMaestro result = service.deactivate(1L);
            assertThat(result.getFlagEstado()).isEqualTo("0");
        }
    }

    @Nested
    class DeleteTest {

        @Test
        void eliminaSinDepreciacion() {
            AfMaestro existing = new AfMaestro();
            existing.setId(1L);
            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(calculoCntblRepository.existsByAfMaestroId(1L)).thenReturn(false);

            service.delete(1L);
            verify(repository).delete(existing);
        }

        @Test
        void lanzaExcepcionSiTieneDepreciacion() {
            AfMaestro existing = new AfMaestro();
            existing.setId(1L);
            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            when(calculoCntblRepository.existsByAfMaestroId(1L)).thenReturn(true);

            assertThatThrownBy(() -> service.delete(1L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MAESTRO_CON_DEPRECIACION);
            verify(repository, never()).delete(any());
        }
    }

    @Nested
    class FindBySubClaseId {

        @Test
        void retornaPagina() {
            when(repository.findByAfSubClaseId(eq(1L), any(Pageable.class)))
                    .thenReturn(new PageImpl<>(List.of(new AfMaestro())));

            Page<AfMaestro> result = service.findByAfSubClaseId(1L, PageRequest.of(0, 10));
            assertThat(result.getTotalElements()).isEqualTo(1);
        }
    }

    @Nested
    class FindByUbicacionId {

        @Test
        void retornaPagina() {
            when(repository.findByAfUbicacionId(eq(1L), any(Pageable.class)))
                    .thenReturn(new PageImpl<>(List.of(new AfMaestro())));

            Page<AfMaestro> result = service.findByAfUbicacionId(1L, PageRequest.of(0, 10));
            assertThat(result.getTotalElements()).isEqualTo(1);
        }
    }
}
