package pe.sunat.web.rest.domain.port;

import pe.sunat.web.rest.domain.model.RucData;

/**
 * Puerto para consulta de RUC (arquitectura hexagonal)
 */
public interface RucPort {
    
    /**
     * Consulta un RUC en el padron
     */
    RucData consultarRuc(String ruc) throws Exception;
    
    /**
     * Registra la consulta en el log
     */
    void registrarConsulta(String rucConsulta, String rucOrigen, 
                           String empresa, String computerName, 
                           String usuario, boolean exitoso) throws Exception;
}
