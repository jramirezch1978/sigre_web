import { Component, EventEmitter, Input, Output, OnInit, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

// Font Awesome Icons
import { faChevronDown, faChevronUp } from '@fortawesome/pro-solid-svg-icons';
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
// Font Awesome Icons



@Component({
  selector: 'app-checbox-autocomplete',
  templateUrl: './checbox-autocomplete.component.html',
  styleUrls: ['./checbox-autocomplete.component.scss'],
  standalone: false,
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      useExisting: forwardRef(() => ChecboxAutocompleteComponent),
      multi: true
    }
  ]
})
export class ChecboxAutocompleteComponent  implements OnInit, ControlValueAccessor {
  // Font Awesome Icons
  fasChevronDown = faChevronDown;
  fasChevronUp = faChevronUp;
  farSearch = faSearch;


  @Input() placeholder: string = 'Seleccionar...';
  @Input() items: any[] = [];
  @Input() displayKey: string = 'nombre';
  @Input() valueKey: string = 'id';
  @Input() width: string = 'w-full';
  @Input() buttonText: string = 'Aplicar';
  @Input() searchPlaceholder: string = 'Buscar...';
  
  @Output() itemsSelected = new EventEmitter<any[]>();
  @Output() buttonClicked = new EventEmitter<any[]>();
  
  searchText: string = '';
  filteredItems: any[] = [];
  showDropdown: boolean = false;
  selectedItems: any[] = [];
  displayText: string = '';
  
  private onChange: any = () => {};
  private onTouch: any = () => {};

  ngOnInit() {
    this.filteredItems = [...this.items];
  }

  toggleDropdown() {
    this.showDropdown = !this.showDropdown;
  }

  onSearchChange() {
    if (!this.searchText) {
      this.filteredItems = [...this.items];
    } else {
      this.filteredItems = this.items.filter(item =>
        this.getDisplayValue(item).toLowerCase().includes(this.searchText.toLowerCase())
      );
    }
  }

  toggleItem(item: any, event: Event) {
    event.stopPropagation();
    const index = this.selectedItems.findIndex(i => i[this.valueKey] === item[this.valueKey]);
    
    if (index > -1) {
      this.selectedItems.splice(index, 1);
    } else {
      this.selectedItems.push(item);
    }
    
    this.updateDisplayText();
    this.itemsSelected.emit(this.selectedItems);
  }

  isSelected(item: any): boolean {
    return this.selectedItems.some(i => i[this.valueKey] === item[this.valueKey]);
  }

  onButtonClick() {
    this.buttonClicked.emit(this.selectedItems);
    this.showDropdown = false;
  }

  updateDisplayText() {
    if (this.selectedItems.length === 0) {
      this.displayText = '';
    } else if (this.selectedItems.length === 1) {
      this.displayText = this.getDisplayValue(this.selectedItems[0]);
    } else {
      this.displayText = `${this.selectedItems.length} seleccionados`;
    }
  }

  getDisplayValue(item: any): string {
    if (!item) return '';
    
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
      this.selectedItems = Array.isArray(value) ? value : [value];
      this.updateDisplayText();
    }
  }

  registerOnChange(fn: any): void {
    this.onChange = fn;
  }

  registerOnTouched(fn: any): void {
    this.onTouch = fn;
  }

}
