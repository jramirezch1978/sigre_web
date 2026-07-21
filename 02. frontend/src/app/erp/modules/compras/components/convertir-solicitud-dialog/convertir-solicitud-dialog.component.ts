import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { catchError, of } from 'rxjs';
import {
  SigreModalService,
  SigreMetoxiModalShellComponent, SigreMetoxiModalActionsComponent,
} from '@sigre-common';
import { CoreApiService } from '../../../almacen/services/core-api.service';
import { SolicitudCompraApiService, ConvertirSolicitudRequestDto } from '../../services/solicitud-compra-api.service';

export interface ConvertirSolicitudDialogData {
  solicitudId: number;
  numero: string;
}

interface ProveedorCheck {
  id: number;
  label: string;
  marcado: boolean;
}

/** Convierte una Solicitud de Compra activa en Cotización(es) u Orden(es) de Compra, una por proveedor. */
@Component({
  selector: 'app-convertir-solicitud-dialog',
  standalone: true,
  imports: [CommonModule, FormsModule, SigreMetoxiModalShellComponent, SigreMetoxiModalActionsComponent],
  templateUrl: './convertir-solicitud-dialog.component.html',
})
export class ConvertirSolicitudDialogComponent implements OnInit {
  private readonly dialogRef = inject(MatDialogRef<ConvertirSolicitudDialogComponent>);
  private readonly coreApi = inject(CoreApiService);
  private readonly api = inject(SolicitudCompraApiService);
  private readonly modal = inject(SigreModalService);
  readonly data = inject<ConvertirSolicitudDialogData>(MAT_DIALOG_DATA);

  cargando = true;
  procesando = false;
  destino: 'COTIZACION' | 'ORDEN_COMPRA' = 'COTIZACION';
  proveedores: ProveedorCheck[] = [];

  ngOnInit(): void {
    this.coreApi.listarProveedores().pipe(catchError(() => of([]))).subscribe(prov => {
      this.proveedores = prov.map(p => ({ id: Number(p.value), label: p.label, marcado: false }));
      this.cargando = false;
    });
  }

  get proveedoresSeleccionados(): number[] {
    return this.proveedores.filter(p => p.marcado).map(p => p.id);
  }

  cancelar(): void { this.dialogRef.close(null); }

  confirmar(): void {
    const proveedorIds = this.proveedoresSeleccionados;
    if (proveedorIds.length === 0) {
      void this.modal.warning('Seleccione al menos un proveedor.', 'Sin proveedores');
      return;
    }
    this.procesando = true;
    const body: ConvertirSolicitudRequestDto = { destino: this.destino, proveedorIds };
    this.api.convertir(this.data.solicitudId, body).subscribe({
      next: res => {
        this.procesando = false;
        const doc = this.destino === 'COTIZACION' ? 'cotización(es)' : 'orden(es) de compra';
        void this.modal.success('Conversión realizada', `Se generaron ${res.documentosGenerados.length} ${doc} a partir de ${this.data.numero}.`);
        this.dialogRef.close(true);
      },
      error: () => { this.procesando = false; },
    });
  }
}
