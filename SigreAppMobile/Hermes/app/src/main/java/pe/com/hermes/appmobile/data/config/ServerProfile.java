package pe.com.hermes.appmobile.data.config;

/**
 * Perfil de servidor remoto — mismos 5 campos que BeanServerRemote de FastSales
 * (nombre, hostIP, port, protocolo, flagDefault), en vez de una unica URL suelta.
 */
public class ServerProfile {

    private String nombre;
    private String hostIp;
    private String port;
    private String protocolo;
    private boolean flagDefault;

    public ServerProfile() {
        this("", "", "", "http", false);
    }

    public ServerProfile(String nombre, String hostIp, String port, String protocolo, boolean flagDefault) {
        this.nombre = nombre;
        this.hostIp = hostIp;
        this.port = port;
        this.protocolo = protocolo;
        this.flagDefault = flagDefault;
    }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getHostIp() { return hostIp; }
    public void setHostIp(String hostIp) { this.hostIp = hostIp; }

    public String getPort() { return port; }
    public void setPort(String port) { this.port = port; }

    public String getProtocolo() { return protocolo; }
    public void setProtocolo(String protocolo) { this.protocolo = protocolo; }

    public boolean isFlagDefault() { return flagDefault; }
    public void setFlagDefault(boolean flagDefault) { this.flagDefault = flagDefault; }

    /** protocolo://hostIp:port/api/ — la URL base real que consume Retrofit. */
    public String apiBaseUrl() {
        String host = hostIp.trim();
        String p = port.trim();
        String sufijo = p.isEmpty() ? "" : ":" + p;
        return protocolo + "://" + host + sufijo + "/api/";
    }
}
