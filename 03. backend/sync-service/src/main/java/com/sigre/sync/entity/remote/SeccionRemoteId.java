package com.sigre.sync.entity.remote;

import jakarta.persistence.Column;
import java.io.Serializable;
import java.util.Objects;

public class SeccionRemoteId implements Serializable {

    @Column(name = "COD_AREA")
    private String codArea;

    @Column(name = "COD_SECCION")
    private String codSeccion;

    public SeccionRemoteId() {}

    public SeccionRemoteId(String codArea, String codSeccion) {
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
        SeccionRemoteId that = (SeccionRemoteId) o;
        return Objects.equals(trim(codArea), trim(that.codArea)) &&
               Objects.equals(trim(codSeccion), trim(that.codSeccion));
    }

    @Override
    public int hashCode() {
        return Objects.hash(trim(codArea), trim(codSeccion));
    }

    private String trim(String value) {
        return value != null ? value.trim() : null;
    }

    @Override
    public String toString() {
        return codArea + "-" + codSeccion;
    }
}
