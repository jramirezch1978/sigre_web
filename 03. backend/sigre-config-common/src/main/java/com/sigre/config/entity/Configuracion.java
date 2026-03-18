package com.sigre.config.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entidad que mapea la tabla CONFIGURACION de la base de datos SIGRE.
 *
 * Estructura según schema_export.json:
 *   PARAMETRO   VARCHAR2(50)      PK, NOT NULL
 *   VALOR_INT   NUMBER(13,0)      nullable
 *   VALOR_DEC   NUMBER(16,6)      nullable
 *   VALOR_CHAR  VARCHAR2(3000)    nullable
 *   VALOR_DATE  DATE              nullable
 *   FEC_REGISTRO DATE             NOT NULL, default sysdate
 */
@Entity
@Table(name = "configuracion")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Configuracion {

    @Id
    @Column(name = "parametro", length = 50, nullable = false)
    private String parametro;

    @Column(name = "valor_int", precision = 13, scale = 0)
    private Long valorInt;

    @Column(name = "valor_dec", precision = 16, scale = 6)
    private BigDecimal valorDec;

    @Column(name = "valor_char", length = 3000)
    private String valorChar;

    @Column(name = "valor_date")
    private LocalDateTime valorDate;

    @Column(name = "fec_registro", nullable = false)
    private LocalDateTime fecRegistro;

    @PrePersist
    public void prePersist() {
        if (fecRegistro == null) {
            fecRegistro = LocalDateTime.now();
        }
    }
}
