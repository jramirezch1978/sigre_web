import { Component, EventEmitter, Input, Output, OnInit, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';

// Font Awesome Icons
import { faChevronDown, faChevronUp } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-fitro-autocomplete',
  templateUrl: './fitro-autocomplete.component.html',
  styleUrls: ['./fitro-autocomplete.component.scss'],
  standalone: false,
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      useExisting: forwardRef(() => FitroAutocompleteComponent),
      multi: true
    }
  ]
})
export class FitroAutocompleteComponent  implements OnInit {
  // Font Awesome Icons
  fasChevronDown = faChevronDown;
  fasChevronUp = faChevronUp;


  @Input() placeholder: string = 'Buscar...';
  @Input() items: any[] = []; 
  @Input() displayKey: string = 'nombre'; 
  @Input() valueKey: string = 'id'; 
  @Input() width: string = 'w-full'; 
  
  @Output() itemSelected = new EventEmitter<any>();
  
  @Input() searchText: string = '';
  filteredItems: any[] = [];
  showDropdown: boolean = false;
  selectedItem: any = null;
  
  private onChange: any = () => {};
  private onTouch: any = () => {};

  ngOnInit() {
    
  }
  select(){
    this.showDropdown= !this.showDropdown;
  }

  filtroSeleccionado(item: any) {
    this.selectedItem = item;
    this.searchText = this.getDisplayValue(item);
    this.showDropdown = false;
    this.itemSelected.emit(item);
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

}

