package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "num_ord_srv", schema = "compras")
public class NumOrdSrv {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "cod_origen", nullable = false, length = 10)
    private String codOrigen;

    @Column(name = "ult_nro")
    private Long ultNro = 0L;
}
