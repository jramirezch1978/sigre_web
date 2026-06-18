import { Component } from '@angular/core';
import { IDoesFilterPassParams, IFilterComp, IFilterParams } from 'ag-grid-community';

@Component({
  selector: 'app-single-select-filter',
  template: `
    <div class="" style="width: 98px; min-width: 98px;">
      <div class="flex flex-col">
        @for(option of options; track option) {
          <div class="flex items-center cursor-pointer hover:bg-gray-100 p-0.5" 
               [class.bg-blue-50]="option === selectedValue"
               (click)="onOptionClick(option)">
            <span class="pl-2 lg:text-xxs xl:text-xs">{{ option }}</span>
          </div>
        }
      </div>
    </div>
  `,
  styles: [`
    .ag-filter-condition {
      padding: 4px 8px;
      cursor: pointer;
      display: flex;
      align-items: center;
    }
    .ag-filter-condition:hover {
      background-color: #f0f0f0;
    }
    .ag-filter-condition.selected {
      background-color: #e3f2fd;
    }
  `],
  standalone: false
})
export class SingleSelectFilterComponent implements IFilterComp {
  private params!: IFilterParams;
  selectedValue: string = 'Soles';
  options: string[] = ['Soles', 'Dolares'];

  agInit(params: IFilterParams): void {
    this.params = params;
  }

  isFilterActive(): boolean {
    return this.selectedValue !== null;
  }

  doesFilterPass(params: IDoesFilterPassParams): boolean {
    const value = this.params.getValue(params.node);
    return value === this.selectedValue;
  }

  getModel() {
    return this.isFilterActive() ? { value: this.selectedValue } : null;
  }

  setModel(model: any): void {
    this.selectedValue = model ? model.value : 'Soles';
  }

  onOptionClick(option: string): void {
    this.selectedValue = option;
    this.params.filterChangedCallback();
  }

  afterGuiAttached(): void {}

  getGui(): HTMLElement {
    return document.createElement('div');
  }
}
