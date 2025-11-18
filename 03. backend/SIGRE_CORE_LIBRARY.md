# 📚 SIGRE Core Library - Librería Compartida

## ¿Por qué una Librería y no un Microservicio?

**CoreLibrary NO debe ser un microservicio** porque contiene:
- Funciones utilitarias comunes
- Validadores reutilizables
- Constantes del sistema
- Helpers y converters
- Excepciones personalizadas base
- DTOs comunes

Estos componentes deben ser una **dependencia Maven (JAR)** que todos los microservicios incluyan, no un servicio REST.

---

## 🏗️ Estructura de la Librería

```
sigre-core-library/
├── pom.xml
└── src/
    ├── main/
    │   └── java/
    │       └── com/
    │           └── sigre/
    │               └── core/
    │                   ├── constants/
    │                   │   ├── SigreConstants.java
    │                   │   └── TipoDocumento.java
    │                   ├── dto/
    │                   │   ├── ResponseDTO.java
    │                   │   ├── ErrorDTO.java
    │                   │   └── PaginatedResponseDTO.java
    │                   ├── exception/
    │                   │   ├── SigreException.java
    │                   │   ├── ValidationException.java
    │                   │   └── ResourceNotFoundException.java
    │                   ├── util/
    │                   │   ├── DateUtils.java
    │                   │   ├── StringUtils.java
    │                   │   ├── NumberUtils.java
    │                   │   └── ValidationUtils.java
    │                   └── validator/
    │                       ├── RucValidator.java
    │                       └── DocumentoValidator.java
    └── test/
        └── java/
            └── com/
                └── sigre/
                    └── core/
```

---

## 📄 pom.xml de la Librería

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.sigre</groupId>
    <artifactId>sigre-core-library</artifactId>
    <version>2.0.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <name>SIGRE Core Library</name>
    <description>Librería compartida con utilidades comunes para todos los microservicios</description>

    <properties>
        <java.version>17</java.version>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <lombok.version>1.18.30</lombok.version>
    </properties>

    <dependencies>
        <!-- Lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>${lombok.version}</version>
            <scope>provided</scope>
        </dependency>

        <!-- Validation -->
        <dependency>
            <groupId>jakarta.validation</groupId>
            <artifactId>jakarta.validation-api</artifactId>
            <version>3.0.2</version>
        </dependency>

        <!-- Test -->
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.10.1</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
            </plugin>
        </plugins>
    </build>

</project>
```

---

## 💡 Ejemplos de Clases

### 1. SigreConstants.java

```java
package com.sigre.core.constants;

public class SigreConstants {
    
    // Estados
    public static final String ESTADO_ACTIVO = "1";
    public static final String ESTADO_INACTIVO = "0";
    public static final String ESTADO_ANULADO = "A";
    
    // Flags
    public static final String FLAG_SI = "S";
    public static final String FLAG_NO = "N";
    
    // Tipos de documento
    public static final String DOC_FACTURA = "FAC";
    public static final String DOC_BOLETA = "BOL";
    public static final String DOC_NOTA_CREDITO = "NCR";
    public static final String DOC_GUIA_REMISION = "GRE";
    
    // Tipos de movimiento
    public static final String MOV_INGRESO = "ING";
    public static final String MOV_SALIDA = "SAL";
    
    // Libros contables
    public static final String LIBRO_DIARIO = "DIARIO";
    public static final String LIBRO_COMPRAS = "COMPRAS";
    public static final String LIBRO_VENTAS = "VENTAS";
    
    private SigreConstants() {
        throw new IllegalStateException("Utility class");
    }
}
```

### 2. ResponseDTO.java

```java
package com.sigre.core.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResponseDTO<T> {
    
    private boolean success;
    private String message;
    private T data;
    private Long timestamp;
    
    public static <T> ResponseDTO<T> success(T data) {
        return ResponseDTO.<T>builder()
            .success(true)
            .data(data)
            .timestamp(System.currentTimeMillis())
            .build();
    }
    
    public static <T> ResponseDTO<T> success(String message, T data) {
        return ResponseDTO.<T>builder()
            .success(true)
            .message(message)
            .data(data)
            .timestamp(System.currentTimeMillis())
            .build();
    }
    
    public static <T> ResponseDTO<T> error(String message) {
        return ResponseDTO.<T>builder()
            .success(false)
            .message(message)
            .timestamp(System.currentTimeMillis())
            .build();
    }
}
```

### 3. DateUtils.java

```java
package com.sigre.core.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class DateUtils {
    
    private static final DateTimeFormatter PERIODO_FORMATTER = DateTimeFormatter.ofPattern("yyyyMM");
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    
    public static String toPeriodo(LocalDate fecha) {
        return fecha.format(PERIODO_FORMATTER);
    }
    
    public static String formatDate(LocalDate fecha) {
        return fecha.format(DATE_FORMATTER);
    }
    
    public static LocalDate periodoToDate(String periodo) {
        return LocalDate.parse(periodo + "01", DateTimeFormatter.ofPattern("yyyyMMdd"));
    }
    
    public static boolean esMismoPeriodo(LocalDate fecha1, LocalDate fecha2) {
        return toPeriodo(fecha1).equals(toPeriodo(fecha2));
    }
    
    private DateUtils() {
        throw new IllegalStateException("Utility class");
    }
}
```

### 4. ValidationUtils.java

```java
package com.sigre.core.util;

import com.sigre.core.exception.ValidationException;

public class ValidationUtils {
    
    public static void requireNonBlank(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            throw new ValidationException(fieldName + " es requerido");
        }
    }
    
    public static void requireNonNull(Object value, String fieldName) {
        if (value == null) {
            throw new ValidationException(fieldName + " es requerido");
        }
    }
    
    public static void requirePositive(Number value, String fieldName) {
        if (value == null || value.doubleValue() <= 0) {
            throw new ValidationException(fieldName + " debe ser positivo");
        }
    }
    
    public static boolean isValidRuc(String ruc) {
        if (ruc == null || ruc.length() != 11) {
            return false;
        }
        return ruc.matches("\\d{11}");
    }
    
    private ValidationUtils() {
        throw new IllegalStateException("Utility class");
    }
}
```

### 5. SigreException.java

```java
package com.sigre.core.exception;

import lombok.Getter;

@Getter
public class SigreException extends RuntimeException {
    
    private final String code;
    
    public SigreException(String message) {
        super(message);
        this.code = "SIGRE_ERROR";
    }
    
    public SigreException(String code, String message) {
        super(message);
        this.code = code;
    }
    
    public SigreException(String message, Throwable cause) {
        super(message, cause);
        this.code = "SIGRE_ERROR";
    }
}
```

---

## 🔧 Cómo Usar en los Microservicios

### 1. Agregar Dependencia en pom.xml

En cada microservicio, agregar:

```xml
<dependency>
    <groupId>com.sigre</groupId>
    <artifactId>sigre-core-library</artifactId>
    <version>2.0.0-SNAPSHOT</version>
</dependency>
```

### 2. Usar en el Código

```java
package com.sigre.contabilidad.service;

import com.sigre.core.constants.SigreConstants;
import com.sigre.core.dto.ResponseDTO;
import com.sigre.core.util.DateUtils;
import com.sigre.core.util.ValidationUtils;

@Service
public class AsientoService {
    
    public ResponseDTO<AsientoDTO> crearAsiento(AsientoRequestDTO request) {
        // Validar
        ValidationUtils.requireNonBlank(request.getEmpresa(), "empresa");
        ValidationUtils.requireNonNull(request.getFecha(), "fecha");
        
        // Usar constantes
        asiento.setFlagEstado(SigreConstants.ESTADO_ACTIVO);
        asiento.setLibro(SigreConstants.LIBRO_DIARIO);
        
        // Usar utilidades
        String periodo = DateUtils.toPeriodo(request.getFecha());
        asiento.setPeriodo(periodo);
        
        // Retornar respuesta estandarizada
        return ResponseDTO.success("Asiento creado", asientoDTO);
    }
}
```

---

## 📦 Instalación Local

```bash
# 1. Compilar la librería
cd sigre-core-library
mvn clean install

# 2. Se instalará en repositorio Maven local
# ~/.m2/repository/com/sigre/sigre-core-library/2.0.0-SNAPSHOT/

# 3. Ahora todos los microservicios pueden usarla
```

---

## 🚀 Ventajas de esta Arquitectura

✅ **DRY (Don't Repeat Yourself)**: Código compartido en un solo lugar  
✅ **Consistencia**: Todos los servicios usan las mismas utilidades  
✅ **Mantenibilidad**: Cambios en un lugar afectan a todos  
✅ **Versionado**: Control de versiones de la librería  
✅ **Ligereza**: No consume recursos como un microservicio  
✅ **Sin latencia**: Llamadas locales, no HTTP  

---

## 📝 Ubicación Recomendada

```
Proyecto-SIGRE-2.0/
├── 01. documentacion/
├── 02. frontend/
├── 03. backend/
│   ├── sigre-core-library/          ← Crear aquí
│   │   ├── pom.xml
│   │   └── src/
│   ├── service-discovery/
│   ├── api-gateway/
│   └── ...
└── 04. database/
```

---

**Resumen**: CoreLibrary debe ser un **JAR compartido**, no un microservicio HTTP. 📚


