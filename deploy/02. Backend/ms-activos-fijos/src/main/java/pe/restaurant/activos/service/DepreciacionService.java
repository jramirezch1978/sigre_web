package pe.restaurant.activos.service;

import pe.restaurant.activos.entity.AfMaestro;

import java.math.BigDecimal;

public interface DepreciacionService {
    
    BigDecimal calcularDepreciacionLineal(AfMaestro activo, Integer vidaUtilMeses, Integer mesesTranscurridos);
    
    BigDecimal calcularDepreciacionAcelerada(AfMaestro activo, Integer vidaUtilMeses, BigDecimal valorNetoActual);
    
    BigDecimal calcularDepreciacionUnidadesProduccion(AfMaestro activo, Integer unidadesTotales, Integer unidadesProducidas);
}
