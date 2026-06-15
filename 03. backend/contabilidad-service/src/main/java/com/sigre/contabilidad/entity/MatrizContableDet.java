package com.sigre.contabilidad.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.Instant;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "matriz_contable_det", schema = "contabilidad")
@EntityListeners(AuditingEntityListener.class)
public class MatrizContableDet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "matriz_contable_id", nullable = false)
    private MatrizContable matrizContable;

    @Column(nullable = false)
    private Integer secuencia;

    @Column(name = "plan_contable_det_id")
    private Long planContableDetId;

    @Column(name = "flag_deb_hab", nullable = false, length = 1)
    private String flagDebHab;

    @Column(name = "referencia_campo", length = 60)
    private String referenciaCampo;

    @Column(length = 30)
    private String campo;

    @Column(length = 500)
    private String formula;

    @Column(name = "glosa_texto", length = 500)
    private String glosaTexto;

    @Column(name = "glosa_campo", length = 500)
    private String glosaCampo;

    @Column(name = "flag_cencos", length = 1)
    private String flagCencos;

    @Column(name = "flag_ctabco", length = 1)
    private String flagCtabco;

    @Column(name = "flag_docref", length = 1)
    private String flagDocref;

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
}
