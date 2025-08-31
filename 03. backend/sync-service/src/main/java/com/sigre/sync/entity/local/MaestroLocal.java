package com.sigre.sync.entity.local;

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
public class MaestroLocal {
    
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
    
    // Campos de auditoría para sincronización
    @Column(name = "FECHA_SYNC")
    private LocalDate fechaSync;
    
    @Column(name = "ESTADO_SYNC", length = 1)
    @Builder.Default
    private String estadoSync = "P"; // P=Pendiente, S=Sincronizado, E=Error
    
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
    
    // Método helper para verificar si está activo
    public boolean isActivo() {
        return "1".equals(flagEstado);
    }
}
