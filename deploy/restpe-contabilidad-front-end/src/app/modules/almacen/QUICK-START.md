# 🚀 Quick Start - Replicar en Otros Módulos

## ⚡ Pasos Rápidos (5 minutos)

### 1. Copiar Estructura Base
```bash
cd src/app/features/[tu-modulo]

# Crear carpetas
mkdir -p store domain/{models,repositories} application/{usecases,facades,dto/{requests,responses}} infrastructure/{repository,providers}
```

### 2. Domain Layer (Modelos y Contratos)

**`domain/models/tu-entidad.entity.ts`**
```typescript
export interface TuEntidad {
  id: string;
  nombre: string;
  // ... otros campos
}
```

**`domain/repositories/itu-entidad.repository.ts`**
```typescript
import { Observable } from 'rxjs';
import { TuEntidad } from '../models/tu-entidad.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';

export abstract class ITuEntidadRepository {
  abstract obtenerTodos(): Observable<TuEntidad[]>;
  abstract guardar(entidad: TuEntidad): Observable<ApiResponse<TuEntidad>>;
  abstract actualizar(entidad: TuEntidad): Observable<ApiResponse<TuEntidad>>;
  abstract eliminar(id: string): Observable<ApiResponse<boolean>>;
}
```

### 3. Store (Estado Reactivo)

**`store/tu-entidad.state.ts`**
```typescript
import { TuEntidad } from '../domain/models/tu-entidad.entity';
import { ApiResponse } from '../../../shared/models/api-response.model';

export interface TuEntidadState {
  entidades: TuEntidad[];
  entidadSeleccionada: TuEntidad | null;
  
  loadingObtener: boolean;
  loadingGuardar: boolean;
  loadingEliminar: boolean;
  loadingActualizar: boolean;
  
  errorObtener: string | null;
  errorGuardar: string | null;
  errorEliminar: string | null;
  errorActualizar: string | null;
  
  resultGuardar: ApiResponse<TuEntidad> | null;
  resultEliminar: ApiResponse<boolean> | null;
  resultActualizar: ApiResponse<TuEntidad> | null;
}

export const initialState: TuEntidadState = {
  entidades: [],
  entidadSeleccionada: null,
  loadingObtener: false,
  loadingGuardar: false,
  loadingEliminar: false,
  loadingActualizar: false,
  errorObtener: null,
  errorGuardar: null,
  errorEliminar: null,
  errorActualizar: null,
  resultGuardar: null,
  resultEliminar: null,
  resultActualizar: null,
};
```

**`store/tu-entidad.store.ts`**
```typescript
import { Injectable, signal, computed } from '@angular/core';
import { TuEntidadState, initialState } from './tu-entidad.state';
import { TuEntidad } from '../domain/models/tu-entidad.entity';

@Injectable({ providedIn: 'root' })
export class TuEntidadStore {
  private readonly state = signal<TuEntidadState>(initialState);

  // Selectores
  readonly entidades = computed(() => this.state().entidades);
  readonly isLoading = computed(() => 
    this.state().loadingObtener || 
    this.state().loadingGuardar || 
    this.state().loadingEliminar || 
    this.state().loadingActualizar
  );
  
  // Mutadores
  setEntidades(entidades: TuEntidad[]) {
    this.state.update(s => ({ ...s, entidades, errorObtener: null }));
  }
  
  setLoadingObtener(value: boolean) {
    this.state.update(s => ({ ...s, loadingObtener: value }));
  }
  
  // ... más mutadores según necesites
}
```

### 4. Application Layer (Casos de Uso)

**`application/usecases/obtener-entidades.usecase.ts`**
```typescript
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { ITuEntidadRepository } from '../../domain/repositories/itu-entidad.repository';
import { TuEntidad } from '../../domain/models/tu-entidad.entity';

@Injectable({ providedIn: 'root' })
export class ObtenerEntidadesUseCase {
  private readonly repository = inject(ITuEntidadRepository);

  execute(): Observable<TuEntidad[]> {
    return this.repository.obtenerTodos();
  }
}
```

**`application/facades/tu-entidad.facade.ts`**
```typescript
import { Injectable, inject } from '@angular/core';
import { ObtenerEntidadesUseCase } from '../usecases/obtener-entidades.usecase';
import { TuEntidadStore } from '../../store/tu-entidad.store';

@Injectable({ providedIn: 'root' })
export class TuEntidadFacade {
  private readonly store = inject(TuEntidadStore);
  private readonly obtenerUC = inject(ObtenerEntidadesUseCase);

  readonly entidades = this.store.entidades;
  readonly isLoading = this.store.isLoading;

  cargarEntidades(): void {
    this.store.setLoadingObtener(true);
    
    this.obtenerUC.execute().subscribe({
      next: (data) => this.store.setEntidades(data),
      error: (err) => console.error(err),
      complete: () => this.store.setLoadingObtener(false)
    });
  }
}
```

### 5. Infrastructure (Adaptador JSON)

**`infrastructure/repository/tu-entidad.repository.impl.ts`**
```typescript
import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay } from 'rxjs';
import { ITuEntidadRepository } from '../../domain/repositories/itu-entidad.repository';
import { TuEntidad } from '../../domain/models/tu-entidad.entity';

@Injectable({ providedIn: 'root' })
export class TuEntidadRepositoryImpl implements ITuEntidadRepository {
  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/[modulo]/entidades.json';

  obtenerTodos(): Observable<TuEntidad[]> {
    return this.http.get<TuEntidad[]>(this.JSON_PATH).pipe(delay(500));
  }
  
  // ... más métodos
}
```

**`infrastructure/providers/tu-entidad.providers.ts`**
```typescript
import { Provider } from '@angular/core';
import { ITuEntidadRepository } from '../../domain/repositories/itu-entidad.repository';
import { TuEntidadRepositoryImpl } from '../repository/tu-entidad.repository.impl';

export const TU_ENTIDAD_PROVIDERS: Provider[] = [
  { provide: ITuEntidadRepository, useClass: TuEntidadRepositoryImpl }
];
```

### 6. Crear JSON de Datos

**`src/assets/data/[modulo]/entidades.json`**
```json
[
  {
    "id": "1",
    "nombre": "Ejemplo 1",
    "estado": "Activo"
  },
  {
    "id": "2",
    "nombre": "Ejemplo 2",
    "estado": "Inactivo"
  }
]
```

### 7. Configurar Módulo

**`tu-modulo.module.ts`**
```typescript
import { TU_ENTIDAD_PROVIDERS } from './infrastructure/providers/tu-entidad.providers';

@NgModule({
  // ...
  providers: [
    ...TU_ENTIDAD_PROVIDERS
  ]
})
export class TuModuloModule { }
```

### 8. Usar en Componente

**`tu-componente.component.ts`**
```typescript
import { Component, inject, effect } from '@angular/core';
import { TuEntidadFacade } from '../../application/facades/tu-entidad.facade';

@Component({
  selector: 'app-tu-componente',
  template: `
    <div [appLoader]="isLoading()">
      <!-- Panel derecho -->
      <div class="panel-derecho">
        <!-- Formulario -->
      </div>
      
      <!-- AG-Grid -->
      <ag-grid-angular [rowData]="entidades()" />
    </div>
  `
})
export class TuComponente {
  private readonly facade = inject(TuEntidadFacade);
  
  readonly entidades = this.facade.entidades;
  readonly isLoading = this.facade.isLoading;
  
  ngOnInit() {
    this.facade.cargarEntidades();
  }
}
```

##   Checklist de Implementación

- [ ] Crear estructura de carpetas
- [ ] Definir entidad en domain/models
- [ ] Crear interfaz de repositorio en domain/repositories
- [ ] Crear state, actions y store
- [ ] Crear use cases en application/usecases
- [ ] Crear facade en application/facades
- [ ] Crear repository implementation en infrastructure
- [ ] Crear providers en infrastructure/providers
- [ ] Crear archivo JSON en assets/data
- [ ] Registrar providers en el módulo
- [ ] Actualizar componente para usar facade
- [ ] Agregar `[appLoader]="isLoading()"` en template

##   Puntos Clave

1. **JSON como fuente de datos**: `assets/data/[modulo]/archivo.json`
2. **Store con Signals**: Estado reactivo automático
3. **Facade orquesta todo**: Componente solo habla con facade
4. **AppLoader integrado**: `[appLoader]="isLoading()"`
5. **Effects para reaccionar**: Usa `effect()` para escuchar cambios

## 💡 Tips

- **Delay en JSON**: `.pipe(delay(500))` simula latencia de red
- **Loading states**: Usa `isLoading()` computed para combinar todos los loading
- **Limpiar estados**: Llama `facade.limpiarEstado()` después de manejar resultados
- **Debugging**: Usa `effect()` con console.log para ver cambios en tiempo real

---

**¡Con esto puedes replicar la arquitectura en cualquier módulo en menos de 5 minutos!**
