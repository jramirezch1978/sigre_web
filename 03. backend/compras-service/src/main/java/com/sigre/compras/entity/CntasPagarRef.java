package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "cntas_pagar", schema = "finanzas")
public class CntasPagarRef {

    @Id
    private Long id;

    @Column(name = "cod_relacion", length = 30)
    private String codRelacion;

    @Column(name = "tipo_doc", length = 20)
    private String tipoDoc;

    @Column(name = "nro_doc", length = 30)
    private String nroDoc;

    @Column(name = "fecha")
    private LocalDate fecha;

    @Column(name = "monto_total", precision = 18, scale = 4)
    private BigDecimal montoTotal;

    @Column(name = "orden_servicio_id")
    private Long ordenServicioId;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado;
}
