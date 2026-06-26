package pe.restaurant.produccion.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.AuditOnlyMappedEntity;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "ficha_tecnica", schema = "produccion")
public class FichaTecnica extends AuditOnlyMappedEntity {

    @Column(name = "receta_id", nullable = false)
    private Long recetaId;

    @Column(name = "alergenos", length = 200)
    private String alergenos;

    @Column(name = "calorias", precision = 10, scale = 2)
    private BigDecimal calorias;

    @Column(name = "proteinas_g", precision = 10, scale = 2)
    private BigDecimal proteinasG;

    @Column(name = "carbohidratos_g", precision = 10, scale = 2)
    private BigDecimal carbohidratosG;

    @Column(name = "grasas_g", precision = 10, scale = 2)
    private BigDecimal grasasG;

    @Column(name = "fibra_g", precision = 10, scale = 2)
    private BigDecimal fibraG;

    @Column(name = "sodio_mg", precision = 10, scale = 2)
    private BigDecimal sodioMg;

    @Column(name = "flag_tipo_dieta", length = 1)
    private String flagTipoDieta = "R";

    @Column(name = "foto_presentacion_url", length = 3000)
    private String fotoPresentacionUrl;

    @Column(name = "foto_blob")
    private byte[] fotoBlob;

    @Column(name = "instrucciones_emplatado", length = 3000)
    private String instruccionesEmplatado;

    @Column(name = "tiempo_preparacion_min")
    private Integer tiempoPreparacionMin;

    @Column(name = "tiempo_coccion_min")
    private Integer tiempoCoccionMin;

    @Column(name = "flag_temperatura_servicio", length = 1)
    private String flagTemperaturaServicio;
}
