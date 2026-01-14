package pe.sunat.web.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.sql.rowset.CachedRowSet;

import pe.sigre.lib.db.DbAccess;
import pe.sunat.web.ancestors.CntrlAncestorWS;
import pe.sunat.web.beans.BeanPadronRuc;
import pe.sunat.web.beans.BeanUsuario;

public class CntrlConsultaRUC extends CntrlAncestorWS{

	public BeanPadronRuc consultarRUC(String pRUC) throws Exception {
		DbAccess db = null;
        CachedRowSet rs = null;
        String lsSQL = "";
        BeanPadronRuc beanPadronRUC = null;
        
        try {
        	lsSQL = "select P.RUC, " + 
        			"       P.RAZON_SOCIAL, " + 
        			"       P.ESTADO, " + 
        			"       P.CONDICION, " + 
        			"       P.UBIGEO, " + 
        			"       P.TIPO_VIA, " + 
        			"       P.NOMBRE_VIA, " + 
        			"       P.CODIGO_ZONA, " + 
        			"       P.TIPO_ZONA, " + 
        			"       P.NUMERO, " + 
        			"       P.INTERIOR, " + 
        			"       P.LOTE, " + 
        			"       P.DEPARTAMENTO, " + 
        			"       P.MANZANA, " + 
        			"       P.KILOMETRO, " + 
        			"       u1.cod_dpto, " + 
        			"       u1.desc_dpto, " + 
        			"       u2.cod_prov, " + 
        			"       u2.desc_provincia, " + 
        			"       u3.desc_distrito " + 
        			"from PADRON_RUC p, " + 
        			"     ubigeo_distrito u3, " + 
        			"     ubigeo_provincia u2, " + 
        			"     ubigeo_departamento u1 " + 
        			"where p.ubigeo    = u3.cod_distrito (+) " + 
        			"  and u3.cod_prov = u2.cod_prov  	 (+) " + 
        			"  and u2.cod_dpto = u1.cod_dpto     (+) " +
        			"  and p.ruc = ?";	
        	
        	
        	
            db = DbAccess.getInstance();

            List<Object> param = new ArrayList<Object>();
            param.add(pRUC.trim());

            rs = db.ExecuteQuery(lsSQL, param);
            
            if (rs.size() == 0) {
            	beanPadronRUC = new BeanPadronRuc();
            	beanPadronRUC.setIsOk(false);
            	beanPadronRUC.setMensaje("Error al buscar el ruc " + pRUC + ", no existe en la base de datos de SUNAT, por favor verifique!");
            	return beanPadronRUC;
            }

            while(rs.next()){

            	beanPadronRUC = BeanPadronRuc.InstanceOf(rs);
                
            }
            
            beanPadronRUC.setIsOk(true);
            
            return beanPadronRUC;
            
        }catch(Exception ex) {
        	
        	throw ex;
        	
        }finally {
        	
        	if (db != null) {
                db.CerrarConexion();
            }
            
            db = null;
        }
        
		
		
	}

	public void registrarConsulta(String pRucConsulta, 
									 String pRucOrigen, 
									 String pEmpresa, 
									 String pComputerName,
									 BeanUsuario beanUsuario, 
									 BeanPadronRuc beanPadronRUC) throws Exception {
		
		DbAccess db = null;
        String lsSQL = "", lsFlagOK = "0";
        Integer liNroItem = 0;
        List<Object> param = null;
        
        try {
        	db = DbAccess.getInstance();
        	
        	// Obtengo el nro de Item
        	lsSQL = "select nvl(max(l.nro_item),0) " + 
        			"from log_consultas l " + 
        			"where l.cod_usr = ? " + 
        			"  and trunc(l.fec_registro) = trunc(sysdate)";
        	
        	param = new ArrayList<Object>();
            param.add(beanUsuario.getCodUsuario());
            
            liNroItem = Integer.parseInt(db.ExecuteScalar(lsSQL, param).toString());
            
            //Incremente el nro de item
            liNroItem ++;
            
            if (beanPadronRUC.getIsOk())
            	lsFlagOK = "1";
            else
            	lsFlagOK = "0";
            
        	//insertamos en el log de consultas
        	lsSQL = "insert into log_consultas("
        			+ "cod_usr, ruc_origen, ruc_consulta, computer_name, fec_registro, nro_item, flag_ok, empresa) "
        			+ "values(?, ?, ?, ?, sysdate, ?, ?, ?)";
        	
        	param.clear();
            param.add(beanUsuario.getCodUsuario());
            param.add(pRucOrigen);
            param.add(pRucConsulta);
            param.add(pComputerName);
            param.add(liNroItem);
            param.add(lsFlagOK);
            param.add(pEmpresa);
        	
        	
            db.ExecuteNonQuery(lsSQL, param);

                        
            
        }catch(Exception ex) {
        	
        	throw ex;
        	
        }finally {
        	
        	if (db != null) {
                db.CerrarConexion();
            }
            
            db = null;
            param = null;
        }
	}

}
