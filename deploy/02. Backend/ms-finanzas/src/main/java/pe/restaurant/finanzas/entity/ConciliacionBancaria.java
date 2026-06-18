package pe.restaurant.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "conciliacion_bancaria", schema = "finanzas")
@EntityListeners(AuditingEntityListener.class)
public class ConciliacionBancaria extends BaseEntity {

    @Column(name = "banco_cnta_id", nullable = false)
    private Long bancoCntaId;

    @Column(name = "periodo_anio", nullable = false)
    private Integer periodoAnio;

    @Column(name = "periodo_mes", nullable = false)
    private Integer periodoMes;

    @Column(name = "saldo_banco", precision = 18, scale = 4)
    private BigDecimal saldoBanco;

    @Column(name = "saldo_libros", precision = 18, scale = 4)
    private BigDecimal saldoLibros;

    @Column(precision = 18, scale = 4)
    private BigDecimal diferencia;


    @OneToMany(mappedBy = "conciliacion", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ConciliacionDet> detalles = new ArrayList<>();

    public void addDetalle(ConciliacionDet detalle) {
        detalles.add(detalle);
        detalle.setConciliacion(this);
    }

    public void removeDetalle(ConciliacionDet detalle) {
        detalles.remove(detalle);
        detalle.setConciliacion(null);
    }

    public void calcularDiferencia() {
        if (saldoBanco != null && saldoLibros != null) {
            this.diferencia = saldoBanco.subtract(saldoLibros);
        }
    }
}
