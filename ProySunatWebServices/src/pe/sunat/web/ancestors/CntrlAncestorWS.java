package pe.sunat.web.ancestors;

import pe.sigre.lib.controller.ancestor.CntrlAncestor;
import pe.sigre.lib.util.SettingINI;

public class CntrlAncestorWS extends CntrlAncestor {
	public CntrlAncestorWS() {
		SettingINI.fileINI = "..\\standalone\\configuration\\SunatWebServices.ini";
	}
}
