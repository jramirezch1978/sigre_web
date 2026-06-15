package com.sigre.contabilidad.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.Objects;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "cntbl_cierre", schema = "contabilidad")
@IdClass(CntblCierre.CntblCierreId.class)
public class CntblCierre {

    @Id
    @Column(name = "ano", nullable = false)
    private Integer ano;

    @Id
    @Column(name = "mes", nullable = false)
    private Integer mes;

    @Column(name = "flag_cierre_mes", length = 1)
    private String flagCierreMes;

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
