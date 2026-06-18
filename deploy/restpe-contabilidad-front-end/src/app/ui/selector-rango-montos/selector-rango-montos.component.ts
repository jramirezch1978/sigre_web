import { Component, EventEmitter, forwardRef, Input, Output } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

// Font Awesome Icons
import { faChevronDown, faChevronUp, faTimes } from '@fortawesome/pro-solid-svg-icons';

// Font Awesome Icons



export interface OpcionRango {
  label: string;
  value: string;
  min?: number;
  max?: number;
}

export interface RangoPersonalizado {
  desde: number;
  hasta: number;
}

@Component({
  selector: 'app-selector-rango-montos',
  templateUrl: './selector-rango-montos.component.html',
  styleUrls: ['./selector-rango-montos.component.scss'],
  standalone: false,
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      useExisting: forwardRef(() => SelectorRangoMontosComponent),
      multi: true
    }
  ]
})
export class SelectorRangoMontosComponent implements ControlValueAccessor {
  // Font Awesome Icons
  fasChevronDown = faChevronDown;
  fasChevronUp = faChevronUp;
  fasTimes = faTimes;



  @Input() placeholder: string = 'Montos de adquisición';
  @Input() width: string = 'w-[158px]';
  @Input() disabled: boolean = false;
  @Input() opciones: OpcionRango[] = [
    { label: 'Menores a 1,000', value: 'menores', max: 1000 },
    { label: 'De 1,000 a 5,000', value: 'de', min: 1000, max: 5000 },
    { label: 'Mayores a 20,000', value: 'mayores', min: 20000 },
    { label: 'Personalizado', value: 'personalizado' }
  ];

  @Output() rangoSeleccionado = new EventEmitter<any>();

  isOpen: boolean = false;
  modoPersonalizado: boolean = false;
  opcionSeleccionada: OpcionRango | null = null;
  
  // Inputs para modo personalizado
  valorDesde: number | null = null;
  valorHasta: number | null = null;

  private onChange: any = () => {};
  private onTouch: any = () => {};

  get textoMostrado(): string {
    if (this.opcionSeleccionada) {
      if (this.opcionSeleccionada.value === 'personalizado' && this.valorDesde !== null && this.valorHasta !== null) {
        return `De ${this.valorDesde.toLocaleString()} a ${this.valorHasta.toLocaleString()}`;
      }
      return this.opcionSeleccionada.label;
    }
    return this.placeholder;
  }

  get mostrarBotonConfirmar(): boolean {
    return this.modoPersonalizado && 
           this.valorDesde !== null && 
           this.valorHasta !== null && 
           this.valorDesde > 0 && 
           this.valorHasta > 0 &&
           this.valorDesde < this.valorHasta;
  }

  toggleDropdown() {
    if (!this.disabled) {
      this.isOpen = !this.isOpen;
    }
  }

  seleccionarOpcion(opcion: OpcionRango) {
    this.opcionSeleccionada = opcion;
    
    if (opcion.value === 'personalizado') {
      this.modoPersonalizado = true;
      this.valorDesde = null;
      this.valorHasta = null;
    } else {
      this.modoPersonalizado = false;
      this.isOpen = false;
      
      const resultado = {
        tipo: opcion.value,
        min: opcion.min,
        max: opcion.max
      };
      
      this.onChange(resultado);
      this.rangoSeleccionado.emit(resultado);
    }
  }

  confirmarRangoPersonalizado() {
    if (this.mostrarBotonConfirmar) {
      const resultado = {
        tipo: 'personalizado',
        min: this.valorDesde,
        max: this.valorHasta
      };
      
      this.isOpen = false;
      this.onChange(resultado);
      this.rangoSeleccionado.emit(resultado);
    }
  }

  volverAOpciones() {
    this.modoPersonalizado = false;
    this.valorDesde = null;
    this.valorHasta = null;
  }

  limpiarSeleccion() {
    this.opcionSeleccionada = null;
    this.modoPersonalizado = false;
    this.valorDesde = null;
    this.valorHasta = null;
    this.onChange(null);
    this.rangoSeleccionado.emit(null);
  }

  // ControlValueAccessor implementation
  writeValue(value: any): void {
    if (value) {
      const opcionEncontrada = this.opciones.find(o => 
        o.value === value.tipo || 
        (o.min === value.min && o.max === value.max)
      );
      
      if (opcionEncontrada) {
        this.opcionSeleccionada = opcionEncontrada;
        
        if (value.tipo === 'personalizado') {
          this.modoPersonalizado = true;
          this.valorDesde = value.min;
          this.valorHasta = value.max;
        }
      }
    } else {
      this.limpiarSeleccion();
    }
  }

  registerOnChange(fn: any): void {
    this.onChange = fn;
  }

  registerOnTouched(fn: any): void {
    this.onTouch = fn;
  }

  setDisabledState(isDisabled: boolean): void {
    this.disabled = isDisabled;
  }
}
