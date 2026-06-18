import {
  ChangeDetectionStrategy,
  ChangeDetectorRef,
  Component,
  ElementRef,
  EventEmitter,
  HostListener,
  Input,
  OnInit,
  OnChanges,
  SimpleChanges,
  Output,
  ViewChild
} from '@angular/core';

import {
  format,
  addMonths,
  subMonths,
  startOfMonth,
  endOfMonth,
  eachDayOfInterval,
  isSameDay,
  isWithinInterval,
  isBefore,
  isAfter,
  setYear
} from 'date-fns';
import { es } from 'date-fns/locale';

// Font Awesome Icons
import { faChevronLeft, faChevronRight, faChevronDown, faChevronUp } from '@fortawesome/pro-solid-svg-icons';



@Component({
    selector: 'app-base-calendar-new',
    templateUrl: './base-calendar.component.html',
    styleUrls: ['./base-calendar.component.scss'],
    standalone: false,
    // OnPush: el calendario solo se re-evalúa cuando cambian sus inputs o se
    // interactúa con él, evitando recalcular las celdas en cada ciclo global de
    // detección de cambios de la página (causa de lag en pantallas pesadas).
    changeDetection: ChangeDetectionStrategy.OnPush
})
export class BaseCalendarNewComponent implements OnInit, OnChanges {
  // Font Awesome Icons
  fasChevronLeft = faChevronLeft;
  fasChevronRight = faChevronRight;
  fasChevronDown = faChevronDown;
  fasChevronUp = faChevronUp;

  private static activeCalendar: BaseCalendarNewComponent | null = null;

  @Input() mode: 'single' | 'range' = 'single';
  @Input() initialDate?: Date | any;
  @Input() initialStartDate?: Date | any;
  @Input() initialEndDate?: Date | any;
  @Input() position: 'left' | 'center' | 'right' | 'top-left' = 'center';
  @Input() minDate?: Date;
  @Input() maxDate?: Date;
  // Si true, bloquea la selección de días anteriores a la fecha actual
  @Input() disablePastDates: boolean = true;
  @Input() full?: boolean = false;
  @Input() calendarHeight?: string = '44px';
  @Input() sameDayRange: boolean = false;
  @Input() disabled: boolean = false;
  @Input() initInNull: boolean = true;
  @Input() placeholder: string = '';
  // Si true y mode='range', muestra dos calendarios lado a lado

  @Output() dateSelected = new EventEmitter<Date>();
  @Output() dateRangeSelected = new EventEmitter<{ start: Date; end: Date }>();

  @ViewChild('calendarContainer') calendarContainer!: ElementRef;

  isCalendarVisible = false;
  currentDate: Date = new Date();
  calendar: (Date | null)[][] = [];
  nextMonthCalendar: (Date | null)[][] = [];
  weekDays: string[] = ['D', 'L', 'M', 'M', 'J', 'V', 'S'];
  selectedDate?: Date;
  rangeStart?: Date;
  rangeEnd?: Date;
  errorMessage: string = '';
  showYearSelection = false;
  availableYears: number[] = [];
  locale = es; // Locale español para date-fns

  constructor(private elementRef: ElementRef, private cdr: ChangeDetectorRef) {
    const currentYear = new Date().getFullYear();
    this.availableYears = Array.from({ length: 51 }, (_, i) => currentYear - 50 + i);
  }

  ngOnInit() {
    this.initializeSelection();
    this.generateCalendar();
  }

  /**
   * Convierte un valor (Date | string ISO | string dd/mm/yyyy) a Date válido.
   * Si no se puede parsear, devuelve la fecha actual para evitar Invalid Date,
   * que provoca excepciones en date-fns (eachDayOfInterval) durante el render.
   */
  private toValidDate(value: any): Date {
    if (value instanceof Date) {
      return isNaN(value.getTime()) ? new Date() : value;
    }
    if (typeof value === 'string') {
      const ddmmyyyy = value.match(/^(\d{2})\/(\d{2})\/(\d{4})$/);
      if (ddmmyyyy) {
        const [, d, m, y] = ddmmyyyy;
        const parsed = new Date(Number(y), Number(m) - 1, Number(d));
        return isNaN(parsed.getTime()) ? new Date() : parsed;
      }
      const parsed = new Date(value);
      return isNaN(parsed.getTime()) ? new Date() : parsed;
    }
    return new Date();
  }

  ngOnChanges(changes: SimpleChanges) {
    // Detectar cambios en initialDate para modo single
    if (changes['initialDate'] && !changes['initialDate'].firstChange) {
      if (this.mode === 'single') {
        if (this.initialDate) {
          this.selectedDate = this.toValidDate(this.initialDate);
          this.currentDate = this.toValidDate(this.initialDate);
          this.generateCalendar();
        } else {
          // Limpiar la selección cuando initialDate es undefined/null
          this.selectedDate = undefined;
          this.currentDate = new Date();
          this.generateCalendar();
        }
      }
    }
    
    // Detectar cambios en initialStartDate para modo single
    if (changes['initialStartDate'] && !changes['initialStartDate'].firstChange) {
      if (this.mode === 'single') {
        if (this.initialStartDate) {
          this.selectedDate = this.toValidDate(this.initialStartDate);
          this.currentDate = this.toValidDate(this.initialStartDate);
          this.generateCalendar();
        } else {
          // Limpiar la selección cuando initialStartDate es undefined/null
          this.selectedDate = undefined;
          this.currentDate = new Date();
          this.generateCalendar();
        }
      }
    }

    // Detectar cambios en initialStartDate o initialEndDate para modo range
    if ((changes['initialStartDate'] && !changes['initialStartDate'].firstChange) ||
        (changes['initialEndDate'] && !changes['initialEndDate'].firstChange)) {
      if (this.mode === 'range') {
        this.rangeStart = this.initialStartDate ? this.toValidDate(this.initialStartDate) : undefined;
        this.rangeEnd = this.initialEndDate ? this.toValidDate(this.initialEndDate) : undefined;
        if (this.rangeStart) {
          this.currentDate = this.rangeStart;
        }
        this.generateCalendar();
      }
    }
  }

  toggleCalendar() {
    // Si este calendario se va a abrir
    if (!this.isCalendarVisible) {
      // Cerrar cualquier otro calendario que esté abierto
      if (BaseCalendarNewComponent.activeCalendar && BaseCalendarNewComponent.activeCalendar !== this) {
        const otro = BaseCalendarNewComponent.activeCalendar;
        otro.isCalendarVisible = false;
        otro.showYearSelection = false;
        // Bajo OnPush hay que marcar el otro calendario para que refleje el cierre.
        otro.cdr.markForCheck();
      }
      // Marcar este como el calendario activo
      BaseCalendarNewComponent.activeCalendar = this;
    } else {
      // Si se está cerrando, limpiar la referencia
      BaseCalendarNewComponent.activeCalendar = null;
    }
    
    this.isCalendarVisible = !this.isCalendarVisible;
  }

  @HostListener('document:click', ['$event'])
  onClickOutside(event: MouseEvent) {
    if (!this.elementRef.nativeElement.contains(event.target)) {
      this.isCalendarVisible = false;
      this.showYearSelection = false;
    }
  }

 initializeSelection() {
  const today = new Date();

  if (this.mode === 'single') {
    // Si initInNull es true (por defecto), no inicializar selectedDate
    if (!this.initInNull) {
      this.selectedDate = this.initialDate ?? today;
    } else {
      this.selectedDate = this.initialDate ?? undefined;
    }
  } else if (this.mode === 'range') {
    // Si initInNull es true y hay placeholder, no inicializar fechas
    if (this.initInNull && this.placeholder) {
      this.rangeStart = this.initialStartDate ?? undefined;
      this.rangeEnd = this.initialEndDate ?? undefined;
    } else if (this.sameDayRange) {
      this.rangeStart = today;
      this.rangeEnd = today;
    } else {
      const dateInit = new Date(today.getFullYear(), today.getMonth(), 1);
      this.rangeStart = this.initialStartDate ?? dateInit;
      this.rangeEnd = this.initialEndDate ?? today;
    }
  }
}

  initializeSelectionWithDate(dateStart: Date, dateEnd: Date) {
    this.initialStartDate = dateStart;
    this.initialEndDate = dateEnd;
    this.rangeStart = dateStart;
    this.rangeEnd = dateEnd;
  }

  generateCalendar() {
    // Evitar Invalid Date: eachDayOfInterval lanza excepción con fechas inválidas.
    if (!(this.currentDate instanceof Date) || isNaN(this.currentDate.getTime())) {
      this.currentDate = new Date();
    }
    const start = startOfMonth(this.currentDate);
    const end = endOfMonth(this.currentDate);
    const days = eachDayOfInterval({ start, end });

    this.calendar = [];
    let week: (Date | null)[] = [];

    const firstDay = start.getDay();
    for (let i = 0; i < firstDay; i++) {
      week.push(null);
    }

    days.forEach(day => {
      week.push(day);
      if (week.length === 7) {
        this.calendar.push(week);
        week = [];
      }
    });

    if (week.length > 0) {
      while (week.length < 7) {
        week.push(null);
      }
      this.calendar.push(week);
    }

    // Generate next month calendar if mode is range
    if (this.mode === 'range') {
      this.generateNextMonthCalendar();
    }
  }

  generateNextMonthCalendar() {
    const nextMonth = this.getNextMonth();
    const start = startOfMonth(nextMonth);
    const end = endOfMonth(nextMonth);
    const days = eachDayOfInterval({ start, end });

    this.nextMonthCalendar = [];
    let week: (Date | null)[] = [];

    const firstDay = start.getDay();
    for (let i = 0; i < firstDay; i++) {
      week.push(null);
    }

    days.forEach(day => {
      week.push(day);
      if (week.length === 7) {
        this.nextMonthCalendar.push(week);
        week = [];
      }
    });

    if (week.length > 0) {
      while (week.length < 7) {
        week.push(null);
      }
      this.nextMonthCalendar.push(week);
    }
  }

  getNextMonth(): Date {
    return addMonths(this.currentDate, 1);
  }

  selectDate(date: Date | null) {
    if (!date || this.isDisabled(date)) return;

    if (this.mode === 'single') {
      this.selectedDate = date;
      this.dateSelected.emit(date);
      this.isCalendarVisible = false;
    } else {
      if (!this.rangeStart || (this.rangeStart && this.rangeEnd)) {
        // Iniciar nueva selección
        this.rangeStart = date;
        this.rangeEnd = undefined;
        this.errorMessage = '';
        this.isCalendarVisible = true;
      } else {
        // Ya hay un rangeStart, ahora seleccionar rangeEnd
        if (isBefore(date, this.rangeStart)) {
          // Si la fecha seleccionada es anterior al inicio, intercambiar
          this.rangeEnd = this.rangeStart;
          this.rangeStart = date;
        } else {
          this.rangeEnd = date;
        }
        
        // Emitir el rango seleccionado
        this.dateRangeSelected.emit({
          start: this.rangeStart,
          end: this.rangeEnd
        });
        this.isCalendarVisible = false;
        this.errorMessage = '';
      }
    }
  }

  isDisabled(date: Date): boolean {
    // if (this.minDate && isBefore(date, this.minDate)) return true;
    // if (this.maxDate && isAfter(date, this.maxDate)) return true;
    return false;
  }

  getDayClasses(day: Date | null): string {
    if (!day) return 'p-0.5 text-center text-gray-400';

    let classes = 'p-1 text-xxs font-semibold m-0.5 h-6 flex justify-center items-center text-center cursor-pointer hover:bg-primary-5 rounded-full ';

    if (this.isDisabled(day)) {
      return classes + 'text-gray-300 cursor-not-allowed';
    }

    if (this.mode === 'single' && this.selectedDate && isSameDay(day, this.selectedDate)) {
      classes += '!bg-primary text-white';
    }

    if (this.mode === 'range') {
      if (this.rangeStart && isSameDay(day, this.rangeStart)) {
        classes += '!bg-primary text-white ';
      }
      if (this.rangeEnd && isSameDay(day, this.rangeEnd)) {
        classes += '!bg-primary text-white ';
      }
      if (this.rangeStart && this.rangeEnd && isWithinInterval(day, { start: this.rangeStart, end: this.rangeEnd })) {
        classes += 'bg-primary-5 ';
      }
    }

    return classes;
  }

  previousMonth() {
    this.currentDate = subMonths(this.currentDate, 1);
    this.generateCalendar();
    if (this.mode === 'range') {
      this.generateNextMonthCalendar();
    }
  }

  nextMonth() {
    this.currentDate = addMonths(this.currentDate, 1);
    this.generateCalendar();
    if (this.mode === 'range') {
      this.generateNextMonthCalendar();
    }
  }

  toggleYearSelection() {
    this.showYearSelection = !this.showYearSelection;
  }

  selectYear(year: number) {
    this.currentDate = setYear(this.currentDate, year);
    this.generateCalendar();
    if (this.mode === 'range') {
      this.generateNextMonthCalendar();
    }
    // No cerramos el calendario al seleccionar un año
  }

  isCurrentYear(year: number): boolean {
    return year === this.currentDate.getFullYear();
  }

  selectLastMonth() {
    const today = new Date();
    const lastMonthStart = startOfMonth(subMonths(today, 1));
    const lastMonthEnd = endOfMonth(subMonths(today, 1));
    this.rangeStart = lastMonthStart;
    this.rangeEnd = lastMonthEnd;
    this.currentDate = lastMonthStart;
    this.generateCalendar();
    if (this.mode === 'range') {
      this.generateNextMonthCalendar();
    }
    this.dateRangeSelected.emit({
      start: this.rangeStart,
      end: this.rangeEnd
    });
    this.isCalendarVisible = false;
  }

  applyRange() {
    if (this.rangeStart && this.rangeEnd) {
      this.dateRangeSelected.emit({
        start: this.rangeStart,
        end: this.rangeEnd
      });
      this.isCalendarVisible = false;
    }
  }

  // Método para formatear el mes y año en español
  getFormattedMonthYear(date: Date): string {
  const text = format(date, 'MMMM yyyy', { locale: this.locale });

  return text.replace(/\b\w/g, (c) => c.toUpperCase());
}

}
