package com.sigre.asistencia.entity;

import jakarta.persistence.Column;
import java.io.Serializable;
import java.util.Objects;

public class SeccionId implements Serializable {

    @Column(name = "CODAREA", length = 2)
    private String codArea;
    
    @Column(name = "CODSECCION", length = 3)
    private String codSeccion;

    public SeccionId() {}

    public SeccionId(String codArea, String codSeccion) {
        this.codArea = codArea;
        this.codSeccion = codSeccion;
    }

    // Getters y setters
    public String getCodArea() {
        return codArea;
    }

    public void setCodArea(String codArea) {
        this.codArea = codArea;
    }

    public String getCodSeccion() {
        return codSeccion;
    }

    public void setCodSeccion(String codSeccion) {
        this.codSeccion = codSeccion;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SeccionId that = (SeccionId) o;
        return Objects.equals(codArea, that.codArea) &&
               Objects.equals(codSeccion, that.codSeccion);
    }

    @Override
    public int hashCode() {
        return Objects.hash(codArea, codSeccion);
    }
}
