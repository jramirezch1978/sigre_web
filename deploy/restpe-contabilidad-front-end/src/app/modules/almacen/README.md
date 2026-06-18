# Módulo Apartado Almacén - Arquitectura Hexagonal

##   Descripción

Este módulo implementa una **arquitectura hexagonal** (también conocida como arquitectura de puertos y adaptadores) con gestión de estado reactiva usando **Angular Signals**. **TODOS los datos estáticos se cargan desde archivos JSON** siguiendo el flujo completo de la arquitectura hexagonal.

##   Principios Clave

1. **Sin datos hardcodeados**: Todos los datos fijos están en archivos JSON
2. **Arquitectura hexagonal completa**: Domain → Application → Infrastructure
3. **Reactividad con Signals**: Estado reactivo en tiempo real
4. **Single Source of Truth**: El Store es la única fuente de verdad
5. **Separación de responsabilidades**: Cada capa tiene un propósito específico

## 🏗️ Estructura de Carpetas

```
apartado-almacen/
│
├── store/                          #   Gestión de Estado (Signals)
│   ├── almacen.state.ts           # Define el estado y su estructura
│   ├── almacen.actions.ts         # Acciones disponibles (constantes)
│   └── almacen.store.ts           # Store con signals y computed
│
├── domain/                         #   Capa de Dominio (Core Business)
│   ├── models/
│   │   └── almacen.entity.ts      # Entidad del dominio
│   └── repositories/
│       └── ialmacen.repository.ts # Interfaz del repositorio (puerto)
│
├── application/                    # 🔧 Capa de Aplicación (Casos de Uso)
│   ├── usecases/
│   │   ├── obtener-almacenes.usecase.ts
│   │   ├── guardar-almacen.usecase.ts
│   │   ├── actualizar-almacen.usecase.ts
│   │   ├── eliminar-almacen.usecase.ts
│   │   └── index.ts
│   ├── facades/
│   │   └── almacen.facade.ts      # Facade para UI (orquesta use cases)
│   └── dto/
│       ├── requests/               # DTOs de entrada
│       └── responses/              # DTOs de salida
│
├── infrastructure/                 # 🔌 Capa de Infraestructura (Adaptadores)
│   ├── repository/
│   │   └── almacen.repository.impl.ts  # Implementación con JSON
│   └── providers/
│       └── almacen.providers.ts   # Providers de Angular
│
└── modulos/                        #   Módulos específicos
    ├── modulo-almacen-tablas/
    ├── modulo-almacen-consultas/
    ├── modulo-almacen-operaciones/
    └── modulo-almacen-reportes/
```

##   Datos desde JSON

### Archivos de Datos

Todos los datos estáticos se encuentran en `src/assets/data/almacen/`:

```
assets/data/almacen/
├── almacenes.json                    # Listado de almacenes
├── catalogos.json                    # Catálogos generales (tipos doc, estados, etc.)
├── transferencias.json               # Transferencias entre almacenes
└── comparaciones-inventario.json     # Comparaciones de inventario
```

### Ejemplo: catalogos.json

```json
{
  "tiposDocumento": [
    { "id": "FAC", "nombre": "Factura" },
    { "id": "BOL", "nombre": "Boleta" }
  ],
  "estadosOperacion": [
    { "id": "PEND", "nombre": "Pendiente" },
    { "id": "APRO", "nombre": "Aprobado" }
  ],
  "unidadesMedida": [
    { "id": "UND", "nombre": "Unidad" },
    { "id": "KG", "nombre": "Kilogramo" }
  ]
}
```

### Ejemplo: transferencias.json

```json
[
  {
    "nroTransferencia": "T001-2025",
    "fechaEnvio": "2025-11-20",
    "origen": "Almacén principal",
    "destino": "Almacén central",
    "cantidadEnviada": 100,
    "estado": "Total"
  }
]
```

##   Datos Simulados (Deprecated)

Los datos se encuentran en:
```
src/assets/data/almacen/almacenes.json
```

Este archivo contiene la data mock que simula las respuestas del backend.

## 🔌 Adaptador HTTP (integración con `ms-almacen`)

> Estado actual: el adaptador de infraestructura ya **no lee JSON** — consume el
> microservicio real `ms-almacen` vía el api-gateway. Es exactamente la
> flexibilidad que promete la arquitectura: *cambiar de JSON a HTTP es solo
> cambiar el adaptador* (capa `infrastructure`); domain, application, store,
> facade y componentes no cambian.

### Piezas nuevas en `infrastructure/`

```
infrastructure/
├── http/
│   ├── almacen-api.config.ts     # Base del gateway + rutas de cada recurso (ALMACEN_ENDPOINTS)
│   └── almacen-http.service.ts   # Cliente HTTP: Bearer + X-Empresa-Id/X-Sucursal-Id + unwrap ApiResponse/PageData
├── mappers/
│   └── almacen.mapper.ts         # Traduce backend (AlmacenResponse/Request) ↔ AlmacenEntity (dominio)
└── repository/
    └── *.repository.impl.ts      # Ahora delegan en AlmacenHttpService (antes leían JSON)
```

Los **contratos del backend** (envoltura `ApiResponse<T>`, `PageData<T>`, y los
DTOs `*Response`/`*Request`) viven en `application/dto/almacen-backend.types.ts`.

### Cómo consume un repositorio el backend

```typescript
@Injectable({ providedIn: 'root' })
export class AlmacenRepositoryImpl implements IAlmacenRepository {
  private readonly api = inject(AlmacenHttpService);

  obtenerTodos(): Observable<AlmacenEntity[]> {
    return this.api
      .getList<BackendAlmacenResponse>(ALMACEN_ENDPOINTS.almacenes, { size: 1000, sort: 'id,desc' })
      .pipe(map(list => AlmacenMapper.toEntityList(list)));
  }
}
```

### Convenciones del adaptador HTTP

- **Rutas relativas** (`/api/almacen/...`, `ALMACEN_GATEWAY_URL=''`) → el dev-server
  las reenvía vía `proxy.conf.json` al gateway dev, evitando CORS.
- `AlmacenHttpService` adjunta `Authorization: Bearer` (token de sesión) y las
  cabeceras de tenant. **DEV:** mientras el login no emita el JWT de
  `ms-auth-security`, se envía `X-Empresa-Id` / `X-Sucursal-Id` hardcodeados
  (empresa 2 / sucursal 1). Quitar ese fallback cuando el JWT lleve el tenant real.
- `getList<T>()` desempaqueta `ApiResponse<PageData<T>>` y devuelve solo `content`;
  `get<T>()`/`post<T>()`/etc. devuelven `data`. Si `success === false`, se lanza
  un error con el `message` del backend (lo capturan los `effects` de feedback).
- Cada `*.repository.impl.ts` usa un **mapper** para traducir el contrato del
  backend a la entidad de dominio; los campos que el backend no expone se dejan
  vacíos y los GAP (sin endpoint) devuelven `of([])` documentado.

Pendientes y cobertura por pantalla: ver [`PENDIENTES_FRONT_ALMACEN.md`](./PENDIENTES_FRONT_ALMACEN.md).

##   Principios de Arquitectura Hexagonal

### 1. **Domain (Núcleo)**
- **Modelos/Entidades**: Representan los conceptos del negocio
- **Repositorios (Interfaces)**: Puertos que definen qué operaciones necesita el dominio
- **Independiente**: No depende de frameworks ni infraestructura

### 2. **Application (Casos de Uso)**
- **UseCases**: Implementan la lógica de negocio específica
- **Facades**: Orquestan múltiples use cases y gestionan el estado
- **DTOs**: Objetos de transferencia de datos

### 3. **Infrastructure (Adaptadores)**
- **Repository Implementation**: Adaptador que implementa la interfaz del dominio
- **Providers**: Configuración de inyección de dependencias
- **Adapta**: JSON, HTTP, LocalStorage, etc.

### 4. **Store (Estado Reactivo)**
- **Signals**: Estado reactivo de Angular
- **Computed**: Selectores derivados
- **Immutable**: Actualizaciones inmutables del estado

##   Flujo de Datos

```
┌─────────────┐
│  Component  │  (UI)
└──────┬──────┘
       │ usa
       ▼
┌─────────────┐
│   Facade    │  (Orquestador)
└──────┬──────┘
       │ delega
       ▼
┌─────────────┐     ┌──────────┐
│  UseCase    │────▶│  Store   │ (Estado)
└──────┬──────┘     └──────────┘
       │ usa
       ▼
┌─────────────┐
│ IRepository │ (Puerto/Interfaz)
└──────┬──────┘
       │ implementa
       ▼
┌─────────────┐
│ Repository  │ (Adaptador)
│    Impl     │
└──────┬──────┘
       │ lee
       ▼
┌─────────────┐
│  JSON File  │ (assets/data/almacen/*)
└─────────────┘
```

## 💻 Uso en Componentes

### 1. Importar el Facade

```typescript
import { Component, inject } from '@angular/core';
import { AlmacenFacade } from '../../application/facades/almacen.facade';

@Component({
  selector: 'app-mi-componente',
  // ...
})
export class MiComponente {
  private readonly almacenFacade = inject(AlmacenFacade);

  // Selectores (lectura)
  almacenes = this.almacenFacade.almacenes;
  isLoading = this.almacenFacade.isLoading;
  hasError = this.almacenFacade.hasError;

  ngOnInit() {
    // Opción 1: Cargar todos los datos
    this.almacenFacade.inicializarDatos();
    
    // Opción 2: Cargar datos específicos
    this.almacenFacade.cargarAlmacenes();
    this.almacenFacade.cargarCatalogos();
  }

  guardar(almacen: AlmacenEntity) {
    this.almacenFacade.guardarAlmacen(almacen);
  }
}
```

### 2. Usar Datos en Template

```html
<div [appLoader]="isLoading()">
  <!-- Usar catálogos en select -->
  <ion-select label="Tipo Documento">
    @for (tipo of catalogos()?.tiposDocumento; track tipo.id) {
      <ion-select-option [value]="tipo.id">
        {{ tipo.nombre }}
      </ion-select-option>
    }
  </ion-select>
  
  <!-- Usar en ag-grid -->
  <ag-grid-angular
    [rowData]="transferencias()"
    [columnDefs]="columnDefs"
  ></ag-grid-angular>
</div>
```

## 📚 Métodos Disponibles en el Facade

### Carga de Datos
- `inicializarDatos()` - Carga todos los datos (almacenes, catálogos, transferencias, comparaciones)
- `cargarAlmacenes()` - Carga solo almacenes
- `cargarCatalogos()` - Carga catálogos (tipos doc, estados, unidades, etc.)
- `cargarTransferencias()` - Carga transferencias
- `cargarComparacionesInventario()` - Carga comparaciones de inventario

### Operaciones CRUD
- `guardarAlmacen(almacen)` - Guardar nuevo almacén
- `actualizarAlmacen(almacen)` - Actualizar almacén existente
- `eliminarAlmacen(codigo)` - Eliminar almacén
- `seleccionarAlmacen(almacen)` - Seleccionar almacén actual

### Datos Reactivos Disponibles
- `almacenes()` - Lista de almacenes
- `catalogos()` - Catálogos generales (tipos, estados, unidades)
- `transferencias()` - Lista de transferencias
- `comparacionesInventario()` - Lista de comparaciones
- `isLoading()` - Estado de carga global
- `hasError()` - Indica si hay errores

### 2. Usar en Template con Signals

```html
<!-- Loading State -->
@if (isLoading()) {
  <app-loader />
}

<!-- Error State -->
@if (hasError()) {
  <div class="error">Error al cargar datos</div>
}

<!-- Data Display -->
@for (almacen of almacenes(); track almacen.codigo) {
  <div>{{ almacen.nombre }}</div>
}
```

## 🔧 Configuración del Módulo

En tu `apartado-almacen.module.ts`, importa los providers:

```typescript
import { ALMACEN_PROVIDERS } from './infrastructure/providers/almacen.providers';

@NgModule({
  // ...
  providers: [
    ...ALMACEN_PROVIDERS
  ]
})
export class ApartadoAlmacenModule { }
```

## 🎨 Integración con AppLoader

Para mostrar el loader global:

```typescript
// En el componente
readonly isLoading = this.almacenFacade.isLoading;

// En el template (justo arriba del ag-grid y al lado del panel derecho)
@if (isLoading()) {
  <app-loader [overlay]="true" message="Cargando almacenes..." />
}
```

##   Replicar en Otros Módulos

### Pasos para replicar esta arquitectura:

1. **Crear estructura de carpetas**:
   ```bash
   mkdir -p {store,domain/{models,repositories},application/{usecases,facades,dto/{requests,responses}},infrastructure/{repository,providers}}
   ```

2. **Domain Layer**:
   - Crear `entity.ts` con la interfaz del modelo
   - Crear `irepository.ts` con la interfaz abstracta

3. **Store Layer**:
   - Crear `state.ts` con el estado inicial
   - Crear `actions.ts` con las acciones
   - Crear `store.ts` con signals y computed

4. **Application Layer**:
   - Crear use cases (uno por operación CRUD)
   - Crear facade que orqueste los use cases
   - Crear DTOs de request/response

5. **Infrastructure Layer**:
   - Crear `repository.impl.ts` que implementa la interfaz
   - Leer desde JSON: `this.http.get<T>('assets/data/modulo/archivo.json')`
   - Simular delays: `.pipe(delay(500))`

6. **Datos JSON**:
   - Crear archivos en `src/assets/data/[modulo-nombre]/`
   - Estructura según tu entidad

7. **Providers**:
   - Registrar la implementación del repositorio
   - Importar en el módulo

##   Ventajas de esta Arquitectura

-   **Separación de Responsabilidades**: Cada capa tiene un propósito claro
-   **Testeable**: Fácil de mockear las dependencias
- 🔌 **Flexible**: Cambiar de JSON a HTTP es solo cambiar el adaptador
-   **Escalable**: Agregar features sin afectar el core
- 🚀 **Reactivo**: Signals de Angular para máximo performance
-   **Mantenible**: Estructura predecible y organizada

## 🐛 Debugging

### Ver el estado actual:
```typescript
effect(() => {
  console.log('Almacenes:', this.almacenFacade.almacenes());
  console.log('Loading:', this.almacenFacade.isLoading());
});
```

### Simular errores:
En `almacen.repository.impl.ts`, puedes lanzar errores:
```typescript
return throwError(() => new Error('Error simulado'));
```

## 📚 Referencias

- [Angular Signals](https://angular.io/guide/signals)
- [Hexagonal Architecture](https://alistair.cockburn.us/hexagonal-architecture/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

**Autor**: Sistema de Arquitectura Hexagonal  
**Versión**: 1.0.0  
**Última actualización**: 2026
