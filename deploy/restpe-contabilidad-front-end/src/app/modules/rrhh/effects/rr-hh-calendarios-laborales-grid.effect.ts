import { Injectable, effect, signal } from '@angular/core';
import { GridApi } from 'ag-grid-community';
import { RrHhStore } from '../store/rr-hh.store';
import { CalendarioLaboralEntity } from '../domain/models/calendario-laboral.entity';

@Injectable()
export class RrHhCalendariosLaboralesGridEffects {
  private gridApi: GridApi | null = null;
  private rowData = signal<CalendarioLaboralEntity[]>([]);

  constructor(private readonly store: RrHhStore) {
    // Efecto: sincronizar datos del store con la grilla
    effect(() => {
      const data = this.store.calendariosLaborales();
      this.rowData.set(data);
      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', data);
      }
    });

    // Efecto: mostrar/ocultar loading overlay
    effect(() => {
      const loading = this.store.loadingCalendariosLaborales();
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
    if (this.store.loadingCalendariosLaborales()) {
      this.gridApi.showLoadingOverlay();
    }
  }

  getRowData(): CalendarioLaboralEntity[] {
    return this.rowData();
  }

  setRowData(data: CalendarioLaboralEntity[]): void {
    this.rowData.set(data);
    if (this.gridApi) {
      this.gridApi.setGridOption('rowData', data);
    }
  }
}
