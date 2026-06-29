package com.sigre.core.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "configuracion", schema = "config")
public class Configuracion {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 60)
    private String modulo;

    @Column(nullable = false, length = 120)
    private String parametro;

    @Column(name = "tipo_dato", nullable = false, length = 20)
    private String tipoDato = "STRING";

    @Column(name = "valor_texto")
    private String valorTexto;

    @Column(name = "valor_entero")
    private Integer valorEntero;

    @Column(name = "valor_decimal", precision = 18, scale = 6)
    private BigDecimal valorDecimal;

    @Column(name = "valor_fecha")
    private LocalDate valorFecha;

    @Column(nullable = false)
    private Boolean editable = true;
}
