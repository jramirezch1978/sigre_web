import { Component, Input, Output, EventEmitter, forwardRef, OnInit, OnChanges, SimpleChanges, ElementRef, HostListener } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

// Font Awesome Icons
import { faEye, faSearch, faXmark } from '@fortawesome/pro-regular-svg-icons';
import { faChevronDown, faCircle, faPlusCircle } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-autocomplete-multi',
  templateUrl: './autocomplete-multi.component.html',
  styleUrls: ['./autocomplete-multi.component.scss'],
  standalone: false,
  providers: [{
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => AutocompleteMultiComponent),
    multi: true
  }]
})
export class AutocompleteMultiComponent  implements OnInit, OnChanges, ControlValueAccessor {
  // Font Awesome Icons
  farEye = faEye;
  farSearch = faSearch;
  farXmark = faXmark;
  fasChevronDown = faChevronDown;
  fasCircle = faCircle;
  fasPlusCircle = faPlusCircle;



  @Input() items: any[] = [];
  @Input() displayKey: string = 'nombre';
  @Input() valueKey: string = 'id';
  @Input() buttonCrear: boolean = false;
  @Input() placeholder: string = 'Seleccionar...';
  @Input() inputWidth: string = '160px';  @Input() mostrarDetalle: boolean = true;
  @Input() modoModal: boolean = false;
  @Input() mostrarBuscador: boolean = true;
  @Input() disabled: boolean = false;
  @Input() mostrarOjo: boolean = true;
  

  @Output() changed = new EventEmitter<any[]>();
  @Output() buttonClicked = new EventEmitter<any[]>();
  @Output() eyeClick = new EventEmitter<Event>();

  selectedItems: any[] = []; // IDs confirmados
  tempSelectedItems: any[] = []; // IDs temporales mientras el dropdown está abierto
  filteredItems: any[] = [];

  searchText: string = '';
  showDropdown = false;

  private onChange = (v: any) => {};
  private onTouch = () => {};

  constructor(private eRef: ElementRef){

  }

  ngOnInit() {
    this.filteredItems = [...this.items];
  }

  ngOnChanges(changes: SimpleChanges) {
    if (changes['items'] && !changes['items'].firstChange) {
      // Cuando items cambia (después de la inicialización), actualizar filteredItems
      this.filteredItems = [...this.items];
      console.log('ngOnChanges: items actualizado. Nuevo contenido:', this.filteredItems);
    }
  }

  // @HostListener('document:click', ['$event'])
  // clickOutside(event: Event) {
  //   if (!this.eRef.nativeElement.contains(event.target)) {
  //     // Si se da clic fuera, descartar cambios temporales
  //     if (this.showDropdown) {
  //       this.tempSelectedItems = [...this.selectedItems]; // Restaurar a lo confirmado
  //     }
  //     this.showDropdown = false;
  //   }
  // }

  onButtonClick() {
    this.buttonClicked.emit(this.selectedItems);
    this.showDropdown = false;
  }
  cancelar(){
    this.showDropdown = false;
  }

  toggleDropdown() {
    if (this.disabled) return;
    if (!this.showDropdown) {
      // Al abrir: copiar los confirmados a temporales para que se puedan editar
      this.tempSelectedItems = [...this.selectedItems];
    } else {
      // Al cerrar: confirmar los cambios
      this.selectedItems = [...this.tempSelectedItems];
      this.onChange(this.selectedItems);
      this.changed.emit(this.selectedItems);
    }
    this.showDropdown = !this.showDropdown;
  }

  filterItems() {
    const q = this.searchText.toLowerCase();
    this.filteredItems = this.items.filter(i =>
      this.getDisplayValue(i).toLowerCase().includes(q)
    );
  }

  getDisplayValue(item: any) {
    return item ? item[this.displayKey] : '';
  }

  getItem(id: any) {
    return this.items.find(i => i[this.valueKey] === id);
  }

  isSelected(id: any) {
    return this.tempSelectedItems.includes(id);
  }

  toggleItem(item: any) {
    const id = item[this.valueKey];

    if (this.tempSelectedItems.includes(id)) {
      this.tempSelectedItems = this.tempSelectedItems.filter(s => s !== id);
    } else {
      this.tempSelectedItems.push(id);
    }

    // NO emitir ni actualizar onChange hasta que se confirme
  }

  clearSelection(event: Event) {
    if (this.disabled) return;
    event.stopPropagation();
    this.selectedItems = [];
    this.tempSelectedItems = [];
    this.onChange([]);
    this.changed.emit([]);
  }

  verDetalle(event: Event) {
    event.stopPropagation();
  }
  abrirModal(event: Event) {
    event.stopPropagation();
    this.eyeClick.emit(event);
  }

  writeValue(value: any): void {
    this.selectedItems = Array.isArray(value) ? value : [];
  }

  seleccionarTodo(){
    // Agregar todos los IDs de los elementos filtrados a la selección temporal
    const todosLosIds = this.filteredItems.map(item => item[this.valueKey]);
    
    todosLosIds.forEach(id => {
      if (!this.tempSelectedItems.includes(id)) {
        this.tempSelectedItems.push(id);
      }
    });

    // Notificar cambios al formulario reactivo solo cuando se confirme
  }

  deseleccionarTodo(){
    // Limpiar todos los items seleccionados temporalmente
    this.tempSelectedItems = [];
    // No notificar hasta confirmar
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

  getDisplayText(): string {
    if (this.selectedItems.length === 0) {
      return this.placeholder;
    }
    
    if (this.selectedItems.length === 1) {
      // Mostrar el nombre del único item seleccionado
      const item = this.getItem(this.selectedItems[0]);
      return item ? this.getDisplayValue(item) : this.placeholder;
    }
    
    // Si hay más de uno, mostrar la cantidad
    return `${this.selectedItems.length} seleccionados`;
  }
}

