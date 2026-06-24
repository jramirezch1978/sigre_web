import { Component, EventEmitter, Input, Output, ViewEncapsulation } from '@angular/core';

export type SigreMetoxiModalSize = 'sm' | 'md' | 'lg' | 'xl';

@Component({
  selector: 'sigre-metoxi-modal-shell',
  standalone: true,
  templateUrl: './metoxi-modal-shell.component.html',
  styleUrls: ['./metoxi-modal-shell.component.scss'],
  encapsulation: ViewEncapsulation.None,
})
export class SigreMetoxiModalShellComponent {
  @Input({ required: true }) titulo!: string;
  @Input() cerrarDeshabilitado = false;
  @Input() mostrarPie = true;
  @Input() cuerpoScroll = true;
  @Input() size: SigreMetoxiModalSize = 'lg';
  @Output() cerrar = new EventEmitter<void>();

  onCerrar(): void {
    this.cerrar.emit();
  }
}
