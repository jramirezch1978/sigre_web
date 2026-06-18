import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { AgGridSharedModule } from 'src/app/shared/ag-grid-shared.module';
import { UiModule } from 'src/app/ui/ui.module';
import { ApartadoContabilidadPageRoutingModule } from './apartado-contabilidad-routing.module';
import { ContabilidadTablaPlancontableComponent } from './m-c-tabla/components/c-t-plancontable/contabilidad-tabla-plancontable.component';
import { ContabilidadTablaPlancentrocostoComponent } from './m-c-tabla/components/c-t-plancentrocosto/contabilidad-tabla-plancentrocosto.component';
import { ContabilidadTablaContabilidadComponent } from './m-c-tabla/components/c-t-contabilidad/contabilidad-tabla-contabilidad.component';
import { ContabilidadTablaDetraccionesComponent } from './m-c-tabla/components/c-t-detracciones/contabilidad-tabla-detracciones.component';
import { ContabilidadTablaImpuestosComponent } from './m-c-tabla/components/c-t-impuestos/contabilidad-tabla-impuestos.component';
import { ContabilidadTablaCuentasvssubcategoriasComponent } from './m-c-tabla/components/c-t-cuentasvssubcategorias/contabilidad-tabla-cuentasvssubcategorias.component';
import { ContabilidadReporteLibrosyasientosComponent } from './m-c-reporte/components/c-r-librosyasientos/contabilidad-reporte-librosyasientos.component';
import { ContabilidadReporteMaestrocontableComponent } from './m-c-reporte/components/c-r-maestrocontable/contabilidad-reporte-maestrocontable.component';
import { ContabilidadReporteReportefinancieroComponent } from './m-c-reporte/components/c-r-reportefinanciero/contabilidad-reporte-reportefinanciero.component';
import { ContabilidadReporteValidacionComponent } from './m-c-reporte/components/c-r-validacion/contabilidad-reporte-validacion.component';
import { ContabilidadReporteAnalisiscuentacontableComponent } from './m-c-reporte/components/c-r-analisiscuentacontable/contabilidad-reporte-analisiscuentacontable.component';
import { SaldosCuentasCorrienteComponent } from './m-c-operaciones/components/saldos-cuentas-corriente/saldos-cuentas-corriente.component';
import { ModalDetalleAsientoComponent } from './m-c-operaciones/components/saldos-cuentas-corriente/modal-detalle-asiento/modal-detalle-asiento.component';
import { EyeCellAsientoComponent } from './m-c-operaciones/components/saldos-cuentas-corriente/eye-cell-asiento/eye-cell-asiento.component';
import { CentroCostosTrabajComponent } from './m-c-consultas/components/centro-costos-trabaj/centro-costos-trabaj.component';
import { GestionAsientosManualComponent } from './m-c-operaciones/components/gestion-asientos-manual/gestion-asientos-manual.component';
import { GestionAsientosAutomaticoComponent } from './m-c-operaciones/components/gestion-asientos-automatico/gestion-asientos-automatico.component';
import { AjustesReclasificacionComponent } from './m-c-operaciones/components/ajustes-reclasificacion/ajustes-reclasificacion.component';
import { ContabilidadTablaTipodecambioComponent } from './m-c-tabla/components/c-t-tipodecambio/contabilidad-tabla-tipodecambio.component';
import { CPClonacionasientosComponent } from './m-c-procesos/pages/c-p-clonacionasientos/c-p-clonacionasientos.component';
import { CPConsistenciaasientosComponent } from './m-c-procesos/pages/c-p-consistenciaasientos/c-p-consistenciaasientos.component';
import { CPGenerarlibrosComponent } from './m-c-procesos/pages/c-p-generarlibros/c-p-generarlibros.component';
import { CPProcesosajustesComponent } from './m-c-procesos/pages/c-p-procesosajustes/c-p-procesosajustes.component';
import { CPCierreContableComponent } from './m-c-procesos/pages/c-p-cierre-contable/c-p-cierre-contable.component';
import { CcCierreAnualComponent } from './m-c-procesos/pages/c-p-cierre-contable/components/cc-cierre-anual/cc-cierre-anual.component';
import { CcCierreMensualComponent } from './m-c-procesos/pages/c-p-cierre-contable/components/cc-cierre-mensual/cc-cierre-mensual.component';
import { ModalCuentasContablesComponent } from './m-c-tabla/components/c-t-contabilidad/components/modal-cuentas-contables/modal-cuentas-contables.component';
import { CTRegistroUitComponent } from './m-c-tabla/components/c-t-registro-uit/c-t-registro-uit.component';
import { ModalNuevoTipoComponent } from './m-c-tabla/components/c-t-plancentrocosto/modals/modal-nuevo-tipo/modal-nuevo-tipo.component';
import { ModalEditarFactorComponent } from './m-c-tabla/components/c-t-plancentrocosto/modals/modal-editar-factor/modal-editar-factor.component';
import { CENTRO_COSTO_PROVIDERS } from './infrastructure/providers/centro-costo.providers';
import { DETRACCION_PROVIDERS } from './infrastructure/providers/detraccion.providers';
import { CUENTA_VS_SUBCATEGORIA_PROVIDERS } from './infrastructure/providers/cuenta-vs-subcategoria.providers';
import { TIPO_DE_CAMBIO_PROVIDERS } from './infrastructure/providers/tipo-de-cambio.providers';
import { TABLA_IMPUESTO_PROVIDERS } from './infrastructure/providers/tabla-impuesto.providers';
import { REGISTRO_UIT_PROVIDERS } from './infrastructure/providers/registro-uit.providers';
import { MAESTRO_CONTABLE_PROVIDERS } from './infrastructure/providers/maestro-contable.providers';
import { REPORTE_VALIDACION_PROVIDERS } from './infrastructure/providers/reporte-validacion.providers';
import { ANALISIS_CUENTA_CONTABLE_PROVIDERS } from './infrastructure/providers/analisis-cuenta-contable.providers';
import { CUENTAS_CORRIENTE_PROVIDERS } from './infrastructure/providers/cuentas-corriente.providers';
import { CONSULTA_CENTRO_COSTOS_PROVIDERS } from './infrastructure/providers/consulta-centro-costos.providers';
import { CONSISTENCIA_ASIENTOS_PROVIDERS } from './infrastructure/providers/consistencia-asientos.providers';
import { CLONACION_ASIENTOS_PROVIDERS } from './infrastructure/providers/clonacion-asientos.providers';
import { GESTION_ASIENTOS_MANUAL_PROVIDERS } from './infrastructure/providers/gestion-asientos-manual.providers';
import { ASIENTOS_AUTOMATICOS_PROVIDERS } from './infrastructure/providers/asientos-automaticos.providers';
import { AJUSTES_RECLASIFICACION_PROVIDERS } from './infrastructure/providers/ajustes-reclasificacion.providers';
import { PROCESOS_AJUSTES_PROVIDERS } from './infrastructure/providers/procesos-ajustes.providers';
import { TABLAS_CONTABILIDAD_PROVIDERS } from './infrastructure/providers/tablas-contabilidad.providers';
import { REPORTE_FINANCIERO_PROVIDERS } from './infrastructure/providers/reporte-financiero.providers';
import { LIBROS_ASIENTOS_PROVIDERS } from './infrastructure/providers/libros-asientos.providers';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    ReactiveFormsModule,
    FontAwesomeModule,
    AgGridSharedModule,
    UiModule,
    ApartadoContabilidadPageRoutingModule,
    EyeCellAsientoComponent
  ],
  declarations: [
    ContabilidadTablaPlancontableComponent,
    CTRegistroUitComponent,
    ContabilidadTablaPlancentrocostoComponent,
    ContabilidadTablaContabilidadComponent,
    ContabilidadTablaDetraccionesComponent,
    ContabilidadTablaImpuestosComponent,
    ContabilidadTablaCuentasvssubcategoriasComponent,
    ContabilidadReporteMaestrocontableComponent,
    ContabilidadReporteValidacionComponent,
    ContabilidadReporteLibrosyasientosComponent,
    ContabilidadReporteReportefinancieroComponent,
    ContabilidadReporteAnalisiscuentacontableComponent,
    SaldosCuentasCorrienteComponent,
    ModalDetalleAsientoComponent,
    CentroCostosTrabajComponent,
    GestionAsientosManualComponent,
    GestionAsientosAutomaticoComponent,
    AjustesReclasificacionComponent,
    ContabilidadTablaTipodecambioComponent,
    CPClonacionasientosComponent,
    CPConsistenciaasientosComponent,
    CPGenerarlibrosComponent,
    CPProcesosajustesComponent,
    CPCierreContableComponent,
    CcCierreAnualComponent,
    CcCierreMensualComponent,
    ModalCuentasContablesComponent,
    ModalNuevoTipoComponent,
    ModalEditarFactorComponent,

  ],
  providers: [
    ...CENTRO_COSTO_PROVIDERS,
    ...DETRACCION_PROVIDERS,
    ...CUENTA_VS_SUBCATEGORIA_PROVIDERS,
    ...TIPO_DE_CAMBIO_PROVIDERS,
    ...TABLA_IMPUESTO_PROVIDERS,
    ...REGISTRO_UIT_PROVIDERS,
    ...MAESTRO_CONTABLE_PROVIDERS,
    ...REPORTE_VALIDACION_PROVIDERS,
    ...ANALISIS_CUENTA_CONTABLE_PROVIDERS,
    ...CUENTAS_CORRIENTE_PROVIDERS,
    ...CONSULTA_CENTRO_COSTOS_PROVIDERS,
    ...CONSISTENCIA_ASIENTOS_PROVIDERS,
    ...CLONACION_ASIENTOS_PROVIDERS,
    ...GESTION_ASIENTOS_MANUAL_PROVIDERS,
    ...ASIENTOS_AUTOMATICOS_PROVIDERS,
    ...AJUSTES_RECLASIFICACION_PROVIDERS,
    ...PROCESOS_AJUSTES_PROVIDERS,
    ...TABLAS_CONTABILIDAD_PROVIDERS,
    ...LIBROS_ASIENTOS_PROVIDERS,
    ...REPORTE_FINANCIERO_PROVIDERS,
  ]
})
export class ApartadoContabilidadPageModule {}
