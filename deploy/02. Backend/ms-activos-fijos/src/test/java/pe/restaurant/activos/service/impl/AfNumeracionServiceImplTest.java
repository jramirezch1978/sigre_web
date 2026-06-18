package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.dto.AfNumeracionConfigRequest;
import pe.restaurant.activos.dto.AfNumeracionConfigResponse;
import pe.restaurant.activos.dto.SiguienteCodigoResponse;
import pe.restaurant.activos.entity.AfNumeracionConfig;
import pe.restaurant.activos.repository.AfNumeracionConfigRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.exception.BusinessException;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfNumeracionServiceImplTest {

    @Mock
    private AfNumeracionConfigRepository repository;

    @InjectMocks
    private AfNumeracionServiceImpl service;

    private AfNumeracionConfig buildConfig(String tipo, String prefijo, Long secuencia, Integer longitud) {
        AfNumeracionConfig cfg = new AfNumeracionConfig();
        cfg.setId(1L);
        cfg.setTipo(tipo);
        cfg.setPrefijo(prefijo);
        cfg.setSecuenciaActual(secuencia);
        cfg.setLongitudNumero(longitud);
        cfg.setFlagEstado("1");
        return cfg;
    }

    @Nested
    class GenerarSiguienteCodigo {

        @Test
        void incrementaSecuencia() {
            AfNumeracionConfig cfg = buildConfig("MAESTRO", "AF", 5L, 6);
            when(repository.findByTipoForUpdate("MAESTRO")).thenReturn(Optional.of(cfg));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            var r = service.generarSiguienteCodigo("MAESTRO");

            assertThat(r.getCodigo()).isEqualTo("AF-000006");
            assertThat(cfg.getSecuenciaActual()).isEqualTo(6L);
        }

        @Test
        void throwsWhenTipoNoConfigurado() {
            when(repository.findByTipoForUpdate("DESCONOCIDO")).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.generarSiguienteCodigo("desconocido"))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo(ActivosErrorCodes.NUMERACION_NO_CONFIGURADA);
        }

        @Test
        void convertToUpperCaseBeforeQuery() {
            AfNumeracionConfig cfg = buildConfig("TRASLADO", "TR", 0L, 5);
            when(repository.findByTipoForUpdate("TRASLADO")).thenReturn(Optional.of(cfg));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            SiguienteCodigoResponse r = service.generarSiguienteCodigo("traslado");

            assertThat(r.getCodigo()).isEqualTo("TR-00001");
            assertThat(r.getTipo()).isEqualTo("TRASLADO");
            assertThat(r.getSecuencia()).isEqualTo(1L);
        }

        @Test
        void codigoFormateaConLongitudCorrecta() {
            AfNumeracionConfig cfg = buildConfig("ACTIVO", "ACT", 99L, 4);
            when(repository.findByTipoForUpdate("ACTIVO")).thenReturn(Optional.of(cfg));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            var r = service.generarSiguienteCodigo("ACTIVO");

            assertThat(r.getCodigo()).isEqualTo("ACT-0100");
        }

        @Test
        void guardaConfigConNuevaSecuencia() {
            AfNumeracionConfig cfg = buildConfig("MAESTRO", "AF", 10L, 6);
            when(repository.findByTipoForUpdate("MAESTRO")).thenReturn(Optional.of(cfg));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            service.generarSiguienteCodigo("MAESTRO");

            verify(repository).save(cfg);
            assertThat(cfg.getSecuenciaActual()).isEqualTo(11L);
        }
    }

    @Nested
    class ObtenerConfig {

        @Test
        void retornaConfigExistente() {
            AfNumeracionConfig cfg = buildConfig("MAESTRO", "AF", 5L, 6);
            when(repository.findByTipoIgnoreCase("MAESTRO")).thenReturn(Optional.of(cfg));

            AfNumeracionConfigResponse r = service.obtenerConfig("MAESTRO");

            assertThat(r.getId()).isEqualTo(1L);
            assertThat(r.getTipo()).isEqualTo("MAESTRO");
            assertThat(r.getPrefijo()).isEqualTo("AF");
            assertThat(r.getSecuenciaActual()).isEqualTo(5L);
            assertThat(r.getLongitudNumero()).isEqualTo(6);
            assertThat(r.getFlagEstado()).isEqualTo("1");
        }

        @Test
        void throwsWhenTipoNoExiste() {
            when(repository.findByTipoIgnoreCase("INEXISTENTE")).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.obtenerConfig("INEXISTENTE"))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo(ActivosErrorCodes.NUMERACION_NO_CONFIGURADA);
        }
    }

    @Nested
    class ActualizarConfig {

        @Test
        void actualizaCamposYGuarda() {
            AfNumeracionConfig cfg = buildConfig("MAESTRO", "AF", 5L, 6);
            when(repository.findByTipoIgnoreCase("MAESTRO")).thenReturn(Optional.of(cfg));
            when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            AfNumeracionConfigRequest req = new AfNumeracionConfigRequest();
            req.setPrefijo("ACT");
            req.setSecuenciaActual(100L);
            req.setLongitudNumero(8);

            AfNumeracionConfigResponse r = service.actualizarConfig("MAESTRO", req);

            assertThat(r.getPrefijo()).isEqualTo("ACT");
            assertThat(r.getSecuenciaActual()).isEqualTo(100L);
            assertThat(r.getLongitudNumero()).isEqualTo(8);
            verify(repository).save(cfg);
        }

        @Test
        void throwsWhenTipoNoExiste() {
            when(repository.findByTipoIgnoreCase("NADA")).thenReturn(Optional.empty());

            AfNumeracionConfigRequest req = new AfNumeracionConfigRequest();
            req.setPrefijo("X");
            req.setSecuenciaActual(0L);
            req.setLongitudNumero(4);

            assertThatThrownBy(() -> service.actualizarConfig("NADA", req))
                    .isInstanceOf(BusinessException.class)
                    .extracting("errorCode").isEqualTo(ActivosErrorCodes.NUMERACION_NO_CONFIGURADA);
        }
    }
}
