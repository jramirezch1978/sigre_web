package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TrabajadorRequest {

    private Long entidadContribuyenteId;

    @NotBlank(message = "El código de trabajador es obligatorio")
    @Size(max = 20)
    private String codigoTrabajador;

    @NotBlank(message = "Los nombres son obligatorios")
    @Size(max = 120)
    private String nombres;

    @Size(max = 60)
    private String nombre1;

    @Size(max = 60)
    private String nombre2;

    @Size(max = 120)
    private String apellidoPaterno;

    @Size(max = 120)
    private String apellidoMaterno;

    private Long tipoDocIdentidadId;

    @Size(max = 30)
    private String numeroDocumento;

    private LocalDate fechaNacimiento;

    private Long sexoId;

    private Long estadoCivilId;

    @Size(max = 300)
    private String alergias;

    private Long tipoSangreId;

    @Size(max = 30)
    private String nroBrevete;

    @Size(max = 30)
    private String autogeneradoEssalud;

    @Size(max = 300)
    private String direccion;

    @Size(max = 40)
    private String telefonoFijo;

    @Size(max = 40)
    private String celular1;

    @Size(max = 40)
    private String celular2;

    @Size(max = 10)
    private String codigoTelCiudad;

    @Size(max = 150)
    private String email;

    @Size(max = 1)
    private String flagDiscapacidad;

    @Size(max = 1)
    private String flagDomiciliado;

    @Size(max = 1)
    private String flagComisionAfp;

    @Size(max = 1)
    private String flagPensionista;

    @Size(max = 1)
    private String flagAfiliadoEps;

    @Size(max = 1)
    private String flagEssaludVida;

    @Size(max = 1)
    private String flagSctrPension;

    @Size(max = 1)
    private String flagSctrSalud;

    @Size(max = 1)
    private String flagQuintaExonerado;

    private Long distritoId;

    private Long tipoViaId;

    @Size(max = 200)
    private String nombreVia;

    @Size(max = 20)
    private String numeroVia;

    private Long tipoZonaId;

    @Size(max = 200)
    private String nombreZona;

    private Long tipoViviendaId;

    @Size(max = 50)
    private String interior;

    @Size(max = 300)
    private String referencia;

    @Size(max = 60)
    private String cuentaBancariaSueldo;

    @Size(max = 60)
    private String cuentaCts;

    private Long bancoSueldoId;

    private Long bancoCtsId;

    private Long monedaSueldoId;

    private Long monedaCtsId;

    private Long adminAfpId;

    @Size(max = 30)
    private String cuspp;

    private Long pensionRtpsId;

    private Long regimenPensionarioId;

    private LocalDate fecIniAfilAfp;

    private LocalDate fecFinAfilAfp;

    private Long regimenLaboralId;

    private Long tipoTrabajadorId;

    private Long tipoTrabajadorRtpsId;

    private Long ocupacionRtpsId;

    private Long areaId;

    private Long seccionId;

    private Long cargoId;

    private Long centroCostoId;

    private Long sucursalId;

    private LocalDate fechaIngreso;

    private LocalDate fechaCese;

    private Long motivoCeseId;

    @Size(max = 120)
    private String motivoCese;

    @Size(max = 500)
    private String comentario;

    @Size(max = 10)
    private String procedencia;

    /** Base64 sin prefijo data-URL; cadena vacía borra el blob existente. Null = no modificar. */
    private String fotoBlobBase64;

    /** Base64 sin prefijo data-URL; cadena vacía borra el blob existente. Null = no modificar. */
    private String dniBlobBase64;
}
