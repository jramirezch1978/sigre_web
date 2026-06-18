import { Component, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faList, faXmark } from '@fortawesome/pro-solid-svg-icons';
import { ToastService } from '@ui/services/toast.service';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { IContableRow } from '../../../c-t-plancontable/plan-contable-loader.service';

@Component({
  selector: 'app-modal-cuentas-contables',
  templateUrl: './modal-cuentas-contables.component.html',
  styleUrls: ['./modal-cuentas-contables.component.scss'],
  standalone: false,
})
export class ModalCuentasContablesComponent implements OnInit {
  // Font Awesome Icons
  farSearch = faSearch;
  fasList = faList;
  fasXmark = faXmark;

  busqueda: string = '';

  cuentaSeleccionada: any = null;
  
  private gridApi!: GridApi;

  localeText = {
    page: 'Página',
    to: 'a',
    of: 'de',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    loadingOoo: 'Cargando...',
    noRowsToShow: 'No hay datos para mostrar'
  }; 

  rowData: IContableRow[] = [];
  private todasLasCuentas: IContableRow[] = [];


  colDefs: ColDef[] = [
    { field: 'descripcion', headerName: 'Descripción cuenta contable', flex: 1,
      valueFormatter: (params: any) => {
        if (params.data?.isNivel1) return '';
        return params.value || '';
      }
    }
  ];

  constructor(
    private modalController: ModalController,
    private toast: ToastService,
    private simulation: SimulationService,
  ) {}

  ngOnInit() {
    this.todasLasCuentas = this.simulation.list('plancontable') || [];
    this.rowData = [...this.todasLasCuentas];
  }

  columnTypes = {
    currency: {
      width: 150,
    },
    shaded: {
      cellClass: 'shaded-class'
    }
  };
  // Configuración para Tree Data
  treeData = true;
  groupDefaultExpanded = 0;

  defaultColDef: ColDef = {
    editable: false,
  };
  getDataPath = (data: IContableRow) => {
    return data.orgHierarchy || [];
  };
  autoGroupColumnDef: ColDef = {
    headerName: 'Cuenta contable',
    width: 235,
    cellRendererParams: {
      suppressCount: true,
      innerRenderer: (params: any) => {
        const value = params.value || '';
        if (params.data?.isNivel1) {
          return value;
        }
        const dashIndex = value.indexOf(' - ');
        return dashIndex !== -1 ? value.substring(0, dashIndex) : value;
      },
    }
  };

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onBuscar() {
    const termino = (this.busqueda ?? '').trim().toLowerCase();
    if (!termino) {
      this.rowData = [...this.todasLasCuentas];
      return;
    }

    // Encontrar cuentas que coinciden por código o descripción
    const coincidencias = this.todasLasCuentas.filter(c =>
      c.codigo.toLowerCase().includes(termino) ||
      c.descripcion.toLowerCase().includes(termino)
    );

    // Incluir padres necesarios para que el árbol se renderice correctamente
    const codigosPadres = new Set<string>();
    coincidencias.forEach(c => {
      const hierarchy = c.orgHierarchy || [];
      for (let i = 1; i < hierarchy.length; i++) {
        const parentPath = hierarchy.slice(0, i).join('|');
        codigosPadres.add(parentPath);
      }
    });

    const resultado = this.todasLasCuentas.filter(c => {
      if (coincidencias.includes(c)) return true;
      const path = (c.orgHierarchy || []).join('|');
      return codigosPadres.has(path);
    });

    this.rowData = resultado;
    setTimeout(() => this.gridApi?.expandAll(), 0);
  }

  onCellClicked(event: any) {
    this.cuentaSeleccionada = event.data;
    console.log('Cuenta seleccionada:', this.cuentaSeleccionada);
  }

  cerrarModal(aceptar: boolean) {
    if (aceptar) {
      if (!this.cuentaSeleccionada) {
        this.toast.warning('Por favor, seleccione una cuenta contable antes de aceptar.');
        return;
      }
      // Enviar la cuenta seleccionada
      this.modalController.dismiss({
        ok: true,
        cuenta: this.cuentaSeleccionada
      });
    } else {
      // Solo cerrar sin enviar datos
      this.modalController.dismiss({ ok: false });
    }
  }

}
