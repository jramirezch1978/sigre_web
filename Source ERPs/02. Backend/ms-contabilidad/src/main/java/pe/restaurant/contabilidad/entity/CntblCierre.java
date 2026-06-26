package pe.restaurant.contabilidad.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.io.Serializable;
import java.time.Instant;
import java.util.Objects;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "cntbl_cierre", schema = "contabilidad")
@IdClass(CntblCierre.CntblCierreId.class)
@EntityListeners(AuditingEntityListener.class)
public class CntblCierre {

    @Id
    @Column(name = "ano", nullable = false)
    private Integer ano;

    @Id
    @Column(name = "mes", nullable = false)
    private Integer mes;

    @Column(name = "flag_reg_cntbl", length = 1)
    private String flagRegCntbl = "1";

    @Column(name = "flag_mov_banco", length = 1)
    private String flagMovBanco = "1";

    @Column(name = "flag_cierre_mes", length = 1)
    private String flagCierreMes = "1";

    @Column(name = "flag_gen_asnt_autom", length = 1)
    private String flagGenAsntAutom = "0";

    @Column(name = "pd_campo", length = 1)
    private String pdCampo = "1";

    @Column(name = "pd_dma", length = 1)
    private String pdDma = "1";

    @Column(name = "pd_mtto_fab", length = 1)
    private String pdMttoFab = "1";

    @Column(name = "pd_mtto_maq", length = 1)
    private String pdMttoMaq = "1";

    @Column(name = "flag_almacen", length = 1)
    private String flagAlmacen = "0";

    @Column(name = "flag_oper_ot", length = 1)
    private String flagOperOt = "0";

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

    @Getter
    @Setter
    @NoArgsConstructor
    public static class CntblCierreId implements Serializable {
        private Integer ano;
        private Integer mes;

        public CntblCierreId(Integer ano, Integer mes) {
            this.ano = ano;
            this.mes = mes;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof CntblCierreId that)) return false;
            return Objects.equals(ano, that.ano) && Objects.equals(mes, that.mes);
        }

        @Override
        public int hashCode() {
            return Objects.hash(ano, mes);
        }
    }
}
