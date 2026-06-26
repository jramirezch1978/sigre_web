package pe.restaurant.contabilidad.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "cntbl_asiento", schema = "contabilidad")
public class CntblAsiento extends BaseEntity {

    @Column(nullable = false, unique = true, length = 16)
    private String voucher;

    @Column(name = "libro_id", nullable = false)
    private Long libroId;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(nullable = false, length = 3000)
    private String glosa;

    @Column(name = "naturaleza_asiento", nullable = false, length = 1)
    private String naturalezaAsiento;

    @Column(name = "modulo_origen", nullable = false, length = 1)
    private String moduloOrigen;

    @Column(name = "cntbl_preasiento_id")
    private Long cntblPreasientoId;

    @Column(name = "moneda_id", nullable = false)
    private Long monedaId;

    @Column(name = "tasa_cambio", nullable = false, precision = 18, scale = 6)
    private BigDecimal tasaCambio;

    @OneToMany(mappedBy = "cntblAsiento", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CntblAsientoDet> detalles = new ArrayList<>();

    public void addDetalle(CntblAsientoDet detalle) {
        detalles.add(detalle);
        detalle.setCntblAsiento(this);
    }

    public void removeDetalle(CntblAsientoDet detalle) {
        detalles.remove(detalle);
        detalle.setCntblAsiento(null);
    }
}
