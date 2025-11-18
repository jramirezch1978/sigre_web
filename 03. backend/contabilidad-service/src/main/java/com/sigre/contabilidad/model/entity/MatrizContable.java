package com.sigre.contabilidad.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Entidad Matriz Contable - Tabla MATRIZ_CONTABLE
 * Define las reglas de integración contable de otros módulos
 * 
 * CRÍTICO: Esta tabla es el corazón de la integración contable automática
 * Ejemplo: Movimiento de Almacén → Matriz → Asiento Contable
 */
@Entity
@Table(name = "MATRIZ_CONTABLE")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MatrizContable {

    @EmbeddedId
    private MatrizContableId id;

    @Column(name = "DESCRIPCION", length = 200)
    private String descripcion;

    @Column(name = "CUENTA_DEBE", length = 20)
    private String cuentaDebe;

    @Column(name = "CUENTA_HABER", length = 20)
    private String cuentaHaber;

    @Column(name = "CENTRO_COSTO_DEBE", length = 20)
    private String centroCostoDebe;

    @Column(name = "CENTRO_COSTO_HABER", length = 20)
    private String centroCostoHaber;

    @Column(name = "LIBRO_DESTINO", length = 10)
    private String libroDestino;

    @Column(name = "ORIGEN_DESTINO", length = 10)
    private String origenDestino;

    @Column(name = "FLAG_ACTIVO", length = 1)
    private String flagActivo; // S=Activo, N=Inactivo

    @Column(name = "GLOSA_PLANTILLA", length = 500)
    private String glosaPlantilla;
}

