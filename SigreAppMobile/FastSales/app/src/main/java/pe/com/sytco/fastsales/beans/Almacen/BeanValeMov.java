package pe.com.sytco.fastsales.beans.Almacen;

import java.io.Serializable;
import java.sql.Date;

public class BeanValeMov implements Serializable {

    private static final long serialVersionUID = -3425128038215124296L;
    private String nroVale;
    private String nroRefer;
    private String tipoMov;
    private Date fecRegistro;
    private Date fecProduccion;

    public String getNroVale() {
        return nroVale;
    }

    public void setNroVale(String nroVale) {
        this.nroVale = nroVale;
    }

    public String getNroRefer() {
        return nroRefer;
    }

    public void setNroRefer(String nroRefer) {
        this.nroRefer = nroRefer;
    }

    public String getTipoMov() {
        return tipoMov;
    }

    public void setTipoMov(String tipoMov) {
        this.tipoMov = tipoMov;
    }

    public Date getFecRegistro() {
        return fecRegistro;
    }

    public void setFecRegistro(Date fecRegistro) {
        this.fecRegistro = fecRegistro;
    }

    public Date getFecProduccion() {
        return fecProduccion;
    }

    public void setFecProduccion(Date fecProduccion) {
        this.fecProduccion = fecProduccion;
    }
}
