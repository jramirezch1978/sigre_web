import { Injectable, effect, signal } from '@angular/core';
import { GridApi } from 'ag-grid-community';
import { RrHhStore } from '../store/rr-hh.store';
import { PermisoEntity } from '../domain/models/permiso.entity';

@Injectable()
export class RrHhAprobacionPermisosGridEffects {
  private gridApi: GridApi | null = null;
  private rowData = signal<PermisoEntity[]>([]);

  constructor(private readonly store: RrHhStore) {
    // Efecto: sincronizar datos del store con la grilla
    effect(() => {
      const data = this.store
        .permisos()
        .filter((permiso) => permiso.permiso_estado === 'Pendiente');
      this.rowData.set(data);
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', data);
      }
    });

    // Efecto: mostrar/ocultar loading overlay
    effect(() => {
      const loading = this.store.loadingPermisos();
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
    if (this.store.loadingPermisos()) {
      this.gridApi.showLoadingOverlay();
    }
  }

  getRowData(): PermisoEntity[] {
    return this.rowData();
  }

  setRowData(data: PermisoEntity[]): void {
    this.rowData.set(data);
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', data);
    }
  }
}
