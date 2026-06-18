#   Implementación del Módulo de Proveedores

##   Resumen

Se ha implementado exitosamente la arquitectura de Clean Architecture para el módulo de proveedores en el feature de Compras, siguiendo el mismo patrón utilizado en el módulo de Almacenes.

## 📁 Estructura Creada

```
apartado-compras/
├── domain/
│   ├── models/
│   │   └── proveedor.entity.ts          # Entidad de dominio
│   └── repositories/
│       └── iproveedor.repository.ts     # Interfaz del repositorio
├── application/
│   ├── facades/
│   │   └── proveedor.facade.ts          # Facade para la UI
│   └── usecases/
│       ├── obtener-proveedores.usecase.ts
│       ├── guardar-proveedor.usecase.ts
│       ├── actualizar-proveedor.usecase.ts
│       ├── eliminar-proveedor.usecase.ts
│       └── index.ts
├── infrastructure/
│   ├── repository/
│   │   └── proveedores.repository.impl.ts # Implementación del repositorio
│   └── providers/
│       └── proveedor.providers.ts        # Configuración de inyección de dependencias
├── store/
│   ├── proveedor.state.ts               # Estado de la aplicación
│   └── proveedor.store.ts               # Store con signals de Angular
└── effects/
    ├── proveedor-feedback.effect.ts     # Effects para feedback (toasts)
    └── proveedor-sync.effect.ts         # Effects para sincronización
```

## 📄 Archivo JSON Mockup

Ubicación: `src/assets/data/compras/tablas/proveedores.json`

Contiene 5 proveedores de ejemplo con sus respectivas cuentas bancarias, siguiendo la estructura de la interfaz `IRow`.

## 🔧 Componente Actualizado

El componente `ComprasTablasGestionProveedoresComponent` fue actualizado para:

1. **Inyectar el Facade y Effects:**
   ```typescript
   private readonly proveedorFacade = inject(ProveedorFacade);
   private readonly feedbackEffects = inject(ProveedorFeedbackEffects);
   ```

2. **Usar selectores reactivos del Store:**
   ```typescript
   readonly proveedores = this.proveedorFacade.proveedores;
   readonly isLoading = this.proveedorFacade.isLoading;
   readonly loadingGuardar = this.proveedorFacade.loadingGuardar;
   // etc...
   ```

3. **Effect para actualizar la tabla automáticamente:**
   ```typescript
   effect(() => {
     const proveedores = this.proveedores();
     this.rowData = proveedores;
     if (this.gridApi) {
       this.gridApi.setGridOption('rowData', this.rowData);
     }
   });
   ```

4. **Métodos actualizados para usar el Facade:**
   - `cargarProveedoresDesdeStore()`: Carga proveedores desde el JSON
   - `guardar()`: Usa `proveedorFacade.guardarProveedor()` o `actualizarProveedor()`
   - `onBtReset()`: Recarga datos desde el repositorio

## 🎨 Patrón de Arquitectura

### Flujo de Datos

1. **UI → Facade → Use Case → Repository → HTTP Client**
   ```
   Component → ProveedorFacade → ObtenerProveedoresUseCase → 
   ProveedorRepositoryImpl → HttpClient → JSON
   ```

2. **Response → Store → Signals → UI**
   ```
   JSON → Repository → Use Case → Facade → Store.setProveedores() → 
   Signal (computed) → Component (effect) → AG-Grid
   ```

### Beneficios

-   **Separación de responsabilidades**: Cada capa tiene una responsabilidad única
-   **Testeable**: Fácil de testear por capas
-   **Escalable**: Fácil de agregar nuevas funcionalidades
-   **Mantenible**: Código organizado y fácil de entender
-   **Reactividad**: Uso de signals de Angular para UI reactiva
-   **Feedback automático**: Effects manejan toasts y sincronización

## 🚀 Uso

### Cargar Proveedores

```typescript
this.proveedorFacade.cargarProveedores();
```

### Guardar Proveedor

```typescript
const proveedor: ProveedorEntity = {
  codigo: '',
  razonSocial: 'Proveedor Ejemplo',
  identificacionFiscal: '20123456789',
  estado: 'Activo',
  // ... resto de propiedades
};

this.proveedorFacade.guardarProveedor(proveedor);
```

### Actualizar Proveedor

```typescript
this.proveedorFacade.actualizarProveedor(proveedor);
```

### Eliminar Proveedor

```typescript
this.proveedorFacade.eliminarProveedor(codigo);
```

### Observar Estado de Carga

```typescript
// En el template
@if (loadingObtener()) {
  <ion-spinner></ion-spinner>
}
```

##   Notas Importantes

1. **Effects Automáticos**: Los effects están configurados para:
   - Mostrar toasts de éxito/error automáticamente
   - Recargar la lista después de guardar, actualizar o eliminar
   - Limpiar resultados después de sincronizar

2. **Store Reactivo**: El store usa signals de Angular, lo que significa que cualquier cambio se refleja automáticamente en la UI sin necesidad de subscripciones manuales.

3. **Providers**: Los providers están registrados en `apartado-compras.module.ts`:
   ```typescript
   providers: [
     ...PROVEEDOR_PROVIDERS
   ]
   ```

4. **Repositorio Mock**: El repositorio actualmente consume un JSON local. Para conectar a una API real, solo se necesita modificar `ProveedorRepositoryImpl` sin tocar ninguna otra parte del código.

##   Migración de SimulationService

El componente ya no usa `SimulationService` para proveedores. Los datos ahora se gestionan a través del repositorio y el store, asegurando:

- Consistencia de datos
- Mejor manejo de estados de carga
- Feedback automático al usuario
- Sincronización automática

##   Próximos Pasos

1. **Conectar a API real**: Modificar `ProveedorRepositoryImpl` para usar endpoints reales
2. **Implementar paginación**: Agregar soporte para paginación en el repositorio
3. **Agregar filtros**: Implementar filtros y búsqueda en el repositorio
4. **Caché**: Considerar implementar estrategia de caché en el store
5. **Validaciones**: Agregar validaciones de negocio en los use cases

---

  **Implementación completada exitosamente**  
