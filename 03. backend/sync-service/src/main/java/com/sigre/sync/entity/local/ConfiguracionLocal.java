package com.sigre.sync.entity.local;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "configuracion")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ConfiguracionLocal {

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

    // Campos de auditoría para sincronización
    @Column(name = "FECHA_SYNC")
    private LocalDate fechaSync;

    @Column(name = "ESTADO_SYNC", length = 1)
    @Builder.Default
    private String estadoSync = "P"; // P=Pendiente, S=Sincronizado, E=Error
}
