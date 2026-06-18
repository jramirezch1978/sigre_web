import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';

@Component({
  selector: 'app-slider-rango',
  templateUrl: './slider-rango.component.html',
  styleUrls: ['./slider-rango.component.scss'],
  standalone:false,
})
export class SliderRangoComponent  implements OnInit {

  @Input() min = 0;
  @Input() max = 100000;
  @Input() step = 100;
  @Input() from = 1000;
  @Input() to = 5000;
  @Input() currency = 'S/';
  @Output() rangeChange = new EventEmitter<{from:number,to:number}>();

  ngOnInit() {
    if (this.from > this.to) { const tmp = this.from; this.from = this.to; this.to = tmp; }
  }

  onRangeChange(ev: any) {
    const val = ev?.detail?.value;
    if (Array.isArray(val)) {
      this.from = Number(val[0]);
      this.to = Number(val[1]);
      this.rangeChange.emit({ from: this.from, to: this.to });
    }
  }
}