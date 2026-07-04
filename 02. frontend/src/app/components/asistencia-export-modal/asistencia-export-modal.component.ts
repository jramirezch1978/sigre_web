import { Component, EventEmitter, Input, Output } from '@angular/core';
import { CommonModule } from '@angular/common';

export type AsistenciaExportFormato = 'excel' | 'word' | 'pdf';

/**
 * Modal de exportacion (Excel / Word / PDF) exclusivo del modulo de asistencia.
 */
@Component({
  selector: 'app-asistencia-export-modal',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './asistencia-export-modal.component.html',
  styleUrls: ['./asistencia-export-modal.component.scss']
})
export class AsistenciaExportModalComponent {
  @Input() visible = false;
  @Input() exportando = false;
  @Output() cerrar = new EventEmitter<void>();
  @Output() exportar = new EventEmitter<AsistenciaExportFormato>();

  onCerrar(): void {
    this.cerrar.emit();
  }

  onExportar(formato: AsistenciaExportFormato): void {
    if (this.exportando) {
      return;
    }
    this.exportar.emit(formato);
  }
}
