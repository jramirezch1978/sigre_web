package pe.restaurant.contabilidad.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "matriz_contable", schema = "contabilidad")
public class MatrizContable extends BaseEntity {

    @Column(name = "grupo_matriz_cntbl_id", nullable = false)
    private Long grupoMatrizCntblId;

    @Column(nullable = false, unique = true, length = 10)
    private String codigo;

    @Column(length = 3000)
    private String descripcion;

    @OneToMany(mappedBy = "matrizContable", fetch = FetchType.LAZY)
    @OrderBy("secuencia ASC")
    private List<MatrizContableDet> detalles = new ArrayList<>();
}
