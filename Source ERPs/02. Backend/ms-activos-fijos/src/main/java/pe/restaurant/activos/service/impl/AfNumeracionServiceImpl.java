package pe.restaurant.activos.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.dto.AfNumeracionConfigRequest;
import pe.restaurant.activos.dto.AfNumeracionConfigResponse;
import pe.restaurant.activos.dto.SiguienteCodigoResponse;
import pe.restaurant.activos.entity.AfNumeracionConfig;
import pe.restaurant.activos.repository.AfNumeracionConfigRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.service.AfNumeracionService;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfNumeracionServiceImpl implements AfNumeracionService {

    private final AfNumeracionConfigRepository repository;

    @Override
    public AfNumeracionConfigResponse obtenerConfig(String tipo) {
        return toResponse(requireConfig(tipo));
    }

    @Override
    @Transactional
    public AfNumeracionConfigResponse actualizarConfig(String tipo, AfNumeracionConfigRequest request) {
        AfNumeracionConfig cfg = requireConfig(tipo);
        cfg.setPrefijo(request.getPrefijo());
        cfg.setSecuenciaActual(request.getSecuenciaActual());
        cfg.setLongitudNumero(request.getLongitudNumero());
        cfg.setUpdatedBy(TenantContext.getUsuarioId());
        return toResponse(repository.save(cfg));
    }

    @Override
    @Transactional
    public SiguienteCodigoResponse generarSiguienteCodigo(String tipo) {
        AfNumeracionConfig cfg = repository.findByTipoForUpdate(tipo.toUpperCase())
                .orElseThrow(() -> new BusinessException(
                        "Numeración no configurada para tipo: " + tipo,
                        HttpStatus.BAD_REQUEST,
                        ActivosErrorCodes.NUMERACION_NO_CONFIGURADA));
        long next = cfg.getSecuenciaActual() + 1;
        cfg.setSecuenciaActual(next);
        cfg.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(cfg);
        String codigo = cfg.getPrefijo() + "-" + String.format("%0" + cfg.getLongitudNumero() + "d", next);
        return new SiguienteCodigoResponse(tipo.toUpperCase(), codigo, next);
    }

    private AfNumeracionConfig requireConfig(String tipo) {
        return repository.findByTipoIgnoreCase(tipo)
                .orElseThrow(() -> new BusinessException(
                        "Numeración no configurada para tipo: " + tipo,
                        HttpStatus.BAD_REQUEST,
                        ActivosErrorCodes.NUMERACION_NO_CONFIGURADA));
    }

    private static AfNumeracionConfigResponse toResponse(AfNumeracionConfig cfg) {
        AfNumeracionConfigResponse r = new AfNumeracionConfigResponse();
        r.setId(cfg.getId());
        r.setTipo(cfg.getTipo());
        r.setPrefijo(cfg.getPrefijo());
        r.setSecuenciaActual(cfg.getSecuenciaActual());
        r.setLongitudNumero(cfg.getLongitudNumero());
        r.setFlagEstado(cfg.getFlagEstado());
        return r;
    }
}
