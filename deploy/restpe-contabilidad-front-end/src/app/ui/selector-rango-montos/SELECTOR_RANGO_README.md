# Componente Selector de Rango de Montos

## Uso del componente

### En tu componente TypeScript:

```typescript
// En tu componente
rangoSeleccionado: any = null;

// Método para manejar la selección
onRangoSeleccionado(rango: any) {
  console.log('Rango seleccionado:', rango);
  // rango puede ser:
  // { tipo: 'menores', max: 1000 }
  // { tipo: 'de', min: 1000, max: 5000 }
  // { tipo: 'mayores', min: 20000 }
  // { tipo: 'personalizado', min: 1500, max: 3000 }
}
```

### En tu template HTML:

**Ejemplo básico:**
```html
<app-selector-rango-montos
  [(ngModel)]="rangoSeleccionado"
  placeholder="Montos de adquisición"
  width="w-[158px]"
  (rangoSeleccionado)="onRangoSeleccionado($event)">
</app-selector-rango-montos>
```

**Ejemplo con opciones personalizadas:**
```html
<app-selector-rango-montos
  [(ngModel)]="rangoSeleccionado"
  [opciones]="opcionesCustom"
  placeholder="Seleccionar rango"
  width="w-[200px]"
  (rangoSeleccionado)="onRangoSeleccionado($event)">
</app-selector-rango-montos>
```

**En el TypeScript con opciones custom:**
```typescript
opcionesCustom = [
  { label: 'Menos de 500', value: 'pequeno', max: 500 },
  { label: 'De 500 a 2,000', value: 'mediano', min: 500, max: 2000 },
  { label: 'Más de 2,000', value: 'grande', min: 2000 },
  { label: 'Personalizado', value: 'personalizado' }
];
```

**Ejemplo con FormControl:**
```html
<div class="flex items-center gap-2">
  <span class="text-xs">Rango de montos:</span>
  <app-selector-rango-montos
    formControlName="rangoMontos"
    placeholder="Seleccionar rango"
    width="w-[180px]"
    (rangoSeleccionado)="onRangoSeleccionado($event)">
  </app-selector-rango-montos>
</div>
```

## Propiedades del componente

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `placeholder` | `string` | `'Montos de adquisición'` | Texto cuando no hay selección |
| `width` | `string` | `'w-[158px]'` | Clase de Tailwind para el ancho |
| `disabled` | `boolean` | `false` | Deshabilitar el componente |
| `opciones` | `OpcionRango[]` | Opciones por defecto | Array de opciones disponibles |

## Eventos

| Evento | Tipo | Descripción |
|--------|------|-------------|
| `rangoSeleccionado` | `EventEmitter<any>` | Emite el rango seleccionado con estructura { tipo, min?, max? } |

## Interfaz OpcionRango

```typescript
export interface OpcionRango {
  label: string;    // Texto a mostrar
  value: string;    // Valor identificador
  min?: number;     // Monto mínimo 
  max?: number;     // Monto máximo 
}
```

## Características

 Modo opciones predefinidas (Menores a X, De X a Y, Mayores a Z)
 Modo personalizado con inputs Desde/Hasta
 Botón confirmar solo aparece cuando ambos inputs tienen valores válidos
 Validación automática (desde < hasta)
 Botón para limpiar selección
 Compatible con FormControl y ngModel
 Dropdown con navegación entre modos
 Completamente tipado con TypeScript
 Responsive y personalizable

## Comportamiento del modo personalizado

1. Al seleccionar "Personalizado", se ocultan las opciones predefinidas
2. Aparecen dos inputs: "Desde" y "Hasta"
3. El botón "Confirmar" solo aparece cuando:
   - Ambos inputs tienen valores
   - Los valores son mayores a 0
   - El valor "Desde" es menor que "Hasta"
4. Botón de volver (←) para regresar a las opciones predefinidas
