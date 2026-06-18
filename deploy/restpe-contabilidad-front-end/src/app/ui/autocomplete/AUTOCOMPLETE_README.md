# Componente Autocomplete

## Uso del componente

### En tu componente TypeScript:

```typescript
// En tu componente
cuentasContables = [
  { id: '10023', nombre: '10023 - Cuentas por pagar', descripcion: 'Cuentas por pagar a proveedores' },
  { id: '11011', nombre: '11011 - Bancos', descripcion: 'Cuentas bancarias' },
  { id: '11015', nombre: '11015 - Proveedores nacionales', descripcion: 'Proveedores del país' },
  { id: '11017', nombre: '11017 - Documentos por pagar', descripcion: 'Documentos pendientes de pago' },
  { id: '12001', nombre: '12001 - Mobiliario', descripcion: 'Mobiliario y equipo' },
  { id: '14001', nombre: '14001 - Capital social', descripcion: 'Capital social de la empresa' }
];

// En el método que maneja la selección
onCuentaSeleccionada(cuenta: any) {
  console.log('Cuenta seleccionada:', cuenta);
}
```

### En tu template HTML:

**Ejemplo básico:**
```html
<div class="flex flex-row items-center gap-2">
  <span class="w-[120px] text-xxs">Cta. Contable Asociada<span class="text-danger">*</span></span>
  <app-autocomplete
    formControlName="ctaContable"
    [items]="cuentasContables"
    displayKey="nombre"
    valueKey="id"
    placeholder="Buscar cuenta contable"
    width="w-[160px]"
    (itemSelected)="onCuentaSeleccionada($event)">
  </app-autocomplete>
</div>
```

**Ejemplo con ngModel:**
```html
<app-autocomplete
  [(ngModel)]="ctaContableSeleccionada"
  [items]="cuentasContables"
  displayKey="nombre"
  valueKey="id"
  placeholder="Buscar cuenta contable"
  width="w-[200px]"
  (itemSelected)="onCuentaSeleccionada($event)">
</app-autocomplete>
```

## Propiedades del componente

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `items` | `any[]` | `[]` | Array de objetos a filtrar |
| `displayKey` | `string` | `'nombre'` | Propiedad del objeto que se mostrará en la lista |
| `valueKey` | `string` | `'id'` | Propiedad del objeto que se guardará como valor |
| `placeholder` | `string` | `'Buscar...'` | Texto del placeholder |
| `width` | `string` | `'w-full'` | Clase de Tailwind para el ancho |
| `disabled` | `boolean` | `false` | Deshabilitar el input |

## Eventos

| Evento | Tipo | Descripción |
|--------|------|-------------|
| `itemSelected` | `EventEmitter<any>` | Se emite cuando se selecciona un item |

## Características

 Búsqueda en tiempo real
 Dropdown con scroll para muchos items
 Mensaje cuando no hay resultados
 Botón para limpiar selección
 Compatible con FormControl y ngModel
 Completamente tipado con TypeScript
 Responsive y personalizable
