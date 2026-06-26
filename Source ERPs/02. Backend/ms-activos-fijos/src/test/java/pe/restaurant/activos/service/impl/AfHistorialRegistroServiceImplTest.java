package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.entity.AfHistorial;
import pe.restaurant.activos.repository.AfHistorialRepository;
import pe.restaurant.common.security.TenantContext;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfHistorialRegistroServiceImplTest {

    @Mock
    private AfHistorialRepository historialRepository;
    @InjectMocks
    private AfHistorialRegistroServiceImpl service;

    @Test
    void registrarSavesHistorialWhenUsuarioPresent() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(5L);

            AfHistorial saved = new AfHistorial();
            saved.setId(1L);
            when(historialRepository.save(any(AfHistorial.class))).thenReturn(saved);

            service.registrar(10L, "CREACION", "Activo creado", null, "ACTIVO", "MAESTRO");

            verify(historialRepository).save(argThat(h ->
                    h.getAfMaestroId().equals(10L) &&
                    h.getTipoEvento().equals("CREACION") &&
                    h.getDescripcion().equals("Activo creado") &&
                    h.getValorAnterior() == null &&
                    h.getValorNuevo().equals("ACTIVO") &&
                    h.getUsuarioId().equals(5L) &&
                    h.getModulo().equals("MAESTRO") &&
                    h.getFechaEvento() != null &&
                    "1".equals(h.getFlagEstado()) &&
                    h.getCreatedBy().equals(5L)
            ));
        }
    }

    @Test
    void registrarSkipsWhenUsuarioNull() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(null);

            service.registrar(10L, "CREACION", "Activo creado", null, "ACTIVO", "MAESTRO");

            verify(historialRepository, never()).save(any());
        }
    }

    @Test
    void registrarSavesWithValorAnteriorAndNuevo() {
        try (MockedStatic<TenantContext> tc = mockStatic(TenantContext.class)) {
            tc.when(TenantContext::getUsuarioId).thenReturn(7L);

            when(historialRepository.save(any(AfHistorial.class))).thenAnswer(inv -> inv.getArgument(0));

            service.registrar(20L, "TRASLADO", "Trasladado", "Ubicacion A", "Ubicacion B", "TRASLADO");

            verify(historialRepository).save(argThat(h ->
                    h.getValorAnterior().equals("Ubicacion A") &&
                    h.getValorNuevo().equals("Ubicacion B") &&
                    h.getAfMaestroId().equals(20L)
            ));
        }
    }
}
