import { Injectable, effect, signal } from '@angular/core';
import { GridApi } from 'ag-grid-community';
import { RrHhStore } from '../store/rr-hh.store';
import { AsistenciaEntity } from '../domain/models/asistencia.entity';

@Injectable()
export class RrHhAsistenciasGridEffects {
  private gridApi: GridApi | null = null;
  private rowData = signal<AsistenciaEntity[]>([]);

  constructor(private readonly store: RrHhStore) {
    // Efecto: sincronizar datos del store con la grilla
    effect(() => {
      const data = this.store.asistencias();
      this.rowData.set(data);
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', data);
      }
    });

    // Efecto: mostrar/ocultar loading overlay
    effect(() => {
      const loading = this.store.loadingAsistencias();
      if (this.gridApi) {
        if (loading) {
          this.gridApi.showLoadingOverlay();
        } else {
          this.gridApi.hideOverlay();
        }
      }
    });
  }

  setGridApi(api: GridApi): void {
    this.gridApi = api;
    // Si el loading ya estaba activo cuando se registró la grilla, mostrar overlay
    if (this.store.loadingAsistencias()) {
      this.gridApi.showLoadingOverlay();
    }
  }

  getRowData(): AsistenciaEntity[] {
    return this.rowData();
  }

  setRowData(data: AsistenciaEntity[]): void {
    this.rowData.set(data);
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', data);
    }
  }
}
