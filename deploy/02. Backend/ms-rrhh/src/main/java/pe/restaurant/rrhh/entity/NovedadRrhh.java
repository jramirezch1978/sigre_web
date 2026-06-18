package pe.restaurant.rrhh.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;
import java.time.LocalDate;

@Data @EqualsAndHashCode(callSuper = true)
@NoArgsConstructor @AllArgsConstructor
@Entity @Table(name = "novedad_rrhh", schema = "rrhh")
public class NovedadRrhh extends BaseEntity {

    @Column(name = "trabajador_id", nullable = false) private Long trabajadorId;
    @Column(name = "tipo_novedad_rrhh_id", nullable = false) private Long tipoNovedadRrhhId;
    @Column(name = "citt", length = 40) private String citt;
    @Column(name = "fecha_ini", nullable = false) private LocalDate fechaIni;
    @Column(name = "fecha_fin", nullable = false) private LocalDate fechaFin;
    @Column(name = "dias_teoricos") private Integer diasTeoricos;
    @Column(name = "dias_reales") private Integer diasReales;
}
