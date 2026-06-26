package pe.restaurant.almacen.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.Objects;

/**
 * Tabla {@code contabilidad.tipo_mov_matriz_subcat}.
 * PK compuesta: (tipo_mov, grp_cntbl, cod_sub_cat, item).
 */
@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "tipo_mov_matriz_subcat", schema = "contabilidad")
@IdClass(TipoMovMatrizSubcat.TipoMovMatrizSubcatId.class)
public class TipoMovMatrizSubcat {

    @Id
    @Column(name = "tipo_mov", nullable = false, length = 10)
    private String tipoMov;

    @Id
    @Column(name = "grp_cntbl", nullable = false, length = 2)
    private String grpCntbl;

    @Id
    @Column(name = "cod_sub_cat", nullable = false, length = 10)
    private String codSubCat;

    @Id
    @Column(nullable = false)
    private Integer item;

    @Column(name = "matriz_contable_id", nullable = false)
    private Long matrizCntblFinanId;

    @Getter
    @Setter
    @NoArgsConstructor
    public static class TipoMovMatrizSubcatId implements Serializable {
        private String tipoMov;
        private String grpCntbl;
        private String codSubCat;
        private Integer item;

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof TipoMovMatrizSubcatId that)) return false;
            return Objects.equals(tipoMov, that.tipoMov)
                    && Objects.equals(grpCntbl, that.grpCntbl)
                    && Objects.equals(codSubCat, that.codSubCat)
                    && Objects.equals(item, that.item);
        }

        @Override
        public int hashCode() {
            return Objects.hash(tipoMov, grpCntbl, codSubCat, item);
        }
    }
}
