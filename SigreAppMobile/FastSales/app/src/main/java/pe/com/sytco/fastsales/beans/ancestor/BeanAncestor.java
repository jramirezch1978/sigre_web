package pe.com.sytco.fastsales.beans.ancestor;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;

public class BeanAncestor {
    private boolean isOk;
    private String mensaje;
    private String empresa;
    private boolean isNuevo, isModificado;
    private boolean selected = false;
    private Integer intReturn = 0;

    public String getEmpresa() {
        return empresa;
    }
    public void setEmpresa(String empresa) {
        this.empresa = empresa;
    }
    public boolean getIsOk() {
        return isOk;
    }
    public void setIsOk(boolean value) {
        this.isOk = value;
    }
    public String getMensaje() {
        return mensaje;
    }
    public void setMensaje(String value) {
        this.mensaje = value;
    }
    public boolean getIsNuevo() {
        return isNuevo;
    }
    public void setNuevo(boolean value) {
        this.isNuevo = value;
    }
    public boolean getIsModificado() {
        return isModificado;
    }
    public void setModificado(boolean value) {
        this.isModificado = value;
    }
    public void setSelected(boolean value) {
        this.selected = value;
    }
    public boolean getSelected(){
        return this.selected;
    }
    public boolean isSelected() {
        return this.selected;
    }
    public Integer getIntReturn() {
        return intReturn;
    }
    public void setIntReturn(Integer value) {
        this.intReturn = intReturn;
    }

    public void populate(ExtendedSoapObject soapObject) throws Exception {
        if (soapObject.getProperty("mensaje") == null)
            this.mensaje = "";
        else
            this.mensaje = soapObject.getProperty("mensaje").toString();

        if (soapObject.getProperty("intReturn") == null)
            this.intReturn = 0;
        else
            this.intReturn = Integer.parseInt(soapObject.getProperty("intReturn").toString());

        if (soapObject.getProperty("isOk") == null)
            this.isOk = true;
        else
            this.isOk = Boolean.parseBoolean(soapObject.getProperty("isOk").toString());
    }



}
