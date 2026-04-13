package pe.sunat.web.rest.domain.port;

import pe.sunat.web.rest.domain.model.TipoCambioData;

/**
 * Puerto para consulta de tipo de cambio (arquitectura hexagonal)
 */
public interface TipoCambioPort {
    
    /**
     * Consulta el tipo de cambio para una fecha
     * @param fecha formato YYYY-MM-DD o "today"
     */
    TipoCambioData consultarTipoCambio(String fecha) throws Exception;
}
