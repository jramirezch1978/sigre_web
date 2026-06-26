package pe.restaurant.activos.service.impl;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.service.DepreciacionService;

import java.math.BigDecimal;
import java.math.RoundingMode;

@Slf4j
@Service
public class DepreciacionServiceImpl implements DepreciacionService {

    @Override
    public BigDecimal calcularDepreciacionLineal(AfMaestro activo, Integer vidaUtilMeses, Integer mesesTranscurridos) {
        log.debug("Calculando depreciación lineal para activo {} - Vida útil: {} meses, Meses transcurridos: {}", 
                activo.getCodigo(), vidaUtilMeses, mesesTranscurridos);
        
        if (mesesTranscurridos >= vidaUtilMeses) {
            log.debug("Activo {} completamente depreciado", activo.getCodigo());
            return BigDecimal.ZERO;
        }
        
        BigDecimal valorDepreciable = activo.getValorAdquisicion().subtract(activo.getValorResidual());
        BigDecimal depreciacionMensual = valorDepreciable.divide(
                BigDecimal.valueOf(vidaUtilMeses), 
                4, 
                RoundingMode.HALF_UP
        );
        
        log.debug("Depreciación lineal mensual calculada: {} para activo {}", 
                depreciacionMensual, activo.getCodigo());
        
        return depreciacionMensual;
    }

    @Override
    public BigDecimal calcularDepreciacionAcelerada(AfMaestro activo, Integer vidaUtilMeses, BigDecimal valorNetoActual) {
        log.debug("Calculando depreciación acelerada para activo {} - Vida útil: {} meses, Valor neto actual: {}", 
                activo.getCodigo(), vidaUtilMeses, valorNetoActual);
        
        if (valorNetoActual.compareTo(activo.getValorResidual()) <= 0) {
            log.debug("Activo {} alcanzó su valor residual", activo.getCodigo());
            return BigDecimal.ZERO;
        }
        
        Integer vidaUtilAnios = vidaUtilMeses / 12;
        if (vidaUtilAnios == 0) {
            vidaUtilAnios = 1;
        }
        
        BigDecimal tasaAnual = BigDecimal.valueOf(2)
                .divide(BigDecimal.valueOf(vidaUtilAnios), 4, RoundingMode.HALF_UP);
        
        BigDecimal tasaMensual = tasaAnual.divide(BigDecimal.valueOf(12), 4, RoundingMode.HALF_UP);
        
        BigDecimal depreciacionMensual = valorNetoActual.multiply(tasaMensual)
                .setScale(4, RoundingMode.HALF_UP);
        
        BigDecimal valorNetoProyectado = valorNetoActual.subtract(depreciacionMensual);
        if (valorNetoProyectado.compareTo(activo.getValorResidual()) < 0) {
            depreciacionMensual = valorNetoActual.subtract(activo.getValorResidual());
        }
        
        log.debug("Depreciación acelerada mensual calculada: {} para activo {}", 
                depreciacionMensual, activo.getCodigo());
        
        return depreciacionMensual;
    }

    @Override
    public BigDecimal calcularDepreciacionUnidadesProduccion(AfMaestro activo, Integer unidadesTotales, Integer unidadesProducidas) {
        log.debug("Calculando depreciación por unidades de producción para activo {} - Unidades totales: {}, Unidades producidas: {}", 
                activo.getCodigo(), unidadesTotales, unidadesProducidas);
        
        if (unidadesTotales == null || unidadesTotales == 0) {
            log.warn("Unidades totales no definidas para activo {}, retornando depreciación 0", activo.getCodigo());
            return BigDecimal.ZERO;
        }
        
        if (unidadesProducidas == null || unidadesProducidas == 0) {
            log.debug("No hay unidades producidas en el periodo para activo {}", activo.getCodigo());
            return BigDecimal.ZERO;
        }
        
        BigDecimal valorDepreciable = activo.getValorAdquisicion().subtract(activo.getValorResidual());
        
        BigDecimal depreciacionPorUnidad = valorDepreciable.divide(
                BigDecimal.valueOf(unidadesTotales), 
                4, 
                RoundingMode.HALF_UP
        );
        
        BigDecimal depreciacionMensual = depreciacionPorUnidad.multiply(BigDecimal.valueOf(unidadesProducidas))
                .setScale(4, RoundingMode.HALF_UP);
        
        log.debug("Depreciación por unidades de producción calculada: {} para activo {}", 
                depreciacionMensual, activo.getCodigo());
        
        return depreciacionMensual;
    }
}
