import { Injectable, signal, computed } from '@angular/core';
import { PanelDocumentoState, initialPanelDocumentoState } from './panel-documento.state';
import { PanelDocumentoEntity } from '../domain/models/panel-documento.entity';

@Injectable()
export class PanelDocumentoStore {

  private readonly state = signal<PanelDocumentoState>(initialPanelDocumentoState);

  // Selectores
  readonly registros = computed(() => this.state().registros);
  readonly loading   = computed(() => this.state().loading);
  readonly error     = computed(() => this.state().error);

  readonly isLoading = computed(() => this.state().loading);
  readonly hasError  = computed(() => !!this.state().error);

  // Mutadores de loading
  setLoading(value: boolean) {
    this.state.update(s => ({ ...s, loading: value }));
  }

  // Mutadores de datos
  setRegistros(registros: PanelDocumentoEntity[]) {
    this.state.update(s => ({ ...s, registrosCompletos: registros, registros, error: null }));
  }

  filtrarRegistros(filtros: { comprobante: string; estadoProv: string; estado: string }) {
    const completos = this.state().registrosCompletos;
    const filtrados = completos.filter(r => {
      if (filtros.comprobante !== 'todos') {
        const docNormalizado = r.panel_estado_doc_documento
          .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
          .toLowerCase().replace(/\s+/g, '_');
        if (docNormalizado !== filtros.comprobante) return false;
      }
      if (filtros.estadoProv !== 'todos') {
        const estados = r.panel_estado_doc_data_proveedor?.estados ?? [];
        const estadosLower = estados.map(e => e.toLowerCase());
        const mapeo: Record<string, string> = {
          'activo': 'activo',
          'anulado': 'anulado',
          'aceptado': 'aceptado en sunat',
          'baja-aceptada': 'baja aceptada',
          'pendiente-baja': 'pendiente de baja',
          'pendiente-aceptacion': 'pendiente de aceptación',
          'pendiente-rd': 'pendiente rd',
        };
        const buscar = mapeo[filtros.estadoProv];
        if (buscar && !estadosLower.includes(buscar)) return false;
      }
      if (filtros.estado !== 'todos') {
        if (r.panel_estado_doc_estado.toLowerCase() !== filtros.estado) return false;
      }
      return true;
    });
    this.state.update(s => ({ ...s, registros: filtrados }));
  }

  // Mutadores de error
  setError(message: string | null) {
    this.state.update(s => ({ ...s, error: message, loading: false }));
  }

  // Reset
  resetState() {
    this.state.set(initialPanelDocumentoState);
  }
}
