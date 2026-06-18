import { Directive, ElementRef, HostListener, OnInit } from '@angular/core';
import { NgControl } from '@angular/forms';

@Directive({
  selector: '[appDecimal]',
  standalone: false
})
export class DecimalDirective implements OnInit {
  constructor(private el: ElementRef, private ngControl: NgControl) {}

  ngOnInit() {
    // Formatear el valor inicial después de que Angular haya renderizado
    setTimeout(() => this.formatValue(), 100);
  }

  @HostListener('keypress', ['$event'])
  onKeyPress(event: any) {
    const char = event.key;
    const input = this.el.nativeElement;
    const value = input.value;

    // Permitir solo números y un punto decimal
    if (!/[\d.]/.test(char)) {
      event.preventDefault();
    }

    // Prevenir múltiples puntos decimales
    if (char === '.' && value.includes('.')) {
      event.preventDefault();
    }
  }

  @HostListener('blur')
  onBlur() {
    this.formatValue();
  }

  @HostListener('change')
  onChange() {
    this.formatValue();
  }

  private formatValue() {
    const input = this.el.nativeElement;
    const value = input.value;

    if (value !== '' && value !== null && value !== undefined) {
      const numValue = parseFloat(value);
      if (!isNaN(numValue)) {
        input.value = numValue.toFixed(2);
        // Actualizar el control del formulario
        if (this.ngControl?.control) {
          this.ngControl.control.setValue(numValue, { emitEvent: false });
        }
      }
    } else if (value === '') {
      if (this.ngControl?.control) {
        this.ngControl.control.setValue('', { emitEvent: false });
      }
    }
  }
}
