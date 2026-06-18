# BaseCalendarNewComponent - Guía de Uso

## Importación Rápida

### **Paso 1: UiModule ya tiene el componente** 
El `BaseCalendarNewComponent` **ya está declarado y exportado** en `src/app/ui/ui.module.ts`. No necesitas hacer nada aquí.

### **Paso 2: Importar UiModule en tu Feature Module**
En el módulo de la feature donde uses el calendario:

```typescript
// Ejemplo: src/app/features/apartado-contabilidad/m-c-tabla/m-c-tabla.module.ts
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { UiModule } from 'src/app/ui/ui.module';

@NgModule({
  declarations: [
    ContabilidadTablaPlancontableComponent,
    // otros componentes...
  ],
  imports: [
    CommonModule,
    UiModule,  // ← AGREGAR ESTA LÍNEA
    // otros módulos...
  ],
})
export class MCTablaModule { }
```

### **Paso 3: Usar en el Template**

```html
<!-- Modo RANGO (2 fechas) -->
<app-base-calendar-new 
  mode="range"
  [initialStartDate]="startDate"
  [initialEndDate]="endDate"
  (dateRangeSelected)="onDateRangeSelected($event)">
</app-base-calendar-new>

<!-- Modo SINGLE (1 fecha) -->
<app-base-calendar-new 
  mode="single"
  [initialDate]="selectedDate"
  (dateSelected)="onDateSelected($event)">
</app-base-calendar-new>
```

### **Paso 4: Manejar en TypeScript**

```typescript
import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-mi-componente',
  templateUrl: './mi-componente.component.html',
  standalone: false,
})
export class MiComponente implements OnInit {
  startDate: Date | undefined;
  endDate: Date | undefined;
  selectedDate: Date | undefined;

  ngOnInit() {
    // Inicializar
    const today = new Date();
    this.startDate = new Date(today.getFullYear(), today.getMonth(), 1);
    this.endDate = today;
  }

  // Para modo RANGE
  onDateRangeSelected(range: { start: Date; end: Date }) {
    console.log('Rango:', range.start, 'a', range.end);
    this.startDate = range.start;
    this.endDate = range.end;
  }

  // Para modo SINGLE
  onDateSelected(date: Date) {
    console.log('Fecha:', date);
    this.selectedDate = date;
  }
}
```

---

## Propiedades (Inputs)

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `mode` | 'single' \| 'range' | 'single' | Modo de selección |
| `initialDate` | Date | undefined | Fecha inicial (modo single) |
| `initialStartDate` | Date | undefined | Fecha inicio (modo range) |
| `initialEndDate` | Date | undefined | Fecha fin (modo range) |
| `position` | 'left' \| 'center' \| 'right' | 'center' | Posición del calendario |
| `minDate` | Date | undefined | Fecha mínima permitida |
| `maxDate` | Date | undefined | Fecha máxima permitida |
| `disabled` | boolean | false | Deshabilitar calendario |
| `initInNull` | boolean | false | No inicializar con fecha default |
| `full` | boolean | false | Ancho 100% si es true |
| `calendarHeight` | string | '44px' | Altura del botón |
| `sameDayRange` | boolean | false | Rango debe ser del mismo día |

---

## Eventos (Outputs)

### Modo RANGE
```typescript
(dateRangeSelected)="onDateRangeSelected($event)"
// $event = { start: Date, end: Date }
```

### Modo SINGLE
```typescript
(dateSelected)="onDateSelected($event)"
// $event = Date
```

---

## Ejemplos Completos

### Ejemplo 1: Rango de Fechas Filtrado
```html
<app-base-calendar-new 
  class="flex-none"
  mode="range"
  [initialStartDate]="startDate"
  [initialEndDate]="endDate"
  [minDate]="minDate"
  [maxDate]="maxDate"
  position="left"
  (dateRangeSelected)="filtrarPorFechas($event)">
</app-base-calendar-new>

<p *ngIf="startDate && endDate">
  Mostrando datos de {{ startDate | date: 'shortDate' }} 
  a {{ endDate | date: 'shortDate' }}
</p>
```

```typescript
export class MiComponente {
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  constructor() {
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }

  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
    // Llamar a servicio para filtrar datos
    this.cargarDatos(range.start, range.end);
  }

  cargarDatos(start: Date, end: Date) {
    // Lógica para cargar datos filtrados
  }
}
```

### Ejemplo 2: Fecha Única para Reporte
```html
<app-base-calendar-new
  class="flex-none"
  mode="single"
  [initialDate]="selectedDate"
  [minDate]="minDate"
  [maxDate]="maxDate"
  position="center"
  (dateSelected)="generarReporte($event)">
</app-base-calendar-new>
```

```typescript
export class ReporteComponente {
  selectedDate: Date = new Date();
  minDate: Date = new Date(2020, 0, 1);
  maxDate: Date = new Date();

  generarReporte(date: Date) {
    console.log('Generando reporte para:', date);
    // Lógica para generar reporte
  }
}
