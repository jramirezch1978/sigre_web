import { Component, EventEmitter, Input, Output, OnInit } from '@angular/core';

// Font Awesome Icons
import { faChevronDown, faChevronLeft, faChevronRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-quarter-picker',
  templateUrl: './quarter-picker.component.html',
  styleUrls: ['./quarter-picker.component.scss'],
  standalone: false
})
export class QuarterPickerComponent implements OnInit {
  // Font Awesome Icons
  fasChevronDown = faChevronDown;
  fasChevronLeft = faChevronLeft;
  fasChevronRight = faChevronRight;


  @Input() selectedStartMonth: number | null = null;
  @Input() selectedYear: number | null = null;
  @Input() placeholder: string = 'Seleccionar trimestre';
  @Input() disabled: boolean = false;
  @Input() position: 'left' | 'center' | 'right' | 'top-left' = 'left';
  @Output() quarterYearChange = new EventEmitter<{startMonth: number, endMonth: number, year: number}>();

  showDropdown: boolean = false;
  currentYear: number = new Date().getFullYear();

  months = [
    { value: 1, label: 'Enero', abbr: 'Ene' },
    { value: 2, label: 'Febrero', abbr: 'Feb' },
    { value: 3, label: 'Marzo', abbr: 'Mar' },
    { value: 4, label: 'Abril', abbr: 'Abr' },
    { value: 5, label: 'Mayo', abbr: 'May' },
    { value: 6, label: 'Junio', abbr: 'Jun' },
    { value: 7, label: 'Julio', abbr: 'Jul' },
    { value: 8, label: 'Agosto', abbr: 'Ago' },
    { value: 9, label: 'Septiembre', abbr: 'Set' },
    { value: 10, label: 'Octubre', abbr: 'Oct' },
    { value: 11, label: 'Noviembre', abbr: 'Nov' },
    { value: 12, label: 'Diciembre', abbr: 'Dic' }
  ];

  ngOnInit() {}

  toggleDropdown() {
    if(this.disabled == true){
      return;
    }else{
      this.showDropdown = !this.showDropdown;
    }
  }

  closeDropdown() {
    this.showDropdown = false;
  }

  selectMonth(month: number) {
    this.selectedStartMonth = month;
    this.selectedYear = this.currentYear;
    const endMonth = month + 2 > 12 ? month + 2 - 12 : month + 2;
    this.quarterYearChange.emit({
      startMonth: month,
      endMonth: endMonth,
      year: this.currentYear
    });
    this.closeDropdown();
  }

  previousYear() {
    this.currentYear--;
  }

  nextYear() {
    this.currentYear++;
  }

  isMonthSelected(month: number): boolean {
    if (!this.selectedStartMonth || !this.selectedYear || this.selectedYear !== this.currentYear) {
      return false;
    }
    // Marcar el mes seleccionado y los 2 siguientes
    const endMonth = this.selectedStartMonth + 2;
    if (endMonth <= 12) {
      return month >= this.selectedStartMonth && month <= endMonth;
    } else {
      // Si cruza el año (ej: Nov, Dic, Ene)
      return month >= this.selectedStartMonth || month <= (endMonth - 12);
    }
  }

  getDisplayText(): string {
    if (this.selectedStartMonth && this.selectedYear) {
      const startMonthObj = this.months.find(m => m.value === this.selectedStartMonth);
      const endMonth = this.selectedStartMonth + 2 > 12 ? this.selectedStartMonth + 2 - 12 : this.selectedStartMonth + 2;
      const endMonthObj = this.months.find(m => m.value === endMonth);
      return `${startMonthObj?.abbr}-${endMonthObj?.abbr} ${this.selectedYear}`;
    }
    return this.placeholder;
  }
}
