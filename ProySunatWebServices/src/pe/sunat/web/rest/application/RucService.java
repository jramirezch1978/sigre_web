package pe.sunat.web.rest.application;

import pe.sunat.web.beans.BeanPadronRuc;
import pe.sunat.web.beans.BeanUsuario;
import pe.sunat.web.controlador.CntrlConsultaRUC;
import pe.sunat.web.rest.domain.model.RucData;
import pe.sunat.web.rest.domain.port.RucPort;

/**
 * Servicio de consulta RUC - Capa de aplicacion
 * Reutiliza los controladores existentes
 */
public class RucService implements RucPort {
    
    private CntrlConsultaRUC cntrlConsultaRUC;
    
    public RucService() {
        this.cntrlConsultaRUC = new CntrlConsultaRUC();
    }
    
    @Override
    public RucData consultarRuc(String ruc) throws Exception {
        BeanPadronRuc bean = cntrlConsultaRUC.consultarRUC(ruc);
        
        if (bean == null || !bean.getIsOk()) {
            throw new Exception(bean != null ? bean.getMensaje() : "RUC no encontrado");
        }
        
        return RucData.fromBean(bean);
    }
    
    @Override
    public void registrarConsulta(String rucConsulta, String rucOrigen, 
                                   String empresa, String computerName, 
                                   String usuario, String ipLocal, boolean exitoso) throws Exception {
        
        BeanUsuario beanUsuario = new BeanUsuario();
        beanUsuario.setCodUsuario(usuario);
        
        BeanPadronRuc beanRuc = new BeanPadronRuc();
        beanRuc.setIsOk(exitoso);
        beanRuc.setRuc(rucConsulta);
        
        cntrlConsultaRUC.registrarConsulta(rucConsulta, rucOrigen, empresa, 
                                           computerName, ipLocal, beanUsuario, beanRuc);
    }
}
