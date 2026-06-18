package pe.restaurant.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import pe.restaurant.common.entity.BaseEntity;

import java.time.LocalDate;

@Entity
@Table(name = "trabajador", schema = "rrhh")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Trabajador extends BaseEntity {

    @Column(name = "entidad_contribuyente_id")
    private Long entidadContribuyenteId;

    @Column(name = "codigo_trabajador", nullable = false, length = 20, unique = true)
    private String codigoTrabajador;

    @Column(name = "nombres", nullable = false, length = 120)
    private String nombres;

    @Column(name = "apellido_paterno", length = 120)
    private String apellidoPaterno;

    @Column(name = "apellido_materno", length = 120)
    private String apellidoMaterno;

    @Column(name = "tipo_doc_identidad_id")
    private Long tipoDocIdentidadId;

    @Column(name = "numero_documento", length = 30, unique = true)
    private String numeroDocumento;

    @Column(name = "fecha_nacimiento")
    private LocalDate fechaNacimiento;

    @Column(name = "sexo_id")
    private Long sexoId;

    @Column(name = "estado_civil_id")
    private Long estadoCivilId;

    @Column(name = "direccion", length = 300)
    private String direccion;

    @Column(name = "telefono", length = 40)
    private String telefono;

    @Column(name = "email", length = 150)
    private String email;

    @Column(name = "cuenta_bancaria_sueldo", length = 60)
    private String cuentaBancariaSueldo;

    @Column(name = "cuenta_cts", length = 60)
    private String cuentaCts;

    @Column(name = "admin_afp_id")
    private Long adminAfpId;

    @Column(name = "cuspp", length = 30)
    private String cuspp;

    @Column(name = "regimen_laboral_id")
    private Long regimenLaboralId;

    @Column(name = "area_id")
    private Long areaId;

    @Column(name = "cargo_id")
    private Long cargoId;

    @Column(name = "sucursal_id")
    private Long sucursalId;

    @Column(name = "fecha_ingreso")
    private LocalDate fechaIngreso;

    @Column(name = "fecha_cese")
    private LocalDate fechaCese;

    @Column(name = "motivo_cese", length = 120)
    private String motivoCese;
}
