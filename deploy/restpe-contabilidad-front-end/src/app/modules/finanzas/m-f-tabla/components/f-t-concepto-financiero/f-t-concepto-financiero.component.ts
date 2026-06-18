import {
  Component,
  OnInit,
  inject,
  effect,
  OnDestroy,
  Signal,
  computed,
} from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import {
  ColDef,
  ColGroupDef,
  GridApi,
  GridReadyEvent,
} from 'ag-grid-community';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ToastService } from 'src/app/ui/services/toast.service';
import { ModalConfirmationComponent } from 'src/app/ui/modal-confirmation/modal-confirmation.component';
import { CanComponentDeactivate } from 'src/app/auth/guards/can-deactivate.guard';

// Font Awesome Icons
import { faBook, faSearch } from '@fortawesome/pro-regular-svg-icons';
import {
  faAngleDown,
  faCirclePlus,
  faDownload,
  faRotateRight,
} from '@fortawesome/pro-solid-svg-icons';
import { ConceptoFinancieroFacade } from 'src/app/modules/finanzas/application/facades/concepto-financiero.facade';

import { ConceptoFinancieroEntity } from 'src/app/modules/finanzas/domain/models/concepto-financiero.entity';

import { debounceTime, distinctUntilChanged, Subject } from 'rxjs';
import { MatrizContableFacade } from '@modules/activos/application/facades/matriz-contable.facade';
import { MatrizContableEntity } from '@modules/activos/domain/models/matriz-contable.entity';
import { format } from 'date-fns';
import { ConceptoFinancieroFeedbackEffects } from '@modules/finanzas/effects/concepto-financiero-feedback.effect';

@Component({
  selector: 'app-f-t-concepto-financiero',
  templateUrl: './f-t-concepto-financiero.component.html',
  styleUrls: ['./f-t-concepto-financiero.component.scss'],
  standalone: false,
})
export class FTConceptoFinancieroComponent
  implements OnInit, CanComponentDeactivate, OnDestroy
{
  private buscarSubject = new Subject<string>();
  // ── Inyecciones ─────────────────────────────────────────────────────────────
  private readonly matrizContableFacade = inject(MatrizContableFacade);
  private readonly conceptoFacade = inject(ConceptoFinancieroFacade);

  //MUESTRA LOS TOAST DE ÉXITO O ERROR CUANDO SE GUARDA O ACTUALIZA UN CONCEPTO FINANCIERO
  private readonly conceptoEffects = inject(ConceptoFinancieroFeedbackEffects);

  // ── Signals expuestos al template ────────────────────────────────────────────
  readonly isLoading = this.conceptoFacade.isLoading;

  // Font Awesome Icons
  farBook = faBook;
  farSearch = faSearch;
  fasAngleDown = faAngleDown;
  fasCirclePlus = faCirclePlus;
  fasDownload = faDownload;
  fasRotateRight = faRotateRight;

  mostrartabla = true;
  private gridApi!: GridApi;
  fechaCreacion: Date | undefined;
  filaSeleccionada: any = null;
  conceptoFinancieroForm!: FormGroup;
  campoNuevo: boolean = true;
  mostrarNumeroDocumento: boolean = true;
  disabledBoton: boolean = true;
  disabledBotonNuevo: boolean = true;
  valoresOriginales: any = null;
  formularioInicial: any = null;
  formularioModificado: boolean = false;

  errorGuardar: string | null = null;
  errorActualizar: string | null = null;
  errorObtenerMatriz: string | null = null;
  errorObtenerConceptos: string | null = null;
  resultGuardar: ConceptoFinancieroEntity | null = null;
  resultActualizar: ConceptoFinancieroEntity | null = null;

  matrizContable: Signal<MatrizContableEntity[]> = computed(() =>
    //Filtramos y mostramos en select solo activos
    this.matrizContableFacade
      .matrizContable()
      .filter((item) => item.matriz_contable_estado === '1'),
  );

  tiposMovimiento = [
    { id: 'ingreso', nombre: 'Ingreso' },
    { id: 'egreso', nombre: 'Egreso' },
    { id: 'transferencia', nombre: 'Transferencia' },
    { id: 'ajuste', nombre: 'Ajuste' },
  ];

  categorias = [
    // { id: 'servicios', nombre: 'Servicios' },
    // { id: 'ventas', nombre: 'Ventas' },
    // { id: 'personal', nombre: 'Personal' },
    // { id: 'financiero', nombre: 'Financiero' },
    // { id: 'compras', nombre: 'Compras' }
    { id: 'operativo', nombre: 'Operativo' },
    { id: 'financiero', nombre: 'Financiero' },
    { id: 'extraordinario', nombre: 'Extraordinario' },
    { id: 'otros', nombre: 'Otros' },
  ];

  naturalezasContables = [
    // { id: 'gasto', nombre: 'Gasto' },
    // { id: 'ingreso', nombre: 'Ingreso' },
    // { id: 'activo', nombre: 'Activo' },
    // { id: 'pasivo', nombre: 'Pasivo' }
    { id: 'debito', nombre: 'Débito' },
    { id: 'credito', nombre: 'Crédito' },
  ];

  cuentasContables = [
    { id: '10101', nombre: '10101 - Caja general' },
    { id: '10102', nombre: '10102 - Bancos' },
    { id: '60111', nombre: '60111 - Mercaderías' },
    { id: '62111', nombre: '62111 - Sueldos y salarios' },
    { id: '63111', nombre: '63111 - Servicios prestados por terceros' },
    { id: '70111', nombre: '70111 - Ventas' },
    { id: '77111', nombre: '77111 - Ingresos financieros' },
  ];

  origenes = [
    { id: 'origen', nombre: 'Origen' },
    { id: 'destino', nombre: 'Destino' },
  ];

  destinos = [
    // { id: 'caja', nombre: 'Caja' },
    // { id: 'banco', nombre: 'Banco' },
    { id: 'proveedor', nombre: 'Proveedor' },
    { id: 'cliente', nombre: 'Cliente' },
    { id: 'empleados', nombre: 'Empleado' },
    { id: 'entidad', nombre: 'Entidad bancaria' },
    { id: 'otro', nombre: 'Otro' },
  ];

  columnTypes = {
    default: {
      resizable: false,
      sortable: false,
      filter: false,
      floatingFilter: false,
    },
  };

  colDefs: (ColDef | ColGroupDef)[] = [
    { field: 'concepto_codigo', headerName: 'Código', width: 90, filter: true },
    {
      field: 'concepto_nombre',
      headerName: 'Nombre',
      flex: 1,
      minWidth: 200,
      filter: true,
    },
    // {
    //   field: 'concepto_tipo_movimiento',
    //   headerName: 'Tipo de movimiento',
    //   width: 140,
    //   filter: true,
    // },
    // {
    //   field: 'concepto_categoria',
    //   headerName: 'Categoría',
    //   width: 130,
    //   filter: true,
    // },
    // {
    //   field: 'concepto_naturaleza_contable',
    //   headerName: 'Naturaleza contable',
    //   width: 150,
    //   filter: true,
    // },
    // {
    //   field: 'concepto_cuenta_contable',
    //   headerName: 'Cuenta Contable',
    //   width: 130,
    // },
    // { field: 'concepto_origen', headerName: 'Origen', width: 100 },
    // { field: 'concepto_destino', headerName: 'Destino', width: 100 },
    // {
    //   field: 'concepto_created_by',
    //   headerName: 'Creado por',
    //   width: 150,
    // },
    // {
    //   field: 'concepto_fecha_creacion',
    //   headerName: 'Fecha de creación',
    //   width: 150,
    // },
    // {
    //   field: 'concepto_updated_by',
    //   headerName: 'Actualizado por',
    //   width: 150,
    // },
    // {
    //   field: 'concepto_fec_modificacion',
    //   headerName: 'Última actualización',
    //   width: 150,
    // },
    // {
    //   headerName: 'Matriz Contable',
    //   children: [
    //     {
    //       headerName: 'Codigo',
    //       width: 100,
    //       valueGetter: (params: any) => {
    //         return params.data?.concepto_matriz_contable_codigo
    //           ? params.data.concepto_matriz_contable_codigo
    //           : '-';
    //       },
    //     },
    //     {
    //       headerName: 'Nombre',
    //       flex: 1,
    //       minWidth: 150,
    //       valueGetter: (params: any) => {
    //         return params.data?.concepto_matriz_contable_descripcion
    //           ? params.data.concepto_matriz_contable_descripcion
    //           : '-';
    //       },
    //     },
    //   ],
    // },
    {
      headerName: 'Matriz Contable Codigo',
      width: 170,
      valueGetter: (params: any) => {
        return params.data?.concepto_matriz_contable_codigo
          ? params.data.concepto_matriz_contable_codigo
          : '-';
      },
    },
    {
      headerName: 'Matriz Contable Nombre',
      flex: 1,
      minWidth: 150,
      valueGetter: (params: any) => {
        return params.data?.concepto_matriz_contable_descripcion
          ? params.data.concepto_matriz_contable_descripcion
          : '-';
      },
    },
    {
      field: 'concepto_estado_flag',
      headerName: 'Estado',
      width: 100,
      headerClass: 'centrarencabezado',
      filter: true,
      cellStyle: {
        textAlign: 'center',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
      // 👇 1. ESTO HACE QUE EL FILTRO RECONOZCA LOS TEXTOS AL BUSCAR O DESPLEGAR
      valueFormatter: (params: any) => {
        return params.value === '1' || params.value === 1
          ? 'Activo'
          : 'Inactivo';
      },

      // 👇 2. ESTO SINCRO_NIZA EL COMPORTAMIENTO INTERNO DEL BUSCADOR
      filterParams: {
        valueFormatter: (params: any) => {
          return params.value === '1' || params.value === 1
            ? 'Activo'
            : 'Inactivo';
        },
      },
      cellRenderer: (params: any) => {
        const color =
          params.value === '1'
            ? 'bg-[#DCFDE7] text-[#16A34A]'
            : 'bg-[#FFE5E5] text-[#D32F2F]';
        return `<span class="badge-table ${color}">${params.value === '1' ? 'Activo' : 'Inactivo'}</span>`;
      },
    },
    // {
    //   field: 'concepto_estado',
    //   headerName: 'Estado',
    //   width: 100,
    //   headerClass: 'centrarencabezado',
    //   filter: true,
    //   cellStyle: { textAlign: 'center', display: 'flex', justifyContent: 'center', alignItems: 'center' },
    //   cellRenderer: (params: any) => {
    //     const color = params.value === 'Activo' ? 'bg-[#DCFDE7] text-[#16A34A]' : 'bg-[#FFE5E5] text-[#D32F2F]';
    //     return `<span class="badge-table ${color}">${params.value}</span>`;
    //   }
    // }
  ];

  rowData: ConceptoFinancieroEntity[] = [];

  localeText = {
    page: 'Página',
    of: 'de',
    to: 'a',
    next: 'Siguiente',
    last: 'Último',
    first: 'Primero',
    previous: 'Anterior',
    noRowsToShow: 'No hay filas para mostrar',
    loadingOoo: 'Cargando...',
  };

  textoSearch: string = '';

  constructor(
    private modalController: ModalController,
    private formBuilder: FormBuilder,
    private toastService: ToastService,
  ) {
    // Sincronizar signal del store con el array del grid
    effect(() => {
      const conceptosOriginales = this.conceptoFacade.conceptos();
      const matricesOriginales = this.matrizContableFacade.matrizContable();

      if (!conceptosOriginales.length) {
        this.rowData = [];
        if (this.gridApi) this.gridApi.setGridOption('rowData', this.rowData);
        return;
      }

      // const matrizMap = new Map<string, any>(
      //   matricesOriginales
      //     .filter((m) => m.id !== undefined && m.id !== null)
      //     .map((m) => [String(m.id), m]),
      // );

      const matrizMap = new Map<number, any>(
        matricesOriginales
          .filter((m) => m.id !== undefined && m.id !== null)
          .map((m) => [m.id as number, m]),
      );

      this.rowData = conceptosOriginales.map((concepto) => {
        const idMatriz = concepto.concepto_matriz_contable_id;
        const matriz =
          idMatriz !== null && idMatriz !== undefined
            ? matrizMap.get(idMatriz)
            : null;
        if (!matriz) return { ...concepto };

        return {
          ...concepto,
          concepto_matriz_contable_codigo: matriz.matriz_contable_codigo,
          concepto_matriz_contable_descripcion:
            matriz.matriz_contable_descripcion,
        };
      });

      //   this.rowData = conceptosOriginales
      //     .map((concepto) => {
      //       const idMatriz = String(concepto.concepto_matriz_contable_id);
      //       const matriz = idMatriz ? matrizMap.get(String(idMatriz)) : null;
      //       console.log('Concepto:', concepto);
      //       console.log('Matriz encontrada para concepto:', matriz);
      //       if (!matriz) return { ...concepto }; // Si la API de matrices no ha respondido, el concepto se muestra intacto

      //       return {
      //         ...concepto,
      //         concepto_matriz_contable_codigo: matriz.matriz_contable_codigo,
      //         concepto_matriz_contable_descripcion:
      //           matriz.matriz_contable_descripcion,
      //       };
      //     })
      //     .reverse();

      if (this.gridApi) {
        this.gridApi.setGridOption('rowData', this.rowData);
      }
    });

    effect(() => {
      this.resultGuardar = this.conceptoFacade.resultGuardar();
      this.resultActualizar = this.conceptoFacade.resultActualizar();

      if (this.resultActualizar || this.resultGuardar) {
        this.conceptoFacade.cargarConceptos();
      }
    });

    this.conceptoFinancieroForm = this.formBuilder.group({
      nombre: ['', Validators.required],
      // tipoMovimiento: ['', Validators.required],
      // categoria: ['', Validators.required],
      // naturalezaContable: ['', Validators.required],
      // cuentaContable: ['', Validators.required],
      // origen: ['origen', Validators.required],
      // destino: ['', Validators.required],
      // estado: ['activo', Validators.required],
      flagEstado: ['1', Validators.required],
      // asociarDocumento: ['si', Validators.required],
      // numeroDocumento: [''],
      fechaCreacion: [{ value: this.obtenerFechaActual(), disabled: true }],
      matrizContableId: [0, Validators.required],
    });
  }

  obtenerFechaActual(): string {
    const hoy = new Date();
    const dia = String(hoy.getDate()).padStart(2, '0');
    const mes = String(hoy.getMonth() + 1).padStart(2, '0');
    const anio = hoy.getFullYear();
    return `${dia}/${mes}/${anio}`;
  }

  ngOnInit() {
    // Cargar conceptos desde el servidor
    this.matrizContableFacade.cargarMatrizContable();
    this.conceptoFacade.cargarConceptos();

    // Suscribirse a cambios del formulario para detectar modificaciones
    this.conceptoFinancieroForm.valueChanges.subscribe(() => {
      this.verificarCambios();
      this.actualizarEstadoBoton();
      this.verificarCambiosEnFormulario();
    });

    // Guardar estado inicial del formulario
    this.formularioInicial = this.conceptoFinancieroForm.value;
    this.actualizarEstadoBoton();
    this.actualizarEstadoBotonNuevo();

    // Configuramos el buscador con un retraso de 300ms
    this.buscarSubject
      .pipe(
        debounceTime(300),
        distinctUntilChanged(), // Solo busca si el texto realmente cambió
      )
      .subscribe((texto) => {
        if (this.gridApi) {
          // El Quick Filter de AG-Grid hace toda la magia por ti
          this.gridApi.setGridOption('quickFilterText', texto);
        }
      });
  }

  private verificarCambiosEnFormulario() {
    // Verificar si hay algún campo con valor (excepto fechaCreacion, origen por defecto, estado y asociarDocumento por defecto)
    const valores = this.conceptoFinancieroForm.value;

    const tieneValores =
      (valores.nombre && String(valores.nombre).trim() !== '') ||
      valores.tipoMovimiento ||
      valores.categoria ||
      valores.naturalezaContable ||
      valores.cuentaContable ||
      valores.destino ||
      (valores.numeroDocumento &&
        String(valores.numeroDocumento).trim() !== '');

    // Si hay valores en el formulario Y NO hay fila seleccionada, habilitar el botón
    if (tieneValores && !this.filaSeleccionada) {
      this.disabledBotonNuevo = false;
    } else if (this.filaSeleccionada) {
      // Si hay fila seleccionada, siempre habilitar
      this.disabledBotonNuevo = false;
    } else {
      // Si no hay valores ni fila seleccionada, deshabilitar
      this.disabledBotonNuevo = true;
    }
  }

  private actualizarEstadoBotonNuevo() {
    this.verificarCambiosEnFormulario();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  onCellClicked(event: any) {
    const data = event.data;

    // Validar si hay cambios sin guardar
    if (this.formularioModificado) {
      this.mostrarModalConfirmacion().then((confirmar) => {
        if (!confirmar) {
          // Usuario canceló, deseleccionar la nueva fila y mantener la anterior
          if (this.filaSeleccionada) {
            // Reseleccionar la fila que estaba seleccionada antes
            setTimeout(() => {
              this.gridApi.deselectAll();
              this.gridApi.forEachNode((node) => {
                if (
                  node.data.concepto_codigo ===
                  this.filaSeleccionada.concepto_codigo
                ) {
                  node.setSelected(true);
                }
              });
            }, 0);
          } else {
            // Si no había fila seleccionada, solo deseleccionar todo
            this.gridApi.deselectAll();
          }
          return;
        }
        // Si confirma, cargar la nueva fila
        this.cargarDatosFilaSeleccionada(data, event.node);
      });
    } else {
      // Sin cambios, cargar directamente
      this.cargarDatosFilaSeleccionada(data, event.node);
    }
  }

  private cargarDatosFilaSeleccionada(data: any, node: any): void {
    console.log('Concepto seleccionado:', data);
    this.campoNuevo = false;
    this.filaSeleccionada = data;
    this.gridApi.deselectAll();

    // Seleccionar el nodo en AG-Grid
    if (node) {
      node.setSelected(true);
    }

    if (this.filaSeleccionada) {
      // Buscar los objetos completos en los arrays
      const cuentaEncontrada = this.cuentasContables.find(
        (c) => c.id === this.filaSeleccionada.concepto_cuenta_contable,
      );

      const tipoMovimientoEncontrado = this.tiposMovimiento.find(
        (t) =>
          t.nombre.toLowerCase() ===
          this.filaSeleccionada.concepto_tipo_movimiento?.toLowerCase(),
      );

      const categoriaEncontrada = this.categorias.find(
        (c) =>
          c.nombre.toLowerCase() ===
          this.filaSeleccionada.concepto_categoria?.toLowerCase(),
      );

      const naturalezaEncontrada = this.naturalezasContables.find(
        (n) =>
          n.nombre.toLowerCase() ===
          this.filaSeleccionada.concepto_naturaleza_contable?.toLowerCase(),
      );

      const origenEncontrado = this.origenes.find(
        (o) =>
          o.nombre.toLowerCase() ===
          this.filaSeleccionada.concepto_origen?.toLowerCase(),
      );

      const destinoEncontrado = this.destinos.find(
        (d) =>
          d.nombre.toLowerCase() ===
          this.filaSeleccionada.concepto_destino?.toLowerCase(),
      );

      // this.conceptoFinancieroForm.patchValue({
      //   nombre: this.filaSeleccionada.concepto_nombre || '',
      //   tipoMovimiento: tipoMovimientoEncontrado
      //     ? tipoMovimientoEncontrado.id
      //     : '',
      //   categoria: categoriaEncontrada ? categoriaEncontrada.id : '',
      //   naturalezaContable: naturalezaEncontrada ? naturalezaEncontrada.id : '',
      //   cuentaContable: cuentaEncontrada ? cuentaEncontrada.id : '',
      //   origen: origenEncontrado ? origenEncontrado.id : '',
      //   destino: destinoEncontrado ? destinoEncontrado.id : '',
      //   estado:
      //     this.filaSeleccionada.concepto_estado?.toLowerCase() === 'activo'
      //       ? 'activo'
      //       : 'inactivo',
      //   asociarDocumento:
      //     this.filaSeleccionada.concepto_asociar_documento ||
      //     (this.filaSeleccionada.concepto_numero_documento ? 'si' : 'no'),
      //   numeroDocumento: this.filaSeleccionada.concepto_numero_documento || '',
      //   fechaCreacion:
      //     this.filaSeleccionada.concepto_fecha_creacion ||
      //     this.obtenerFechaActual(),
      // });

      this.conceptoFinancieroForm.patchValue({
        nombre: data.concepto_nombre,
        flagEstado: data.concepto_estado === 'Activo' ? '1' : '0',
        fechaCreacion: data.concepto_fecha_creacion,
        matrizContableId: data.concepto_matriz_contable_id,
      });

      // Guardar nuevo estado inicial del formulario
      this.formularioInicial = this.conceptoFinancieroForm.value;
      this.formularioModificado = false;
      this.valoresOriginales = JSON.parse(
        JSON.stringify(this.conceptoFinancieroForm.value),
      );

      this.actualizarEstadoBoton();
    }
  }

  onBtReset(): void {
    this.conceptoFacade.cargarConceptos();
  }

  private mapearTipoMovimientoInverso(tipo: string): string {
    return tipo?.toLowerCase() || '';
  }

  private mapearCategoriaInverso(categoria: string): string {
    const mapa: any = {
      Servicios: 'servicios',
      Ventas: 'ventas',
      Personal: 'personal',
      Financiero: 'financiero',
      Compras: 'compras',
    };
    return mapa[categoria] || '';
  }

  private mapearNaturalezaInverso(naturaleza: string): string {
    return naturaleza?.toLowerCase() || '';
  }

  private mapearDestinoInverso(destino: string): string {
    const mapa: any = {
      Caja: 'caja',
      Banco: 'banco',
      Cliente: 'cliente',
      Proveedor: 'proveedor',
      Empleados: 'empleados',
    };
    return mapa[destino] || '';
  }

  onCuentaContableSelected(cuenta: any) {
    console.log('Cuenta contable seleccionada:', cuenta);
  }

  onAsociarDocumentoChange(event: any) {
    const valor = event.detail.value;
    this.mostrarNumeroDocumento = valor === 'si';

    if (!this.mostrarNumeroDocumento) {
      this.conceptoFinancieroForm.patchValue({ numeroDocumento: '' });
    }
  }

  private actualizarEstadoBoton() {
    if (this.campoNuevo) {
      // Modo nuevo: validar que todos los campos obligatorios estén completos
      const form = this.conceptoFinancieroForm.value;
      const camposObligatorios = [
        form.nombre,
        form.estado,
        form.fechaCreacion,
        form.matrizContableId,
      ];

      const todosCompletos = camposObligatorios.every(
        (campo) => campo !== null && campo !== undefined && campo !== '',
      );

      this.disabledBoton = !todosCompletos;
    } else {
      // Modo edición: verificar si hay cambios respecto al original
      if (this.valoresOriginales) {
        const valoresActuales = this.conceptoFinancieroForm.value;
        const hayCambios =
          JSON.stringify(valoresActuales) !==
          JSON.stringify(this.valoresOriginales);
        this.disabledBoton = !hayCambios;
      } else {
        this.disabledBoton = false;
      }
    }
  }
  // Método para verificar si el formulario ha sido modificado
  private verificarCambios(): void {
    if (!this.formularioInicial) {
      this.formularioModificado = false;
      return;
    }
    const valorActual = this.conceptoFinancieroForm.value;
    this.formularioModificado =
      JSON.stringify(this.formularioInicial) !== JSON.stringify(valorActual);
  }

  // Método para mostrar modal de confirmación
  private async mostrarModalConfirmacion(): Promise<boolean> {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Continuar sin guardar',
        title: '¿Seguro que quieres continuar sin guardar la información?',
        message: 'Si sales ahora, perderás la información ingresada',
        btnOkTxt: 'Continuar',
        btnCancelTxt: 'Cancelar',
      },
    });

    await modal.present();
    const { data } = await modal.onWillDismiss();
    return data === true;
  }

  // Implementación del guard CanDeactivate
  async canDeactivate(): Promise<boolean> {
    if (this.formularioModificado) {
      return await this.mostrarModalConfirmacion();
    }
    return true;
  }

  async botonNuevoConcepto() {
    // Validar cambios antes de limpiar
    if (this.formularioModificado) {
      const confirmar = await this.mostrarModalConfirmacion();

      if (!confirmar) {
        return; // Cancelar acción
      }
    }

    this.campoNuevo = true;
    this.filaSeleccionada = null; // Limpiar la fila seleccionada
    this.gridApi?.deselectAll(); // Deseleccionar filas en la tabla
    this.conceptoFinancieroForm.reset({
      nombre: '',
      flagEstado: '1',
      fechaCreacion: this.obtenerFechaActual(),
      matrizContableId: '',
    });

    // Actualizar estado inicial del formulario
    this.formularioInicial = this.conceptoFinancieroForm.value;
    this.formularioModificado = false;
    this.valoresOriginales = null;
    this.mostrarNumeroDocumento = true;

    this.actualizarEstadoBoton();
  }

  private resetearFormulario(): void {
    this.campoNuevo = true;
    this.filaSeleccionada = null;
    this.valoresOriginales = null;
    this.conceptoFinancieroForm.reset({
      nombre: '',
      estado: '1',
      matrizContableId: '',
      fechaCreacion: this.obtenerFechaActual(),
    });

    // Actualizar el formularioInicial para que no considere esto como cambio
    this.formularioInicial = this.conceptoFinancieroForm.value;
    this.formularioModificado = false;

    this.mostrarNumeroDocumento = true;

    // Deseleccionar todas las filas de la tabla
    if (this.gridApi) {
      this.gridApi.deselectAll();
    }

    this.actualizarEstadoBoton();
  }

  botonGuardar() {
    // Validar que el formulario sea válido
    if (this.conceptoFinancieroForm.invalid) {
      this.toastService.warning('Por favor, completa los campos requeridos');
      return;
    }
    const form = this.conceptoFinancieroForm.getRawValue();
    const cuentaEncontrada = this.cuentasContables.find(
      (c) => c.id === form.cuentaContable,
    );

    // const payload: Partial<ConceptoFinancieroEntity> = {
    //   concepto_nombre: form.nombre,
    //   concepto_tipo_movimiento: this.convertirTipoMovimientoParaTabla(
    //     form.tipoMovimiento,
    //   ),
    //   concepto_categoria: this.convertirCategoriaParaTabla(form.categoria),
    //   concepto_naturaleza_contable: this.convertirNaturalezaParaTabla(
    //     form.naturalezaContable,
    //   ),
    //   concepto_cuenta_contable: cuentaEncontrada
    //     ? cuentaEncontrada.id
    //     : form.cuentaContable,
    //   concepto_origen: this.capitalizarPrimeraLetra(form.origen),
    //   concepto_destino: this.convertirDestinoParaTabla(form.destino),
    //   concepto_estado: form.estado === 'activo' ? 'Activo' : 'Inactivo',
    //   concepto_numero_documento: form.numeroDocumento || '',
    //   concepto_fecha_creacion: this.obtenerFechaActual(),
    // };
    const payload: Partial<ConceptoFinancieroEntity> = {
      concepto_nombre: form.nombre,
      concepto_estado: form.flagEstado,
      concepto_fecha_creacion: form.fechaCreacion,
      concepto_matriz_contable_id: form.matrizContableId,
    };

    if (this.campoNuevo) {
      // Generar nuevo código provisional (el servidor asignará el definitivo)
      const nuevoNumero = this.conceptoFacade.conceptos().length + 1;
      payload.concepto_codigo = `CF-${String(nuevoNumero).padStart(3, '0')}`;

      console.log('Payload', payload);

      this.conceptoFacade.guardarConcepto(payload);

      // Actualizar estado antes de limpiar
      this.formularioInicial = this.conceptoFinancieroForm.value;
      this.formularioModificado = false;
    } else if (this.filaSeleccionada) {
      console.log('Payload', payload);
      payload.concepto_codigo = this.filaSeleccionada.concepto_codigo; // Asegurar que el código se mantenga igual
      this.conceptoFacade.actualizarConcepto(
        this.filaSeleccionada.concepto_id,
        payload,
      );

      // Actualizar valores originales para deshabilitar el botón
      this.valoresOriginales = { ...this.conceptoFinancieroForm.value };
      this.formularioModificado = false;
      this.actualizarEstadoBoton();
    }
  }

  private convertirTipoMovimientoParaTabla(tipo: string): string {
    const mapa: any = {
      ingreso: 'Ingreso',
      egreso: 'Egreso',
    };
    return mapa[tipo] || tipo;
  }

  private convertirCategoriaParaTabla(categoria: string): string {
    const mapa: any = {
      operativo: 'Operativo',
      financiero: 'Financiero',
      extraordinario: 'Extraordinario',
      otros: 'Otros',
    };
    return mapa[categoria] || categoria;
  }

  private convertirNaturalezaParaTabla(naturaleza: string): string {
    const mapa: any = {
      debito: 'Débito',
      credito: 'Crédito',
    };
    return mapa[naturaleza] || naturaleza;
  }

  private convertirDestinoParaTabla(destino: string): string {
    const mapa: any = {
      proveedor: 'Proveedor',
      cliente: 'Cliente',
      empleados: 'Empleado',
      entidad: 'Entidad bancaria',
      otro: 'Otro',
    };
    return mapa[destino] || destino;
  }

  private capitalizarPrimeraLetra(texto: string): string {
    if (!texto) return texto;
    return texto.charAt(0).toUpperCase() + texto.slice(1);
  }

  async modalverActualizaciones() {
    // Definir las columnas
    const colDefs = [
      { headerName: 'Fecha y hora', field: 'fechaHora', width: 150 },
      { headerName: 'Usuario', field: 'usuario', width: 120 },
      {
        headerName: 'Acción',
        field: 'accion',
        width: 150,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
      {
        headerName: 'Detalle del cambio',
        field: 'detalleCambio',
        flex: 1,
        wrapText: true,
        autoHeight: true,
        cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
      },
    ];

    // Datos de ejemplo
    const rowData = [
      {
        fechaHora: '12/11/2025 10:30',
        usuario: 'Juan Pérez',
        accion: 'Creación',
        detalleCambio: 'Registro inicial del siniestro',
      },
      {
        fechaHora: '12/11/2025 14:15',
        usuario: 'María González',
        accion: 'Actualización',
        detalleCambio: 'Cambio de estado de "Reportado" a "En evaluación"',
      },
      {
        fechaHora: '13/11/2025 09:00',
        usuario: 'Carlos Rodríguez',
        accion: 'Actualización',
        detalleCambio: 'Agregó documentación de respaldo (3 archivos)',
      },
      {
        fechaHora: '13/11/2025 16:45',
        usuario: 'Ana Martínez',
        accion: 'Actualización',
        detalleCambio: 'Cambio de estado de "En evaluación" a "Aprobado"',
      },
    ];

    const modal = await this.modalController.create({
      component: ModalVerActualizacionesComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Historial de Actualizaciones del Reclamo SIN-0000000007',
        rowData: rowData,
        colDefs: colDefs,
        anchoModal: '700px',
      },
    });

    await modal.present();
  }

  exportarExcel(): void {
    if (!this.gridApi) {
      return;
    }
    const fechaFormateada = format(new Date(), 'yyyy-MM-dd_HH-mm-ss');
    this.gridApi.exportDataAsExcel({
      fileName: `conceptos_financieros_${fechaFormateada}.xlsx`,
      sheetName: `conceptos_financieros`.substring(0, 28),
    });
  }

  onBuscar() {
    this.buscarSubject.next(this.textoSearch);
  }

  botonCancelar() {
    this.resetearFormulario();
    this.actualizarEstadoBoton();
    this.botonNuevoConcepto();
  }

  ngOnDestroy() {
    this.conceptoFacade.limpiarStates();
    this.matrizContableFacade.limpiarErrores();
    this.buscarSubject.complete();
  }
}
