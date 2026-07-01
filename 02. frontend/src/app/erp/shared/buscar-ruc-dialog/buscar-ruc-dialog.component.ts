import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { MatDialogRef } from '@angular/material/dialog';
import { SigreMetoxiModalShellComponent } from '@sigre-common';
import { rucValidator } from '../utils/erp-form-validators.util';
import { ErpConsultaRucService, ConsultaRucResult } from '../../services/erp-consulta-ruc.service';

/**
 * Popup "Buscar RUC": valida formato + dígito verificador en el frontend
 * ANTES de llamar a la API (consulta reactiva vía ErpConsultaRucService).
 * Se cierra devolviendo los datos encontrados (o null si se cancela).
 */
@Component({
  selector: 'app-buscar-ruc-dialog',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, SigreMetoxiModalShellComponent],
  templateUrl: './buscar-ruc-dialog.component.html',
})
export class BuscarRucDialogComponent {
  private readonly fb = inject(FormBuilder);
  private readonly dialogRef = inject(MatDialogRef<BuscarRucDialogComponent>);
  private readonly consultaRucSvc = inject(ErpConsultaRucService);

  readonly form: FormGroup = this.fb.group({
    ruc: ['', [Validators.required, rucValidator()]],
  });

  buscando = false;
  errorApi = '';

  get rucControl() {
    return this.form.get('ruc');
  }

  cancelar(): void {
    this.dialogRef.close(null);
  }

  enviar(): void {
    this.errorApi = '';
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    const ruc = String(this.rucControl?.value ?? '').trim();
    this.buscando = true;
    this.consultaRucSvc.consultarRuc(ruc).subscribe({
      next: (data: ConsultaRucResult) => {
        this.buscando = false;
        this.dialogRef.close(data);
      },
      error: (err: unknown) => {
        this.buscando = false;
        this.errorApi =
          (err as { error?: { message?: string } })?.error?.message ??
          (err as Error)?.message ??
          'No se pudo consultar el RUC en SUNAT.';
      },
    });
  }
}
