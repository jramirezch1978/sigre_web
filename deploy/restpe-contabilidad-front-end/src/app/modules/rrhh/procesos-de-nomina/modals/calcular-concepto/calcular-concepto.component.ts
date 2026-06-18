import { Component, OnInit, Input } from '@angular/core';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-enterprise';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faDownload } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-calcular-concepto',
  templateUrl: './calcular-concepto.component.html',
  styleUrls: ['./calcular-concepto.component.scss'],
  standalone: false,


})
export class CalcularConceptoComponent implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;
  fasAngleDown = faAngleDown;
  fasDownload = faDownload;



  private gridApi!: GridApi;
  @Input() esFilaSeleccionada: boolean = false;
  @Input() monedaSimbolo: string = 'S/'; 
  @Input() pais: string = '';
  @Input() periodoDinamico: string = '';

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

  defaultColDef: ColDef = {
    valueFormatter: (params) => {
      return params.value === null || params.value === undefined || params.value === ''
        ? '–'
        : params.value;
    }
  };

  @Input() rowData: any[] = [];
  colDefs: ColDef[] = [];

  colDefsDefecto = [
    { field: 'idTrabajador', headerName: 'ID trabajador', width: 100 },
    { field: 'afp', headerName: 'Reg. Pensionario', width: 70 },
    { field: 'cok', headerName: 'COM ', width: 50 },
    { field: 'nombres', headerName: 'Nombres ', width: 120 },
    { field: 'apellidos', headerName: 'Apellidos ', width: 120 },
    { field: 'cuspp', headerName: 'CUSPP ', width: 100 },
    { field: 'cargo', headerName: 'Cargo ', width: 150 },
    { field: 'sueldo', headerName: 'Sueldo', width: 100, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
      valueFormatter: (params: any) => {
        if(params.value){
          return `${this.monedaSimbolo} ${params.value}`;
        }
        return '-';
      }
    },
    { field: 'asigFamiliar', headerName: 'Asignación Familiar', headerClass: 'derechaencabezado', width: 100,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
    },

    { field: 'totalSoles', headerName: 'Total Ing. Soles', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
      valueFormatter: (params: any) => {
        if(params.value){
          return `${this.monedaSimbolo} ${params.value}`;
        }
        return '-';
      }
    },
    { headerName: "Descuentos Trabajador", headerClass: 'centrarencabezado',
      children: [
        {
          field: "Fondo",
          width: 50,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
        {
          field: "Seg.",
          width: 50,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
        {
          field: "Comision",
          width: 80,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
        {
          field: "Total AFP",
          width: 80,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
        {
          field: "ONP",
          width: 50,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
        {
          field: "Adelanto Quincena",
          width: 120,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
        {
          field: "Total descuentos",
          width: 120,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
      ],
    },
    { headerName: "Saldo Neto Pago Soles", headerClass: 'colorencabezado', width: 140,
      cellClass: (params: any) => {
        const isLastRow = params.rowIndex === params.api.getDisplayedRowCount() - 1;
        return isLastRow ? 'colortotal' : 'colorcelda';
      },
    },
    { headerName: "Aporte empleador",
      children: [
        {
          field: "Essalud",
          width: 90,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
        {
          field: "Total aportes",
          width: 120,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
      ]
    }

  ]
  colDefsDefEcuador = [
    { field: 'idTrabajador', headerName: 'ID trabajador', width: 100 },
    { field: 'nombres', headerName: 'Nombres ', width: 120 },
    { field: 'apellidos', headerName: 'Apellidos ', width: 120 },
    { field: 'cargo', headerName: 'Cargo ', width: 150 },
    { field: 'fechaRegistro', headerName: 'Fecha Registro', width: 150 },
    { field: 'provincia', headerName: 'Provincia', width: 150 },
    { field: 'ciudad', headerName: 'Ciudad', width: 150 },
    { field: 'cargaspersonales', headerName: 'Cargas personales', headerClass: 'derechaencabezado', width: 100,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
    },
    { field: 'sueldo', headerName: 'Sueldo', width: 100, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
      valueFormatter: (params: any) => {
        if(params.value){
          return `${this.monedaSimbolo} ${params.value}`;
        }
        return '-';
      }
    },
    { field: 'horasExtras', headerName: 'Horas extras', width: 150 },
    { field: 'decimotercero', headerName: 'Decimo tercero', width: 100, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
      valueFormatter: (params: any) => {
        if(params.value){
          return `${this.monedaSimbolo} ${params.value}`;
        }
        return '-';
      }
    },
    { field: 'decimocuarto', headerName: 'Decimo cuarto', width: 100, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
      valueFormatter: (params: any) => {
        if(params.value){
          return `${this.monedaSimbolo} ${params.value}`;
        }
        return '-';
      }
    },
    { field: 'fondoreserva', headerName: 'Fondo de reserva', width: 150 },
    { field: 'totalSoles', headerName: 'Ingresos', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
      valueFormatter: (params: any) => {
        if(params.value){
          return `${this.monedaSimbolo} ${params.value}`;
        }
        return '-';
      }
    },
    { headerName: "Descuentos Trabajador", headerClass: 'centrarencabezado',
      children: [
        {
          field: "Ext. Conyugal (3.41%)",
          width: 50,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
        {
          field: "IR",
          width: 50,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
        {
          field: "IESS (9.45%)",
          width: 50,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
        {
          field: "Otros descuentos",
          width: 80,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
        {
          field: "Adelanto Quincena",
          width: 120,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
        {
          field: "Total descuentos",
          width: 120,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
      ],
    },
    { headerName: "Pago Neto", headerClass: 'colorencabezado', width: 140,
      cellClass: (params: any) => {
        const isLastRow = params.rowIndex === params.api.getDisplayedRowCount() - 1;
        return isLastRow ? 'colortotal' : 'colorcelda';
      },
    },
    { headerName: "Aporte empleador",
      children: [
        {
          field: "IESS",
          width: 90,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
        {
          field: "Total aportes",
          width: 120,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
        },
      ]
    }

  ]
  colDefsGuatemala = [
    { field: 'idTrabajador', headerName: 'Codigo', width: 100 },
    { field: 'nombres', headerName: 'Nombres y apellidos', width: 120 },
    { field: 'fechaingreso', headerName: 'Fecha de ingreso', width: 120 },
    { field: 'cargo', headerName: 'Cargo ', width: 150 },
    { field: 'centroCosto', headerName: 'Centro de costos ', width: 150 },
    { field: 'salario', headerName: 'Salario Base', width: 100, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
      valueFormatter: (params: any) => {
        if(params.value){
          return `${this.monedaSimbolo} ${params.value}`;
        }
        return '-';
      }
    },
    { field: 'diasLab', headerName: 'Días laborados', headerClass: 'derechaencabezado', width: 100,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
    },
    { field: 'horasExt', headerName: 'Horas extras', headerClass: 'derechaencabezado', width: 100,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
    },

    {
      field: 'sueldoOrd', headerName: 'Sueldo ordinario', headerClass: 'derechaencabezado', width: 100,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
      valueFormatter: (params: any) => {
        if(params.value){
          return `${this.monedaSimbolo} ${params.value}`;
        }
        return '-';
      }
    },
    { field: 'bonifDecr', headerName: 'Bonificación decreto "37-2001"', width: 100, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
      valueFormatter: (params: any) => {
        if(params.value){
          return `${this.monedaSimbolo} ${params.value}`;
        }
        return '-';
      }
    },
    { field: 'bonificacion', headerName: 'Bonificación Decreto "78-89" (KPIs)', headerClass: 'derechaencabezado', width: 100,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
    },
    { field: 'totalDevengado', headerName: 'TOTAL DEVENGADO', width: 120, headerClass: 'derechaencabezado',
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
      valueFormatter: (params: any) => {
        if(params.value){
          return `${this.monedaSimbolo} ${params.value}`;
        }
        return '-';
      }
    },
    { headerName: "Descuentos Trabajador", headerClass: 'centrarencabezado',
      children: [
        {
          field: "igssLaboral",
          headerName: "IGSS Laboral 4.83%",
          width: 50,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
          valueFormatter: (params: any) => {
            if(params.value){
              return `${this.monedaSimbolo} ${params.value}`;
            }
            return '-';
          }
        },
        {
          field: "israsalariados",
          headerName: "ISR Asalariados",
          width: 50,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
          valueFormatter: (params: any) => {
            if(params.value){
              return `${this.monedaSimbolo} ${params.value}`;
            }
            return '-';
          }
        },
        {
          field: "otrosDescuentos",
          headerName: "Otros descuentos",
          width: 100,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
          valueFormatter: (params: any) => {
            if(params.value){
              return `${this.monedaSimbolo} ${params.value}`;
            }
            return '-';
          }
        },
      ],
    },
    { headerName: "Aporte empleador", headerClass: 'centrarencabezado',
      children: [
        {
          field: "igrAsalariados",
          headerName: "IGSS Asalariados 5%",
          width: 100,
          headerClass: 'derechaencabezado',
          cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center', },
          cellClass: (params: any) => {
            return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
          },
          valueFormatter: (params: any) => {
            if(params.value){
              return `${this.monedaSimbolo} ${params.value}`;
            }
            return '-';
          }
        },
      ],
    },
    { headerName: "TOTAL LíQUIDO A PAGAR", field:'totalPagar' ,headerClass: 'totalpagar', width: 90,
      cellStyle: { textAlign: 'right', display: 'flex', justifyContent: 'right', alignItems: 'center' },
      cellClass: (params: any) => {
        return params.rowIndex === params.api.getDisplayedRowCount() - 1 ? 'colortotal' : '';
      },
      valueFormatter: (params: any) => {
        if(params.value){
          return `${this.monedaSimbolo} ${params.value}`;
        }
        return '-';
      }
    },

  ]

  constructor(private modalController: ModalController) { }

  ngOnInit() {
    this.cargarTablaporPais()
   }

  cargarTablaporPais(){
    if(this.pais == 'GT'){
      this.colDefs = this.colDefsGuatemala;
    }
    if(this.pais == 'EC'){
      this.colDefs = this.colDefsDefEcuador;
    }
    else {
      this.colDefs = this.colDefsDefecto;
    }
  }

  cerrarModal() {
    this.modalController.dismiss(null, 'cancel');
  }

  guardar() {
    // Obtener los datos actualizados de la tabla
    const datosActualizados = this.gridApi?.getRenderedNodes().map(node => node.data) || [];
    this.modalController.dismiss(datosActualizados, 'confirm');
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

}
