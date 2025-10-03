package com.sigre.sync.entity.local;

import java.io.Serializable;
import java.util.Objects;

public class SeccionLocalId implements Serializable {

    private String codArea;
    private String codSeccion;

    public SeccionLocalId() {}

    public SeccionLocalId(String codArea, String codSeccion) {
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
        SeccionLocalId that = (SeccionLocalId) o;
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
