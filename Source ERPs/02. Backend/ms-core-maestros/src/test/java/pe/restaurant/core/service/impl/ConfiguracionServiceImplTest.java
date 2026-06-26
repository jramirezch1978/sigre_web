package pe.restaurant.core.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.jdbc.core.JdbcTemplate;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.dto.*;
import pe.restaurant.core.entity.Configuracion;
import pe.restaurant.core.entity.ConfiguracionUsuario;
import pe.restaurant.common.service.ConfigParameterService;
import pe.restaurant.core.repository.ConfiguracionRepository;
import pe.restaurant.core.repository.ConfiguracionUsuarioRepository;
import pe.restaurant.core.repository.SucursalRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ConfiguracionServiceImplTest {

    @Mock private ConfiguracionRepository configuracionRepository;
    @Mock private ConfiguracionUsuarioRepository configuracionUsuarioRepository;
    @Mock private SucursalRepository sucursalRepository;
    @Mock private JdbcTemplate securityJdbcTemplate;
    @Mock private ConfigParameterService configParameterService;

    @InjectMocks private ConfiguracionServiceImpl service;

    private Configuracion cfg;

    @BeforeEach
    void setUp() {
        cfg = new Configuracion();
        cfg.setParametro("EMPRESA_1_IGV");
        cfg.setModulo("VENTAS");
        cfg.setTipoDato("STRING");
        cfg.setValorTexto("18");
    }

    @Nested
    class ListClaves {
        @Test
        void allClavesNoFilter() {
            when(configuracionRepository.findAll()).thenReturn(List.of(cfg));
            var result = service.listClaves(null, null, null);
            assertThat(result).hasSize(1);
            assertThat(result.get(0).getClave()).isEqualTo("EMPRESA_1_IGV");
        }

        @Test
        void filterByModulo() {
            when(configuracionRepository.findByModulo("VENTAS")).thenReturn(List.of(cfg));
            var result = service.listClaves("VENTAS", null, null);
            assertThat(result).hasSize(1);
        }

        @Test
        void filterByNivel() {
            when(configuracionRepository.findAll()).thenReturn(List.of(cfg));
            var result = service.listClaves(null, "EMPRESA", null);
            assertThat(result).hasSize(1);
        }

        @Test
        void filterByNivelNoMatch() {
            when(configuracionRepository.findAll()).thenReturn(List.of(cfg));
            var result = service.listClaves(null, "SUCURSAL", null);
            assertThat(result).isEmpty();
        }

        @Test
        void filterByFlagEstado() {
            when(configuracionRepository.findAll()).thenReturn(List.of(cfg));
            var result = service.listClaves(null, null, "1");
            assertThat(result).hasSize(1);
        }

        @Test
        void filterByFlagEstadoNoMatch() {
            when(configuracionRepository.findAll()).thenReturn(List.of(cfg));
            var result = service.listClaves(null, null, "0");
            assertThat(result).isEmpty();
        }
    }

    @Nested
    class Resolver {
        @Test
        void returnsDefaultWhenNoContext() {
            when(configParameterService.getRrhhText("GENERAL", "IGV")).thenReturn(null);
            when(configParameterService.getText("IGV", null)).thenReturn("18");
            var result = service.resolver(new ConfigResolverRequest("IGV", null));
            assertThat(result.getValor()).isEqualTo("18");
            assertThat(result.getOrigenNivel()).isEqualTo("EMPRESA");
        }

        @Test
        void returnsNullWhenNoConfigFound() {
            when(configParameterService.getRrhhText("GENERAL", "NOT_EXIST")).thenReturn(null);
            when(configParameterService.getText("NOT_EXIST", null)).thenReturn(null);
            var result = service.resolver(new ConfigResolverRequest("NOT_EXIST", null));
            assertThat(result.getValor()).isNull();
        }

        @Test
        void returnsUsuarioLevelWhenAvailable() {
            ConfigResolverContext ctx = new ConfigResolverContext();
            ctx.setUsuarioId(10L);
            ctx.setSucursalId(1L);
            ctx.setEmpresaId(1L);
            ConfiguracionUsuario userCfg = new ConfiguracionUsuario();
            userCfg.setValorTexto("user_val");
            when(configuracionUsuarioRepository.findByUsuarioIdAndParametroAndFlagEstado(
                    eq(10L), eq("USUARIO_10_THEME"), eq("1"))).thenReturn(Optional.of(userCfg));

            var result = service.resolver(new ConfigResolverRequest("THEME", ctx));
            assertThat(result.getValor()).isEqualTo("user_val");
            assertThat(result.getOrigenNivel()).isEqualTo("USUARIO");
        }

        @Test
        void returnsSucursalLevelWhenNoUsuario() {
            ConfigResolverContext ctx = new ConfigResolverContext();
            ctx.setUsuarioId(10L);
            ctx.setSucursalId(5L);
            ctx.setEmpresaId(1L);
            when(configuracionUsuarioRepository.findByUsuarioIdAndParametroAndFlagEstado(
                    eq(10L), anyString(), eq("1"))).thenReturn(Optional.empty());
            when(configParameterService.getRrhhText("GENERAL", "SUCURSAL_5_KEY"))
                    .thenReturn("suc_val");

            var result = service.resolver(new ConfigResolverRequest("KEY", ctx));
            assertThat(result.getValor()).isEqualTo("suc_val");
            assertThat(result.getOrigenNivel()).isEqualTo("SUCURSAL");
        }

        @Test
        void returnsPaisLevelWhenNoSucursal() {
            ConfigResolverContext ctx = new ConfigResolverContext();
            ctx.setPaisId(100L);
            ctx.setEmpresaId(1L);
            when(configParameterService.getRrhhText("GENERAL", "PAIS_100_TAX"))
                    .thenReturn("pais_val");

            var result = service.resolver(new ConfigResolverRequest("TAX", ctx));
            assertThat(result.getValor()).isEqualTo("pais_val");
            assertThat(result.getOrigenNivel()).isEqualTo("PAIS");
        }

        @Test
        void returnsEmpresaLevelWhenNoPais() {
            ConfigResolverContext ctx = new ConfigResolverContext();
            ctx.setEmpresaId(1L);
            when(configParameterService.getRrhhText("GENERAL", "EMPRESA_1_MODE"))
                    .thenReturn("emp_val");

            var result = service.resolver(new ConfigResolverRequest("MODE", ctx));
            assertThat(result.getValor()).isEqualTo("emp_val");
            assertThat(result.getOrigenNivel()).isEqualTo("EMPRESA");
        }

        @Test
        void fallsToDefaultWhenNoEmpresaMatch() {
            ConfigResolverContext ctx = new ConfigResolverContext();
            ctx.setEmpresaId(1L);
            when(configParameterService.getRrhhText("GENERAL", "EMPRESA_1_X")).thenReturn(null);
            when(configParameterService.getRrhhText("GENERAL", "X")).thenReturn(null);
            when(configParameterService.getText("X", null)).thenReturn("18");

            var result = service.resolver(new ConfigResolverRequest("X", ctx));
            assertThat(result.getValor()).isEqualTo("18");
        }
    }

    @Nested
    class GetEmpresa {
        @Test
        void returnsFilteredByPrefix() {
            Configuracion c = new Configuracion();
            c.setParametro("EMPRESA_1_IGV");
            c.setValorTexto("18");
            when(configuracionRepository.findAll()).thenReturn(List.of(c));
            when(configParameterService.getRrhhText("GENERAL", "EMPRESA_1_IGV")).thenReturn("18");

            var result = service.getEmpresa(1L, null);
            assertThat(result).containsEntry("IGV", "18");
        }

        @Test
        void filtersWithClavesParam() {
            when(configParameterService.getRrhhText("GENERAL", "EMPRESA_1_IGV")).thenReturn("18");

            var result = service.getEmpresa(1L, List.of("IGV"));
            assertThat(result).containsEntry("IGV", "18").doesNotContainKey("RUC");
        }

        @Test
        void returnsEmptyWhenNoMatch() {
            when(configuracionRepository.findAll()).thenReturn(List.of());
            var result = service.getEmpresa(1L, null);
            assertThat(result).isEmpty();
        }
    }

    @Nested
    class SaveEmpresa {
        @Test
        void savesNewConfig() {
            when(securityJdbcTemplate.queryForObject(anyString(), eq(Integer.class), any(Object.class))).thenReturn(1);
            when(configuracionRepository.findByParametro("EMPRESA_1_IGV")).thenReturn(Optional.empty());
            when(configuracionRepository.save(any(Configuracion.class))).thenAnswer(i -> i.getArgument(0));
            when(configuracionRepository.findAll()).thenReturn(List.of());

            var result = service.saveEmpresa(new ConfigEmpresaSaveRequest(1L, Map.of("IGV", "18")));
            assertThat(result).isNotNull();
            verify(configuracionRepository).save(any());
        }

        @Test
        void updatesExistingConfig() {
            when(securityJdbcTemplate.queryForObject(anyString(), eq(Integer.class), any(Object.class))).thenReturn(1);
            Configuracion existing = new Configuracion();
            existing.setParametro("EMPRESA_1_IGV");
            when(configuracionRepository.findByParametro("EMPRESA_1_IGV")).thenReturn(Optional.of(existing));
            when(configuracionRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(configuracionRepository.findAll()).thenReturn(List.of());

            service.saveEmpresa(new ConfigEmpresaSaveRequest(1L, Map.of("IGV", "20")));
            verify(configuracionRepository).save(argThat(c -> "20".equals(c.getValorTexto())));
        }

        @Test
        void throwsWhenEmpresaNotFound() {
            when(securityJdbcTemplate.queryForObject(anyString(), eq(Integer.class), any(Object.class))).thenReturn(0);

            assertThatThrownBy(() -> service.saveEmpresa(new ConfigEmpresaSaveRequest(99L, Map.of("X", "Y"))))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenEmpresaCountNull() {
            when(securityJdbcTemplate.queryForObject(anyString(), eq(Integer.class), any(Object.class))).thenReturn(null);

            assertThatThrownBy(() -> service.saveEmpresa(new ConfigEmpresaSaveRequest(99L, Map.of("X", "Y"))))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void savesNullValue() {
            when(securityJdbcTemplate.queryForObject(anyString(), eq(Integer.class), any(Object.class))).thenReturn(1);
            when(configuracionRepository.findByParametro("EMPRESA_1_KEY")).thenReturn(Optional.empty());
            when(configuracionRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(configuracionRepository.findAll()).thenReturn(List.of());

            java.util.HashMap<String, Object> valores = new java.util.HashMap<>();
            valores.put("KEY", null);
            service.saveEmpresa(new ConfigEmpresaSaveRequest(1L, valores));
            verify(configuracionRepository).save(argThat(c -> c.getValorTexto() == null));
        }
    }

    @Nested
    class GetSucursal {
        @Test
        void returnsValues() {
            Configuracion c = new Configuracion();
            c.setParametro("SUCURSAL_5_ALMACEN");
            c.setValorTexto("ALM01");
            when(configuracionRepository.findAll()).thenReturn(List.of(c));
            when(configParameterService.getRrhhText("GENERAL", "SUCURSAL_5_ALMACEN")).thenReturn("ALM01");

            var result = service.getSucursal(1L, 5L, null);
            assertThat(result).containsEntry("ALMACEN", "ALM01");
        }

        @Test
        void filtersByClaves() {
            when(configParameterService.getRrhhText("GENERAL", "SUCURSAL_5_A")).thenReturn("V1");

            var result = service.getSucursal(1L, 5L, List.of("A"));
            assertThat(result).containsEntry("A", "V1").doesNotContainKey("B");
        }
    }

    @Nested
    class SaveSucursal {
        @Test
        void savesSuccessfully() {
            when(sucursalRepository.existsById(5L)).thenReturn(true);
            when(configuracionRepository.findByParametro("SUCURSAL_5_KEY")).thenReturn(Optional.empty());
            when(configuracionRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(configuracionRepository.findAll()).thenReturn(List.of());

            var request = new ConfigSucursalSaveRequest(1L, 5L, Map.of("KEY", "VAL"));
            service.saveSucursal(request);
            verify(configuracionRepository).save(any());
        }

        @Test
        void throwsWhenSucursalNotFound() {
            when(sucursalRepository.existsById(99L)).thenReturn(false);

            assertThatThrownBy(() -> service.saveSucursal(new ConfigSucursalSaveRequest(1L, 99L, Map.of("X", "Y"))))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class GetUsuario {
        @Test
        void returnsUserConfigs() {
            ConfiguracionUsuario cu = new ConfiguracionUsuario();
            cu.setParametro("USUARIO_10_THEME");
            cu.setValorTexto("dark");
            cu.setFlagEstado("1");
            when(configuracionUsuarioRepository.findByUsuarioIdAndFlagEstado(10L, "1")).thenReturn(List.of(cu));

            var result = service.getUsuario(1L, 10L, null, null);
            assertThat(result).containsEntry("THEME", "dark");
        }

        @Test
        void filtersByClaves() {
            ConfiguracionUsuario cu1 = new ConfiguracionUsuario();
            cu1.setParametro("USUARIO_10_THEME");
            cu1.setValorTexto("dark");
            cu1.setFlagEstado("1");
            ConfiguracionUsuario cu2 = new ConfiguracionUsuario();
            cu2.setParametro("USUARIO_10_LANG");
            cu2.setValorTexto("es");
            cu2.setFlagEstado("1");
            when(configuracionUsuarioRepository.findByUsuarioIdAndFlagEstado(10L, "1")).thenReturn(List.of(cu1, cu2));

            var result = service.getUsuario(1L, 10L, null, List.of("THEME"));
            assertThat(result).containsKey("THEME").doesNotContainKey("LANG");
        }

        @Test
        void returnsEnteroValue() {
            ConfiguracionUsuario cu = new ConfiguracionUsuario();
            cu.setParametro("USUARIO_10_ROWS");
            cu.setValorEntero(50);
            cu.setFlagEstado("1");
            when(configuracionUsuarioRepository.findByUsuarioIdAndFlagEstado(10L, "1")).thenReturn(List.of(cu));

            var result = service.getUsuario(1L, 10L, null, null);
            assertThat(result).containsEntry("ROWS", 50);
        }

        @Test
        void returnsDecimalValue() {
            ConfiguracionUsuario cu = new ConfiguracionUsuario();
            cu.setParametro("USUARIO_10_RATE");
            cu.setValorDecimal(new BigDecimal("3.14"));
            cu.setFlagEstado("1");
            when(configuracionUsuarioRepository.findByUsuarioIdAndFlagEstado(10L, "1")).thenReturn(List.of(cu));

            var result = service.getUsuario(1L, 10L, null, null);
            assertThat(result).containsEntry("RATE", new BigDecimal("3.14"));
        }

        @Test
        void returnsFechaValue() {
            ConfiguracionUsuario cu = new ConfiguracionUsuario();
            cu.setParametro("USUARIO_10_START");
            cu.setValorFecha(LocalDate.of(2025, 1, 1));
            cu.setFlagEstado("1");
            when(configuracionUsuarioRepository.findByUsuarioIdAndFlagEstado(10L, "1")).thenReturn(List.of(cu));

            var result = service.getUsuario(1L, 10L, null, null);
            assertThat(result).containsEntry("START", LocalDate.of(2025, 1, 1));
        }

        @Test
        void returnsNullWhenAllValuesNull() {
            ConfiguracionUsuario cu = new ConfiguracionUsuario();
            cu.setParametro("USUARIO_10_EMPTY");
            cu.setFlagEstado("1");
            when(configuracionUsuarioRepository.findByUsuarioIdAndFlagEstado(10L, "1")).thenReturn(List.of(cu));

            var result = service.getUsuario(1L, 10L, null, null);
            assertThat(result).containsEntry("EMPTY", null);
        }
    }

    @Nested
    class SaveUsuario {
        @Test
        void savesNewUsuarioConfig() {
            when(securityJdbcTemplate.queryForObject(contains("auth.usuario"), eq(Integer.class), any(Object.class))).thenReturn(1);
            when(configuracionUsuarioRepository.findByUsuarioIdAndParametroAndFlagEstado(eq(10L), eq("USUARIO_10_THEME"), eq("1")))
                    .thenReturn(Optional.empty());
            when(configuracionUsuarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(configuracionUsuarioRepository.findByUsuarioIdAndFlagEstado(10L, "1")).thenReturn(List.of());

            var request = new ConfigUsuarioSaveRequest(1L, 10L, null, Map.of("THEME", "dark"));
            service.saveUsuario(request);
            verify(configuracionUsuarioRepository).save(any());
        }

        @Test
        void updatesExistingUsuarioConfig() {
            when(securityJdbcTemplate.queryForObject(contains("auth.usuario"), eq(Integer.class), any(Object.class))).thenReturn(1);
            ConfiguracionUsuario existing = new ConfiguracionUsuario();
            existing.setParametro("USUARIO_10_THEME");
            when(configuracionUsuarioRepository.findByUsuarioIdAndParametroAndFlagEstado(eq(10L), eq("USUARIO_10_THEME"), eq("1")))
                    .thenReturn(Optional.of(existing));
            when(configuracionUsuarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(configuracionUsuarioRepository.findByUsuarioIdAndFlagEstado(10L, "1")).thenReturn(List.of());

            var request = new ConfigUsuarioSaveRequest(1L, 10L, null, Map.of("THEME", "light"));
            service.saveUsuario(request);
            verify(configuracionUsuarioRepository).save(argThat(c -> "light".equals(c.getValorTexto())));
        }

        @Test
        void throwsWhenUsuarioNotFound() {
            when(securityJdbcTemplate.queryForObject(contains("auth.usuario"), eq(Integer.class), any(Object.class))).thenReturn(0);

            assertThatThrownBy(() -> service.saveUsuario(new ConfigUsuarioSaveRequest(1L, 99L, null, Map.of("X", "Y"))))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void throwsWhenUsuarioCountNull() {
            when(securityJdbcTemplate.queryForObject(contains("auth.usuario"), eq(Integer.class), any(Object.class))).thenReturn(null);

            assertThatThrownBy(() -> service.saveUsuario(new ConfigUsuarioSaveRequest(1L, 99L, null, Map.of("X", "Y"))))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void savesNullValue() {
            when(securityJdbcTemplate.queryForObject(contains("auth.usuario"), eq(Integer.class), any(Object.class))).thenReturn(1);
            when(configuracionUsuarioRepository.findByUsuarioIdAndParametroAndFlagEstado(eq(10L), eq("USUARIO_10_KEY"), eq("1")))
                    .thenReturn(Optional.empty());
            when(configuracionUsuarioRepository.save(any())).thenAnswer(i -> i.getArgument(0));
            when(configuracionUsuarioRepository.findByUsuarioIdAndFlagEstado(10L, "1")).thenReturn(List.of());

            java.util.HashMap<String, Object> valores = new java.util.HashMap<>();
            valores.put("KEY", null);
            var request = new ConfigUsuarioSaveRequest(1L, 10L, null, valores);
            service.saveUsuario(request);
            verify(configuracionUsuarioRepository).save(argThat(c -> c.getValorTexto() == null));
        }
    }

    @Nested
    class ExtractValueConfiguracion {
        @Test
        void returnsEntero() {
            Configuracion c = new Configuracion();
            c.setParametro("EMPRESA_1_ROWS");
            c.setValorEntero(25);
            when(configuracionRepository.findAll()).thenReturn(List.of(c));
            when(configParameterService.getRrhhText("GENERAL", "EMPRESA_1_ROWS")).thenReturn(null);
            when(configParameterService.getRrhhInt("GENERAL", "EMPRESA_1_ROWS", null)).thenReturn(25);

            var result = service.getEmpresa(1L, null);
            assertThat(result).containsEntry("ROWS", 25);
        }

        @Test
        void returnsDecimal() {
            Configuracion c = new Configuracion();
            c.setParametro("EMPRESA_1_RATE");
            c.setValorDecimal(new BigDecimal("0.18"));
            when(configuracionRepository.findAll()).thenReturn(List.of(c));
            when(configParameterService.getRrhhText("GENERAL", "EMPRESA_1_RATE")).thenReturn(null);
            when(configParameterService.getRrhhInt("GENERAL", "EMPRESA_1_RATE", null)).thenReturn(null);
            when(configParameterService.getRrhhDec("GENERAL", "EMPRESA_1_RATE", null))
                    .thenReturn(new BigDecimal("0.18"));

            var result = service.getEmpresa(1L, null);
            assertThat(result).containsEntry("RATE", new BigDecimal("0.18"));
        }

        @Test
        void returnsFecha() {
            Configuracion c = new Configuracion();
            c.setParametro("EMPRESA_1_DATE");
            c.setValorFecha(LocalDate.of(2025, 6, 1));
            when(configuracionRepository.findAll()).thenReturn(List.of(c));
            when(configParameterService.getRrhhText("GENERAL", "EMPRESA_1_DATE")).thenReturn("2025-06-01");

            var result = service.getEmpresa(1L, null);
            assertThat(result).containsEntry("DATE", "2025-06-01");
        }

        @Test
        void returnsNullWhenAllFieldsNull() {
            Configuracion c = new Configuracion();
            c.setParametro("EMPRESA_1_NIL");
            when(configuracionRepository.findAll()).thenReturn(List.of(c));
            when(configParameterService.getRrhhText("GENERAL", "EMPRESA_1_NIL")).thenReturn(null);
            when(configParameterService.getRrhhInt("GENERAL", "EMPRESA_1_NIL", null)).thenReturn(null);
            when(configParameterService.getRrhhDec("GENERAL", "EMPRESA_1_NIL", null)).thenReturn(null);

            var result = service.getEmpresa(1L, null);
            assertThat(result).containsEntry("NIL", null);
        }
    }

    @Nested
    class InferNivel {
        @Test
        void infersUsuario() {
            Configuracion c = new Configuracion();
            c.setParametro("USUARIO_1_X");
            c.setModulo("GENERAL");
            c.setTipoDato("STRING");
            when(configuracionRepository.findAll()).thenReturn(List.of(c));

            var result = service.listClaves(null, null, null);
            assertThat(result.get(0).getNivel()).isEqualTo("USUARIO");
        }

        @Test
        void infersSucursal() {
            Configuracion c = new Configuracion();
            c.setParametro("SUCURSAL_1_Y");
            c.setModulo("GENERAL");
            c.setTipoDato("STRING");
            when(configuracionRepository.findAll()).thenReturn(List.of(c));

            var result = service.listClaves(null, null, null);
            assertThat(result.get(0).getNivel()).isEqualTo("SUCURSAL");
        }

        @Test
        void infersPais() {
            Configuracion c = new Configuracion();
            c.setParametro("PAIS_1_Z");
            c.setModulo("GENERAL");
            c.setTipoDato("STRING");
            when(configuracionRepository.findAll()).thenReturn(List.of(c));

            var result = service.listClaves(null, null, null);
            assertThat(result.get(0).getNivel()).isEqualTo("PAIS");
        }

        @Test
        void infersEmpresaDefault() {
            Configuracion c = new Configuracion();
            c.setParametro("OTHER_KEY");
            c.setModulo("GENERAL");
            c.setTipoDato("STRING");
            when(configuracionRepository.findAll()).thenReturn(List.of(c));

            var result = service.listClaves(null, null, null);
            assertThat(result.get(0).getNivel()).isEqualTo("EMPRESA");
        }
    }

    @Nested
    class StripScope {
        @Test
        void stripsNormalScope() {
            Configuracion c = new Configuracion();
            c.setParametro("EMPRESA_1_KEY");
            c.setValorTexto("val");
            when(configuracionRepository.findAll()).thenReturn(List.of(c));
            when(configParameterService.getRrhhText("GENERAL", "EMPRESA_1_KEY")).thenReturn("val");

            var result = service.getEmpresa(1L, null);
            assertThat(result).containsEntry("KEY", "val");
        }

        @Test
        void handlesNoUnderscore() {
            Configuracion c = new Configuracion();
            c.setParametro("EMPRESA_1_");
            c.setValorTexto("val");
            when(configuracionRepository.findAll()).thenReturn(List.of(c));
            when(configParameterService.getRrhhText("GENERAL", "EMPRESA_1_")).thenReturn("val");

            var result = service.getEmpresa(1L, null);
            assertThat(result).containsEntry("", "val");
        }
    }
}
