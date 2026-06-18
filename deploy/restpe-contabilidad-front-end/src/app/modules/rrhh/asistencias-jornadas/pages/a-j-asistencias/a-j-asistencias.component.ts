import { GridApi, GridReadyEvent, ColDef } from 'ag-grid-enterprise';
import { Component, OnInit, inject } from '@angular/core';
import { CountryService } from 'src/app/ui/services/countryservice.service';
import { RrHhFacade } from 'src/app/modules/rrhh/application/facades/rr-hh.facade';
import { RrHhAsistenciasGridEffects } from 'src/app/modules/rrhh/effects/rr-hh-asistencias-grid.effect';
import { AsistenciaEntity } from 'src/app/modules/rrhh/domain/models/asistencia.entity';

// Font Awesome Icons
import { faSearch } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload, faRefresh, faRotateRight } from '@fortawesome/pro-solid-svg-icons';

@Component({
  selector: 'app-a-j-asistencias',
  templateUrl: './a-j-asistencias.component.html',
  styleUrls: ['./a-j-asistencias.component.scss'],
  standalone: false,
})
export class AJAsistenciasComponent  implements OnInit {
  // Facades y Effects
  private readonly rrHhFacade = inject(RrHhFacade);
  private readonly asistenciasGridEffects = inject(RrHhAsistenciasGridEffects);

  // Selectores del store
  readonly isLoading = this.rrHhFacade.loadingAsistencias;

  get rowData(): AsistenciaEntity[] {
    return this.asistenciasGridEffects.getRowData();
  }

  // Font Awesome Icons
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;
  fasRefresh = faRefresh;
  fasRotateRight = faRotateRight;



  pais = this.countryService.getCountryCode();
  simboloMoneda: string = 'S/';

  private gridApi!: GridApi;
  
  colDefs: ColDef<AsistenciaEntity>[] = [];


  localeText = {
    page: 'Página',
    of: 'de',
    to: 'a',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    noRowsToShow: 'No hay filas para mostrar',
    loadingOoo: 'Cargando...'
  };
  columnTypes = {
    currency: { 
        width: 150,
    },
    shaded: {
        cellClass: 'shaded-class'
    }
  };
  defaultColDef = {
    resizable: true,
    flex: 1,
    minWidth: 100,
  };

  constructor(private countryService: CountryService) { }

  ngOnInit() {
    this.rrHhFacade.cargarAsistencias();
    this.inicializarColumnas();
  }

  inicializarColumnas() {
    this.colDefs = [
      { headerName: 'Nombre colaborador', field: 'asistencia_nombre', minWidth: 120, flex: 1 },
      { headerName: 'Sucursal', field: 'asistencia_sucursal', width: 120 },
      { headerName: 'Tipo de turno', field: 'asistencia_tipo_turno', width: 120 },
      { headerName: 'Descripción', field: 'asistencia_descripcion', width: 120 },
      { headerName: 'Días trabajados', field: 'asistencia_dias_trabajados', width: 120 },
      { headerName: 'Días ausentes', field: 'asistencia_dias_ausentes', width: 120 },
      { headerName: 'Días tardanza', field: 'asistencia_dias_tardanza', width: 120 },
      { headerName: 'Días horas faltantes', field: 'asistencia_horas_feriado', width: 120 },
      { headerName: 'Cantidad horas laborales totales', field: 'asistencia_horas_lt', width: 120, headerClass: 'derechaencabezadodoble',
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' }
      },
      { headerName: 'AVG horas laboradas al día', field: 'asistencia_horas_ld', width: 120, headerClass: 'derechaencabezadodoble',
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' }
      },
      { headerName: 'Total de horas faltantes', field: 'asistencia_total_hf', width: 120, headerClass: 'derechaencabezadodoble',
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' }
      },
      { headerName: 'Descuento por horas faltantes', field: 'asistencia_descuento_hf', width: 120, headerClass: 'derechaencabezadodoble',
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
        valueFormatter: (params) => {
          return `${this.simboloMoneda} ${params.value}`;
        }
      },
    ];

    // Para Guatemala, agregar columna de horas extra al 50%
    if (this.pais === 'GT') {
      this.colDefs.push({
        headerName: 'Total de costo de horas extra (50%)', 
        field: 'asistencia_total_costo_h50', 
        width: 120, 
        headerClass: 'derechaencabezadodoble',
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
        valueFormatter: (params) => { return `${this.simboloMoneda} ${params.value}` }
      });
      this.colDefs.push({
          headerName: 'Total de costo de horas extra (100%)', field: 'asistencia_total_costo_h2', width: 120, headerClass: 'derechaencabezadodoble',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params) => { return `${this.simboloMoneda} ${params.value}` }
      });
    }
    if (this.pais === 'PE') {
      this.colDefs.push({
        headerName: 'Total de costo de horas extra (25%)', field: 'asistencia_total_ch', width: 120, headerClass: 'derechaencabezadodoble',
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
        valueFormatter: (params) => { return `${this.simboloMoneda} ${params.value}` }
        ,
      });
      this.colDefs.push({
          headerName: 'Total de costo de horas extra (35%)', field: 'asistencia_total_costo_h2', width: 120, headerClass: 'derechaencabezadodoble',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params) => { return `${this.simboloMoneda} ${params.value}` }
      });
    }
    if (this.pais === 'EC') {
      this.colDefs.push({
        headerName: 'Total de costo de horas extra (25%)', field: 'asistencia_total_ch', width: 120, headerClass: 'derechaencabezadodoble',
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
        valueFormatter: (params) => { return `${this.simboloMoneda} ${params.value}` }
        ,
      });
      this.colDefs.push({
        headerName: 'Total de costo de horas extra (50%)', field: 'asistencia_total_ch', width: 120, headerClass: 'derechaencabezadodoble',
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
        valueFormatter: (params) => { return `${this.simboloMoneda} ${params.value}` }
        ,
      });
      this.colDefs.push({
          headerName: 'Total de costo de horas extra (100%)', field: 'asistencia_total_costo_h2', width: 120, headerClass: 'derechaencabezadodoble',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
          valueFormatter: (params) => { return `${this.simboloMoneda} ${params.value}` }
      });
    }

    // Agregar las columnas finales
    this.colDefs.push(
      { headerName: 'Remuneración por horas asistidas', field: 'asistencia_remuneracion', width: 120, headerClass: 'derechaencabezadodoble',
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'},
        valueFormatter: (params) => {
          return `${this.simboloMoneda} ${params.value}`;
        }
      },
      { headerName: '% de asistencia', headerClass: 'derechaencabezado', field: 'asistencia_porcentaje_asistencia', width: 120,
        cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center'}
      }
    );
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.asistenciasGridEffects.setGridApi(params.api);
  }

  onBtReset() {
    this.rrHhFacade.cargarAsistencias();
  }

}
