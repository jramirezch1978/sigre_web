package pe.com.sytco.fastsales.beans.RENIEC;

import java.util.Arrays;
import java.util.List;

public class BeanResponseRENIEC {
    private String dni, cui, apellido_paterno, apellido_materno, nombres;

    /*
    {
        "dni": "73157439",
            "cui": 7,
            "apellido_paterno": "RAMIREZ",
            "apellido_materno": "ARICA",
            "nombres": "GIANFRANCO ALEXANDER"
    }
     */

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getCui() {
        return cui;
    }

    public void setCui(String cui) {
        this.cui = cui;
    }

    public String getApellido_paterno() {
        return apellido_paterno;
    }

    public void setApellido_paterno(String apellido_paterno) {
        this.apellido_paterno = apellido_paterno;
    }

    public String getApellido_materno() {
        return apellido_materno;
    }

    public void setApellido_materno(String apellido_materno) {
        this.apellido_materno = apellido_materno;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }


    public String getNombre1() {
        List<String> listaNombre = Arrays.asList(this.nombres.split(" "));

        if (listaNombre.size() > 0){
            return listaNombre.get(0);
        }else{
            return "";
        }
    }

    public String getNombre2() {
        List<String> listaNombre = Arrays.asList(this.nombres.split(" "));
        String ls_return = "";

        if (listaNombre.size() > 2){
            ls_return = "";
            for(Integer i = 1; i<listaNombre.size(); i++){
                ls_return += listaNombre.get(i) + " ";
            }

            return ls_return.trim();

        }else if (listaNombre.size() == 2){
            return listaNombre.get(1);
        }else{
            return "";
        }
    }

    public String getFullNombre() {

        return this.apellido_paterno.trim() + " " + this.apellido_materno.trim() + ", " + this.nombres;
    }
}
