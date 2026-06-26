package pe.restaurant.activos.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfHistorial;
import pe.restaurant.activos.repository.AfHistorialRepository;
import pe.restaurant.activos.service.AfHistorialRegistroService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.security.TenantContext;

import java.time.LocalDateTime;

@Slf4j
@Service
@RequiredArgsConstructor
public class AfHistorialRegistroServiceImpl implements AfHistorialRegistroService {

    private final AfHistorialRepository historialRepository;

    @Override
    @Transactional
    public void registrar(Long afMaestroId, String tipoEvento, String descripcion,
                          String valorAnterior, String valorNuevo, String modulo) {
        Long usuarioId = TenantContext.getUsuarioId();
        if (usuarioId == null) {
            log.warn("Historial omitido para activo {}: sin usuario en TenantContext", afMaestroId);
            return;
        }
        AfHistorial evento = new AfHistorial();
        evento.setAfMaestroId(afMaestroId);
        evento.setTipoEvento(tipoEvento);
        evento.setDescripcion(descripcion);
        evento.setValorAnterior(valorAnterior);
        evento.setValorNuevo(valorNuevo);
        evento.setUsuarioId(usuarioId);
        evento.setFechaEvento(LocalDateTime.now());
        evento.setModulo(modulo);
        evento.setFlagEstado(ActivosFlagEstado.ACTIVO);
        evento.setCreatedBy(usuarioId);
        historialRepository.save(evento);
        log.debug("Historial {} registrado para activo {}", tipoEvento, afMaestroId);
    }
}
