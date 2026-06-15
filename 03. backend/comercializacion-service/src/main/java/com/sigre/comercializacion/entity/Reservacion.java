package com.sigre.comercializacion.entity;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;
import com.sigre.common.entity.BaseEntity;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "reservacion", schema = "ventas")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = "items")
public class Reservacion extends BaseEntity {

    @Column(name = "sucursal_id")
    private Long sucursalId;

    @Column(name = "cliente_id")
    private Long clienteId;

    @Column(name = "mesa_id")
    private Long mesaId;

    /** Opcional: comprobante vinculado; la anulación de factura exige que la reserva no siga CONFIRMADA. */
    @Column(name = "fs_factura_simpl_id")
    private Long fsFacturaSimplId;

    @Column(name = "fecha", nullable = false)
    private LocalDate fecha;

    @Column(name = "hora", nullable = false)
    private LocalTime hora;

    @Column(name = "comensales")
    private Integer comensales;

    @Column(name = "observaciones", columnDefinition = "TEXT")
    private String observaciones;

    @Column(name = "estado", nullable = false, length = 20)
    private String estado = "CONFIRMADA";

    @Column(name = "motivo_cancelacion", columnDefinition = "TEXT")
    private String motivoCancelacion;

    @OneToMany(mappedBy = "reservacion", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ReservacionDet> items = new ArrayList<>();
}
