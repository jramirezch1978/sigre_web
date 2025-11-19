package com.sigre.sync.entity.local;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import java.time.LocalDate;

@Entity
@Table(name = "origen")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrigenLocal {

    @Id
    @Column(name = "COD_ORIGEN", length = 2)
    private String codOrigen;

    @Column(name = "NOMBRE", length = 30)
    private String nombre;

    @Column(name = "DIR_CALLE", length = 100)
    private String dirCalle;

    @Column(name = "DIR_NUMERO", length = 10)
    private String dirNumero;

    @Column(name = "DIR_LOTE", length = 10)
    private String dirLote;

    @Column(name = "DIR_MNZ", length = 10)
    private String dirMnz;

    @Column(name = "DIR_URBANIZACION", length = 50)
    private String dirUrbanizacion;

    @Column(name = "DIR_DISTRITO", length = 30)
    private String dirDistrito;

    @Column(name = "DIR_DEPARTAMENTO", length = 30)
    private String dirDepartamento;

    @Column(name = "DIR_PROVINCIA", length = 30)
    private String dirProvincia;

    @Column(name = "DIR_COD_POSTAL", length = 10)
    private String dirCodPostal;

    @Column(name = "TELEFONO", length = 20)
    private String telefono;

    @Column(name = "FAX", length = 20)
    private String fax;

    @Column(name = "EMAIL", length = 50)
    private String email;

    @Column(name = "FLAG_REPLICACION", length = 1)
    @Builder.Default
    private String flagReplicacion = "1";

    @Column(name = "FLAG_ESTADO", length = 1)
    @Builder.Default
    private String flagEstado = "1";

    @Column(name = "CEN_BEF_GEN_OC", length = 12)
    private String cenBefGenOc;

    @Column(name = "CEN_BEF_GEN_VTAS", length = 12)
    private String cenBefGenVtas;

    @Column(name = "CENCOS_OC", length = 10)
    private String cencosOc;

    @Column(name = "CNTA_PRSP_OC", length = 10)
    private String cntaPrspOc;

    @Column(name = "CENCOS_IGV", length = 10)
    private String cencosIgv;

    @Column(name = "CNTA_PRSP_IGV", length = 10)
    private String cntaPrspIgv;

    @Column(name = "FLAG_PRSP_IGV", length = 1)
    @Builder.Default
    private String flagPrspIgv = "1";

    // Campos de auditoría para sincronización
    @Column(name = "FECHA_SYNC")
    private LocalDate fechaSync;

    @Column(name = "ESTADO_SYNC", length = 1)
    @Builder.Default
    private String estadoSync = "P"; // P=Pendiente, S=Sincronizado, E=Error

    public boolean isActivo() {
        return "1".equals(flagEstado);
    }
}

