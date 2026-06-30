package com.sigre.almacen.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;

/** Referencia read-only a contabilidad.cntbl_libro (para mostrar el libro del tipo de almacén). */
@Getter
@NoArgsConstructor
@Entity
@Table(name = "cntbl_libro", schema = "contabilidad")
public class CntblLibroRef {

    @Id
    private Long id;

    @Column(name = "codigo", length = 20)
    private String codigo;

    @Column(name = "nombre", length = 120)
    private String nombre;
}
