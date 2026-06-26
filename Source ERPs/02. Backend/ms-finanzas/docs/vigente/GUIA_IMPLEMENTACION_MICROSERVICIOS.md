# Guía de Implementación de Microservicios - Restaurant.pe ERP

## 📋 Tabla de Contenido

1. [Introducción](#introducción)
2. [Arquitectura Base del Microservicio](#arquitectura-base-del-microservicio)
3. [Estructura de Capas](#estructura-de-capas)
4. [Configuración del Microservicio](#configuración-del-microservicio)
5. [Comunicación entre Microservicios](#comunicación-entre-microservicios)
6. [Patrón de Validación de FK Externas](#patrón-de-validación-de-fk-externas)
7. [Implementación de Entidades CRUD](#implementación-de-entidades-crud)
8. [Manejo de Errores](#manejo-de-errores)
9. [Deployment en Kubernetes](#deployment-en-kubernetes)
10. [Checklist de Implementación](#checklist-de-implementación)

---

## 1. Introducción

  Este documento establece los patrones y guías de implementación estándar para microservicios en el proyecto Restaurant.pe ERP. Se basa en las implementaciones de los microservicios `ms-activos-fijos` y `ms-finanzas` y debe aplicarse a todos los microservicios del sistema.

### 1.1 Objetivo

Proporcionar una guía completa y replicable para:
  - Crear nuevos microservicios
  - Implementar entidades de negocio
  - Validar relaciones entre microservicios
  - Mantener consistencia en el código
  - Facilitar el mantenimiento y escalabilidad

### 1.2 Alcance

Esta guía cubre:
  - ✅ Estructura de proyecto y capas
  - ✅ Configuración de comunicación inter-microservicios
  - ✅ Validación de Foreign Keys externas
  - ✅ Manejo de errores estandarizado
  - ✅ Deployment en Kubernetes
  - ✅ Pruebas locales y en producción

---

## 2. Arquitectura Base del Microservicio

  ### 2.1 Stack Tecnológico

  | Componente | Tecnología | Versión |
  |------------|-----------|---------|
  | Framework | Spring Boot | 3.x |
  | Lenguaje | Java | 17+ |
  | Base de Datos | PostgreSQL | 15+ |
  | HTTP Client | OpenFeign | 4.x |
  | Build Tool | Maven | 3.9+ |
  | Container | Docker | Latest |
  | Orchestration | Kubernetes (EKS) | 1.28+ |
  | **Puerto ms-finanzas** | **9005** | **Schema finanzas** |
  | **Puerto ms-activos-fijos** | **9008** | **Schema activos** |
  
  ### 2.2 Arquitectura de Microservicios
  
  ```
  ┌─────────────────────────────────────────────────────┐
  │                   Cliente/Frontend                   │
  └──────────────────────┬──────────────────────────────┘
  │
  ▼
  ┌─────────────────────────────────────────────────────┐
  │                  API Gateway (8080)                  │
  │  - Enrutamiento                                      │
  │  - Autenticación JWT                                 │
  │  - Rate Limiting                                     │
  └──────────┬────────────────────────┬─────────────────┘
  │                        │
  ▼                        ▼
  ┌──────────────────────┐  ┌──────────────────────┐
  │  ms-activos-fijos    │  │  ms-core-maestros    │
  │  (Puerto 9008)       │  │  (Puerto 9002)       │
  │                      │  │                      │
  │  - Aseguradoras      │  │  - Sucursales        │
  │  - Clases            │  │  - Empresas          │
  │  - SubClases         │  │  - Monedas           │
  │  - Ubicaciones       │  │  - Etc.              │
  └──────────┬───────────┘  └──────────┬───────────┘
  │                         │
  ▼                        ▼
  ┌──────────────────────┐  ┌──────────────────────┐
  │    ms-finanzas       │  │    ms-auth-security  │
  │    (Puerto 9005)     │  │    (Puerto 9001)     │
  │                      │  │                      │
  │  - Bancos            │  │  - Usuarios          │
  │  - Cuentas Bancarias │  │  - Roles             │
  │  - Conceptos Fin.    │  │  - Permisos          │
  │  - Flujos de Caja    │  │  - JWT Tokens        │
  │  - CxP/CxC           │  │                      │
  └──────────┬───────────┘  └──────────┬───────────┘
  │                         │
  └────────HTTP/Feign───────┘
  (Validación FK)
  ```
  
  ### 2.3 Comunicación entre Microservicios
  
  **Patrón:** Comunicación HTTP a través del API Gateway usando Feign Client
  
  **Flujo:**
  ```
  ms-activos-fijos → API Gateway → ms-core-maestros
  (Feign)         (Port 80)      (Port 9002)
  
  ms-finanzas → API Gateway → ms-core-maestros
  (Feign)      (Port 80)      (Port 9002)
  
  ms-finanzas → API Gateway → ms-auth-security
  (Feign)      (Port 80)      (Port 9001)
  ```

---

## 3. Estructura de Capas

  ### 3.1 Organización de Paquetes

  **Para ms-activos-fijos:**
  ```
  pe.restaurant.activos/
  ├── client/              # Feign Clients para comunicación externa
  │   └── CoreMaestrosClient.java
  ├── config/              # Configuraciones de Spring
  │   ├── FeignConfig.java
  │   ├── DataSourceConfig.java
  │   └── SecurityConfig.java
  ├── controller/          # Endpoints REST
  │   ├── AfAseguradoraController.java
  │   ├── AfClaseController.java
  │   ├── AfSubClaseController.java
  │   └── AfUbicacionController.java
  ├── dto/                 # Data Transfer Objects
  │   ├── request/
  │   │   ├── AfAseguradoraRequest.java
  │   │   ├── AfClaseRequest.java
  │   │   ├── AfSubClaseRequest.java
  │   │   └── AfUbicacionRequest.java
  │   ├── response/
  │   │   ├── AfAseguradoraResponse.java
  │   │   ├── AfClaseResponse.java
  │   │   ├── AfSubClaseResponse.java
  │   │   └── AfUbicacionResponse.java
  │   └── SucursalResponse.java  # DTOs de otros microservicios
  ├── entity/              # Entidades JPA
  │   ├── AfAseguradora.java
  │   ├── AfClase.java
  │   ├── AfSubClase.java
  │   └── AfUbicacion.java
  ├── enums/               # Enumeraciones
  ├── event/               # Event Publishers/Listeners
  ├── exception/           # Excepciones personalizadas (hereda de common)
  ├── mapper/              # Mappers DTO <-> Entity
  │   ├── AfAseguradoraMapper.java
  │   ├── AfClaseMapper.java
  │   ├── AfSubClaseMapper.java
  │   └── AfUbicacionMapper.java
  ├── repository/          # Repositorios JPA
  │   ├── AfAseguradoraRepository.java
  │   ├── AfClaseRepository.java
  │   ├── AfSubClaseRepository.java
  │   └── AfUbicacionRepository.java
  ├── service/             # Interfaces de servicio
  │   ├── AfAseguradoraService.java
  │   ├── AfClaseService.java
  │   ├── AfSubClaseService.java
  │   ├── AfUbicacionService.java
  │   └── ActivosErrorCodes.java
  └── service/impl/        # Implementaciones de servicio
  ├── AfAseguradoraServiceImpl.java
  ├── AfClaseServiceImpl.java
  ├── AfSubClaseServiceImpl.java
  └── AfUbicacionServiceImpl.java
  ```
  
  **Para ms-finanzas:**
  ```
  pe.restaurant.finanzas/
  ├── client/              # Feign Clients para comunicación externa
  │   ├── CoreMaestrosClient.java
  │   └── AuthSecurityClient.java
  ├── config/              # Configuraciones de Spring
  │   ├── FeignConfig.java
  │   ├── DataSourceConfig.java
  │   └── SecurityConfig.java
  ├── controller/          # Endpoints REST
  │   ├── BancoController.java
  │   ├── CuentaBancariaController.java
  │   ├── ConceptoFinancieroController.java
  │   ├── CodigoFlujoCajaController.java
  │   └── GrupoFlujoCajaController.java
  ├── dto/                 # Data Transfer Objects
  │   ├── request/
  │   │   ├── BancoRequest.java
  │   │   ├── CuentaBancariaRequest.java
  │   │   ├── ConceptoFinancieroRequest.java
  │   │   ├── CodigoFlujoCajaRequest.java
  │   │   └── GrupoFlujoCajaRequest.java
  │   ├── response/
  │   │   ├── BancoResponse.java
  │   │   ├── CuentaBancariaResponse.java
  │   │   ├── ConceptoFinancieroResponse.java
  │   │   ├── CodigoFlujoCajaResponse.java
  │   │   └── GrupoFlujoCajaResponse.java
  │   ├── MonedaResponse.java     # DTOs de ms-core-maestros
  │   └── UsuarioResponse.java   # DTOs de ms-auth-security
  ├── entity/              # Entidades JPA
  │   ├── Banco.java
  │   ├── BancoCnta.java
  │   ├── ConceptoFinanciero.java
  │   ├── GrupoCodigoFlujoCaja.java
  │   ├── CodigoFlujoCaja.java
  │   └── AutorizadorGiro.java
  ├── enums/               # Enumeraciones
  ├── event/               # Event Publishers/Listeners
  ├── exception/           # Excepciones personalizadas (hereda de common)
  ├── mapper/              # Mappers DTO <-> Entity
  │   ├── BancoMapper.java
  │   ├── CuentaBancariaMapper.java
  │   ├── ConceptoFinancieroMapper.java
  │   ├── CodigoFlujoCajaMapper.java
  │   └── GrupoFlujoCajaMapper.java
  ├── repository/          # Repositorios JPA
  │   ├── BancoRepository.java
  │   ├── BancoCntaRepository.java
  │   ├── ConceptoFinancieroRepository.java
  │   ├── CodigoFlujoCajaRepository.java
  │   └── GrupoFlujoCajaRepository.java
  ├── service/             # Interfaces de servicio
  │   ├── BancoService.java
  │   ├── CuentaBancariaService.java
  │   ├── ConceptoFinancieroService.java
  │   ├── CodigoFlujoCajaService.java
  │   ├── GrupoFlujoCajaService.java
  │   └── FinanzasErrorCodes.java
  └── service/impl/        # Implementaciones de servicio
  ├── BancoServiceImpl.java
  ├── CuentaBancariaServiceImpl.java
  ├── ConceptoFinancieroServiceImpl.java
  ├── CodigoFlujoCajaServiceImpl.java
  └── GrupoFlujoCajaServiceImpl.java
  ```
  
  ### 3.2 Responsabilidades por Capa
  
  | Capa | Responsabilidad | Reglas |
  |------|----------------|--------|
  | **Controller** | Exponer endpoints REST, validar entrada | No lógica de negocio, solo orquestación |
  | **Service** | Lógica de negocio, validaciones, transacciones | SRP: una responsabilidad por servicio |
  | **Repository** | Acceso a datos, consultas JPA | Solo operaciones de BD |
  | **Mapper** | Transformación DTO ↔ Entity | Sin lógica de negocio |
  | **Client** | Comunicación con microservicios externos | Configurado con Feign |
  | **Config** | Configuración de beans, seguridad, Feign | Centralizar configuraciones |

---

## 4. Configuración del Microservicio

### 4.1 application.yml

  ```yaml
server:
  port: 9005  # Puerto único por microservicio (ms-finanzas)
  # Para ms-activos-fijos usar puerto 9008

spring:
  application:
    name: ms-finanzas  # Para ms-activos-fijos usar ms-activos-fijos
  jpa:
    hibernate:
      ddl-auto: none
    open-in-view: false
    properties:
      hibernate:
        default_schema: finanzas  # Schema del microservicio
        # Para ms-activos-fijos usar: activos
        dialect: org.hibernate.dialect.PostgreSQLDialect
  flyway:
    enabled: false
  rabbitmq:
    host: ${RABBIT_HOST:localhost}
    port: ${RABBIT_PORT:5672}
    username: ${RABBIT_USER:restaurant}
    password: ${RABBIT_PASS:R4bb1t_D3v!}

management:
  endpoints:
    web:
      exposure:
        include: health,info,prometheus

app:
  security-datasource:
    jdbc-url: jdbc:postgresql://${DB_HOST:localhost}:${DB_PORT:5432}/${DB_SECURITY_NAME:restaurant_pe_security}?sslmode=${DB_SSL_MODE:require}
    username: ${DB_USER:restaurant_admin}
    password: ${DB_PASS:R3st4ur4nt_D3v!}
  tenant:
    jdbc-ssl-mode: ${DB_SSL_MODE:require}
    pool:
      maximum-pool-size: ${TENANT_POOL_MAX:8}
      minimum-idle: ${TENANT_POOL_MIN_IDLE:0}

# Configuración para comunicación con otros microservicios
api:
  gateway:
    url: ${API_GATEWAY_URL:http://localhost:8080}

# Configuración de Feign Client
feign:
  client:
    config:
      default:
        connectTimeout: 5000
        readTimeout: 10000
        loggerLevel: basic
  compression:
    request:
      enabled: true
    response:
      enabled: true

springdoc:
  api-docs:
    path: /api/finanzas/v3/api-docs  # Para ms-activos-fijos usar: /api/activos/v3/api-docs
  swagger-ui:
    path: /api/finanzas/swagger-ui.html  # Para ms-activos-fijos usar: /api/activos/swagger-ui.html
  ```
  
  ### 4.2 application-local.yml (para desarrollo local)
  
  ```yaml
# Configuración para desarrollo local - conexión directa sin API Gateway
api:
  gateway:
    url: http://localhost:9002  # Conexión directa a ms-core-maestros
  ```

  **Uso:**
  ```bash
  mvn spring-boot:run -Dspring.profiles.active=local
  ```

### 4.3 Variables de Entorno

  | Variable | Descripción | Ejemplo Local | Ejemplo Kubernetes |
  |----------|-------------|---------------|-------------------|
  | `DB_HOST` | Host de PostgreSQL | localhost | rds-endpoint.amazonaws.com |
  | `DB_PORT` | Puerto de PostgreSQL | 5432 | 5432 |
  | `DB_USER` | Usuario de BD | restaurant_admin | restaurant_admin |
  | `DB_PASS` | Password de BD | (secret) | (desde Secret) |
  | `DB_SECURITY_NAME` | Base de datos security | restaurant_pe_security | restaurant_pe_security |
  | `DB_SSL_MODE` | Modo SSL | require | require |
  | `RABBIT_HOST` | Host de RabbitMQ | localhost | rabbitmq.observability.svc.cluster.local |
  | `RABBIT_PORT` | Puerto de RabbitMQ | 5672 | 5672 |
  | `RABBIT_USER` | Usuario RabbitMQ | restaurant | restaurant |
  | `RABBIT_PASS` | Password RabbitMQ | (secret) | (desde Secret) |
  | `API_GATEWAY_URL` | URL del API Gateway | http://localhost:8080 | http://api-gateway:80 |

---

## 5. Comunicación entre Microservicios

  ### 5.1 Principios de Comunicación

  1. **Siempre a través del API Gateway** (excepto en desarrollo local)
  2. **Transmitir el JWT token** en todas las peticiones
  3. **Usar Feign Client** para comunicación HTTP
  4. **Manejo robusto de errores** (timeouts, 404, etc.)
  5. **Logging** de todas las peticiones externas
  
  ### 5.2 Implementación de Feign Client
  
  #### 5.2.1 Crear DTO de Respuesta Externa
  
  **Archivo:** `dto/SucursalResponse.java`
  
  ```java
  package pe.restaurant.activos.dto;
  
  import lombok.AllArgsConstructor;
  import lombok.Data;
  import lombok.NoArgsConstructor;
  
  @Data
  @NoArgsConstructor
  @AllArgsConstructor
  public class SucursalResponse {
  private Long id;
  private String codigo;
  private String nombre;
  private String flagEstado;  // "1" = activo, "0" = inactivo
  private Long empresaId;
}
  ```

  **⚠️ Importante:** El DTO debe coincidir exactamente con la respuesta del microservicio externo.
  
  #### 5.2.2 Crear Configuración de Feign
  
  **Archivo:** `config/FeignConfig.java`
  
  ```java
  package pe.restaurant.activos.config;
  
  import feign.RequestInterceptor;
  import org.springframework.context.annotation.Bean;
  import org.springframework.context.annotation.Configuration;
  import org.springframework.web.context.request.RequestContextHolder;
  import org.springframework.web.context.request.ServletRequestAttributes;
  
  @Configuration
  public class FeignConfig {
  
  @Bean
  public RequestInterceptor requestInterceptor() {
  return requestTemplate -> {
  ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
  if (attributes != null) {
  // Transmitir Authorization header (JWT token)
  String authorization = attributes.getRequest().getHeader("Authorization");
  if (authorization != null) {
  requestTemplate.header("Authorization", authorization);
  }
  
  // Transmitir headers de contexto tenant
  String userId = attributes.getRequest().getHeader("X-User-Id");
  if (userId != null) {
  requestTemplate.header("X-User-Id", userId);
  }
  
  String empresaId = attributes.getRequest().getHeader("X-Empresa-Id");
  if (empresaId != null) {
  requestTemplate.header("X-Empresa-Id", empresaId);
  }
  }
  };
  }
}
  ```

  **Función:** Este interceptor captura los headers de la petición entrante y los transmite al microservicio destino.
  
  #### 5.2.3 Crear Feign Client Interface
  
  **Archivo:** `client/CoreMaestrosClient.java`
  
  ```java
  package pe.restaurant.activos.client;
  
  import org.springframework.cloud.openfeign.FeignClient;
  import org.springframework.web.bind.annotation.GetMapping;
  import org.springframework.web.bind.annotation.PathVariable;
  import pe.restaurant.activos.dto.SucursalResponse;
  import pe.restaurant.common.dto.ApiResponse;
  
  @FeignClient(
  name = "ms-core-maestros",
  url = "${api.gateway.url}",
  path = "/api/core/sucursales",
  configuration = pe.restaurant.activos.config.FeignConfig.class
  )
  public interface CoreMaestrosClient {
  
  @GetMapping("/{id}")
  ApiResponse<SucursalResponse> obtenerSucursalPorId(@PathVariable("id") Long id);
}
  ```

  **Parámetros:**
- `name`: Nombre del microservicio destino (para Eureka, opcional)
- `url`: URL base (API Gateway)
- `path`: Path base del recurso
- `configuration`: Configuración de Feign con interceptor

---

## 6. Patrón de Validación de FK Externas

### 6.1 Cuándo Aplicar

Este patrón **DEBE** aplicarse cuando:
  - ✅ Una entidad tiene una FK hacia otra entidad en **otro microservicio**
  - ✅ Necesitas validar la **existencia** del registro
  - ✅ Necesitas validar el **estado** del registro (activo/inactivo)

  **Ejemplo:** `AfUbicacion` tiene FK `sucursalId` → tabla `sucursal` en `ms-core-maestros`
  
  ### 6.2 Implementación Paso a Paso
  
  #### Paso 1: Crear DTO de Respuesta
  
  Ya cubierto en sección 5.2.1
  
  #### Paso 2: Crear Feign Client
  
  Ya cubierto en sección 5.2.3

#### Paso 3: Agregar Códigos de Error

  **Archivo:** `service/ActivosErrorCodes.java`
  
  ```java
  package pe.restaurant.activos.service;
  
  public class ActivosErrorCodes {
  
  // ... otros códigos ...
  
  public static final ErrorCode SUCURSAL_NO_ENCONTRADA = new ErrorCode(
  "ACT-007",
  "La sucursal especificada no existe en el sistema"
  );
  
  public static final ErrorCode SUCURSAL_INACTIVA = new ErrorCode(
  "ACT-008",
  "La sucursal está inactiva y no puede ser utilizada"
  );

// Patrón genérico para otras FK externas:
  // [ENTIDAD]_NO_ENCONTRADA = ACT-00X
  // [ENTIDAD]_INACTIVA = ACT-00X
}
  ```

#### Paso 4: Implementar Método de Validación en Service

  **Archivo:** `service/impl/AfUbicacionServiceImpl.java`
  
  ```java
  package pe.restaurant.activos.service.impl;
  
  import feign.FeignException;
  import lombok.RequiredArgsConstructor;
  import lombok.extern.slf4j.Slf4j;
  import org.springframework.http.HttpStatus;
  import org.springframework.stereotype.Service;
  import org.springframework.transaction.annotation.Transactional;
  import pe.restaurant.activos.client.CoreMaestrosClient;
  import pe.restaurant.activos.dto.SucursalResponse;
  import pe.restaurant.activos.service.ActivosErrorCodes;
  import pe.restaurant.common.dto.ApiResponse;
  import pe.restaurant.common.exception.BusinessException;
  
  @Slf4j
  @Service
  @RequiredArgsConstructor
  public class AfUbicacionServiceImpl implements AfUbicacionService {
  
  private final CoreMaestrosClient coreMaestrosClient;
  private final AfUbicacionRepository repository;
  private final AfUbicacionMapper mapper;
  
  @Override
  @Transactional
  public AfUbicacionResponse create(AfUbicacionRequest request) {
log.info("Creando ubicación de activo con codigo: {} para sucursal: {}", 
                request.getCodigo(), request.getSucursalId());
        
        // 1. Validar FK externa
        validarSucursalExistente(request.getSucursalId());
        
        // 2. Validar código único
        if (repository.existsByCodigo(request.getCodigo())) {
            throw new BusinessException(
                "Ya existe una ubicación con el código: " + request.getCodigo(),
                HttpStatus.CONFLICT,
                ActivosErrorCodes.UBICACION_CODIGO_DUPLICADO
            );
        }
        
        // 3. Crear entidad
        AfUbicacion entity = mapper.toEntity(request);
        AfUbicacion saved = repository.save(entity);
        
        log.info("Ubicación de activo creada exitosamente con id: {}", saved.getId());
        return mapper.toResponse(saved);
    }

    @Override
    @Transactional
    public AfUbicacionResponse update(Long id, AfUbicacionRequest request) {
        log.info("Actualizando ubicación de activo con id: {}", id);
        
        // 1. Validar existencia
        AfUbicacion existing = findById(id);
        
        // 2. Validar FK externa (si cambió)
        if (!existing.getSucursalId().equals(request.getSucursalId())) {
            validarSucursalExistente(request.getSucursalId());
        }
        
        // 3. Validar código único (si cambió)
        if (!existing.getCodigo().equals(request.getCodigo()) && 
            repository.existsByCodigo(request.getCodigo())) {
            throw new BusinessException(
                "Ya existe una ubicación con el código: " + request.getCodigo(),
                HttpStatus.CONFLICT,
                ActivosErrorCodes.UBICACION_CODIGO_DUPLICADO
            );
        }
        
        // 4. Actualizar
        mapper.updateEntity(request, existing);
        AfUbicacion updated = repository.save(existing);
        
        log.info("Ubicación de activo actualizada exitosamente con id: {}", id);
        return mapper.toResponse(updated);
    }

    /**
     * Valida que la sucursal exista y esté activa en ms-core-maestros
     * 
     * @param sucursalId ID de la sucursal a validar
     * @throws BusinessException si la sucursal no existe o está inactiva
     */
    private void validarSucursalExistente(Long sucursalId) {
        try {
            log.debug("Validando existencia de sucursal con id: {}", sucursalId);
            ApiResponse<SucursalResponse> response = coreMaestrosClient.obtenerSucursalPorId(sucursalId);
            
            // Validar que la respuesta contenga datos
            if (response == null || response.getData() == null) {
                log.warn("Sucursal no encontrada con id: {}", sucursalId);
                throw new BusinessException(
                    "La sucursal con ID " + sucursalId + " no existe en el sistema",
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             HttpStatus.NOT_FOUND,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ActivosErrorCodes.SUCURSAL_NO_ENCONTRADA
                                                                                                                                                                                                                                                                                                                                                                                                                                                                  );
                                                                                                                                                                                                  }
                                                                                                                                                                                                  
                                                                                                                                                                                                  // Validar que la sucursal esté activa
                                                                                                                                                                                                  SucursalResponse sucursal = response.getData();
                                                                                                                                                                                                  if (!"1".equals(sucursal.getFlagEstado())) {
                  log.warn("Sucursal inactiva con id: {}", sucursalId);
                throw new BusinessException(
                    "La sucursal '" + sucursal.getNombre() + "' está inactiva. Debe activarla antes de usarla",
                                                        HttpStatus.BAD_REQUEST,
                                                        ActivosErrorCodes.SUCURSAL_INACTIVA
                                                                                                                                                                                                  );
                                                                                                                                                                                                  }

                  log.debug("Sucursal validada exitosamente: {} - {}", sucursal.getCodigo(), sucursal.getNombre());
            
        } catch (FeignException.NotFound e) {
            // El endpoint retornó 404
            log.warn("Sucursal no encontrada con id: {} - Error: {}", sucursalId, e.getMessage());
            throw new BusinessException(
                "La sucursal con ID " + sucursalId + " no existe en el sistema",
                                                                                            HttpStatus.NOT_FOUND,
                                                                                            ActivosErrorCodes.SUCURSAL_NO_ENCONTRADA
                                                                                                                                                                                                  );
  } catch (FeignException e) {
  // Otro error de comunicación (timeout, 500, etc.)
log.error("Error al comunicarse con ms-core-maestros para validar sucursal {}: {}", 
                    sucursalId, e.getMessage());
            throw new BusinessException(
                "Error al validar la sucursal. Por favor, intente nuevamente",
                                                                                 HttpStatus.SERVICE_UNAVAILABLE,
                                                                                 "ACT-999"  // Código genérico para errores de comunicación
  );
  }
  }
}
  ```

### 6.3 Manejo de Errores en Validación FK

  | Escenario | Exception | HTTP Status | Código Error | Mensaje |
  |-----------|-----------|-------------|--------------|---------|
  | Registro no existe (404) | `FeignException.NotFound` | 404 | ACT-007 | "La sucursal con ID X no existe" |
  | Registro inactivo | `BusinessException` | 400 | ACT-008 | "La sucursal está inactiva" |
  | Timeout/Error comunicación | `FeignException` | 503 | ACT-999 | "Error al validar. Intente nuevamente" |

### 6.4 Template Genérico para Validación FK

  ```java
  /**
  * Valida que [ENTIDAD] exista y esté activa en [MICROSERVICIO]
  *
  * @param [entidad]Id ID de [entidad] a validar
  * @throws BusinessException si [entidad] no existe o está inactiva
  */
  private void validar[Entidad]Existente(Long [entidad]Id) {
  try {
log.debug("Validando existencia de [entidad] con id: {}", [entidad]Id);
        ApiResponse<[Entidad]Response> response = [microservicio]Client.obtener[Entidad]PorId([entidad]Id);
        
        if (response == null || response.getData() == null) {
            log.warn("[Entidad] no encontrada con id: {}", [entidad]Id);
            throw new BusinessException(
                "La [entidad] con ID " + [entidad]Id + " no existe en el sistema",
                                                                                                               HttpStatus.NOT_FOUND,
                                                                                                               ActivosErrorCodes.[ENTIDAD]_NO_ENCONTRADA
                                                                                                               );
  }
  
  [Entidad]Response [entidad] = response.getData();
  if (!"1".equals([entidad].getFlagEstado())) {
log.warn("[Entidad] inactiva con id: {}", [entidad]Id);
            throw new BusinessException(
                "La [entidad] '" + [entidad].getNombre() + "' está inactiva",
                                       HttpStatus.BAD_REQUEST,
                                       ActivosErrorCodes.[ENTIDAD]_INACTIVA
  );
  }

log.debug("[Entidad] validada exitosamente: {}", [entidad].getNombre());
        
    } catch (FeignException.NotFound e) {
        log.warn("[Entidad] no encontrada con id: {}", [entidad]Id);
        throw new BusinessException(
            "La [entidad] con ID " + [entidad]Id + " no existe",
                                                                                                  HttpStatus.NOT_FOUND,
                                                                                                  ActivosErrorCodes.[ENTIDAD]_NO_ENCONTRADA
  );
  } catch (FeignException e) {
log.error("Error al comunicarse con [microservicio]: {}", e.getMessage());
        throw new BusinessException(
            "Error al validar la [entidad]. Intente nuevamente",
                                                       HttpStatus.SERVICE_UNAVAILABLE,
                                                       "ACT-999"
  );
  }
}
  ```

---

## 7. Implementación de Entidades CRUD

  ### 7.1 Entidades Implementadas
  
  #### 7.1.1 ms-activos-fijos

  | Entidad | Tabla | Schema | Descripción | FK Externas |
  |---------|-------|--------|-------------|-------------|
  | `AfAseguradora` | `af_aseguradora` | activos | Compañías aseguradoras | Ninguna |
  | `AfClase` | `af_clase` | activos | Clasificación de activos | Ninguna |
  | `AfSubClase` | `af_sub_clase` | activos | Subclasificación de activos | `claseId` (interna) |
  | `AfUbicacion` | `af_ubicacion` | activos | Ubicaciones físicas | `sucursalId` (externa) |
  
  #### 7.1.2 ms-finanzas

  | Entidad | Tabla | Schema | Descripción | FK Externas | Equivalente SIGRE |
  |---------|-------|--------|-------------|-------------|-------------------|
  | `Banco` | `banco` | finanzas | Maestro de bancos | Ninguna | BANCO |
  | `BancoCnta` | `banco_cnta` | finanzas | Cuentas bancarias propias | `bancoId` (interna), `monedaId` (externa) | BANCO_CNTA |
  | `ConceptoFinanciero` | `concepto_financiero` | finanzas | Catálogo de conceptos financieros | Ninguna | Nuevo |
  | `GrupoCodigoFlujoCaja` | `grupo_codigo_flujo_caja` | finanzas | Grupos de códigos de flujo de caja | Ninguna | GRUPO_COD_FLUJO_CAJA |
  | `CodigoFlujoCaja` | `codigo_flujo_caja` | finanzas | Códigos de flujo de caja | `grupoCodigoFlujoCajaId` (interna) | Nuevo |
  | `AutorizadorGiro` | `autorizador_giro` | finanzas | Autorizadores de giros por centro de costo | `usuarioId` (externa), `centrosCostoId` (externa) | AUTORIZADOR_GIRO |
  
  ### 7.2 Estructura de Entidad Estándar
  
  **Ejemplo ms-activos-fijos (con AuditableEntity):**
  ```java
  package pe.restaurant.activos.entity;
  
  import jakarta.persistence.*;
  import lombok.AllArgsConstructor;
  import lombok.Data;
  import lombok.NoArgsConstructor;
  import pe.restaurant.common.entity.AuditableEntity;
  
  @Entity
  @Table(name = "af_ubicacion", schema = "activos")
  @Data
  @NoArgsConstructor
  @AllArgsConstructor
  public class AfUbicacion extends AuditableEntity {
  
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  
  @Column(nullable = false, unique = true, length = 20)
  private String codigo;
  
  @Column(nullable = false, length = 100)
  private String nombre;
  
  @Column(name = "sucursal_id", nullable = false)
  private Long sucursalId;  // FK externa a ms-core-maestros
  
  @Column(name = "flag_estado", length = 1)
  private String flagEstado = "1";  // "1" = activo, "0" = inactivo
}
  ```
  
  **Ejemplo ms-finanzas (con @PrePersist/@PreUpdate):**
  ```java
  package pe.restaurant.finanzas.entity;
  
  import jakarta.persistence.*;
  import lombok.AllArgsConstructor;
  import lombok.Getter;
  import lombok.NoArgsConstructor;
  import lombok.Setter;
  
  import java.time.LocalDateTime;
  
  @Getter
  @Setter
  @NoArgsConstructor
  @AllArgsConstructor
  @Entity
  @Table(name = "banco_cnta", schema = "finanzas")
  public class BancoCnta {
  
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  
  @Column(name = "cod_ctabco", nullable = false, length = 30, unique = true)
  private String codigo;
  
  @Column(name = "banco_id", nullable = false)
  private Long bancoId;
  
  @Column(name = "moneda_id")
  private Long monedaId;  // FK externa a ms-core-maestros
  
  @Column(name = "flag_estado", nullable = false, length = 1)
  private String flagEstado = "1";
  
  @Column(name = "created_by")
  private Long createdBy;
  
  @Column(name = "fec_creacion")
  private LocalDateTime fecCreacion;
  
  @Column(name = "updated_by")
  private Long updatedBy;
  
  @Column(name = "fec_modificacion")
  private LocalDateTime fecModificacion;
  
  @PrePersist
  protected void onCreate() {
      fecCreacion = LocalDateTime.now();
      flagEstado = flagEstado == null ? "1" : flagEstado;
  }
  
  @PreUpdate
  protected void onUpdate() {
      fecModificacion = LocalDateTime.now();
  }
}
  ```

  **Hereda de `AuditableEntity`:**
- `createdAt`: Timestamp de creación
- `updatedAt`: Timestamp de última actualización
- `createdBy`: Usuario que creó
- `updatedBy`: Usuario que actualizó
  
  **Alternativa usada en ms-finanzas:**
  Algunas entidades como `BancoCnta` usan `@PrePersist` y `@PreUpdate` directamente en la entidad para manejar auditoría:
  
  ### 7.3 Request DTO
  
  ```java
  package pe.restaurant.activos.dto.request;
  
  import jakarta.validation.constraints.NotBlank;
  import jakarta.validation.constraints.NotNull;
  import jakarta.validation.constraints.Size;
  import lombok.AllArgsConstructor;
  import lombok.Data;
  import lombok.NoArgsConstructor;
  
  @Data
  @NoArgsConstructor
  @AllArgsConstructor
  public class AfUbicacionRequest {
  
  @NotBlank(message = "El código es obligatorio")
  @Size(max = 20, message = "El código no puede exceder 20 caracteres")
  private String codigo;
  
  @NotBlank(message = "El nombre es obligatorio")
  @Size(max = 100, message = "El nombre no puede exceder 100 caracteres")
  private String nombre;
  
  @NotNull(message = "La sucursal es obligatoria")
  private Long sucursalId;
}
  ```
  
  ### 7.4 Response DTO
  
  ```java
  package pe.restaurant.activos.dto.response;
  
  import lombok.AllArgsConstructor;
  import lombok.Data;
  import lombok.NoArgsConstructor;
  
  import java.time.LocalDateTime;
  
  @Data
  @NoArgsConstructor
  @AllArgsConstructor
  public class AfUbicacionResponse {
  private Long id;
  private String codigo;
  private String nombre;
  private Long sucursalId;
  private String flagEstado;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;
}
  ```
  
  ### 7.5 Mapper
  
  ```java
  package pe.restaurant.activos.mapper;
  
  import org.springframework.stereotype.Component;
  import pe.restaurant.activos.dto.request.AfUbicacionRequest;
  import pe.restaurant.activos.dto.response.AfUbicacionResponse;
  import pe.restaurant.activos.entity.AfUbicacion;
  
  @Component
  public class AfUbicacionMapper {
  
  public AfUbicacion toEntity(AfUbicacionRequest request) {
  AfUbicacion entity = new AfUbicacion();
  entity.setCodigo(request.getCodigo());
  entity.setNombre(request.getNombre());
  entity.setSucursalId(request.getSucursalId());
  entity.setFlagEstado("1");  // Por defecto activo
  return entity;
  }

  public void updateEntity(AfUbicacionRequest request, AfUbicacion entity) {
  entity.setCodigo(request.getCodigo());
  entity.setNombre(request.getNombre());
  entity.setSucursalId(request.getSucursalId());
  }

  public AfUbicacionResponse toResponse(AfUbicacion entity) {
  AfUbicacionResponse response = new AfUbicacionResponse();
  response.setId(entity.getId());
  response.setCodigo(entity.getCodigo());
  response.setNombre(entity.getNombre());
  response.setSucursalId(entity.getSucursalId());
  response.setFlagEstado(entity.getFlagEstado());
  response.setCreatedAt(entity.getCreatedAt());
  response.setUpdatedAt(entity.getUpdatedAt());
  return response;
  }
}
  ```
  
  ### 7.6 Repository
  
  ```java
  package pe.restaurant.activos.repository;
  
  import org.springframework.data.jpa.repository.JpaRepository;
  import org.springframework.stereotype.Repository;
  import pe.restaurant.activos.entity.AfUbicacion;
  
  @Repository
  public interface AfUbicacionRepository extends JpaRepository<AfUbicacion, Long> {
  
  boolean existsByCodigo(String codigo);
  
  boolean existsByCodigoAndIdNot(String codigo, Long id);
}
  ```
  
  ### 7.7 Controller
  
  ```java
  package pe.restaurant.activos.controller;
  
  import io.swagger.v3.oas.annotations.Operation;
  import io.swagger.v3.oas.annotations.tags.Tag;
  import jakarta.validation.Valid;
  import lombok.RequiredArgsConstructor;
  import org.springframework.data.domain.Page;
  import org.springframework.data.domain.Pageable;
  import org.springframework.data.domain.Sort;
  import org.springframework.data.web.PageableDefault;
  import org.springframework.http.HttpStatus;
  import org.springframework.web.bind.annotation.*;
  import pe.restaurant.activos.dto.request.AfUbicacionRequest;
  import pe.restaurant.activos.dto.response.AfUbicacionResponse;
  import pe.restaurant.activos.service.AfUbicacionService;
  import pe.restaurant.common.dto.ApiResponse;
  
  @RestController
  @RequestMapping("/api/activos/ubicaciones")
  @RequiredArgsConstructor
  @Tag(name = "Ubicaciones de Activos", description = "Gestión de ubicaciones físicas de activos fijos")
  public class AfUbicacionController {
  
  private final AfUbicacionService service;
  
  @GetMapping
  @Operation(summary = "Listar ubicaciones", description = "Obtiene un listado paginado de ubicaciones")
  public ApiResponse<Page<AfUbicacionResponse>> findAll(
  @PageableDefault(size = 10, sort = "codigo", direction = Sort.Direction.ASC) Pageable pageable) {
  return ApiResponse.ok(service.findAll(pageable));
  }

  @GetMapping("/{id}")
  @Operation(summary = "Obtener ubicación por ID")
  public ApiResponse<AfUbicacionResponse> findById(@PathVariable Long id) {
  return ApiResponse.ok(service.findByIdResponse(id));
  }

  @PostMapping
  @ResponseStatus(HttpStatus.CREATED)
  @Operation(summary = "Crear ubicación", description = "Crea una nueva ubicación de activo")
  public ApiResponse<AfUbicacionResponse> create(@Valid @RequestBody AfUbicacionRequest request) {
  return ApiResponse.created(service.create(request));
  }

  @PutMapping("/{id}")
  @Operation(summary = "Actualizar ubicación")
  public ApiResponse<AfUbicacionResponse> update(
  @PathVariable Long id,
  @Valid @RequestBody AfUbicacionRequest request) {
  return ApiResponse.ok(service.update(id, request));
  }

  @PatchMapping("/{id}/activar")
  @Operation(summary = "Activar ubicación")
  public ApiResponse<Void> activar(@PathVariable Long id) {
  service.activar(id);
  return ApiResponse.ok();
  }

  @PatchMapping("/{id}/desactivar")
  @Operation(summary = "Desactivar ubicación")
  public ApiResponse<Void> desactivar(@PathVariable Long id) {
  service.desactivar(id);
  return ApiResponse.ok();
  }

  @DeleteMapping("/{id}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  @Operation(summary = "Eliminar ubicación")
  public ApiResponse<Void> delete(@PathVariable Long id) {
  service.delete(id);
  return ApiResponse.noContent();
  }
}
  ```

---

## 8. Manejo de Errores

  ### 8.1 Códigos de Error Estándar

  ```java
  package pe.restaurant.activos.service;
  
  import pe.restaurant.common.exception.ErrorCode;
  
  public class ActivosErrorCodes {
  
  // Clase
  public static final ErrorCode CLASE_CODIGO_DUPLICADO = new ErrorCode(
  "ACT-001",
  "Ya existe una clase de activo con el código especificado"
  );
  
  public static final ErrorCode CLASE_NO_ENCONTRADA = new ErrorCode(
  "ACT-002",
  "La clase de activo especificada no existe"
  );
  
  // SubClase
  public static final ErrorCode SUBCLASE_CODIGO_DUPLICADO = new ErrorCode(
  "ACT-003",
  "Ya existe una subclase de activo con el código especificado"
  );
  
  public static final ErrorCode SUBCLASE_NO_ENCONTRADA = new ErrorCode(
  "ACT-004",
  "La subclase de activo especificada no existe"
  );
  
  // Ubicación
  public static final ErrorCode UBICACION_CODIGO_DUPLICADO = new ErrorCode(
  "ACT-005",
  "Ya existe una ubicación con el código especificado"
  );
  
  public static final ErrorCode UBICACION_NO_ENCONTRADA = new ErrorCode(
  "ACT-006",
  "La ubicación especificada no existe"
  );
  
  // FK Externas - Sucursal
  public static final ErrorCode SUCURSAL_NO_ENCONTRADA = new ErrorCode(
  "ACT-007",
  "La sucursal especificada no existe en el sistema"
  );
  
  public static final ErrorCode SUCURSAL_INACTIVA = new ErrorCode(
  "ACT-008",
  "La sucursal está inactiva y no puede ser utilizada"
  );
  
  // Aseguradora
  public static final ErrorCode ASEGURADORA_RUC_DUPLICADO = new ErrorCode(
  "ACT-009",
  "Ya existe una aseguradora con el RUC especificado"
  );
  
  public static final ErrorCode ASEGURADORA_NO_ENCONTRADA = new ErrorCode(
  "ACT-010",
  "La aseguradora especificada no existe"
  );
}
  ```
  
  ### 8.2 Formato de Respuesta de Error
  
  ```json
  {
    "status": 404,
    "message": "La sucursal con ID 999 no existe en el sistema",
    "code": "ACT-007",
    "timestamp": "2026-04-17T14:30:00Z",
    "path": "/api/activos/ubicaciones"
  }
  ```

---

## 11. Checklist de Implementación

  ### 9.1 Estructura de Archivos

  ```
  04. Terraform-aws/
  ├── k8s/
  │   └── dev/
  │       ├── ms-activos-fijos.yaml
  │       ├── ms-core-maestros.yaml
  │       ├── api-gateway.yaml
  │       └── ...
  └── ...
  ```
  
  ### 9.2 Deployment YAML para ms-activos-fijos
  
  **Archivo:** `04. Terraform-aws/k8s/dev/ms-activos-fijos.yaml`
  
  ```yaml
  # ms-activos-fijos: Deployment + Service (puerto 9008)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ms-activos-fijos
  namespace: dev
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ms-activos-fijos
  template:
    metadata:
      labels:
        app: ms-activos-fijos
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "9008"
        prometheus.io/path: "/actuator/prometheus"
    spec:
      containers:
        - name: ms-activos-fijos
          image: IMAGE_PLACEHOLDER
          ports:
            - containerPort: 9008
          env:
            # Base de datos
            - name: DB_HOST
              valueFrom: { secretKeyRef: { name: app-secrets, key: DB_HOST } }
            - name: DB_PORT
              valueFrom: { secretKeyRef: { name: app-secrets, key: DB_PORT } }
            - name: DB_USER
              valueFrom: { secretKeyRef: { name: app-secrets, key: DB_USER } }
            - name: DB_PASS
              valueFrom: { secretKeyRef: { name: app-secrets, key: DB_PASSWORD } }
            - name: DB_SSL_MODE
              value: "require"
            - name: DB_SECURITY_NAME
              value: "restaurant_pe_security"
            # RabbitMQ
            - name: RABBIT_HOST
              value: "rabbitmq.observability.svc.cluster.local"
            - name: RABBIT_PORT
              value: "5672"
            - name: RABBIT_USER
              valueFrom: { secretKeyRef: { name: app-secrets, key: RABBITMQ_USER } }
            - name: RABBIT_PASS
              valueFrom: { secretKeyRef: { name: app-secrets, key: RABBITMQ_PASSWORD } }
            # API Gateway - IMPORTANTE
            - name: API_GATEWAY_URL
              value: "http://api-gateway:80"  # Puerto 80, no 8080
          resources:
            requests: { memory: "192Mi", cpu: "100m" }
            limits: { memory: "320Mi", cpu: "250m" }
---
apiVersion: v1
kind: Service
metadata:
  name: ms-activos-fijos
  namespace: dev
spec:
  type: ClusterIP
  selector:
    app: ms-activos-fijos
  ports:
    - port: 9008
      targetPort: 9008
  ```

### 9.3 Puntos Críticos de Configuración

  | Configuración | Valor | Descripción |
  |---------------|-------|-------------|
  | `API_GATEWAY_URL` | `http://api-gateway:80` | ⚠️ **Puerto 80**, no 8080 (Service ClusterIP) |
  | `replicas` | 1 o más | Número de instancias del pod |
  | `containerPort` | 9008 | Puerto interno del contenedor Java |
  | `service.port` | 9008 | Puerto expuesto por el Service |
  | `resources.limits.memory` | 320Mi | Límite de memoria |
  | `resources.requests.memory` | 192Mi | Memoria solicitada |

### 9.4 Comandos de Deployment

  ```bash
  # Build y push de imagen Docker
  .\deploy.bat ms-activos-fijos --force
  
  # Verificar deployment
  kubectl -n dev get pods -l app=ms-activos-fijos
  
  # Ver logs
  kubectl -n dev logs -f deployment/ms-activos-fijos
  
  # Descargar logs localmente
  .\download-log.bat ms-activos-fijos
  
  # Verificar estado del servicio
  kubectl -n dev get svc ms-activos-fijos
  
  # Verificar conectividad interna
  kubectl -n dev exec -it [pod-name] -- wget -qO- http://api-gateway:80/actuator/health
  ```

### 9.5 Diferencias Local vs Kubernetes

  | Aspecto | Local | Kubernetes |
  |---------|-------|------------|
  | **API Gateway URL** | `http://localhost:8080` | `http://api-gateway:80` |
  | **Puerto API Gateway** | 8080 (directo a Spring Boot) | 80 (Service ClusterIP) |
  | **Base de Datos** | localhost:5432 | RDS endpoint |
  | **RabbitMQ** | localhost:5672 | rabbitmq.observability.svc.cluster.local:5672 |
  | **Secrets** | Hardcoded en YAML | Desde Kubernetes Secrets |

---

## 9. Mapeos de Tablas Legacy SIGRE (ms-finanzas)

### 9.1 Tablas Normalizadas vs Catálogos SUNAT

Algunas tablas legacy SIGRE han sido normalizadas usando catálogos SUNAT existentes:

| Tabla Legacy SIGRE | Existe en ERP | Equivalente en ERP | Observación |
|-------------------|---------------|-------------------|-------------|
| `DOC_TIPO_PAGO_SUNAT` | ✅ Sí | `core.catalogo_sunat_det` (catalog TAB10) | Normalizado en catálogos SUNAT |
| `MEDIOS_DE_PAGO` | ✅ Sí | `core.catalogo_sunat_det` (catalog TAB01) | TAB01 = Tipo Medio de Pago |
| `GRUPO_COD_FLUJO_CAJA` | ✅ Sí | `finanzas.grupo_codigo_flujo_caja` | Equivalente funcional en finanzas |
| `AUTORIZADOR_GIRO` | ✅ Sí | `finanzas.autorizador_giro` | Implementado en DDL tenant con FK a usuario y FK diferida a centros_costo |

### 9.2 Consideraciones para Validaciones FK

#### 9.2.1 Catálogos SUNAT (core.catalogo_sunat_det)

Para validar contra catálogos SUNAT:
```java
// Validar medio de pago (TAB01)
private void validarMedioPagoExistente(Long medioPagoId) {
    ApiResponse<CatalogoSunatDetResponse> response = coreMaestrosClient.obtenerCatalogoSunatDet(medioPagoId);
    // Validar que pertenezca a TAB01 y esté activo
}
```

#### 9.2.2 Tablas con FK Diferidas

`autorizador_giro` tiene FK diferida a `contabilidad.centros_costo`:
```java
// La validación de centros_costo debe manejarse con cuidado
// ya que la FK es diferida (DEFERRABLE INITIALLY DEFERRED)
private void validarCentroCostoExistente(Long centrosCostoId) {
    try {
        // Validación opcional si el centro de costo debe existir en tiempo real
        // o si se permite la validación diferida
    } catch (Exception e) {
        // Manejar caso de FK diferida
    }
}
```

---

## 10. Deployment en Kubernetes

### 10.1 Nueva Entidad CRUD (Sin FK Externas)

- [ ] **1. Entidad**
    - [ ] Crear clase `@Entity` en `entity/`
    - [ ] Extender de `AuditableEntity`
    - [ ] Definir campos con anotaciones JPA
    - [ ] Agregar índices y constraints

- [ ] **2. DTOs**
    - [ ] Crear `Request` DTO con validaciones
    - [ ] Crear `Response` DTO

- [ ] **3. Repository**
    - [ ] Crear interface extendiendo `JpaRepository`
    - [ ] Agregar métodos custom si necesario

- [ ] **4. Mapper**
    - [ ] Implementar `toEntity()`
    - [ ] Implementar `updateEntity()`
    - [ ] Implementar `toResponse()`

- [ ] **5. Service**
    - [ ] Crear interface `Service`
    - [ ] Implementar `ServiceImpl`
    - [ ] Métodos: `findAll()`, `findById()`, `create()`, `update()`, `delete()`
    - [ ] Métodos: `activar()`, `desactivar()`

- [ ] **6. Controller**
    - [ ] Crear `@RestController`
    - [ ] Implementar endpoints CRUD
    - [ ] Agregar documentación Swagger

- [ ] **7. Códigos de Error**
    - [ ] Agregar en `ActivosErrorCodes.java`
    - [ ] Documentar en `Activos-Fijos-Error-Codes.md`

- [ ] **8. Pruebas**
    - [ ] Probar localmente
    - [ ] Probar en Kubernetes
    - [ ] Validar Swagger UI

### 10.2 Nueva Entidad CRUD con FK Externa

  **Incluye todo lo anterior MÁS:**

- [ ] **9. DTO de Respuesta Externa**
    - [ ] Crear DTO que mapee la respuesta del microservicio externo
    - [ ] Ubicar en `dto/`

- [ ] **10. Feign Client**
    - [ ] Crear interface `@FeignClient` en `client/`
    - [ ] Configurar `url = "${api.gateway.url}"`
    - [ ] Configurar `configuration = FeignConfig.class`
    - [ ] Definir método GET por ID

- [ ] **11. Configuración Feign** (una sola vez por microservicio)
    - [ ] Verificar que existe `FeignConfig.java` con interceptor
    - [ ] Verificar configuración en `application.yml`

- [ ] **12. Validación FK en Service**
    - [ ] Implementar método `validar[Entidad]Existente()`
    - [ ] Llamar en `create()` y `update()`
    - [ ] Manejar `FeignException.NotFound`
    - [ ] Manejar `FeignException` genérico
    - [ ] Validar estado activo

- [ ] **13. Códigos de Error FK**
    - [ ] `[ENTIDAD]_NO_ENCONTRADA`
    - [ ] `[ENTIDAD]_INACTIVA`

- [ ] **14. Pruebas Específicas**
    - [ ] Crear con FK válida
    - [ ] Crear con FK inválida (debe fallar)
    - [ ] Crear con FK inactiva (debe fallar)
    - [ ] Verificar logs de comunicación

### 10.3 Nuevo Microservicio Completo

- [ ] **1. Estructura Base**
    - [ ] Copiar estructura de `ms-activos-fijos`
    - [ ] Renombrar paquetes
    - [ ] Configurar `application.yml`

- [ ] **2. Configuración**
    - [ ] Definir puerto único en `application.yml`
    - [ ] Definir schema de BD
    - [ ] Configurar `api.gateway.url`
    - [ ] Configurar Feign timeouts

- [ ] **3. Feign Config**
    - [ ] Crear `FeignConfig.java`
    - [ ] Configurar interceptor de headers

- [ ] **4. Kubernetes**
    - [ ] Crear YAML de deployment
    - [ ] Configurar variables de entorno
    - [ ] **Importante:** `API_GATEWAY_URL=http://api-gateway:80`
    - [ ] Definir resources (CPU/memory)

- [ ] **5. Códigos de Error**
    - [ ] Crear archivo `[Modulo]ErrorCodes.java`
    - [ ] Crear documentación `.md`

- [ ] **6. Deployment**
    - [ ] Agregar en `build.bat`
    - [ ] Agregar en `deploy.bat`
    - [ ] Probar deployment

---

## 11. Troubleshooting Común

  ### 11.1 Error: Connection refused al API Gateway

  **Síntoma:**
  ```
  Connect timed out executing GET http://api-gateway:8080/...
  ```
  
  **Causa:** Puerto incorrecto del API Gateway en Kubernetes
  
  **Solución:**
  ```yaml
  # INCORRECTO
            API_GATEWAY_URL: "http://api-gateway:8080"

  # CORRECTO
            API_GATEWAY_URL: "http://api-gateway:80"
  ```

  ### 11.2 Error: 401 Unauthorized al llamar a otro microservicio

  **Síntoma:**
  ```
  [401 Unauthorized] during [GET] to [http://api-gateway:80/api/core/sucursales/2]
  ```
  
  **Causa:** JWT token no se está transmitiendo
  
  **Solución:** Verificar que el Feign Client tenga configurado `FeignConfig.class`:
  ```java
  @FeignClient(
  name = "ms-core-maestros",
  url = "${api.gateway.url}",
  path = "/api/core/sucursales",
  configuration = pe.restaurant.activos.config.FeignConfig.class  // ← IMPORTANTE
  )
  ```

  ### 11.3 Error: No se aplican cambios en Kubernetes

  **Síntoma:** Los cambios de código no se reflejan después de deploy

  **Solución:**
  ```bash
  # Forzar recreación de pods
  .\deploy.bat ms-activos-fijos --force
  
  # Verificar que se creó nuevo pod
  kubectl -n dev get pods -l app=ms-activos-fijos
  
  # El pod debe tener AGE reciente (ej: 2m)
  ```

  ### 11.4 Error: localhost:8080 en Kubernetes

  **Síntoma:**
  ```
  Connection refused localhost:8080
  ```

  **Causa:** Variable `API_GATEWAY_URL` no está definida en Kubernetes

  **Solución:** Verificar deployment YAML:
  ```yaml
            env:
              - name: API_GATEWAY_URL
                value: "http://api-gateway:80"  # Debe estar presente
  ```

---

## 12. Mejores Prácticas

### 12.1 Código

1. ✅ **Nombres en español** para métodos y variables de negocio
2. ✅ **Logging descriptivo** con `log.info()`, `log.debug()`, `log.error()`
3. ✅ **Validaciones tempranas** (fail fast)
4. ✅ **Transacciones** en métodos que modifican datos
5. ✅ **Métodos pequeños** (< 50 líneas)
6. ✅ **Guard clauses** para validaciones
  
  ### 12.2 Comunicación entre Microservicios

1. ✅ **Siempre a través del API Gateway**
2. ✅ **Transmitir JWT token** en todas las peticiones
3. ✅ **Validar FK externas** antes de guardar
4. ✅ **Manejar timeouts** con mensajes amigables
5. ✅ **Logging de peticiones** externas
  
  ### 12.3 Kubernetes

1. ✅ **Variables de entorno** para configuración
2. ✅ **Secrets** para credenciales
3. ✅ **Health checks** con Actuator
4. ✅ **Resource limits** definidos
5. ✅ **Labels y annotations** para Prometheus

---

## 13. Referencias

### 13.1 Documentación Interna

- `ARQUITECTURA_RESTAURANT_PE.md` - Arquitectura general del sistema
- `Activos-Fijos-Error-Codes.md` - Códigos de error del módulo
- Marco de Trabajo (Reglas de Desarrollo)

### 13.2 Ejemplos de Código

- `ms-activos-fijos/` - Microservicio de referencia
- `ms-core-maestros/` - Microservicio maestro

### 13.3 Configuraciones

- `application.yml` - Configuración del microservicio
- `ms-activos-fijos.yaml` - Deployment Kubernetes

---

## 14. Glosario

  | Término | Descripción |
  |---------|-------------|
  | **FK Externa** | Foreign Key que apunta a una tabla en otro microservicio |
  | **Feign Client** | Cliente HTTP declarativo para comunicación entre microservicios |
  | **API Gateway** | Punto único de entrada que enruta peticiones a microservicios |
  | **ClusterIP** | Tipo de Service de Kubernetes para comunicación interna |
  | **JWT Token** | Token de autenticación transmitido en header Authorization |
  | **Tenant** | Empresa/organización en un sistema multi-tenant |
  | **Flyway** | Herramienta de migración de BD (deshabilitada, usamos scripts SQL) |

---

## 15. Próximos Pasos

1. **Aplicar esta guía** a nuevas entidades en `ms-activos-fijos`
2. **Replicar patrón** en otros microservicios del proyecto
3. **Documentar excepciones** y casos especiales
4. **Crear templates** de código para acelerar desarrollo
5. **Automatizar validaciones** con tests unitarios

---

**Versión:** 1.0
  **Fecha:** 2026-04-17
  **Autor:** Equipo de Desarrollo Restaurant.pe
  **Microservicio de Referencia:** ms-activos-fijos
