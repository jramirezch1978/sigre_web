package pe.com.sytco.fastsales.api.rrhh.dto;

import java.util.List;

public class ParteDestajoRequest {
    private String empresa;
    private String usuario;
    private String fecParte;
    private String cliente;
    private String cuadrilla;
    private String turno;
    private String especie;
    private String presentacion;
    private String tarea;
    private String otAdm;
    private String numeroOt;
    private String operSec;
    private String fechaInicio;
    private String fechaFin;
    private String codOrigen;
    private List<ParteDestajoDetalleDto> detalle;

    public void setEmpresa(String empresa) { this.empresa = empresa; }
    public void setUsuario(String usuario) { this.usuario = usuario; }
    public String getEmpresa() { return empresa; }
    public String getUsuario() { return usuario; }
    public String getFecParte() { return fecParte; }
    public void setFecParte(String fecParte) { this.fecParte = fecParte; }
    public void setCliente(String cliente) { this.cliente = cliente; }
    public void setCuadrilla(String cuadrilla) { this.cuadrilla = cuadrilla; }
    public void setTurno(String turno) { this.turno = turno; }
    public void setEspecie(String especie) { this.especie = especie; }
    public void setPresentacion(String presentacion) { this.presentacion = presentacion; }
    public void setTarea(String tarea) { this.tarea = tarea; }
    public void setOtAdm(String otAdm) { this.otAdm = otAdm; }
    public void setNumeroOt(String numeroOt) { this.numeroOt = numeroOt; }
    public void setOperSec(String operSec) { this.operSec = operSec; }
    public void setFechaInicio(String fechaInicio) { this.fechaInicio = fechaInicio; }
    public void setFechaFin(String fechaFin) { this.fechaFin = fechaFin; }
    public void setCodOrigen(String codOrigen) { this.codOrigen = codOrigen; }
    public void setDetalle(List<ParteDestajoDetalleDto> detalle) { this.detalle = detalle; }
}
