package com.sigre.asistencia.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import java.util.List;

@Entity
@Table(name = "centros_costo")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "cencos")
@ToString(exclude = "trabajadores")
public class CentrosCosto {
    
    @Id
    @Column(name = "CENCOS", length = 10)
    private String cencos;
    
    @Column(name = "COD_N1", length = 2)
    private String codN1;
    
    @Column(name = "COD_N2", length = 2)
    private String codN2;
    
    @Column(name = "COD_N3", length = 2)
    private String codN3;
    
    @Column(name = "ORIGEN", length = 2)
    private String origen;
    
    @Column(name = "DESC_CENCOS", length = 80)
    private String descripcionCencos;
    
    @Column(name = "EMAIL", length = 40)
    private String email;
    
    @Column(name = "FLAG_ESTADO", length = 1)
    @Builder.Default
    private String flagEstado = "1";
    
    @Column(name = "FLAG_TIPO", length = 1)
    private String flagTipo;
    
    @Column(name = "FLAG_MOD_PRES", length = 1)
    private String flagModPres;
    
    @Column(name = "FLAG_CTA_PRESUP", length = 1)
    @Builder.Default
    private String flagCtaPresup = "0";
    
    @Column(name = "GRP_CNTBL", length = 2)
    private String grupoCntbl;
    
    @Column(name = "FLAG_REPLICACION", length = 1)
    @Builder.Default
    private String flagReplicacion = "1";
    
    // Relación uno a muchos con Maestro
    @OneToMany(mappedBy = "centroCostoEntity", fetch = FetchType.LAZY)
    private List<Maestro> trabajadores;
    
    // Helper method
    public boolean isActivo() {
        return "1".equals(flagEstado);
    }
}