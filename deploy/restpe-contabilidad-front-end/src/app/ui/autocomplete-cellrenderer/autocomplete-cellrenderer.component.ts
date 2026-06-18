import { Component } from '@angular/core';
import { ICellEditorAngularComp } from 'ag-grid-angular';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-autocomplete-cellrenderer',
  templateUrl: './autocomplete-cellrenderer.component.html',
  styleUrls: ['./autocomplete-cellrenderer.component.scss'],
  standalone: false,
})
export class AutocompleteCellrendererComponent implements ICellEditorAngularComp {
  // Font Awesome Icons
  farSearch = faSearch;



  params: any;
  items: any[] = [];
  filteredItems: any[] = [];

  searchText = '';
  value: any;

  showPopover = false;
  popoverEvent: any;

  private searchTimeout: any;
  private readonly DEBOUNCE_MS = 300;

  agInit(params: any): void {
    this.params = params;
    this.items = params.items || params.colDef.items || [];

    this.value = params.value;

    // Mostrar texto inicial si viene valor
    if (this.value) {
      const item = this.items.find(i => i.id === this.value);
      if (item) this.searchText = item.nombre;
    }
  }

  onInputClick(ev: any) {
    this.popoverEvent = ev;

    // Limpiar texto y cerrar popover
    this.searchText = '';
    this.filteredItems = [];
    this.showPopover = false;
  }
  /** BÚSQUEDA CON DEBOUNCE + abrir popover solo cuando termine */
  onSearch(event: any) {
    const q = (event.detail?.value ?? '').toString().trim();
    this.searchText = q;

    // Si no hay texto → cerrar todo
    if (q === '') {
      this.closePopover();
      return;
    }

    // Cancelar debounce anterior
    if (this.searchTimeout) {
      clearTimeout(this.searchTimeout);
    }

    // Nuevo debounce
    this.searchTimeout = setTimeout(() => {
      const query = q.toLowerCase();

      // Ejecutar filtrado
      this.filteredItems = this.items.filter(item =>
        (item.nombre || '').toLowerCase().includes(query)
      );

      // Mostrar popover SOLO si hay resultados
      this.showPopover =
        this.filteredItems.length > 0 &&
        this.searchText.trim().length > 0;

      this.searchTimeout = null;
    }, this.DEBOUNCE_MS);
  }

  selectItem(item: any) {
    this.value = item.id;
    this.searchText = item.nombre;

    this.closePopover();

    setTimeout(() => this.params.stopEditing(), 10);
  }

  closePopover() {
    if (this.searchTimeout) {
      clearTimeout(this.searchTimeout);
    }
    this.showPopover = false;
    this.filteredItems = [];
  }

  onPopoverDismiss() {
    this.closePopover();
  }

  getValue() {
    return this.value;
  }
}
