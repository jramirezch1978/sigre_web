import { Directive, ElementRef, OnDestroy, OnInit, Renderer2, inject } from '@angular/core';
import { NgControl } from '@angular/forms';
import { Subscription, merge } from 'rxjs';
import { estadoValidacionCampo } from './sigre-field-validation.util';

/**
 * Muestra un icono de validación dentro/junto al campo: check verde si es válido y tiene
 * valor, icono rojo si es inválido tras interacción, y nada si está vacío/intacto.
 *
 * Funciona con reactive forms (formControlName) y template-driven ([(ngModel)]).
 *  - En `ion-input` / `ion-select` / `ion-textarea` el icono se proyecta en el slot "end".
 *  - En inputs planos (`input`/`select`/`textarea`) se envuelve el campo y se posiciona a la derecha.
 *
 * Uso: `<ion-input sigreValid formControlName="ruc">` o `<input sigreValid [(ngModel)]="x" #r="ngModel">`.
 */
@Directive({
  selector: '[sigreValid]',
  standalone: true,
})
export class SigreValidIconDirective implements OnInit, OnDestroy {
  private readonly ngControl = inject(NgControl, { self: true, optional: true });
  private readonly hostRef = inject(ElementRef<HTMLElement>);
  private readonly renderer = inject(Renderer2);

  private icon?: HTMLElement;
  private sub?: Subscription;

  ngOnInit(): void {
    const control = this.ngControl?.control;
    if (!control) {
      return;
    }
    const host = this.hostRef.nativeElement;
    const esIonic = host.tagName.toLowerCase().startsWith('ion-');

    this.icon = this.renderer.createElement('span');
    this.renderer.addClass(this.icon, 'material-icons-outlined');
    this.renderer.addClass(this.icon, 'sigre-valid-icon');
    this.renderer.setAttribute(this.icon, 'aria-hidden', 'true');

    if (esIonic) {
      this.renderer.setAttribute(this.icon, 'slot', 'end');
      // En el patrón legacy (ion-item > ion-label + ion-input) el slot "end" pertenece al
      // ion-item; si no hay ion-item (ion-input moderno) se proyecta en el propio control.
      const item = host.closest('ion-item');
      this.renderer.appendChild(item ?? host, this.icon);
    } else {
      // Envolver el input plano para posicionar el icono a su derecha.
      const parent = this.renderer.parentNode(host);
      const wrap = this.renderer.createElement('span');
      this.renderer.addClass(wrap, 'sigre-valid-wrap');
      this.renderer.insertBefore(parent, wrap, host);
      this.renderer.appendChild(wrap, host);
      this.renderer.appendChild(wrap, this.icon);
    }

    this.sub = merge(control.statusChanges, control.valueChanges).subscribe(() => this.render());
    this.render();
  }

  ngOnDestroy(): void {
    this.sub?.unsubscribe();
  }

  private render(): void {
    if (!this.icon) {
      return;
    }
    const estado = estadoValidacionCampo(this.ngControl?.control ?? null);
    this.renderer.setProperty(this.icon, 'textContent',
      estado === 'valid' ? 'check_circle' : estado === 'invalid' ? 'error' : '');
    this.aplicarClase('sigre-valid-icon--valid', estado === 'valid');
    this.aplicarClase('sigre-valid-icon--invalid', estado === 'invalid');
  }

  private aplicarClase(clase: string, activa: boolean): void {
    if (activa) {
      this.renderer.addClass(this.icon, clase);
    } else {
      this.renderer.removeClass(this.icon, clase);
    }
  }
}
