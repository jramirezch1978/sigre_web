package pe.restaurant.activos.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.dto.AfMaestroCcDistribRequest;
import pe.restaurant.activos.entity.AfMaestroCcDistrib;
import pe.restaurant.activos.repository.AfMaestroCcDistribRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.service.AfMaestroCcDistribService;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfMaestroCcDistribServiceImpl implements AfMaestroCcDistribService {

    private final AfMaestroCcDistribRepository repository;
    private final AfMaestroRepository maestroRepository;

    @Override
    public List<AfMaestroCcDistrib> listarPorMaestro(Long afMaestroId) {
        validarMaestro(afMaestroId);
        return repository.findByAfMaestroIdOrderByIdAsc(afMaestroId);
    }

    @Override
    @Transactional
    public List<AfMaestroCcDistrib> reemplazarDistribucion(Long afMaestroId, List<AfMaestroCcDistribRequest> lineas) {
        validarMaestro(afMaestroId);
        if (lineas == null || lineas.isEmpty()) {
            repository.deleteByAfMaestroId(afMaestroId);
            return List.of();
        }
        BigDecimal suma = lineas.stream()
                .map(AfMaestroCcDistribRequest::getPorcentaje)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        if (suma.compareTo(new BigDecimal("100")) != 0) {
            throw new BusinessException(
                    "La suma de porcentajes debe ser 100 (actual: " + suma + ")",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.DISTRIBUCION_CC_INVALIDA);
        }
        repository.deleteByAfMaestroId(afMaestroId);
        List<AfMaestroCcDistrib> guardadas = new ArrayList<>();
        for (AfMaestroCcDistribRequest req : lineas) {
            AfMaestroCcDistrib row = new AfMaestroCcDistrib();
            row.setAfMaestroId(afMaestroId);
            row.setCentroCostoId(req.getCentroCostoId());
            row.setPorcentaje(req.getPorcentaje());
            row.setCreatedBy(TenantContext.getUsuarioId());
            guardadas.add(repository.save(row));
        }
        return guardadas;
    }

    private void validarMaestro(Long afMaestroId) {
        if (!maestroRepository.existsById(afMaestroId)) {
            throw new ResourceNotFoundException("Activo", afMaestroId);
        }
    }
}
