# Configuración de VS Code Launch para Microservicios

## Estructura del launch.json

El archivo `.vscode/launch.json` permite configurar cómo se ejecutan y depuran los microservicios desde VS Code.

## Objeto de Configuración para Microservicio

Para agregar un nuevo microservicio al array `configurations`, utiliza el siguiente objeto como plantilla:

```json
{
    "type": "java",
    "name": "Spring Boot-[NombreAplicacion]Application<[nombre-proyecto]>",
    "request": "launch",
    "cwd": "${workspaceFolder}",
    "mainClass": "pe.restaurant.[paquete].[NombreAplicacion]Application",
    "projectName": "[nombre-proyecto]",
    "args": "",
    "envFile": "${workspaceFolder}/.env",
    "env": {
        "DB_HOST": "db-pv-pod1-dev.contabilidad.restaurant.pe",
        "DB_PORT": "5433",
        "DB_SECURITY_NAME": "restaurant_pe_security",
        "DB_USER": "restaurant_admin",
        "DB_PASS": "Erp_restpe#2026",
        "DB_SSL_MODE": "disable",
        "API_GATEWAY_URL": "http://localhost:9002"
    }
}
```

## Ejemplo Concreto para ms-ventas

```json
{
    "type": "java",
    "name": "Spring Boot-VentasApplication<ms-ventas>",
    "request": "launch",
    "cwd": "${workspaceFolder}",
    "mainClass": "pe.restaurant.ventas.VentasApplication",
    "projectName": "ms-ventas",
    "args": "",
    "envFile": "${workspaceFolder}/.env",
    "env": {
        "DB_HOST": "db-pv-pod1-dev.contabilidad.restaurant.pe",
        "DB_PORT": "5433",
        "DB_SECURITY_NAME": "restaurant_pe_security",
        "DB_USER": "restaurant_admin",
        "DB_PASS": "Erp_restpe#2026",
        "DB_SSL_MODE": "disable",
        "API_GATEWAY_URL": "http://localhost:9002"
    }
}
```

## Fuente de Cada Dato

### Datos Automáticos (del proyecto)

| Campo | Fuente | Cómo encontrarlo |
|-------|--------|------------------|
| `mainClass` | Clase principal con `@SpringBootApplication` | Busca en `src/main/java/` la clase con `@SpringBootApplication` |
| `projectName` | artifactId del pom.xml | Línea `<artifactId>[nombre]</artifactId>` en pom.xml |
| `name` | Combinación de mainClass y projectName | Formato: "Spring Boot-[NombreClase]<[projectName]>" |

### Datos de Configuración (constantes)

| Campo | Valor | Descripción |
|-------|-------|-------------|
| `type` | "java" | Tipo de aplicación Java |
| `request` | "launch" | Acción de iniciar aplicación |
| `cwd` | "${workspaceFolder}" | Directorio raíz del workspace |
| `args` | "" | Argumentos de línea de comandos |
| `envFile` | "${workspaceFolder}/.env" | Archivo de variables de entorno |

### Variables de Entorno

| Variable | Valor Actual | Descripción |
|----------|--------------|-------------|
| `DB_HOST` | "db-pv-pod1-dev.contabilidad.restaurant.pe" | Servidor de base de datos |
| `DB_PORT` | "5433" | Puerto PostgreSQL |
| `DB_SECURITY_NAME` | "restaurant_pe_security" | Base de datos de seguridad |
| `DB_USER` | "restaurant_admin" | Usuario de base de datos |
| `DB_PASS` | "Erp_restpe#2026" | Contraseña de base de datos |
| `DB_SSL_MODE` | "disable" | Configuración SSL |
| `API_GATEWAY_URL` | "http://localhost:9002" | URL del API Gateway |

## Pasos para Agregar Nuevo Microservicio

1. **Identificar la clase principal**:
   ```bash
   find . -name "*Application.java" -path "*/src/main/java/*"
   ```

2. **Obtener el artifactId** del pom.xml:
   ```xml
   <artifactId>nombre-del-microservicio</artifactId>
   ```

3. **Construir el nombre**:
   - Si la clase es `VentasApplication` y el artifactId es `ms-ventas`
   - Resultado: "Spring Boot-VentasApplication<ms-ventas>"

4. **Copiar la plantilla** y reemplazar los valores específicos

5. **Agregar al array configurations** en launch.json

## Notas Importantes

- El `mainClass` debe incluir el paquete completo
- El `projectName` debe coincidir exactamente con el artifactId
- Las variables de entorno pueden ajustarse según las necesidades del microservicio
- Si un microservicio no necesita API Gateway, puedes omitir esa variable
