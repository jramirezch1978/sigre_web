import { Component, EventEmitter, Input, Output, ViewChild, ElementRef, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

// Font Awesome Icons
import { faCircleXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-file-upload',
  templateUrl: './file-upload.component.html',
  styleUrls: ['./file-upload.component.scss'],
  standalone: false,
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      useExisting: forwardRef(() => FileUploadComponent),
      multi: true
    }
  ]
})
export class FileUploadComponent implements ControlValueAccessor {
  // Font Awesome Icons
  farCircleXmark = faCircleXmark;


  @Input() accept: string = '.pdf,.xml'; // Tipos de archivo aceptados
  @Input() placeholder: string = 'Haz clic para subir un archivo'; // Texto del placeholder
  @Input() maxFileSize: number = 5; // Tamaño máximo en MB
  @Input() width: string = 'w-40'; // Ancho del componente (clase Tailwind)
  @Input() disabled: boolean = false; // Deshabilitar el componente
  @Input() required: boolean = false; // Marcar como requerido

  @Output() fileSelected = new EventEmitter<File>();
  @Output() fileRemoved = new EventEmitter<void>();
  @Output() error = new EventEmitter<string>();

  @ViewChild('fileInput', { static: false }) fileInput!: ElementRef<HTMLInputElement>;

  selectedFile: File | null = null;
  fileName: string = '';
  
  // ControlValueAccessor
  private onChange: (value: string) => void = () => {};
  private onTouched: () => void = () => {};
  isDisabled: boolean = false;

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files.length > 0) {
      const file = input.files[0];
      
      // Validar tamaño del archivo
      const fileSizeMB = file.size / (1024 * 1024);
      if (fileSizeMB > this.maxFileSize) {
        this.error.emit(`El archivo excede el tamaño máximo permitido de ${this.maxFileSize}MB`);
        this.clearInput();
        return;
      }

      // Validar tipo de archivo si se especifica accept
      if (this.accept) {
        const acceptedTypes = this.accept.split(',').map(type => type.trim());
        const fileExtension = '.' + file.name.split('.').pop()?.toLowerCase();
        const isValidType = acceptedTypes.some(type => {
          if (type.startsWith('.')) {
            return type.toLowerCase() === fileExtension;
          }
          return file.type.match(type);
        });

        if (!isValidType) {
          this.error.emit(`Tipo de archivo no permitido. Solo se aceptan: ${this.accept}`);
          this.clearInput();
          return;
        }
      }

      this.selectedFile = file;
      this.fileName = file.name;
      this.onChange(file.name);
      this.onTouched();
      this.fileSelected.emit(file);
    }
  }

  removeFile(): void {
    this.selectedFile = null;
    this.fileName = '';
    this.clearInput();
    this.onChange('');
    this.onTouched();
    this.fileRemoved.emit();
  }

  openFileDialog(): void {
    if (!this.disabled && !this.isDisabled) {
      this.fileInput.nativeElement.click();
    }
  }

  private clearInput(): void {
    if (this.fileInput) {
      this.fileInput.nativeElement.value = '';
    }
  }

  get hasFile(): boolean {
    return !!this.selectedFile;
  }
  
  // Implementación de ControlValueAccessor
  writeValue(value: string): void {
    if (value) {
      this.fileName = value;
    } else {
      this.fileName = '';
      this.selectedFile = null;
      this.clearInput();
    }
  }

  registerOnChange(fn: (value: string) => void): void {
    this.onChange = fn;
  }

  registerOnTouched(fn: () => void): void {
    this.onTouched = fn;
  }

  setDisabledState(isDisabled: boolean): void {
    this.isDisabled = isDisabled;
  }
}
