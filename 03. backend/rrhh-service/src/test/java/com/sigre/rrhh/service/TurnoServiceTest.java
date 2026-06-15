package com.sigre.rrhh.service;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.rrhh.constants.TurnoConstants;
import com.sigre.rrhh.dto.request.TurnoRequest;
import com.sigre.rrhh.mapper.TurnoMapper;
import com.sigre.rrhh.repository.TurnoRepository;
import com.sigre.rrhh.repository.HorarioTrabajadorRepository;
import com.sigre.rrhh.service.impl.TurnoServiceImpl;

import com.sigre.rrhh.entity.Turno;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("TurnoServiceImpl — Pruebas Unitarias")
class TurnoServiceTest {
    @Mock private TurnoRepository turnoRepository;
    @Mock private TurnoMapper turnoMapper;
    @Mock private HorarioTrabajadorRepository horarioTrabajadorRepository;
    @InjectMocks private TurnoServiceImpl turnoService;

    @Test
    @DisplayName("crear() con nombre duplicado -> lanza BusinessException")
    void crear_cuandoNombreDuplicado_lanzaBusinessException() {
        TurnoRequest request = TurnoRequest.builder()
                .nombre("Turno Mañana")
                .aplicaLunes(true)
                .build();
        when(turnoRepository.existsByNombreIgnoreCase(anyString())).thenReturn(true);

        assertThatThrownBy(() -> turnoService.crear(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining(TurnoConstants.MSG_NOMBRE_DUPLICADO);

        verify(turnoRepository).existsByNombreIgnoreCase(anyString());
    }

    @Test
    @DisplayName("desactivar() con asignados -> lanza BusinessException")
    void desactivar_cuandoTieneAsignados_lanzaBusinessException() {
        Turno t = new Turno();
        when(turnoRepository.findById(1L)).thenReturn(Optional.of(t));
        when(horarioTrabajadorRepository.existsByTurnoIdAndFlagEstado(1L, "1")).thenReturn(true);

        assertThatThrownBy(() -> turnoService.desactivar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("colaboradores asignados");

        verify(turnoRepository).findById(1L);
        verify(horarioTrabajadorRepository).existsByTurnoIdAndFlagEstado(1L, "1");
    }

    @Test
    @DisplayName("desactivar() sin asignados -> desactiva exitosamente")
    void desactivar_cuandoExisteYSinAsignados_desactivaExitosamente() {
        Turno t = new Turno();
        when(turnoRepository.findById(1L)).thenReturn(Optional.of(t));
        when(horarioTrabajadorRepository.existsByTurnoIdAndFlagEstado(1L, "1")).thenReturn(false);

        turnoService.desactivar(1L);

        verify(turnoRepository).findById(1L);
        verify(horarioTrabajadorRepository).existsByTurnoIdAndFlagEstado(1L, "1");
        verify(turnoRepository).save(any());
    }

    @Test
    @DisplayName("desactivar() con ID inexistente -> lanza ResourceNotFoundException")
    void desactivar_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        assertThatThrownBy(() -> turnoService.desactivar(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }
}
