import { Component, Input, OnInit } from '@angular/core';
import { FormControl } from '@angular/forms';

let _counter = 0;
@Component({
  selector: 'app-calendar-popover',
  templateUrl: './calendar-popover.component.html',
  styleUrls: ['./calendar-popover.component.scss'],
  standalone: false
})
export class CalendarPopoverComponent  implements OnInit {

  @Input() control!: FormControl<string | null>;

  @Input() placeholder = 'Elegir fecha';

  @Input() displayFormat = 'dd/MM/yyyy';

  @Input() presentation: any = 'date';
  @Input() showBackdrop = false;
  @Input() locale = 'es-PE';
  @Input() firstDayOfWeek = 1;

  @Input() width = 250; 

  triggerId = `calendar-popover-trigger-${++_counter}`;

  ngOnInit(): void {
    if (!this.control) {
      throw new Error('[app-calendar-popover] Debes pasar un FormControl en [control].');
    }
  }

}
