import { Injectable, signal, computed } from '@angular/core';
import { PanelReenvioState, initialPanelReenvioState } from './panel-reenvio.state';
import { PanelReenvioEntity } from '../domain/models/panel-reenvio.entity';

@Injectable()
export class PanelReenvioStore {

  private readonly state = signal<PanelReenvioState>(initialPanelReenvioState);

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
  setRegistros(registros: PanelReenvioEntity[]) {
    this.state.update(s => ({ ...s, registrosCompletos: registros, registros, error: null }));
  }

  filtrarRegistros(filtros: { comprobante: string; tipo: string; estado: string }) {
    const completos = this.state().registrosCompletos;
    const filtrados = completos.filter(r => {
      if (filtros.comprobante !== 'todos') {
        const docNormalizado = r.panel_reenvio_documento
          .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
          .toLowerCase().replace(/\s+/g, '_');
        if (docNormalizado !== filtros.comprobante) return false;
      }
      if (filtros.tipo !== 'todos') {
        if (r.panel_reenvio_tipo !== filtros.tipo) return false;
      }
      if (filtros.estado !== 'todos') {
        if (r.panel_reenvio_estado.toLowerCase() !== filtros.estado) return false;
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
    this.state.set(initialPanelReenvioState);
  }

  // Actualizar estado de un registro por N° documento
  actualizarEstadoRegistro(nroDocumento: string, nuevoEstado: string) {
    this.state.update(s => ({
      ...s,
      registrosCompletos: s.registrosCompletos.map(r =>
        r.panel_reenvio_nro_documento === nroDocumento
          ? { ...r, panel_reenvio_estado: nuevoEstado }
          : r
      ),
      registros: s.registros.map(r =>
        r.panel_reenvio_nro_documento === nroDocumento
          ? { ...r, panel_reenvio_estado: nuevoEstado }
          : r
      ),
    }));
  }
}
