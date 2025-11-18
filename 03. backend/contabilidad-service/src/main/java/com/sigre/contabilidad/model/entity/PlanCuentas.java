package com.sigre.contabilidad.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Entidad Plan de Cuentas - Tabla PLAN_CUENTAS
 * Define el catálogo de cuentas contables
 */
@Entity
@Table(name = "PLAN_CUENTAS")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PlanCuentas {

    @EmbeddedId
    private PlanCuentasId id;

    @Column(name = "DESCRIPCION", length = 200, nullable = false)
    private String descripcion;

    @Column(name = "NIVEL")
    private Integer nivel;

    @Column(name = "CUENTA_PADRE", length = 20)
    private String cuentaPadre;

    @Column(name = "TIPO_CUENTA", length = 1)
    private String tipoCuenta; // A=Activo, P=Pasivo, G=Gasto, I=Ingreso, C=Capital

    @Column(name = "NATURALEZA", length = 1)
    private String naturaleza; // D=Deudora, A=Acreedora

    @Column(name = "FLAG_MOVIMIENTO", length = 1)
    private String flagMovimiento; // S=Permite movimiento, N=Solo título

    @Column(name = "FLAG_DESTINO", length = 1)
    private String flagDestino; // S=Cuenta de destino (Clase 9), N=Normal

    @Column(name = "FLAG_ESTADO", length = 1)
    private String flagEstado; // 1=Activo, 0=Inactivo
}

