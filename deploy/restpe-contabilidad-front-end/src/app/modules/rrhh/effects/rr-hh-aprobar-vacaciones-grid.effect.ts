import { Injectable, effect, signal } from '@angular/core';
import { GridApi } from 'ag-grid-community';
import { RrHhStore } from '../store/rr-hh.store';
import { VacacionLicenciaEntity } from '../domain/models/vacacion-licencia.entity';

@Injectable()
export class RrHhAprobarVacacionesGridEffects {
  private gridApi: GridApi | null = null;
  private rowData = signal<VacacionLicenciaEntity[]>([]);

  constructor(private readonly store: RrHhStore) {
    // Efecto: sincronizar datos del store con la grilla
    effect(() => {
      const data = this.store
        .vacacionesLicencias()
        .filter((solicitud) => solicitud.vacacion_licencia_estado === 'Pendiente');
      this.rowData.set(data);
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', data);
      }
    });

    // Efecto: mostrar/ocultar loading overlay
    effect(() => {
      const loading = this.store.loadingVacacionesLicencias();
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
    if (this.store.loadingVacacionesLicencias()) {
      this.gridApi.showLoadingOverlay();
    }
  }

  getRowData(): VacacionLicenciaEntity[] {
    return this.rowData();
  }

  setRowData(data: VacacionLicenciaEntity[]): void {
    this.rowData.set(data);
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', data);
    }
  }
}
