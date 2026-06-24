package com.sigre.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
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

    @Column(name = "nombre1", length = 60)
    private String nombre1;

    @Column(name = "nombre2", length = 60)
    private String nombre2;

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

    @Column(name = "alergias", length = 300)
    private String alergias;

    @Column(name = "tipo_sangre_id")
    private Long tipoSangreId;

    @Lob
    @Column(name = "foto_blob")
    private byte[] fotoBlob;

    @Lob
    @Column(name = "dni_blob")
    private byte[] dniBlob;

    @Column(name = "nro_brevete", length = 30)
    private String nroBrevete;

    @Column(name = "autogenerado_essalud", length = 30)
    private String autogeneradoEssalud;

    @Column(name = "direccion", length = 300)
    private String direccion;

    @Column(name = "telefono_fijo", length = 40)
    private String telefonoFijo;

    @Column(name = "celular1", length = 40)
    private String celular1;

    @Column(name = "celular2", length = 40)
    private String celular2;

    @Column(name = "codigo_tel_ciudad", length = 10)
    private String codigoTelCiudad;

    @Column(name = "email", length = 150)
    private String email;

    @Column(name = "flag_discapacidad", length = 1)
    private String flagDiscapacidad;

    @Column(name = "flag_domiciliado", length = 1)
    private String flagDomiciliado;

    @Column(name = "flag_comision_afp", length = 1)
    private String flagComisionAfp;

    @Column(name = "flag_pensionista", length = 1)
    private String flagPensionista;

    @Column(name = "flag_afiliado_eps", length = 1)
    private String flagAfiliadoEps;

    @Column(name = "flag_essalud_vida", length = 1)
    private String flagEssaludVida;

    @Column(name = "flag_sctr_pension", length = 1)
    private String flagSctrPension;

    @Column(name = "flag_sctr_salud", length = 1)
    private String flagSctrSalud;

    @Column(name = "flag_quinta_exonerado", length = 1)
    private String flagQuintaExonerado;

    @Column(name = "distrito_id")
    private Long distritoId;

    @Column(name = "tipo_via_id")
    private Long tipoViaId;

    @Column(name = "nombre_via", length = 200)
    private String nombreVia;

    @Column(name = "numero_via", length = 20)
    private String numeroVia;

    @Column(name = "tipo_zona_id")
    private Long tipoZonaId;

    @Column(name = "nombre_zona", length = 200)
    private String nombreZona;

    @Column(name = "tipo_vivienda_id")
    private Long tipoViviendaId;

    @Column(name = "interior", length = 50)
    private String interior;

    @Column(name = "referencia", length = 300)
    private String referencia;

    @Column(name = "cuenta_bancaria_sueldo", length = 60)
    private String cuentaBancariaSueldo;

    @Column(name = "cuenta_cts", length = 60)
    private String cuentaCts;

    @Column(name = "banco_sueldo_id")
    private Long bancoSueldoId;

    @Column(name = "banco_cts_id")
    private Long bancoCtsId;

    @Column(name = "moneda_sueldo_id")
    private Long monedaSueldoId;

    @Column(name = "moneda_cts_id")
    private Long monedaCtsId;

    @Column(name = "admin_afp_id")
    private Long adminAfpId;

    @Column(name = "cuspp", length = 30)
    private String cuspp;

    @Column(name = "pension_rtps_id")
    private Long pensionRtpsId;

    @Column(name = "regimen_pensionario_id")
    private Long regimenPensionarioId;

    @Column(name = "fec_ini_afil_afp")
    private LocalDate fecIniAfilAfp;

    @Column(name = "fec_fin_afil_afp")
    private LocalDate fecFinAfilAfp;

    @Column(name = "regimen_laboral_id")
    private Long regimenLaboralId;

    @Column(name = "tipo_trabajador_id")
    private Long tipoTrabajadorId;

    @Column(name = "tipo_trabajador_rtps_id")
    private Long tipoTrabajadorRtpsId;

    @Column(name = "ocupacion_rtps_id")
    private Long ocupacionRtpsId;

    @Column(name = "area_id")
    private Long areaId;

    @Column(name = "seccion_id")
    private Long seccionId;

    @Column(name = "cargo_id")
    private Long cargoId;

    @Column(name = "centro_costo_id")
    private Long centroCostoId;

    @Column(name = "sucursal_id")
    private Long sucursalId;

    @Column(name = "fecha_ingreso")
    private LocalDate fechaIngreso;

    @Column(name = "fecha_cese")
    private LocalDate fechaCese;

    @Column(name = "motivo_cese_id")
    private Long motivoCeseId;

    @Column(name = "motivo_cese", length = 120)
    private String motivoCese;

    @Column(name = "comentario", length = 500)
    private String comentario;

    @Column(name = "procedencia", length = 10)
    private String procedencia;

    @Column(name = "porc_judicial", nullable = false, precision = 4, scale = 2)
    private BigDecimal porcJudicial;

    @Column(name = "porc_jud_util", nullable = false, precision = 5, scale = 2)
    private BigDecimal porcJudUtil;

    @Column(name = "flag_cat_trab", nullable = false, length = 1)
    private String flagCatTrab;

    @Column(name = "flag_dscto_comedor", nullable = false, length = 1)
    private String flagDsctoComedor;
}
