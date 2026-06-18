import { Component, EventEmitter, Input, Output, OnInit, OnChanges, SimpleChanges, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faTimes } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-autocomplete',
  templateUrl: './autocomplete.component.html',
  styleUrls: ['./autocomplete.component.scss'],
  standalone: false,
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      useExisting: forwardRef(() => AutocompleteComponent),
      multi: true
    }
  ]
})
export class AutocompleteComponent implements OnInit, OnChanges, ControlValueAccessor {
  // Font Awesome Icons
  farSearch = faSearch;
  fasTimes = faTimes;


  @Input() placeholder: string = 'Buscar...';
  @Input() items: any[] = []; // Array de items a filtrar
  @Input() displayKey: string = 'nombre'; // Key para mostrar en la lista (ej: 'nombre', 'descripcion')
  @Input() valueKey: string = 'id'; // Key del valor que se guardará
  @Input() width: string = 'w-full'; // Ancho del input
  @Input() disabled: boolean = false;
  @Input() height: string = '28px';
  @Input() pseudo: boolean = false;
  @Input() tipo: String = 'text';
  
  @Output() itemSelected = new EventEmitter<any>();
  @Output() searchChanged = new EventEmitter<string>();
  
  searchText: string = '';
  filteredItems: any[] = [];
  showDropdown: boolean = false;
  selectedItem: any = null;
  private pendingValue: any = null;
  
  private onChange: any = () => {};
  private onTouch: any = () => {};

  ngOnInit() {
    this.filteredItems = this.items;
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['items'] && this.items) {
      this.filteredItems = this.items;
      // Re-resolver valor pendiente cuando llegan nuevos items
      if (this.pendingValue) {
        const item = this.items.find(i => i[this.valueKey] === this.pendingValue);
        if (item) {
          this.selectedItem = item;
          this.searchText = this.getDisplayValue(item);
          this.pendingValue = null;
        }
      }

      if (this.searchText?.trim()) {
        const query = this.searchText.toLowerCase();
        this.filteredItems = this.items.filter(item => {
          const displayValue = this.getDisplayValue(item)?.toLowerCase() || '';
          return displayValue.includes(query);
        });
        this.showDropdown = true;
      }
    }
  }

  // onSearch(event: any) {
  //   const query = event.target.value.toLowerCase();
  //   this.searchText = query;
    
  //   if (query.length === 0) {
  //     this.filteredItems = this.items;
  //     this.showDropdown = false;
  //     return;
  //   }
    
  //   this.filteredItems = this.items.filter(item => {
  //     const displayValue = this.getDisplayValue(item).toLowerCase();
  //     return displayValue.includes(query);
  //   });
    
  //   this.showDropdown = this.filteredItems.length > 0;
  // }

  // NORRMALIZA A MINUSCULAS POR INTERNO 

  onSearch(event: any) {
    const value = event?.detail?.value ?? event?.target?.value ?? '';
    const query = value?.toLowerCase() || '';  

    this.searchText = value;
    this.searchChanged.emit(value);

    if (query.length === 0) {
      this.filteredItems = this.items;
      this.showDropdown = false;
      return;
    }

    this.filteredItems = this.items.filter(item => {
      const displayValue = this.getDisplayValue(item)?.toLowerCase() || '';
      return displayValue.includes(query);
    });

    this.showDropdown = true;
  }

  onFocus() {
    if (this.searchText.length > 0) {
      this.showDropdown = true;
    }
  }

  onBlur() {
    // Delay para permitir click en el dropdown
    setTimeout(() => {
      this.showDropdown = false;
    }, 200);
  }

  selectItem(item: any) {
    this.selectedItem = item;
    this.showDropdown = false;
    
    const value = item[this.valueKey];
    this.onChange(value);
    this.onTouch();

    // Mostrar el valor seleccionado en el campo de búsqueda
    this.searchText = this.getDisplayValue(item);
    this.filteredItems = this.items;

    // Emitir al final para que el padre pueda llamar clearSelection() sin que se sobreescriba
    this.itemSelected.emit(item);
  }

  clearSelection() {
    this.selectedItem = null;
    this.searchText = '';
    this.filteredItems = this.items;
    this.showDropdown = false;
    this.onChange(null);
    this.onTouch();
  }

  getDisplayValue(item: any): string {
    if (!item) return '';
    
    // Si displayKey contiene un punto, navegar por el objeto
    if (this.displayKey.includes('.')) {
      const keys = this.displayKey.split('.');
      let value = item;
      for (const key of keys) {
        value = value[key];
        if (!value) return '';
      }
      return value;
    }
    
    return item[this.displayKey] || '';
  }

  // ControlValueAccessor methods
  writeValue(value: any): void {
    if (value) {
      const item = this.items.find(i => i[this.valueKey] === value);
      if (item) {
        this.selectedItem = item;
        this.searchText = this.getDisplayValue(item);
        this.pendingValue = null;
      } else {
        // Items aún no disponibles, guardar para resolver en ngOnChanges
        this.pendingValue = value;
      }
    } else {
      this.pendingValue = null;
      this.clearSelection();
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
