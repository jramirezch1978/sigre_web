import { Injectable } from '@angular/core';

export interface OrdenCompraDraftArticulo {
  codigo: string;
  descripcion: string;
  unidad: string;
  unidadMedida: string;
  cantidad: number;
  precioUnitario: number;
  subtotal: number;
  impuestos: number;
  total: number;
}

export interface OrdenCompraDraftTransfer {
  planOrigen: string;
  almacen: string;
  sucursal: string;
  articulos: OrdenCompraDraftArticulo[];
}

@Injectable({ providedIn: 'root' })
export class OrdenCompraDraftTransferService {
  private pendingDraft: OrdenCompraDraftTransfer | null = null;

  setPendingDraft(draft: OrdenCompraDraftTransfer): void {
    this.pendingDraft = structuredClone(draft);
  }

  hasPendingDraft(): boolean {
    return this.pendingDraft !== null;
  }

  consumePendingDraft(): OrdenCompraDraftTransfer | null {
    if (!this.pendingDraft) {
      return null;
    }

    const draft = structuredClone(this.pendingDraft);
    this.pendingDraft = null;
    return draft;
  }
}
