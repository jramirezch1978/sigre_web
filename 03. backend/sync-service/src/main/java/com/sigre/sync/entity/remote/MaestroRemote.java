package com.sigre.sync.entity.remote;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import java.time.LocalDate;

@Entity
@Table(name = "maestro")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "codTrabajador")
public class MaestroRemote {
    
    @Id
    @Column(name = "COD_TRABAJADOR", length = 8)
    private String codTrabajador;
    
    @Column(name = "COD_TRAB_ANTGUO", length = 8)
    private String codTrabAntiguo;
    
    @Column(name = "FOTO_TRABAJ", length = 200)
    private String fotoTrabaj;
    
    @Column(name = "APEL_PATERNO", length = 40, nullable = false)
    private String apellidoPaterno;
    
    @Column(name = "APEL_MATERNO", length = 40, nullable = false)
    private String apellidoMaterno;
    
    @Column(name = "NOMBRE1", length = 40, nullable = false)
    private String nombre1;
    
    @Column(name = "NOMBRE2", length = 40)
    private String nombre2;
    
    @Column(name = "FLAG_ESTADO", length = 1, nullable = false)
    private String flagEstado;
    
    @Column(name = "FEC_INGRESO")
    private LocalDate fechaIngreso;
    
    @Column(name = "FEC_NACIMIENTO")
    private LocalDate fechaNacimiento;
    
    @Column(name = "FEC_CESE")
    private LocalDate fechaCese;
    
    @Column(name = "DIRECCION", length = 200)
    private String direccion;
    
    @Column(name = "TELEFONO1", length = 10)
    private String telefono1;
    
    @Column(name = "DNI", length = 8)
    private String dni;
    
    @Column(name = "EMAIL", length = 3000)
    private String email;
    
    @Column(name = "COD_EMPRESA", length = 8, nullable = false)
    private String codEmpresa;
    
    @Column(name = "CENCOS", length = 10, nullable = false)
    private String centroCosto;
    
    @Column(name = "FLAG_MARCA_RELOJ", length = 1)
    @Builder.Default
    private String flagMarcaReloj = "0";
    
    @Column(name = "FLAG_ESTADO_CIVIL", length = 1)
    private String flagEstadoCivil;
    
    @Column(name = "FLAG_SEXO", length = 1)
    private String flagSexo;

    @Column(name = "TIPO_TRABAJADOR", length = 3)
    private String tipoTrabajador;

    @Column(name = "COD_SECCION", length = 3)
    private String codSeccion;

    @Column(name = "COD_AREA", length = 1)
    private String codArea;

    // Método helper para obtener nombre completo
    public String getNombreCompleto() {
        StringBuilder nombre = new StringBuilder();
        nombre.append(nombre1);
        if (nombre2 != null && !nombre2.trim().isEmpty()) {
            nombre.append(" ").append(nombre2);
        }
        nombre.append(" ").append(apellidoPaterno).append(" ").append(apellidoMaterno);
        return nombre.toString().trim();
    }
}
