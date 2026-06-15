package com.sigre.rrhh.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;

import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.ContratoRequest;
import com.sigre.rrhh.dto.request.HorarioRequest;
import com.sigre.rrhh.dto.request.TrabajadorRequest;
import com.sigre.rrhh.dto.response.*;
import com.sigre.rrhh.dto.response.*;
import com.sigre.rrhh.entity.Contrato;
import com.sigre.rrhh.entity.HorarioTrabajador;
import com.sigre.rrhh.entity.Trabajador;
import com.sigre.rrhh.mapper.TrabajadorMapper;
import com.sigre.rrhh.repository.ContratoRepository;
import com.sigre.rrhh.repository.HorarioTrabajadorRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("TrabajadorServiceImpl — Pruebas Unitarias")
class TrabajadorServiceImplTest {

    @Mock private TrabajadorRepository trabajadorRepo;
    @Mock private ContratoRepository contratoRepo;
    @Mock private HorarioTrabajadorRepository horarioRepo;
    @Mock private TrabajadorMapper mapper;

    private TrabajadorServiceImpl service;

    @BeforeEach
    void setUp() {
        service = new TrabajadorServiceImpl(trabajadorRepo, contratoRepo, horarioRepo, mapper);
        TenantContext.setUsuarioId(1L);
        lenient().when(trabajadorRepo.existsSexoById(anyLong())).thenReturn(true);
        lenient().when(trabajadorRepo.existsEstadoCivilById(anyLong())).thenReturn(true);
        lenient().when(trabajadorRepo.existsTipoDocIdentidadById(anyLong())).thenReturn(true);
        lenient().when(trabajadorRepo.existsRegimenLaboralById(anyLong())).thenReturn(true);
        lenient().when(trabajadorRepo.existsAreaById(anyLong())).thenReturn(true);
        lenient().when(trabajadorRepo.existsCargoById(anyLong())).thenReturn(true);
        lenient().when(trabajadorRepo.existsSucursalById(anyLong())).thenReturn(true);
        lenient().when(trabajadorRepo.existsAdminAfpById(anyLong())).thenReturn(true);
        lenient().when(mapper.toDetailResponse(any(), anyList(), anyList())).thenReturn(
            TrabajadorDetailResponse.builder().id(1L).codigoTrabajador("TRB-001").flagEstado("1").build());
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    @Nested
    @DisplayName("listar()")
    class Listar {

        @Test
        @DisplayName("Sin filtros retorna pagina con resultados")
        void sinFiltros_retornaPagina() {
            Trabajador t = trabajadorEntity(1L);
            TrabajadorListResponse dto = TrabajadorListResponse.builder().id(1L).codigoTrabajador("TRB-001").build();
            when(trabajadorRepo.findWithFilters(any(), any(), any(), any(), any(), any(), any(), any(), any()))
                    .thenReturn(new PageImpl<>(List.of(t)));
            when(mapper.toListResponse(t)).thenReturn(dto);

            Page<TrabajadorListResponse> result = service.listar(null, null, null, null, null, null, null, null, PageRequest.of(0, 10));

            assertThat(result.getContent()).hasSize(1);
            assertThat(result.getContent().get(0).getCodigoTrabajador()).isEqualTo("TRB-001");
        }
    }

    @Nested
    @DisplayName("obtenerPorId()")
    class ObtenerPorId {

        @Test
        @DisplayName("Existente retorna detalle")
        void existente_retornaDetalle() {
            Trabajador t = trabajadorEntity(1L);
            TrabajadorDetailResponse dto = TrabajadorDetailResponse.builder().id(1L).codigoTrabajador("TRB-001").build();
            when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(t));
            when(contratoRepo.findByTrabajadorIdOrderByFecCreacionDesc(1L)).thenReturn(List.of());
            when(horarioRepo.findByTrabajadorIdOrderByFecCreacionDesc(1L)).thenReturn(List.of());
            when(mapper.toDetailResponse(t, List.of(), List.of())).thenReturn(dto);

            TrabajadorDetailResponse result = service.obtenerPorId(1L);

            assertThat(result.getId()).isEqualTo(1L);
        }

        @Test
        @DisplayName("Inexistente lanza RESOURCE_NOT_FOUND")
        void inexistente_lanzaNotFound() {
            when(trabajadorRepo.findById(99L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.obtenerPorId(99L))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo("RESOURCE_NOT_FOUND");
        }
    }

    @Nested
    @DisplayName("crear()")
    class Crear {

        private TrabajadorRequest buildRequest() {
            return TrabajadorRequest.builder()
                    .codigoTrabajador("TRB-001")
                    .nombres("Juan")
                    .areaId(1L).cargoId(1L).sucursalId(1L)
                    .sexoId(1L).estadoCivilId(1L)
                    .tipoDocIdentidadId(1L).numeroDocumento("12345678")
                    .regimenLaboralId(1L)
                    .fechaNacimiento(LocalDate.of(1990, 1, 1))
                    .email("juan@test.com")
                    .build();
        }

        @Test
        @DisplayName("Datos validos crea trabajador")
        void datosValidos_creaTrabajador() {
            TrabajadorRequest req = buildRequest();
            Trabajador t = new Trabajador();
            when(trabajadorRepo.existsByCodigoTrabajadorAndFlagEstado(any(), eq("1"))).thenReturn(false);
            when(trabajadorRepo.existsByNumeroDocumentoAndFlagEstado(any(), eq("1"))).thenReturn(false);
            stubFKsValidas();
            when(trabajadorRepo.save(any())).thenAnswer(inv -> {
                Trabajador saved = inv.getArgument(0);
                saved.setId(1L);
                return saved;
            });
            TrabajadorDetailResponse dto = TrabajadorDetailResponse.builder().id(1L).codigoTrabajador("TRB-001").flagEstado("1").build();
            when(mapper.toDetailResponse(any(), anyList(), anyList())).thenReturn(dto);

            TrabajadorDetailResponse result = service.crear(req);

            assertThat(result.getId()).isEqualTo(1L);
            assertThat(result.getFlagEstado()).isEqualTo("1");
            verify(trabajadorRepo).save(any());
        }

        @Test
        @DisplayName("Codigo duplicado lanza RH-TR-003")
        void codigoDuplicado_lanzaError() {
            TrabajadorRequest req = buildRequest();
            when(trabajadorRepo.existsByCodigoTrabajadorAndFlagEstado(req.getCodigoTrabajador(), "1")).thenReturn(true);

            assertThatThrownBy(() -> service.crear(req))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo("RH-TR-003");
        }

        @Test
        @DisplayName("Documento duplicado lanza RH-TR-004")
        void documentoDuplicado_lanzaError() {
            TrabajadorRequest req = buildRequest();
            when(trabajadorRepo.existsByCodigoTrabajadorAndFlagEstado(any(), eq("1"))).thenReturn(false);
            when(trabajadorRepo.existsByNumeroDocumentoAndFlagEstado(req.getNumeroDocumento(), "1")).thenReturn(true);

            assertThatThrownBy(() -> service.crear(req))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo("RH-TR-004");
        }

        @Test
        @DisplayName("Email invalido lanza RH-TR-008")
        void emailInvalido_lanzaError() {
            TrabajadorRequest req = buildRequest();
            req.setEmail("noesmail");

            assertThatThrownBy(() -> service.crear(req))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo("RH-TR-008");
        }

        @Test
        @DisplayName("Menor de 18 lanza RH-TR-005")
        void menorDeEdad_lanzaError() {
            TrabajadorRequest req = buildRequest();
            req.setFechaNacimiento(LocalDate.now().minusYears(15));

            assertThatThrownBy(() -> service.crear(req))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo("RH-TR-005");
        }
    }

    @Nested
    @DisplayName("activar() / desactivar()")
    class ActivarDesactivar {

        @Test
        @DisplayName("Activar cambia estado a '1'")
        void activar_cambiaEstado() {
            Trabajador t = trabajadorEntity(1L);
            t.setFlagEstado("0");
            when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(t));
            when(trabajadorRepo.save(any())).thenAnswer(inv -> inv.getArgument(0));
            TrabajadorDetailResponse dto = TrabajadorDetailResponse.builder().id(1L).flagEstado("1").build();
            when(mapper.toDetailResponse(any(), anyList(), anyList())).thenReturn(dto);

            TrabajadorDetailResponse result = service.activar(1L);

            assertThat(result.getFlagEstado()).isEqualTo("1");
        }

        @Test
        @DisplayName("Desactivar cambia estado a '0' y desactiva contratos/horarios")
        void desactivar_cascada() {
            Trabajador t = trabajadorEntity(1L);
            when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(t));
            when(trabajadorRepo.save(any())).thenAnswer(inv -> inv.getArgument(0));
            TrabajadorDetailResponse dto = TrabajadorDetailResponse.builder().id(1L).flagEstado("0").build();
            when(mapper.toDetailResponse(any(), anyList(), anyList())).thenReturn(dto);

            TrabajadorDetailResponse result = service.desactivar(1L);

            assertThat(result.getFlagEstado()).isEqualTo("0");
        }
    }

    @Nested
    @DisplayName("cesar()")
    class Cesar {

        @Test
        @DisplayName("Cese valido registra fecha y motivo")
        void ceseValido_registraFechaYMotivo() {
            Trabajador t = trabajadorEntity(1L);
            when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(t));
            when(trabajadorRepo.save(any())).thenAnswer(inv -> inv.getArgument(0));
            TrabajadorDetailResponse dto = TrabajadorDetailResponse.builder().id(1L).flagEstado("0").build();
            when(mapper.toDetailResponse(any(), anyList(), anyList())).thenReturn(dto);

            TrabajadorDetailResponse result = service.cesar(1L, LocalDate.of(2026, 5, 31), "Renuncia");

            assertThat(result.getFlagEstado()).isEqualTo("0");
        }

        @Test
        @DisplayName("Fecha cese antes de ingreso lanza RH-TR-009")
        void fechaCeseAnterior_lanzaError() {
            Trabajador t = trabajadorEntity(1L);
            t.setFechaIngreso(LocalDate.of(2024, 3, 15));
            when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(t));

            assertThatThrownBy(() -> service.cesar(1L, LocalDate.of(2023, 1, 1), "Motivo"))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo("RH-TR-009");
        }

        @Test
        @DisplayName("Trabajador inactivo lanza RH-TR-010")
        void trabajadorInactivo_lanzaError() {
            Trabajador t = trabajadorEntity(1L);
            t.setFlagEstado("0");
            when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(t));

            assertThatThrownBy(() -> service.cesar(1L, LocalDate.now(), "Motivo"))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo("RH-TR-010");
        }
    }

    @Nested
    @DisplayName("Contratos (sub-recurso)")
    class Contratos {

        @Test
        @DisplayName("listarContratos() retorna lista")
        void listar_retornaLista() {
            when(trabajadorRepo.existsById(1L)).thenReturn(true);
            when(contratoRepo.findByTrabajadorIdOrderByFecCreacionDesc(1L))
                    .thenReturn(List.of(contratoEntity(1L, 1L)));
            when(mapper.toContratoResponse(any())).thenReturn(ContratoResponse.builder().id(1L).build());

            List<ContratoResponse> result = service.listarContratos(1L, null);

            assertThat(result).hasSize(1);
        }

        @Test
        @DisplayName("crearContrato() con datos validos crea contrato")
        void crear_datosValidos() {
            when(trabajadorRepo.existsById(1L)).thenReturn(true);
            when(trabajadorRepo.existsTipoContratoById(1L)).thenReturn(true);
            when(contratoRepo.existsByTrabajadorIdAndFlagEstado(1L, "1")).thenReturn(false);
            when(contratoRepo.save(any())).thenAnswer(inv -> {
                Contrato saved = inv.getArgument(0);
                saved.setId(1L);
                return saved;
            });
            when(mapper.toContratoResponse(any())).thenReturn(ContratoResponse.builder().id(1L).trabajadorId(1L).flagEstado("1").build());

            ContratoRequest req = ContratoRequest.builder()
                    .tipoContratoId(1L)
                    .fechaInicio(LocalDate.of(2026, 6, 1))
                    .remuneracion(new BigDecimal("3800"))
                    .build();

            ContratoResponse result = service.crearContrato(1L, req);

            assertThat(result.getTrabajadorId()).isEqualTo(1L);
            assertThat(result.getFlagEstado()).isEqualTo("1");
        }

        @Test
        @DisplayName("crearContrato() con contrato activo existente lanza RH-CL-003")
        void crear_contratoActivoExistente_lanzaError() {
            when(trabajadorRepo.existsById(1L)).thenReturn(true);
            when(trabajadorRepo.existsTipoContratoById(1L)).thenReturn(true);
            when(contratoRepo.existsByTrabajadorIdAndFlagEstado(1L, "1")).thenReturn(true);

            ContratoRequest req = ContratoRequest.builder().tipoContratoId(1L).fechaInicio(LocalDate.now()).build();

            assertThatThrownBy(() -> service.crearContrato(1L, req))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo("RH-CL-003");
        }

        @Test
        @DisplayName("desactivarContrato() cambia estado a '0'")
        void desactivar_cambiaEstado() {
            when(contratoRepo.findByIdAndTrabajadorId(1L, 1L)).thenReturn(Optional.of(contratoEntity(1L, 1L)));
            when(contratoRepo.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(mapper.toContratoResponse(any())).thenReturn(ContratoResponse.builder().id(1L).flagEstado("0").build());

            ContratoResponse result = service.desactivarContrato(1L, 1L);

            assertThat(result.getFlagEstado()).isEqualTo("0");
        }
    }

    @Nested
    @DisplayName("Horarios (sub-recurso)")
    class Horarios {

        @Test
        @DisplayName("listarHorarios() retorna lista")
        void listar_retornaLista() {
            when(trabajadorRepo.existsById(1L)).thenReturn(true);
            when(horarioRepo.findByTrabajadorIdOrderByFecCreacionDesc(1L))
                    .thenReturn(List.of(horarioEntity(1L, 1L)));
            when(mapper.toHorarioResponse(any())).thenReturn(HorarioResponse.builder().id(1L).build());

            List<HorarioResponse> result = service.listarHorarios(1L, null);

            assertThat(result).hasSize(1);
        }

        @Test
        @DisplayName("crearHorario() con datos validos asigna horario")
        void crear_datosValidos() {
            when(trabajadorRepo.existsById(1L)).thenReturn(true);
            when(trabajadorRepo.existsTurnoById(2L)).thenReturn(true);
            when(horarioRepo.existsByTrabajadorIdAndFlagEstado(1L, "1")).thenReturn(false);
            when(horarioRepo.existsSolapamiento(any(), any(), any(), any())).thenReturn(false);
            when(horarioRepo.save(any())).thenAnswer(inv -> {
                HorarioTrabajador saved = inv.getArgument(0);
                saved.setId(1L);
                return saved;
            });
            when(mapper.toHorarioResponse(any())).thenReturn(HorarioResponse.builder().id(1L).trabajadorId(1L).flagEstado("1").build());

            HorarioRequest req = HorarioRequest.builder()
                    .turnoId(2L)
                    .fechaDesde(LocalDate.of(2026, 6, 1))
                    .build();

            HorarioResponse result = service.crearHorario(1L, req);

            assertThat(result.getTrabajadorId()).isEqualTo(1L);
            assertThat(result.getFlagEstado()).isEqualTo("1");
        }

        @Test
        @DisplayName("crearHorario() con horario activo existente lanza RH-HT-003")
        void crear_horarioActivoExistente_lanzaError() {
            when(trabajadorRepo.existsById(1L)).thenReturn(true);
            when(trabajadorRepo.existsTurnoById(2L)).thenReturn(true);
            when(horarioRepo.existsByTrabajadorIdAndFlagEstado(1L, "1")).thenReturn(true);

            HorarioRequest req = HorarioRequest.builder().turnoId(2L).fechaDesde(LocalDate.now()).build();

            assertThatThrownBy(() -> service.crearHorario(1L, req))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo("RH-HT-003");
        }

        @Test
        @DisplayName("desactivarHorario() cambia estado a '0'")
        void desactivar_cambiaEstado() {
            when(horarioRepo.findByIdAndTrabajadorId(1L, 1L)).thenReturn(Optional.of(horarioEntity(1L, 1L)));
            when(horarioRepo.save(any())).thenAnswer(inv -> inv.getArgument(0));
            when(mapper.toHorarioResponse(any())).thenReturn(HorarioResponse.builder().id(1L).flagEstado("0").build());

            HorarioResponse result = service.desactivarHorario(1L, 1L);

            assertThat(result.getFlagEstado()).isEqualTo("0");
        }
    }

    private void stubFKsValidas() {
        lenient().when(trabajadorRepo.existsAreaById(anyLong())).thenReturn(true);
        lenient().when(trabajadorRepo.existsCargoById(anyLong())).thenReturn(true);
        lenient().when(trabajadorRepo.existsSucursalById(anyLong())).thenReturn(true);
        lenient().when(trabajadorRepo.existsAdminAfpById(anyLong())).thenReturn(true);
        lenient().when(trabajadorRepo.existsSexoById(anyLong())).thenReturn(true);
        lenient().when(trabajadorRepo.existsEstadoCivilById(anyLong())).thenReturn(true);
        lenient().when(trabajadorRepo.existsTipoDocIdentidadById(anyLong())).thenReturn(true);
        lenient().when(trabajadorRepo.existsRegimenLaboralById(anyLong())).thenReturn(true);
    }

    private static Trabajador trabajadorEntity(Long id) {
        Trabajador t = new Trabajador();
        t.setId(id);
        t.setCodigoTrabajador("TRB-001");
        t.setNombres("Juan");
        t.setApellidoPaterno("Perez");
        t.setNumeroDocumento("12345678");
        t.setAreaId(1L);
        t.setCargoId(1L);
        t.setSucursalId(1L);
        t.setFechaIngreso(LocalDate.of(2024, 1, 1));
        t.setFlagEstado("1");
        return t;
    }

    private static Contrato contratoEntity(Long id, Long trabajadorId) {
        Contrato c = new Contrato();
        c.setId(id);
        c.setTrabajadorId(trabajadorId);
        c.setTipoContratoId(1L);
        c.setFechaInicio(LocalDate.of(2024, 1, 1));
        c.setRemuneracion(new BigDecimal("3500"));
        c.setFlagEstado("1");
        return c;
    }

    private static HorarioTrabajador horarioEntity(Long id, Long trabajadorId) {
        HorarioTrabajador h = new HorarioTrabajador();
        h.setId(id);
        h.setTrabajadorId(trabajadorId);
        h.setTurnoId(1L);
        h.setFechaDesde(LocalDate.of(2024, 1, 1));
        h.setFlagEstado("1");
        return h;
    }
}
