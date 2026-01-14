package pe.sunat.web.controlador;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.rowset.CachedRowSet;

import pe.sigre.lib.db.DbAccess;
import pe.sunat.web.ancestors.CntrlAncestorWS;
import pe.sunat.web.beans.BeanUsuario;

public class CntrlUsuario extends CntrlAncestorWS {

	public BeanUsuario validarCredenciales(String pUsuario, String pClave) throws Exception {
		
		String lsSQL = "";
		DbAccess db = null;
		CachedRowSet rs = null;
		BeanUsuario beanUsuario = null;
		
		try {
			lsSQL = "select t.cod_usr, " + 
					"       t.nom_usuario, " + 
					"       t.clave, " + 
					"       t.flag_estado, " + 
					"       t.fec_registro, " +
					"       t.max_consultas " +
					"from usuarios t " + 
					"where t.cod_usr = ?";	
	    	
	    	
	    	
	        db = DbAccess.getInstance();

	        List<Object> param = new ArrayList<Object>();
	        param.add(pUsuario.trim());

	        rs = db.ExecuteQuery(lsSQL, param);
	        
	        if (rs.size() == 0 )
	        	throw new Exception("El usuario [" + pUsuario + "] no existe por favor verifique!");
	        
	        while(rs.next()){

	        	beanUsuario = BeanUsuario.InstanceOf(rs);
	        	
	        	if (beanUsuario.getFlagEstado().trim().equals("0")) {
	        		throw new Exception("El usuario [" + pUsuario + "] se encuentra desactivado, por favor verifique!");
	        	}
	        	
	        	if (!beanUsuario.getClave().trim().equals(pClave)) {
	        		throw new Exception("La clave ingresada no es correcta, por favor verifique!");
	        	}
                
            }
	        
	        return beanUsuario;
	        
		}catch(Exception ex) {
			
			throw ex;
			
		}finally {
			try {
            	
                if (db != null) {
                    db.CerrarConexion();
                }
                
                db = null;
                
            } catch (SQLException e) {
                e.printStackTrace();
                throw e;
            }
		}
		
		
	}

	public boolean validarMaxConsultas(BeanUsuario beanUsuario) throws Exception {
		String lsSQL = "";
		DbAccess db = null;
		Integer liCount = 0;
		
		try {
			
			if (beanUsuario.getMaxConsultas() == -1)
				return true;
			
			lsSQL = "select count(*) " + 
					"from log_consultas t " + 
					"where cod_usr = ? " + 
					"  and trunc(t.fec_registro) = trunc(sysdate)\r\n" + 
					"  and t.flag_ok             = '1' ";	
	    	
	    	
	    	
	        db = DbAccess.getInstance();

	        List<Object> param = new ArrayList<Object>();
	        param.add(beanUsuario.getCodUsuario().trim());

	        liCount = Integer.parseInt(db.ExecuteScalar(lsSQL, param).toString());
	        
	        if (liCount > beanUsuario.getMaxConsultas() )
	        	throw new Exception("El usuario [" + beanUsuario.getCodUsuario() + "] ya excedió su limite de " 
	        					+ beanUsuario.getMaxConsultas().toString()  + " consultas diarios, por favor verifique!");
	        
	        
	        
	        return true;
	        
		}catch(Exception ex) {
			
			throw ex;
			
		}finally {
			try {
            	
                if (db != null) {
                    db.CerrarConexion();
                }
                
                db = null;
                
            } catch (SQLException e) {
                e.printStackTrace();
                throw e;
            }
		}
		
	}

}
