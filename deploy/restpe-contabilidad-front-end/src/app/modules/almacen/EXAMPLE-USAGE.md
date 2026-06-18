# Ejemplo de Uso - Arquitectura Hexagonal

##   Ejemplo Completo en un Componente

```typescript
import { Component, inject, effect } from '@angular/core';
import { AlmacenFacade } from '../../application/facades/almacen.facade';
import { AlmacenEntity } from '../../domain/models/almacen.entity';

@Component({
  selector: 'app-mi-almacen',
  template: `
    <!-- AppLoader para mostrar estado de carga -->
    <div [appLoader]="isLoading()">
      
      <!-- Panel Derecho con formulario -->
      <div class="panel-derecho">
        <!-- Contenido del formulario -->
      </div>

      <!-- Tabla con AG-Grid -->
      <ag-grid-angular 
        [rowData]="almacenes()" 
        [columnDefs]="colDefs"
      />
    </div>
  `
})
export class MiAlmacenComponent {
  // 1️⃣ INYECTAR EL FACADE
  private readonly almacenFacade = inject(AlmacenFacade);

  // 2️⃣ EXPONER SELECTORES (Signals)
  readonly almacenes = this.almacenFacade.almacenes;
  readonly isLoading = this.almacenFacade.isLoading;
  readonly hasError = this.almacenFacade.hasError;

  constructor() {
    // 3️⃣ EFFECTS PARA REACCIONAR A CAMBIOS
    
    // Effect para actualizar la tabla
    effect(() => {
      const data = this.almacenes();
      console.log('Almacenes actualizados:', data);
      // Actualizar AG-Grid si es necesario
    });

    // Effect para manejar guardado exitoso
    effect(() => {
      const result = this.almacenFacade.resultGuardar();
      if (result?.success) {
        console.log('  Guardado exitoso:', result.message);
        this.almacenFacade.limpiarEstado();
      }
    });

    // Effect para manejar errores
    effect(() => {
      const error = this.almacenFacade.errorGuardar();
      if (error) {
        console.error('  Error:', error);
        this.almacenFacade.limpiarEstado();
      }
    });
  }

  ngOnInit() {
    // 4️⃣ CARGAR DATOS AL INICIAR
    this.almacenFacade.cargarAlmacenes();
  }

  // 5️⃣ ACCIONES DEL USUARIO
  guardar() {
    const nuevoAlmacen: AlmacenEntity = {
      codigo: '',
      nombre: 'Almacén Test',
      tipo: 'Principal',
      direccion: 'Av. Test 123',
      ciudad: 'Piura',
      distrito: 'Piura',
      capacidad: '100 m2',
      responsable: 'Juan Pérez',
      estado: 'Activo'
    };

    this.almacenFacade.guardarAlmacen(nuevoAlmacen);
  }

  actualizar(almacen: AlmacenEntity) {
    this.almacenFacade.actualizarAlmacen(almacen);
  }

  eliminar(codigo: string) {
    this.almacenFacade.eliminarAlmacen(codigo);
  }

  seleccionar(almacen: AlmacenEntity) {
    this.almacenFacade.seleccionarAlmacen(almacen);
  }
}
```

## 🔧 Uso del AppLoader

El `appLoader` ya está integrado en el template principal:

```html
<div class="contenedor-principal" [appLoader]="isLoading()">
  <div class="panel-izquierdo">
    <!-- Tabla AG-Grid -->
  </div>

  <div class="panel-derecho">
    <!-- Formulario -->
  </div>
</div>
```

**Características del appLoader:**
- Se muestra automáticamente cuando `isLoading()` es `true`
- Cubre toda la pantalla con un overlay
- Se posiciona **entre el panel derecho y la tabla AG-Grid**
- Desaparece automáticamente cuando termina la carga

##   Template con Signals (Control Flow)

```html
<!-- Estado de carga -->
@if (isLoading()) {
  <div class="loader">Cargando...</div>
}

<!-- Estado de error -->
@if (hasError()) {
  <div class="error">Error al cargar datos</div>
}

<!-- Mostrar datos -->
@if (almacenes().length > 0) {
  @for (almacen of almacenes(); track almacen.codigo) {
    <div class="card">
      <h3>{{ almacen.nombre }}</h3>
      <p>{{ almacen.direccion }}</p>
    </div>
  }
} @else {
  <p>No hay almacenes</p>
}
```

##   Selectores Disponibles

### Datos
```typescript
almacenes()              // AlmacenEntity[]
almacenSeleccionado()    // AlmacenEntity | null
```

### Estados de Carga
```typescript
loadingObtener()    // boolean
loadingGuardar()    // boolean
loadingEliminar()   // boolean
loadingActualizar() // boolean
isLoading()         // boolean - Combina todos los loading
```

### Errores
```typescript
errorObtener()      // string | null
errorGuardar()      // string | null
errorEliminar()     // string | null
errorActualizar()   // string | null
hasError()          // boolean - True si hay algún error
```

### Resultados
```typescript
resultGuardar()     // ApiResponse<AlmacenEntity> | null
resultEliminar()    // ApiResponse<boolean> | null
resultActualizar()  // ApiResponse<AlmacenEntity> | null
```

## 🚀 Acciones (Métodos del Facade)

```typescript
// Cargar todos los almacenes
almacenFacade.cargarAlmacenes();

// Guardar nuevo almacén
almacenFacade.guardarAlmacen(almacen);

// Actualizar almacén existente
almacenFacade.actualizarAlmacen(almacen);

// Eliminar almacén
almacenFacade.eliminarAlmacen(codigo);

// Seleccionar almacén
almacenFacade.seleccionarAlmacen(almacen);

// Limpiar estados de error/éxito
almacenFacade.limpiarEstado();

// Reset completo del store
almacenFacade.reset();
```

##   Flujo Típico de CRUD

### Crear
```typescript
onGuardar() {
  const almacen: AlmacenEntity = this.construirAlmacen();
  this.almacenFacade.guardarAlmacen(almacen);
  // El effect manejará el resultado
}
```

### Leer
```typescript
ngOnInit() {
  this.almacenFacade.cargarAlmacenes();
  // Los datos estarán disponibles en this.almacenes()
}
```

### Actualizar
```typescript
onActualizar() {
  if (!this.almacenSeleccionado()) return;
  
  const almacenActualizado = {
    ...this.almacenSeleccionado()!,
    nombre: this.formValue.nombre
  };
  
  this.almacenFacade.actualizarAlmacen(almacenActualizado);
}
```

### Eliminar
```typescript
onEliminar(codigo: string) {
  this.almacenFacade.eliminarAlmacen(codigo);
  // El effect manejará el resultado
}
```

## 🎨 Integración con AG-Grid

```typescript
export class MiComponente {
  private gridApi!: GridApi;
  readonly almacenes = this.almacenFacade.almacenes;

  constructor() {
    // Effect para actualizar grid cuando cambian los datos
    effect(() => {
      const data = this.almacenes();
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', data);
      }
    });
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onCellClicked(event: any) {
    // Seleccionar almacén al hacer clic
    this.almacenFacade.seleccionarAlmacen(event.data);
  }
}
```

## 💡 Tips y Mejores Prácticas

1. **Siempre usa effects para reaccionar a cambios del store**
   ```typescript
   effect(() => {
     const result = this.almacenFacade.resultGuardar();
     if (result?.success) {
       // Hacer algo
       this.almacenFacade.limpiarEstado(); // ¡Importante!
     }
   });
   ```

2. **Limpia el estado después de manejar resultados**
   ```typescript
   this.almacenFacade.limpiarEstado();
   ```

3. **Usa el selector isLoading() para el appLoader**
   ```html
   <div [appLoader]="isLoading()">
   ```

4. **No modifiques el state directamente, usa el facade**
     `this.store.almacenes = [...]`
     `this.almacenFacade.cargarAlmacenes()`

5. **Los signals son readonly, úsalos con ()**
   ```typescript
   const data = this.almacenes(); //  
   const data = this.almacenes;   //  
   ```

##   Debugging

```typescript
// Ver estado completo en console
effect(() => {
  console.log('Almacenes:', this.almacenes());
  console.log('Loading:', this.isLoading());
  console.log('Seleccionado:', this.almacenSeleccionado());
});

// Ver cuando cambian los datos
effect(() => {
  console.log('Datos actualizados:', this.almacenes());
}, { allowSignalWrites: true });
```

---

**¡Listo!** Con esta estructura puedes manejar todo el flujo de datos de forma reactiva y escalable.
