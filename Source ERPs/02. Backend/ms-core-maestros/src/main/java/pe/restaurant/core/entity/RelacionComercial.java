package pe.restaurant.core.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "entidad_contribuyente", schema = "core")
public class RelacionComercial extends BaseEntity {

    @Column(name = "tipo_persona", nullable = false, length = 15)
    private String tipoPersona = "JURIDICA";

    @Column(name = "tipo_documento", length = 20)
    private String tipoDocumento;

    // core.entidad_contribuyente no tiene columna tipo_doc_identidad_id (DDL es la fuente de verdad).
    // Se mantiene como @Transient para el contrato del DTO sin generar SQL contra una columna inexistente.
    @Transient
    private Long tipoDocIdentidadId;

    @Column(name = "nro_documento", length = 30)
    private String nroDocumento;

    @Column(name = "razon_social", length = 200)
    private String razonSocial;

    @Column(name = "nombre_comercial", length = 300)
    private String nombreComercial;

    @Column(name = "nombres", length = 120)
    private String nombres;

    @Column(name = "apellidos", length = 120)
    private String apellidos;

    @Column(name = "direccion", length = 300)
    private String direccion;

    @Column(name = "telefono", length = 40)
    private String telefono;

    @Column(name = "email", length = 150)
    private String email;

    @Column(name = "es_proveedor", nullable = false)
    private Boolean esProveedor = false;

    @Column(name = "es_cliente", nullable = false)
    private Boolean esCliente = false;

    @Column(name = "es_empleado", nullable = false)
    private Boolean esEmpleado = false;

    @Column(name = "tipo_entidad_contribuyente_id")
    private Long tipoEntidadContribuyenteId;
}
