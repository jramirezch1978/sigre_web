# File Upload Component

Componente reutilizable para subir archivos con validación y feedback visual.

## Características

-  Validación de tipo de archivo
-  Validación de tamaño de archivo
-  Feedback visual del archivo seleccionado
-  Opción de remover archivo
-  Personalizable (ancho, alto, placeholder)
-  Emite eventos para manejo del archivo
-  Soporte para deshabilitar
-  Muestra nombre completo del archivo en tooltip

## Uso básico

### En tu template HTML:

```html
<app-file-upload
  [accept]="'.pdf,.xml'"
  [placeholder]="'Haz clic para subir un archivo'"
  (fileSelected)="onFileSelected($event)"
  (fileRemoved)="onFileRemoved()"
  (error)="onError($event)">
</app-file-upload>
```

### En tu componente TypeScript:

```typescript
onFileSelected(file: File) {
  console.log('Archivo seleccionado:', file);
  // Aquí puedes manejar el archivo, por ejemplo:
  // - Subirlo a un servidor
  // - Leer su contenido
  // - Validar información adicional
}

onFileRemoved() {
  console.log('Archivo removido');
  // Limpiar cualquier dato relacionado
}

onError(errorMessage: string) {
  console.error('Error:', errorMessage);
  // Mostrar mensaje de error al usuario
}
```

## Propiedades de entrada (@Input)

| Propiedad | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `accept` | string | '.pdf,.xml' | Tipos de archivo aceptados (extensiones o MIME types) |
| `placeholder` | string | 'Haz clic para subir un archivo' | Texto mostrado cuando no hay archivo |
| `maxFileSize` | number | 5 | Tamaño máximo del archivo en MB |
| `width` | string | 'w-40' | Clase Tailwind para el ancho |
| `height` | string | 'h-[28px]' | Clase Tailwind para el alto |
| `disabled` | boolean | false | Deshabilitar el componente |
| `required` | boolean | false | Marcar como campo requerido |

## Eventos de salida (@Output)

| Evento | Tipo | Descripción |
|--------|------|-------------|
| `fileSelected` | EventEmitter<File> | Se emite cuando se selecciona un archivo válido |
| `fileRemoved` | EventEmitter<void> | Se emite cuando se remueve el archivo |
| `error` | EventEmitter<string> | Se emite cuando ocurre un error de validación |

## Ejemplos de uso

### Subir solo PDFs

```html
<app-file-upload
  [accept]="'.pdf'"
  [placeholder]="'Subir PDF'"
  [maxFileSize]="10"
  (fileSelected)="handlePdf($event)">
</app-file-upload>
```

### Subir imágenes

```html
<app-file-upload
  [accept]="'image/*'"
  [placeholder]="'Subir imagen'"
  [maxFileSize]="3"
  [width]="'w-60'"
  (fileSelected)="handleImage($event)">
</app-file-upload>
```

### Subir documentos con validación específica

```html
<app-file-upload
  [accept]="'.pdf,.doc,.docx'"
  [placeholder]="'Subir documento de identidad'"
  [maxFileSize]="5"
  [required]="true"
  (fileSelected)="handleDocument($event)"
  (error)="showErrorToast($event)">
</app-file-upload>
```

### Con ancho personalizado

```html
<app-file-upload
  [accept]="'.xml,.pdf'"
  [width]="'w-64'"
  [height]="'h-[32px]'"
  [placeholder]="'Cargar comprobante'"
  (fileSelected)="onFileSelected($event)">
</app-file-upload>
```

### Componente deshabilitado

```html
<app-file-upload
  [disabled]="!canUpload"
  [placeholder]="'No disponible'"
  (fileSelected)="onFileSelected($event)">
</app-file-upload>
```

## Validaciones

El componente realiza las siguientes validaciones automáticas:

1. **Tamaño de archivo**: Verifica que el archivo no exceda el `maxFileSize` especificado
2. **Tipo de archivo**: Valida que la extensión del archivo coincida con los tipos especificados en `accept`

Si alguna validación falla, se emite el evento `error` con un mensaje descriptivo.

## Estilos

El componente utiliza clases de Tailwind CSS y se adapta al tema de tu aplicación. Los colores utilizados son:

- `border-text-5`: Color del borde
- `bg-Background-light`: Fondo cuando hay archivo seleccionado
- `text-primary`: Color del texto del placeholder
- `text-danger`: Color del icono de eliminar

## Ejemplo completo en un formulario

```html
<form [formGroup]="myForm">
  <div class="form-field">
    <label class="label">
      Copia de documento de identidad 
      <span class="text-danger">*</span>
    </label>
    
    <app-file-upload
      [accept]="'.pdf,.jpg,.png'"
      [placeholder]="'Haz clic para subir documento'"
      [maxFileSize]="5"
      [required]="true"
      (fileSelected)="onDocumentSelected($event)"
      (fileRemoved)="onDocumentRemoved()"
      (error)="showError($event)">
    </app-file-upload>
  </div>
</form>
```

```typescript
export class MyComponent {
  documentoIdentidad: File | null = null;

  onDocumentSelected(file: File) {
    this.documentoIdentidad = file;
    console.log('Documento cargado:', file.name);
    // Aquí podrías subir el archivo al servidor
  }

  onDocumentRemoved() {
    this.documentoIdentidad = null;
    console.log('Documento removido');
  }

  showError(error: string) {
    // Mostrar toast o mensaje de error
    console.error(error);
  }
}
```
