package pe.com.sytco.fastsales.beans;

/**
 * Created by jramirez on 23/09/2015.
 */
public class parametro {
    private Object value;
    private String nombre;

    public parametro(String pNombre, Object pValue) {
        this.setNombre(pNombre);
        this.setValue(pValue);
    }

    public Object getValue() {
        return value;
    }

    public void setValue(Object value) {
        this.value = value;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
}
