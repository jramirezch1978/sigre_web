package pe.com.sytco.fastsales.apiServices.RENIEC;

import com.google.gson.annotations.SerializedName;

import java.util.Arrays;
import java.util.List;

public class PersonaResponse {
    private String dni, cui;
    private String nombres;
    private String error;

    @SerializedName("apellido_paterno")
    private String apellidoPaterno;

    @SerializedName("apellido_materno")
    private String apellidoMaterno;

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
    public String getNombres() {
        return nombres;
    }
    public void setNombres(String nombres) {
        this.nombres = nombres;
    }
    public String getError() {
        return error;
    }
    public void setError(String error) {
        this.error = error;
    }
    public String getApellidoPaterno() {
        return apellidoPaterno;
    }
    public void setApellidoPaterno(String apellidoPaterno) {
        this.apellidoPaterno = apellidoPaterno;
    }
    public String getApellidoMaterno() {
        return apellidoMaterno;
    }
    public void setApellidoMaterno(String apellidoMaterno) {
        this.apellidoMaterno = apellidoMaterno;
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

        return this.apellidoPaterno.trim() + " " + this.apellidoMaterno.trim() + ", " + this.nombres;
    }
}
