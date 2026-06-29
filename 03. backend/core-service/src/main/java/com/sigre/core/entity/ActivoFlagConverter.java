package com.sigre.core.entity;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

/**
 * Mapea el flag de estado en formato "1"/"0" (convención del dominio) a la columna
 * boolean config.configuracion.activo. Permite conservar la lógica existente basada en
 * flagEstado="1" sin tocar el repositorio ni el servicio.
 */
@Converter
public class ActivoFlagConverter implements AttributeConverter<String, Boolean> {

    @Override
    public Boolean convertToDatabaseColumn(String flag) {
        return "1".equals(flag);
    }

    @Override
    public String convertToEntityAttribute(Boolean activo) {
        return Boolean.TRUE.equals(activo) ? "1" : "0";
    }
}
