package pe.sunat.web.ancestors;

import pe.sigre.lib.bean.ancestor.BeanAncestor;
import pe.sigre.lib.util.SettingINI;

public class BeanAncestorWS extends BeanAncestor {
	
	public BeanAncestorWS() {
		SettingINI.fileINI = "..\\standalone\\configuration\\SunatWebServices.ini";
	}
	

}
