import { Component, OnInit } from '@angular/core';
import { ICellEditorAngularComp } from 'ag-grid-angular';
import {
  addMonths,
  subMonths,
  startOfMonth,
  endOfMonth,
  eachDayOfInterval,
  isSameDay,
  setYear,
  format
} from 'date-fns';
import { es } from 'date-fns/locale';
import { faChevronLeft, faChevronRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-calendar-cell-editor',
  templateUrl: './calendar-cell-editor.component.html',
  styleUrls: ['./calendar-cell-editor.component.scss'],
  standalone: false,
})
export class CalendarCellEditorComponent implements ICellEditorAngularComp, OnInit {
  fasChevronLeft  = faChevronLeft;
  fasChevronRight = faChevronRight;

  params: any;
  selectedDate: Date | undefined;
  currentDate: Date = new Date();
  calendar: (Date | null)[][] = [];
  weekDays = ['D', 'L', 'M', 'M', 'J', 'V', 'S'];
  locale = es;
  showYearSelection = false;
  availableYears: number[] = [];

  agInit(params: any): void {
    this.params = params;
    const val = params.value;
    if (val instanceof Date) {
      this.selectedDate = val;
      this.currentDate = new Date(val);
    } else if (typeof val === 'string' && val) {
      const p = val.split('/');
      if (p.length === 3) {
        this.selectedDate = new Date(+p[2], +p[1] - 1, +p[0]);
        this.currentDate = new Date(this.selectedDate);
      }
    }
  }

  ngOnInit(): void {
    const cur = new Date().getFullYear();
    this.availableYears = Array.from({ length: 51 }, (_, i) => cur - 25 + i);
    this.generateCalendar();
  }

  getValue(): any {
    return this.selectedDate ?? this.params.value;
  }

  isPopup(): boolean { return true; }

  generateCalendar(): void {
    const start = startOfMonth(this.currentDate);
    const end   = endOfMonth(this.currentDate);
    const days  = eachDayOfInterval({ start, end });
    this.calendar = [];
    let week: (Date | null)[] = Array(start.getDay()).fill(null);
    for (const day of days) {
      week.push(day);
      if (week.length === 7) { this.calendar.push(week); week = []; }
    }
    if (week.length) {
      while (week.length < 7) week.push(null);
      this.calendar.push(week);
    }
  }

  selectDate(day: Date | null): void {
    if (!day) return;
    this.selectedDate = day;
    setTimeout(() => this.params.stopEditing(), 100);
  }

  prevMonth(): void { this.currentDate = subMonths(this.currentDate, 1); this.generateCalendar(); }
  nextMonth(): void { this.currentDate = addMonths(this.currentDate, 1); this.generateCalendar(); }

  toggleYearSelection(): void { this.showYearSelection = !this.showYearSelection; }

  selectYear(year: number): void {
    this.currentDate = setYear(this.currentDate, year);
    this.showYearSelection = false;
    this.generateCalendar();
  }

  isCurrentYear(year: number): boolean {
    return year === this.currentDate.getFullYear();
  }

  getFormattedMonthYear(date: Date): string {
    const text = format(date, 'MMMM yyyy', { locale: this.locale });
    return text.replace(/\b\w/g, c => c.toUpperCase());
  }

  getDayClasses(day: Date | null): string {
    if (!day) return 'p-0.5 text-center text-gray-400';
    let classes = 'p-1 text-xxs font-semibold m-0.5 h-6 flex justify-center items-center text-center cursor-pointer hover:bg-primary-5 rounded-full ';
    if (this.selectedDate && isSameDay(day, this.selectedDate)) {
      classes += '!bg-primary text-white';
    }
    return classes;
  }
}
