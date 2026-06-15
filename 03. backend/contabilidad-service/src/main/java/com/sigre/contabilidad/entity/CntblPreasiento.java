package com.sigre.contabilidad.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "cntbl_preasiento", schema = "contabilidad")
@EntityListeners(AuditingEntityListener.class)
public class CntblPreasiento extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 16)
    private String voucher;

    @Column(name = "libro_id", nullable = false)
    private Long libroId;

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "modulo_origen", nullable = false, length = 1)
    private String moduloOrigen;

    @Column(name = "naturaleza_asiento", nullable = false, length = 1)
    private String naturalezaAsiento;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(nullable = false, length = 3000)
    private String glosa;

    @Column(name = "moneda_id", nullable = false)
    private Long monedaId;

    @Column(name = "tasa_cambio", nullable = false, precision = 18, scale = 6)
    private BigDecimal tasaCambio;

    @Column(name = "fecha_procesamiento")
    private LocalDate fechaProcesamiento;

    @CreatedBy
    @Column(name = "created_by", updatable = false)
    private Long createdBy;

    @CreatedDate
    @Column(name = "fec_creacion", updatable = false)
    private Instant fecCreacion;

    @LastModifiedBy
    @Column(name = "updated_by")
    private Long updatedBy;

    @LastModifiedDate
    @Column(name = "fec_modificacion")
    private Instant fecModificacion;

    @OneToMany(mappedBy = "cntblPreasiento", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("secuencia ASC")
    private List<CntblPreasientoDet> detalles = new ArrayList<>();

    public void addDetalle(CntblPreasientoDet detalle) {
        detalles.add(detalle);
        detalle.setCntblPreasiento(this);
    }
}
