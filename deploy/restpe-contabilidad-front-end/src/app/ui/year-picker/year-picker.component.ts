import { Component, EventEmitter, Input, Output, OnInit } from '@angular/core';

// Font Awesome Icons
import { faChevronDown, faChevronLeft, faChevronRight } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-year-picker',
  templateUrl: './year-picker.component.html',
  styleUrls: ['./year-picker.component.scss'],
  standalone: false
})
export class YearPickerComponent implements OnInit {
  // Font Awesome Icons
  fasChevronDown = faChevronDown;
  fasChevronLeft = faChevronLeft;
  fasChevronRight = faChevronRight;


  @Input() selectedYear: number | null = null;
  @Input() placeholder: string = 'Seleccionar año';
  @Input() disabled: boolean = false;
  @Input() position: 'left' | 'center' | 'right' | 'top-left' = 'left';
  @Output() yearChange = new EventEmitter<number>();

  showDropdown: boolean = false;
  currentDecadeStart: number = Math.floor(new Date().getFullYear() / 10) * 10;
  
  years: number[] = [];

  ngOnInit() {
    this.generateYears();
  }

  generateYears() {
    this.years = [];
    for (let i = 0; i < 12; i++) {
      this.years.push(this.currentDecadeStart + i);
    }
  }

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

  selectYear(year: number) {
    this.selectedYear = year;
    this.yearChange.emit(year);
    this.closeDropdown();
  }

  previousDecade() {
    this.currentDecadeStart -= 10;
    this.generateYears();
  }

  nextDecade() {
    this.currentDecadeStart += 10;
    this.generateYears();
  }

  getDisplayText(): string {
    if (this.selectedYear) {
      return `${this.selectedYear}`;
    }
    return this.placeholder;
  }
}
