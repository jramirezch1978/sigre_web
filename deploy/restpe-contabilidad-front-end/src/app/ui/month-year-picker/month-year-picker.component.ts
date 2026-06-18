import { Component, EventEmitter, Input, Output, OnInit } from '@angular/core';

// Font Awesome Icons
import { faChevronDown, faChevronLeft, faChevronRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-month-year-picker',
  templateUrl: './month-year-picker.component.html',
  styleUrls: ['./month-year-picker.component.scss'],
  standalone: false
})
export class MonthYearPickerComponent implements OnInit {
  // Font Awesome Icons
  fasChevronDown = faChevronDown;
  fasChevronLeft = faChevronLeft;
  fasChevronRight = faChevronRight;


  @Input() selectedMonth: number | null = null;
  @Input() selectedYear: number | null = null;
  @Input() placeholder: string = 'Perido contable';
  @Input() disabled: boolean = false;
  @Input() position: 'left' | 'center' | 'right' | 'top-left' = 'left';
  @Output() monthYearChange = new EventEmitter<{month: number, year: number}>();

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
    this.selectedMonth = month;
    this.emitChange();
  }

  previousYear() {
    this.currentYear--;
  }

  nextYear() {
    this.currentYear++;
  }

  selectYear() {
    this.selectedYear = this.currentYear;
    this.emitChange();
    this.closeDropdown();
  }

  emitChange() {
    if (this.selectedMonth !== null && this.selectedYear !== null) {
      this.monthYearChange.emit({
        month: this.selectedMonth,
        year: this.selectedYear
      });
    }
  }

  getDisplayText(): string {
    if (this.selectedMonth && this.selectedYear) {
      const mes = this.selectedMonth.toString().padStart(2, '0');
      return `${this.selectedYear}${mes}`;
    }
    return this.placeholder;
  }

}
