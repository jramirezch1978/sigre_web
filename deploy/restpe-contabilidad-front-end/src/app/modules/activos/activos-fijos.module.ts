import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { IonicModule } from '@ionic/angular';

import { ActivosFijosPageRoutingModule } from './activos-fijos-routing.module';

import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { AgGridSharedModule } from 'src/app/shared/ag-grid-shared.module';
import { UiModule } from 'src/app/ui/ui.module';
import { ActivosfijosOperacionesRegistroactivosComponent } from './m-af-tabla/pages/af-o-registroactivos/activosfijos-operaciones-registroactivos.component';
import { ActivosfijosOperacionesRegistrotrasladoComponent } from './m-af-operaciones/pages/af-o-registrotraslado/activosfijos-operaciones-registrotraslado.component';
import { ActivosfijosOperacionesAprobaciontrasladoComponent } from './m-af-operaciones/pages/af-o-aprobaciontraslado/activosfijos-operaciones-aprobaciontraslado.component';
import { ActivosfijosOperacionesOperacionesactivosComponent } from './m-af-operaciones/pages/af-o-operacionesactivos/activosfijos-operaciones-operacionesactivos.component';
import { ActivosfijosOperacionesPolizasseguroComponent } from './m-af-operaciones/pages/af-o-polizasseguro/activosfijos-operaciones-polizasseguro.component';
import { ActivosfijosOperacionesRevaluacionesComponent } from './m-af-operaciones/pages/af-o-revaluaciones/activosfijos-operaciones-revaluaciones.component';
import { ActivosfijosOperacionesAsignacionratiosComponent } from './m-af-operaciones/pages/af-o-asignacionratios/activosfijos-operaciones-asignacionratios.component';
// import { ActivofijoTablaUbicacionactivosComponent } from './m-af-tabla/pages/af-t-ubicacionactivos/activofijo-tabla-ubicacionactivos.component';
import { ActivofijoTablaParamoperacionesComponent } from './m-af-tabla/pages/af-t-paramoperaciones/activofijo-tabla-paramoperaciones.component';
import { ActivofijoTablaNumactivosComponent } from './m-af-tabla/pages/af-t-numactivos/activofijo-tabla-numactivos.component';
import { ActivofijoTablaNumtrasladosComponent } from './m-af-tabla/pages/af-t-numtraslados/activofijo-tabla-numtraslados.component';
import { ActivofijoTablaOperacionesComponent } from './m-af-tabla/pages/af-t-operaciones/activofijo-tabla-operaciones.component';
import { ActivofijoTablaIncidenciasComponent } from './m-af-tabla/pages/af-t-incidencias/activofijo-tabla-incidencias.component';
import { ActivofijoTablaSegurosComponent } from './m-af-tabla/pages/af-t-seguros/activofijo-tabla-seguros.component';
import { ActivofijoTablaClasifactivosComponent } from './m-af-tabla/pages/af-t-clasifactivos/activofijo-tabla-clasifactivos.component';
import { ActivofijoTablaMatrizcontableComponent } from './m-af-tabla/pages/af-t-matrizcontable/activofijo-tabla-matrizcontable.component';
import { ActivofijoReporteResumenactivofijoComponent } from './m-af-reporte/pages/af-r-resumenactivofijo/activofijo-reporte-resumenactivofijo.component';
import { ActivofijoReporteDepreciacionanualComponent } from './m-af-reporte/pages/af-r-depreciacionanual/activofijo-reporte-depreciacionanual.component';
import { ActivofijoReporteResumenrangosComponent } from './m-af-reporte/pages/af-r-resumenrangos/activofijo-reporte-resumenrangos.component';
import { ActivofijoProcesosCalculodepreciacionComponent } from './m-af-procesos/pages/af-p-calculodepreciacion/activofijo-procesos-calculodepreciacion.component';
import { ActivofijoProcesosGeneracionasientosdepreciacionComponent } from './m-af-procesos/pages/af-p-generacionasientosdepreciacion/activofijo-procesos-generacionasientosdepreciacion.component';
import { ActivofijoProcesosGeneracionasientosrevaluacionComponent } from './m-af-procesos/pages/af-p-generacionasientosrevaluacion/activofijo-procesos-generacionasientosrevaluacion.component';
import { ActivofijoProcesosGeneracionasientosindexacionComponent } from './m-af-procesos/pages/af-p-generacionasientosindexacion/activofijo-procesos-generacionasientosindexacion.component';
import { ActivofijoProcesosGeneraciondevengoaseguradoresComponent } from './m-af-procesos/pages/af-p-generaciondevengoaseguradores/activofijo-procesos-generaciondevengoaseguradores.component';
import { ActivofijoProcesosGeneracionasientossiniestroComponent } from './m-af-procesos/pages/af-p-generacionasientossiniestro/activofijo-procesos-generacionasientossiniestro.component';
import { ActivofijoTablaAseguradoresComponent } from './m-af-tabla/pages/af-t-aseguradores/activofijo-tabla-aseguradores.component';
import { ActivosfijosOperacionesRegistroactivosCrearAccesorioComponent } from './m-af-tabla/pages/af-o-registroactivos/modals/af-o-registroactivos-crear-accesorio/activosfijos-operaciones-registroactivos-crear-accesorio.component';
import { ActivosfijosOperacionesRegistroactivosCrearAdaptacionComponent } from './m-af-tabla/pages/af-o-registroactivos/modals/af-o-registroactivos-crear-adaptacion/activosfijos-operaciones-registroactivos-crear-adaptacion.component';
import { ActivosfijosOperacionesRegistroactivosCrearIncidenciaComponent } from './m-af-tabla/pages/af-o-registroactivos/modals/af-o-registroactivos-crear-incidencia/activosfijos-operaciones-registroactivos-crear-incidencia.component';
import { AfORegistroactivosRegistrarTrasladoComponent } from './m-af-tabla/pages/af-o-registroactivos/modals/af-o-registroactivos-registrar-traslado/af-o-registroactivos-registrar-traslado.component';
import { IconCellComponent } from './m-af-tabla/pages/af-t-clasifactivos/components/icon-cell/icon-cell.component';
import { IconUbicCellComponent } from './m-af-tabla/pages/af-t-ubicacionactivos/components/icon-ubic-cell/icon-ubic-cell.component';
import { ModalFormulasComponent } from './m-af-reporte/pages/af-r-depreciacionanual/modals/modal-formulas/modal-formulas.component';
import { AccesorioActionsCellComponent } from './m-af-tabla/pages/af-o-registroactivos/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { AccesorioActionsCellComponent as AsignacionratiosAccesorioActionsCellComponent } from './m-af-operaciones/pages/af-o-asignacionratios/cell-renderers/accesorio-actions-cell/accesorio-actions-cell.component';
import { ModalAsientoContableComponent } from './m-af-procesos/pages/af-p-generacionasientosdepreciacion/modal/modal-asiento-contable/modal-asiento-contable.component';
import { GeneracionsiniestroTabEvaluacionComponent } from './m-af-procesos/pages/af-p-generacionasientossiniestro/components/generacionsiniestro-tab-evaluacion/generacionsiniestro-tab-evaluacion.component';
import { GeneracionsiniestroTabGestionComponent } from './m-af-procesos/pages/af-p-generacionasientossiniestro/components/generacionsiniestro-tab-gestion/generacionsiniestro-tab-gestion.component';
import { GeneracionsiniestroTabReclamoComponent } from './m-af-procesos/pages/af-p-generacionasientossiniestro/components/generacionsiniestro-tab-reclamo/generacionsiniestro-tab-reclamo.component';
import { GeneracionsiniestroTabRegistroComponent } from './m-af-procesos/pages/af-p-generacionasientossiniestro/components/generacionsiniestro-tab-registro/generacionsiniestro-tab-registro.component';
import { ModalCancelarPolizaComponent } from './m-af-operaciones/pages/af-o-polizasseguro/modal/modal-cancelar-poliza/modal-cancelar-poliza.component';
import { ModalRenovarPolizaComponent } from './m-af-operaciones/pages/af-o-polizasseguro/modal/modal-renovar-poliza/modal-renovar-poliza.component';
import { ModalAnularOperacionComponent } from './m-af-operaciones/pages/af-o-operacionesactivos/modal/modal-anular-operacion/modal-anular-operacion.component';
import { AtTabGeneralComponent } from './m-af-operaciones/pages/af-o-aprobaciontraslado/components/at-tab-general/at-tab-general.component';
import { AtTabUbicacionComponent } from './m-af-operaciones/pages/af-o-aprobaciontraslado/components/at-tab-ubicacion/at-tab-ubicacion.component';
import { ModalRechazarTrasladoComponent } from './m-af-operaciones/pages/af-o-aprobaciontraslado/components/modals/modal-rechazar-traslado/modal-rechazar-traslado.component';
import { ModalAgregarCentroComponent } from './m-af-operaciones/pages/af-o-asignacionratios/modals/modal-agregar-centro/modal-agregar-centro.component';
import { SingleSelectFilterComponent } from './m-af-reporte/pages/af-r-resumenactivofijo/single-select-filter.component';
import { AfOVentasActivosComponent } from './m-af-operaciones/pages/af-o-ventas-activos/af-o-ventas-activos.component';
import { AfOReceptTrasladosAfComponent } from './m-af-operaciones/pages/af-o-recept-traslados-af/af-o-recept-traslados-af.component';
import { SimulationService } from 'src/app/simulation/simulation.service';
import { ACTIVO_FIJO_PROVIDERS } from './infrastructure/providers/activo-fijo.providers';
import { ASEGURADORA_PROVIDERS } from './infrastructure/providers/aseguradora.providers';
import { CLASIF_ACTIVO_PROVIDERS } from './infrastructure/providers/clasif-activo.providers';
import { INCIDENCIA_PROVIDERS } from './infrastructure/providers/incidencia.providers';
import { MATRIZ_CONTABLE_PROVIDERS } from './infrastructure/providers/matriz-contable.providers';
import { NUM_ACTIVO_PROVIDERS } from './infrastructure/providers/num-activo.providers';
import { NUM_TRASLADO_PROVIDERS } from './infrastructure/providers/num-traslado.providers';
import { OPERACION_PROVIDERS } from './infrastructure/providers/operacion.providers';
import { PARAM_OPERACION_PROVIDERS } from './infrastructure/providers/param-operacion.providers';
import { SEGURO_PROVIDERS } from './infrastructure/providers/seguro.providers';
import { UBICACION_ACTIVO_PROVIDERS } from './infrastructure/providers/ubicacion-activo.providers';
import { DEPRECIACION_ANUAL_PROVIDERS } from './infrastructure/providers/depreciacion-anual.providers';
import { RESUMEN_ACTIVO_FIJO_PROVIDERS } from './infrastructure/providers/resumen-activo-fijo.providers';
import { RESUMEN_RANGOS_PROVIDERS } from './infrastructure/providers/resumen-rangos.providers';
import { CALCULO_DEPRECIACION_PROVIDERS } from './infrastructure/providers/calculo-depreciacion.providers';
import { GENERACION_ASIENTOS_DEPRECIACION_PROVIDERS } from './infrastructure/providers/generacion-asientos-depreciacion.providers';
import { GENERACION_ASIENTOS_INDEXACION_PROVIDERS } from './infrastructure/providers/generacion-asientos-indexacion.providers';
import { GENERACION_ASIENTOS_REVALUACION_PROVIDERS } from './infrastructure/providers/generacion-asientos-revaluacion.providers';
import { GENERACION_ASIENTOS_SINIESTRO_PROVIDERS } from './infrastructure/providers/generacion-asientos-siniestro.providers';
import { GENERACION_DEVENGO_ASEGURADORES_PROVIDERS } from './infrastructure/providers/generacion-devengo-aseguradores.providers';
import { APROBACION_TRASLADO_PROVIDERS } from './infrastructure/providers/aprobacion-traslado.providers';
import { ASIGNACION_RATIOS_PROVIDERS } from './infrastructure/providers/asignacion-ratios.providers';
import { POLIZA_SEGURO_PROVIDERS } from './infrastructure/providers/poliza-seguro.providers';
import { RECEPCION_TRASLADO_PROVIDERS } from './infrastructure/providers/recepcion-traslado.providers';
import { REGISTRO_TRASLADO_PROVIDERS } from './infrastructure/providers/registro-traslado.providers';
import { REGISTRO_OPERACION_ACTIVO_PROVIDERS } from './infrastructure/providers/registro-operacion-activo.providers';
import { REVALUACION_PROVIDERS } from './infrastructure/providers/revaluacion.providers';
import { VENTA_ACTIVO_PROVIDERS } from './infrastructure/providers/venta-activo.providers';
import { PROVEEDOR_ACTIVO_PROVIDERS } from './infrastructure/providers/proveedor-activo.providers';
import { CENTRO_COSTO_PROVIDERS } from '../contabilidad/infrastructure/providers/centro-costo.providers';
import { AfORegistroactivosRevaluarComponent } from './m-af-tabla/pages/af-o-registroactivos/modals/af-o-registroactivos-revaluar/af-o-registroactivos-revaluar.component';
import { AfORegistroactivosBajaComponent } from './m-af-tabla/pages/af-o-registroactivos/modals/af-o-registroactivos-baja/af-o-registroactivos-baja.component';
import { ActivofijoTablaUbicacionactivosComponent } from './m-af-tabla/pages/af-t-ubicacionactivos/activofijo-tabla-ubicacionactivos.component';


@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    ReactiveFormsModule,
    FontAwesomeModule,
    AgGridSharedModule,
    UiModule,
    ActivosFijosPageRoutingModule
  ],
  providers: [
    SimulationService,
    ...ACTIVO_FIJO_PROVIDERS,
    ...ASEGURADORA_PROVIDERS,
    ...CLASIF_ACTIVO_PROVIDERS,
    ...INCIDENCIA_PROVIDERS,
    ...MATRIZ_CONTABLE_PROVIDERS,
    ...NUM_ACTIVO_PROVIDERS,
    ...NUM_TRASLADO_PROVIDERS,
    ...OPERACION_PROVIDERS,
    ...PARAM_OPERACION_PROVIDERS,
    ...SEGURO_PROVIDERS,
    ...UBICACION_ACTIVO_PROVIDERS,
    ...DEPRECIACION_ANUAL_PROVIDERS,
    ...RESUMEN_ACTIVO_FIJO_PROVIDERS,
    ...RESUMEN_RANGOS_PROVIDERS,
    ...CALCULO_DEPRECIACION_PROVIDERS,
    ...GENERACION_ASIENTOS_DEPRECIACION_PROVIDERS,
    ...GENERACION_ASIENTOS_INDEXACION_PROVIDERS,
    ...GENERACION_ASIENTOS_REVALUACION_PROVIDERS,
    ...GENERACION_ASIENTOS_SINIESTRO_PROVIDERS,
    ...GENERACION_DEVENGO_ASEGURADORES_PROVIDERS,
    ...APROBACION_TRASLADO_PROVIDERS,
    ...ASIGNACION_RATIOS_PROVIDERS,
    ...POLIZA_SEGURO_PROVIDERS,
    ...RECEPCION_TRASLADO_PROVIDERS,
    ...REGISTRO_TRASLADO_PROVIDERS,
    ...REGISTRO_OPERACION_ACTIVO_PROVIDERS,
    ...REVALUACION_PROVIDERS,
    ...VENTA_ACTIVO_PROVIDERS,
    ...PROVEEDOR_ACTIVO_PROVIDERS,
    ...CENTRO_COSTO_PROVIDERS,
  ],
  declarations: [
    IconCellComponent,
    ActivofijoTablaOperacionesComponent,
    ActivofijoTablaIncidenciasComponent,
    ActivofijoTablaAseguradoresComponent,
    ActivofijoTablaSegurosComponent,
    ActivofijoTablaClasifactivosComponent,
    ActivofijoTablaMatrizcontableComponent,
    ActivosfijosOperacionesRegistroactivosComponent,
    ActivosfijosOperacionesRegistrotrasladoComponent,
    ActivosfijosOperacionesAprobaciontrasladoComponent,
    ActivosfijosOperacionesOperacionesactivosComponent,
    ActivosfijosOperacionesPolizasseguroComponent,
    ActivosfijosOperacionesRevaluacionesComponent,
    ActivosfijosOperacionesAsignacionratiosComponent,
    ActivofijoTablaUbicacionactivosComponent,
    IconUbicCellComponent,
    AfORegistroactivosBajaComponent,
    ActivofijoTablaParamoperacionesComponent,
    ActivofijoTablaNumactivosComponent,
    ActivofijoTablaNumtrasladosComponent,
    ActivofijoReporteResumenactivofijoComponent,
    ActivofijoReporteDepreciacionanualComponent,
    ActivofijoReporteResumenrangosComponent,
    ActivofijoProcesosCalculodepreciacionComponent,
    ActivofijoProcesosGeneracionasientosdepreciacionComponent,
    ActivofijoProcesosGeneracionasientosrevaluacionComponent,
    ActivofijoProcesosGeneracionasientosindexacionComponent,
    ActivofijoProcesosGeneraciondevengoaseguradoresComponent,
    ActivofijoProcesosGeneracionasientossiniestroComponent,
    ActivosfijosOperacionesRegistroactivosCrearAccesorioComponent,
    ActivosfijosOperacionesRegistroactivosCrearAdaptacionComponent,
    ActivosfijosOperacionesRegistroactivosCrearIncidenciaComponent,
    AfORegistroactivosRegistrarTrasladoComponent,
    AtTabGeneralComponent,
    AfORegistroactivosRevaluarComponent,
    AtTabUbicacionComponent,
    ModalFormulasComponent,
    AccesorioActionsCellComponent,
    AsignacionratiosAccesorioActionsCellComponent,
    ModalAsientoContableComponent,
    GeneracionsiniestroTabEvaluacionComponent,
    GeneracionsiniestroTabGestionComponent,
    GeneracionsiniestroTabReclamoComponent,
    AfOVentasActivosComponent,
    GeneracionsiniestroTabRegistroComponent,
    ModalRechazarTrasladoComponent,
    ModalCancelarPolizaComponent,
    ModalRenovarPolizaComponent,
    ModalAnularOperacionComponent,
    ModalAgregarCentroComponent,
    SingleSelectFilterComponent,
    AfOReceptTrasladosAfComponent
  ]
})
export class ActivosFijosPageModule {}
