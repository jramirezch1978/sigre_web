package com.sigre.comercializacion.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.BaseEntity;

import java.time.Instant;

@Entity
@Table(name = "pedido_mesa", schema = "ventas",
       uniqueConstraints = @UniqueConstraint(columnNames = {"numero"}))
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class PedidoMesa extends BaseEntity {

    @Column(name = "sucursal_id")
    private Long sucursalId;

    @Column(name = "tipo", nullable = false, length = 20)
    private String tipo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "mesa_id")
    private Mesa mesa;

    @Column(name = "mesero_id")
    private Long meseroId;

    @Column(name = "turno_id")
    private Long turnoId;

    @Column(name = "numero", nullable = false, length = 30, unique = true)
    private String numero;

    @Column(name = "comensales")
    private Integer comensales;

    @Column(name = "apertura")
    private Instant apertura;

    @Column(name = "cierre")
    private Instant cierre;

    @Column(name = "observaciones", columnDefinition = "TEXT")
    private String observaciones;
}
