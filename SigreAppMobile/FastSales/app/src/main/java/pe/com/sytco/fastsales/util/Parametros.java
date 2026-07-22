package pe.com.sytco.fastsales.util;

import java.io.Serializable;
import java.util.List;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanParteIngreso;

public class Parametros implements Serializable {
    private String action = "";
    private String string1 = "";
    private String string2 = "";
    private String string3 = "";
    private Integer integer1;
    private Integer integer2;
    private Integer integer3;
    private Boolean isOK;
    private List<BeanParteIngreso> listado = null;

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getString1() {
        return string1;
    }

    public void setString1(String string1) {
        this.string1 = string1;
    }

    public String getString2() {
        return string2;
    }

    public void setString2(String string2) {
        this.string2 = string2;
    }

    public String getString3() {
        return string3;
    }

    public void setString3(String string3) {
        this.string3 = string3;
    }

    public Integer getInteger1() {
        return integer1;
    }

    public void setInteger1(Integer integer1) {
        this.integer1 = integer1;
    }

    public Integer getInteger2() {
        return integer2;
    }

    public void setInteger2(Integer integer2) {
        this.integer2 = integer2;
    }

    public Integer getInteger3() {
        return integer3;
    }

    public void setInteger3(Integer integer3) {
        this.integer3 = integer3;
    }

    public Boolean getIsOK() {
        return isOK;
    }

    public void setIsOK(Boolean value) {
        isOK = value;
    }

    public void setListado(List<BeanParteIngreso> aValue) {
        this.listado = aValue;
    }

    public List<BeanParteIngreso> getListado() {
        return this.listado;
    }

}
