package pe.com.sytco.fastsales.beans;

import java.io.Serializable;
import com.google.gson.annotations.SerializedName;

/**
 * Created by jramirez on 29/10/2017.
 */
public class BeanServerRemote implements Serializable {
    private static final long serialVersionUID = 1;

    @SerializedName("nombre")
    private String nombre;

    @SerializedName("hostIP")
    private String hostIP;

    @SerializedName("port")
    private String port;

    @SerializedName("protocolo")
    private String protocolo;

    @SerializedName("flagDefault")
    private String flagDefault;

    public BeanServerRemote()
    {
        this.protocolo = "http";
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getHostIP() {
        return hostIP;
    }

    public void setHostIP(String value) {
        hostIP = value;
    }

    public String getPort() {
        return port;
    }

    public void setPort(String port) {
        this.port = port;
    }

    public String getProtocolo() {
        return protocolo;
    }

    public void setProtocolo(String protocolo) {
        this.protocolo = protocolo;
    }

    public String getFlagDefault() {
        return flagDefault;
    }

    public void setFlagDefault(String flagDefault) {
        this.flagDefault = flagDefault;
    }
}
