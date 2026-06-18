package pe.restaurant.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

@Entity
@Table(name = "banco", schema = "finanzas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Banco extends BaseEntity {
    
    @Column(name = "cod_banco", nullable = false, unique = true, length = 3)
    private String codBanco;
    
    @Column(name = "nom_banco", length = 120)
    private String nomBanco;
    
    @Column(name = "proveedor", length = 8)
    private String proveedor;
    
    @Column(name = "cod_banco_rtps", length = 2)
    private String codBancoRtps;
    
    @Column(name = "direccion", length = 200)
    private String direccion;
    
    @Column(name = "swift", length = 20)
    private String swift;
    
    @Column(name = "cod_banco_sunat", length = 2)
    private String codBancoSunat;
}
