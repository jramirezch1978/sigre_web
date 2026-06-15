package com.sigre.comercializacion.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.dto.request.ReservacionRequest;
import com.sigre.comercializacion.entity.Reservacion;
import com.sigre.comercializacion.repository.ArticuloRepository;
import com.sigre.comercializacion.repository.MesaRepository;
import com.sigre.comercializacion.repository.ReservacionRepository;
import com.sigre.comercializacion.repository.VentasFkValidator;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ReservacionServiceImplTest {

    @Mock
    private ReservacionRepository repository;
    @Mock
    private VentasFkValidator fkValidator;
    @Mock
    private MesaRepository mesaRepository;
    @Mock
    private ArticuloRepository articuloRepository;
    @InjectMocks
    private ReservacionServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        TenantContext.setSucursalId(10L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    private static ReservacionRequest requestFutura() {
        return ReservacionRequest.builder()
                .sucursalId(10L)
                .fecha(LocalDate.now().plusDays(60))
                .hora(LocalTime.of(20, 0))
                .comensales(2)
                .build();
    }

    @Test
    void create_fsFacturaSimplIdNull_noConsultaComprobante() {
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(repository.save(any(Reservacion.class))).thenAnswer(inv -> {
            Reservacion r = inv.getArgument(0);
            r.setId(100L);
            return r;
        });

        Reservacion out = service.create(requestFutura());

        assertThat(out.getId()).isEqualTo(100L);
        assertThat(out.getFsFacturaSimplId()).isNull();
        verify(fkValidator, never()).existsFsFacturaSimplNoAnulada(any());
    }

    @Test
    void create_fsFacturaSimplIdValido_consultaYPersiste() {
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(fkValidator.existsFsFacturaSimplNoAnulada(55L)).thenReturn(true);
        when(repository.save(any(Reservacion.class))).thenAnswer(inv -> inv.getArgument(0));

        ReservacionRequest req = requestFutura();
        req.setFsFacturaSimplId(55L);

        Reservacion out = service.create(req);

        assertThat(out.getFsFacturaSimplId()).isEqualTo(55L);
        verify(fkValidator).existsFsFacturaSimplNoAnulada(55L);
    }

    @Test
    void create_fsFacturaSimplIdInvalido_lanzaReservacionFk() {
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(fkValidator.existsFsFacturaSimplNoAnulada(55L)).thenReturn(false);

        ReservacionRequest req = requestFutura();
        req.setFsFacturaSimplId(55L);

        BusinessException ex = assertThrows(BusinessException.class, () -> service.create(req));
        assertThat(ex.getErrorCode()).isEqualTo("VEN-142");
        verify(repository, never()).save(any());
    }

    @Test
    void update_fsFacturaSimplIdInvalido_lanzaReservacionFk() {
        Reservacion existente = new Reservacion();
        existente.setId(7L);
        existente.setEstado(ReservacionServiceImpl.ESTADO_CONFIRMADA);
        existente.setFlagEstado("1");
        existente.setFecha(LocalDate.now().plusDays(60));
        existente.setHora(LocalTime.of(19, 0));

        when(repository.findDetailById(7L)).thenReturn(Optional.of(existente));
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(fkValidator.existsFsFacturaSimplNoAnulada(99L)).thenReturn(false);

        ReservacionRequest req = requestFutura();
        req.setFsFacturaSimplId(99L);

        BusinessException ex = assertThrows(BusinessException.class, () -> service.update(7L, req));
        assertThat(ex.getErrorCode()).isEqualTo("VEN-142");
        verify(repository, never()).save(any());
    }

    @Test
    void update_fsFacturaSimplIdValido_permiteGuardar() {
        Reservacion existente = new Reservacion();
        existente.setId(7L);
        existente.setEstado(ReservacionServiceImpl.ESTADO_CONFIRMADA);
        existente.setFlagEstado("1");
        existente.setFecha(LocalDate.now().plusDays(60));
        existente.setHora(LocalTime.of(19, 0));

        when(repository.findDetailById(7L)).thenReturn(Optional.of(existente));
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(fkValidator.existsFsFacturaSimplNoAnulada(12L)).thenReturn(true);
        when(repository.save(any(Reservacion.class))).thenAnswer(inv -> inv.getArgument(0));

        ReservacionRequest req = requestFutura();
        req.setFsFacturaSimplId(12L);

        Reservacion out = service.update(7L, req);

        assertThat(out.getFsFacturaSimplId()).isEqualTo(12L);
        verify(repository).save(existente);
    }
}
