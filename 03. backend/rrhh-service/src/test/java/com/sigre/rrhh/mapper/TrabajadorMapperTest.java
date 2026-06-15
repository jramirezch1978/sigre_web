package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.rrhh.dto.response.*;
import com.sigre.rrhh.entity.Contrato;
import com.sigre.rrhh.entity.HorarioTrabajador;
import com.sigre.rrhh.entity.Trabajador;
import com.sigre.rrhh.repository.TrabajadorRepository;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.lenient;
import static com.sigre.rrhh.RrhhTestFixtures.*;

/**
 * Tests unitarios para {@link TrabajadorMapper}.
 * Verifica la conversión de entidades a DTOs de respuesta.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("TrabajadorMapper — Pruebas Unitarias")
class TrabajadorMapperTest {

    @Mock private TrabajadorRepository repository;

    private TrabajadorMapper mapper;

    @BeforeEach
    void setUp() {
        mapper = new TrabajadorMapper(repository);
        lenient().when(repository.findAreaNombreById(anyLong())).thenReturn("Cocina");
        lenient().when(repository.findCargoNombreById(anyLong())).thenReturn("Chef");
        lenient().when(repository.findSucursalNombreById(anyLong())).thenReturn("Sucursal Miraflores");
        lenient().when(repository.findAdminAfpNombreById(anyLong())).thenReturn("AFP Integra");
        lenient().when(repository.findTurnoNombreById(anyLong())).thenReturn("Turno Mañana");
    }

    @Test
    @DisplayName("toListResponse() mapea campos principales y resuelve FKs")
    void toListResponse_mapeaCampos() {
        Trabajador t = trabajador(1L);

        TrabajadorListResponse resp = mapper.toListResponse(t);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getCodigoTrabajador()).isEqualTo("TRB-001");
        assertThat(resp.getNombres()).isEqualTo("Nombre 1");
        assertThat(resp.getFlagEstado()).isEqualTo("1");
        assertThat(resp.getArea()).isNotNull();
        assertThat(resp.getArea().getId()).isEqualTo(1L);
        assertThat(resp.getArea().getNombre()).isEqualTo("Cocina");
        assertThat(resp.getCargo().getNombre()).isEqualTo("Chef");
        assertThat(resp.getSucursal().getNombre()).isEqualTo("Sucursal Miraflores");
    }

    @Test
    @DisplayName("toDetailResponse() incluye contratos y horarios")
    void toDetailResponse_incluyeSubRecursos() {
        Trabajador t = trabajador(1L);
        t.setAdminAfpId(3L);
        List<Contrato> contratos = List.of(contrato(1L, 1L), contrato(2L, 1L, "0"));
        List<HorarioTrabajador> horarios = List.of(horario(1L, 1L));

        TrabajadorDetailResponse resp = mapper.toDetailResponse(t, contratos, horarios);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getContratos()).hasSize(2);
        assertThat(resp.getHorarios()).hasSize(1);
        assertThat(resp.getAdminAfp()).isNotNull();
        assertThat(resp.getAdminAfp().getNombre()).isEqualTo("AFP Integra");
        assertThat(resp.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("toDetailResponse() con listas vacías retorna listas vacías")
    void toDetailResponse_listasVacias() {
        Trabajador t = trabajador(1L);

        TrabajadorDetailResponse resp = mapper.toDetailResponse(t, List.of(), List.of());

        assertThat(resp.getContratos()).isEmpty();
        assertThat(resp.getHorarios()).isEmpty();
    }

    @Test
    @DisplayName("toContratoResponse() mapea todos los campos")
    void toContratoResponse_mapeaCampos() {
        Contrato c = contratoPlazoFijo(1L, 1L);

        ContratoResponse resp = mapper.toContratoResponse(c);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getTrabajadorId()).isEqualTo(1L);
        assertThat(resp.getTipoContrato()).isNotNull();
        assertThat(resp.getTipoContrato().getId()).isEqualTo(2L);
        assertThat(resp.getFechaInicio()).isNotNull();
        assertThat(resp.getFechaFin()).isNotNull();
        assertThat(resp.getRemuneracion()).isNotNull();
        assertThat(resp.getAsignacionFamiliar()).isTrue();
        assertThat(resp.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toHorarioResponse() resuelve turno")
    void toHorarioResponse_resuelveTurno() {
        HorarioTrabajador h = horario(1L, 1L);

        HorarioResponse resp = mapper.toHorarioResponse(h);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getTrabajadorId()).isEqualTo(1L);
        assertThat(resp.getTurno()).isNotNull();
        assertThat(resp.getTurno().getNombre()).isEqualTo("Turno Mañana");
        assertThat(resp.getFechaDesde()).isNotNull();
        assertThat(resp.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toListResponse() con FK nulas retorna refs nulas")
    void toListResponse_fksNulas_refsNulas() {
        Trabajador t = trabajador(1L);
        t.setAreaId(null);
        t.setCargoId(null);
        t.setSucursalId(null);

        TrabajadorListResponse resp = mapper.toListResponse(t);

        assertThat(resp.getArea()).isNull();
        assertThat(resp.getCargo()).isNull();
        assertThat(resp.getSucursal()).isNull();
    }
}
