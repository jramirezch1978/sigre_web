# Guía de Integración - Datos desde JSON

## 📖 Descripción

Esta guía explica cómo integrar los datos estáticos desde archivos JSON en tus componentes usando la arquitectura hexagonal implementada.

##   Filosofía

**TODOS los datos fijos deben estar en archivos JSON** y ser cargados a través de la arquitectura hexagonal:
-   NO hardcodear arrays en componentes
-   SÍ usar archivos JSON en `assets/data/almacen/`
-   SÍ cargar datos a través del `AlmacenFacade`
-   SÍ usar signals reactivos para actualizar la UI

## 📂 Estructura de Archivos JSON

```
src/assets/data/almacen/
├── almacenes.json                    # Datos de almacenes
├── catalogos.json                    # Catálogos generales
├── transferencias.json               # Transferencias de almacén
└── comparaciones-inventario.json     # Comparaciones de inventario
```

##   Flujo de Datos

```
JSON File → Repository → Use Case → Facade → Store → Component
```

## 💻 Implementación en Componentes

### Paso 1: Inyectar el Facade

```typescript
import { Component, OnInit, inject } from '@angular/core';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';

export class MiComponente implements OnInit {
  // Inyectar facade
  private readonly almacenFacade = inject(AlmacenFacade);
  
  // Exponer selectores reactivos
  readonly almacenes = this.almacenFacade.almacenes;
  readonly catalogos = this.almacenFacade.catalogos;
  readonly transferencias = this.almacenFacade.transferencias;
  readonly isLoading = this.almacenFacade.isLoading;
}
```

### Paso 2: Cargar Datos en ngOnInit

```typescript
ngOnInit() {
  // Opción 1: Cargar todos los datos
  this.almacenFacade.inicializarDatos();
  
  // Opción 2: Cargar datos específicos
  this.almacenFacade.cargarAlmacenes();
  this.almacenFacade.cargarCatalogos();
  this.almacenFacade.cargarTransferencias();
}
```

### Paso 3: Usar Datos en el Template

```html
<!-- Usar con appLoader -->
<div [appLoader]="isLoading()">
  <!-- Grid con datos reactivos -->
  <ag-grid-angular
    [rowData]="transferencias()"
    [columnDefs]="columnDefs"
    ...
  ></ag-grid-angular>
</div>

<!-- Usar en select/dropdown -->
<ion-select>
  @for (item of catalogos()?.tiposDocumento; track item.id) {
    <ion-select-option [value]="item.id">
      {{ item.nombre }}
    </ion-select-option>
  }
</ion-select>
```

##   Ejemplo Completo

### Componente TypeScript

```typescript
import { Component, OnInit, inject } from '@angular/core';
import { AlmacenFacade } from '../../../../application/facades/almacen.facade';
import { ColDef } from 'ag-grid-community';

@Component({
  selector: 'app-a-o-recepcion',
  templateUrl: './a-o-recepcion.component.html',
  standalone: false,
})
export class AoRecepcionComponent implements OnInit {
  
  // Inyectar facade
  private readonly almacenFacade = inject(AlmacenFacade);
  
  // Exponer datos reactivos
  readonly transferencias = this.almacenFacade.transferencias;
  readonly almacenes = this.almacenFacade.almacenes;
  readonly catalogos = this.almacenFacade.catalogos;
  readonly isLoading = this.almacenFacade.isLoading;
  
  // Configuración del grid
  columnDefs: ColDef[] = [
    { field: 'nroTransferencia', headerName: 'Nro. Transferencia' },
    { field: 'fechaEnvio', headerName: 'Fecha Envío' },
    { field: 'origen', headerName: 'Origen' },
    { field: 'destino', headerName: 'Destino' },
  ];
  
  ngOnInit() {
    // Cargar todos los datos necesarios
    this.almacenFacade.inicializarDatos();
  }
}
```

### Template HTML

```html
<div class="contenedor-principal" [appLoader]="isLoading()">
  
  <!-- Panel con filtros -->
  <div class="panel-filtros">
    <ion-select label="Almacén">
      @for (almacen of almacenes(); track almacen.codigo) {
        <ion-select-option [value]="almacen.codigo">
          {{ almacen.nombre }}
        </ion-select-option>
      }
    </ion-select>
    
    <ion-select label="Estado">
      @for (estado of catalogos()?.estadosOperacion; track estado.id) {
        <ion-select-option [value]="estado.id">
          {{ estado.nombre }}
        </ion-select-option>
      }
    </ion-select>
  </div>
  
  <!-- Grid con datos -->
  <ag-grid-angular
    class="ag-theme-alpine"
    [rowData]="transferencias()"
    [columnDefs]="columnDefs"
  ></ag-grid-angular>
  
</div>
```

## 🎨 Datos Disponibles en el Facade

### Almacenes
```typescript
readonly almacenes = this.almacenFacade.almacenes;
// Retorna: Signal<AlmacenEntity[]>
```

### Catálogos Generales
```typescript
readonly catalogos = this.almacenFacade.catalogos;
// Retorna: Signal<CatalogosEntity | null>
// Incluye:
// - tiposDocumento
// - estadosOperacion
// - tiposDespacho
// - estadosProducto
// - unidadesMedida
// - tiposMovimiento
```

### Transferencias
```typescript
readonly transferencias = this.almacenFacade.transferencias;
// Retorna: Signal<TransferenciaEntity[]>
```

### Comparaciones de Inventario
```typescript
readonly comparacionesInventario = this.almacenFacade.comparacionesInventario;
// Retorna: Signal<ComparacionInventarioEntity[]>
```

### Estados de Carga
```typescript
readonly isLoading = this.almacenFacade.isLoading;
readonly loadingCatalogos = this.almacenFacade.loadingCatalogos;
```

## ⚡ Métodos del Facade

### Inicialización
```typescript
// Cargar todos los datos de una vez
this.almacenFacade.inicializarDatos();
```

### Carga Individual
```typescript
// Cargar almacenes
this.almacenFacade.cargarAlmacenes();

// Cargar catálogos
this.almacenFacade.cargarCatalogos();

// Cargar transferencias
this.almacenFacade.cargarTransferencias();

// Cargar comparaciones
this.almacenFacade.cargarComparacionesInventario();
```

##   Agregar Nuevos Tipos de Datos

### 1. Crear archivo JSON
```json
// src/assets/data/almacen/mi-nuevo-dato.json
[
  {
    "id": "1",
    "nombre": "Ejemplo"
  }
]
```

### 2. Crear entidad en el dominio
```typescript
// domain/models/catalogo.entity.ts
export interface MiNuevoDatoEntity {
  id: string;
  nombre: string;
}
```

### 3. Agregar al repositorio
```typescript
// domain/repositories/icatalogos.repository.ts
abstract obtenerMiNuevoDato(): Observable<MiNuevoDatoEntity[]>;

// infrastructure/repository/catalogos.repository.impl.ts
obtenerMiNuevoDato(): Observable<MiNuevoDatoEntity[]> {
  return this.http.get<MiNuevoDatoEntity[]>(`${this.BASE_PATH}/mi-nuevo-dato.json`);
}
```

### 4. Crear use case
```typescript
// application/usecases/obtener-mi-nuevo-dato.usecase.ts
@Injectable()
export class ObtenerMiNuevoDatoUseCase {
  private readonly repository = inject(ICatalogosRepository);
  
  execute(): Observable<MiNuevoDatoEntity[]> {
    return this.repository.obtenerMiNuevoDato();
  }
}
```

### 5. Extender el state y store
```typescript
// store/almacen.state.ts
export interface AlmacenState {
  // ...
  miNuevoDato: MiNuevoDatoEntity[];
  loadingMiNuevoDato: boolean;
}

// store/almacen.store.ts
readonly miNuevoDato = computed(() => this.state().miNuevoDato);

setMiNuevoDato(datos: MiNuevoDatoEntity[]) {
  this.state.update((s) => ({ ...s, miNuevoDato: datos }));
}
```

### 6. Exponer en el facade
```typescript
// application/facades/almacen.facade.ts
private readonly obtenerMiNuevoDatoUC = inject(ObtenerMiNuevoDatoUseCase);
readonly miNuevoDato = this.store.miNuevoDato;

cargarMiNuevoDato(): void {
  this.obtenerMiNuevoDatoUC.execute().subscribe({
    next: (datos) => this.store.setMiNuevoDato(datos),
    error: (err) => console.error(err)
  });
}
```

### 7. Registrar en providers
```typescript
// infrastructure/providers/almacen.providers.ts
ObtenerMiNuevoDatoUseCase,
```

##   Checklist de Migración de Componente

- [ ] Remover arrays hardcodeados del componente
- [ ] Crear archivo JSON con los datos
- [ ] Inyectar `AlmacenFacade` con `inject()`
- [ ] Exponer selectores reactivos (`readonly` con signals)
- [ ] Llamar a `inicializarDatos()` o métodos específicos en `ngOnInit`
- [ ] Actualizar template para usar signals con `()`
- [ ] Agregar `[appLoader]="isLoading()"` al contenedor principal
- [ ] Probar que los datos se cargan correctamente
- [ ] Verificar que no hay errores en consola

## 🚨 Errores Comunes

### Error: "Cannot read properties of null"
**Solución**: Usar optional chaining en el template
```html
<!--   Incorrecto -->
<div>{{ catalogos().tiposDocumento }}</div>

<!--   Correcto -->
<div>{{ catalogos()?.tiposDocumento }}</div>
```

### Error: "is not a function"
**Solución**: Recordar que son signals, usar `()`
```typescript
//   Incorrecto
const datos = this.transferencias;

//   Correcto
const datos = this.transferencias();
```

### Error: Datos no se cargan
**Solución**: Verificar que se llama a `cargarDatos()` en `ngOnInit`
```typescript
ngOnInit() {
  this.almacenFacade.inicializarDatos(); //  
}
```

## 📚 Recursos Adicionales

- [README.md](./README.md) - Visión general de la arquitectura
- [EXAMPLE-USAGE.md](./EXAMPLE-USAGE.md) - Ejemplos de uso
- [Angular Signals Documentation](https://angular.dev/guide/signals)
