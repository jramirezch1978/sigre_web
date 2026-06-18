import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LayoutComponent } from '../layout/components/layout-wrapper/layout.component';
import { IonicModule } from '@ionic/angular';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { RouterModule } from '@angular/router';
import { SidebarComponent } from '../layout/components/sidebar/sidebar.component';
import { HeaderComponent } from '../layout/components/header/header.component';
import { LoaderDirective } from './directive/loader.directive';
import { LoaderComponent } from './loader/loader.component';
import { EmptyStateComponent } from './empty-state/empty-state.component';
import { AlertComponent } from './alert/alert.component';
import { ModalConfirmationComponent } from './modal-confirmation/modal-confirmation.component';
import { ToastContainerComponent } from './toast-container/toast-container.component';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { CalendarPopoverComponent } from './calendar-popover/calendar-popover.component';
import { AutocompleteComponent } from './autocomplete/autocomplete.component';
import { MonthYearPickerComponent } from './month-year-picker/month-year-picker.component';
import { SliderRangoComponent } from './slider-rango/slider-rango.component';
import { FitroAutocompleteComponent } from './fitro-autocomplete/fitro-autocomplete.component';
import { ModalImportarComponent } from './modal-importar/modal-importar.component';
import { BaseCalendarNewComponent } from './base-calendar-new/base-calendar.component';
import { ModalDetalleComponent } from './modal-detalle/modal-detalle.component';
import { ModalCrearAtfprodComponent } from './modal-crear-atfprod/modal-crear-atfprod.component';
import { ChecboxAutocompleteComponent } from './checbox-autocomplete/checbox-autocomplete.component';
import { ModalVerActualizacionesComponent } from './modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { VistaCellRenderComponent } from './vista-cell-render/vista-cell-render.component';
import { AutocompleteCellrendererComponent } from './autocomplete-cellrenderer/autocomplete-cellrenderer.component';
import { BotonAccionesComponent } from './boton-acciones/boton-acciones.component';
import { AutocompleteMultiComponent } from './autocomplete-multi/autocomplete-multi.component';
import { SelectorRangoMontosComponent } from './selector-rango-montos/selector-rango-montos.component';
import { TooltipComponent } from './tooltip/tooltip.component';
import { ModalGenerarAjusteComponent } from './modal-generar-ajuste/modal-generar-ajuste.component';
import { ModalDetalleCuentaComponent } from './modal-detalle-cuenta/modal-detalle-cuenta.component';
import { MonthYearPickerStringComponent } from './month-year-picker-string/month-year-picker-string.component';
import { AccionesCellRenderComponent } from './acciones-cell-render/acciones-cell-render.component';
import { BilleteCellRenderComponent } from './billete-cell-render/billete-cell-render.component';
import { ModalCuotasComponent } from './modal-cuotas/modal-cuotas.component';
import { AcciEditEliminarComponent } from './acci-edit-eliminar/acci-edit-eliminar.component';
import { AccionesHerramientasCellRenderComponent } from './acciones-herramientas-cell-render/acciones-herramientas-cell-render.component';
import { ModalRegistrarIngresosComponent } from './modal-registrar-ingresos/modal-registrar-ingresos.component';
import { FileUploadComponent } from './file-upload/file-upload.component';
import { IconBuildingCellComponent } from './icon-building-cell/icon-building-cell.component';
import { EntradaSalidaCellRendererComponent } from './entrada-salida-cell-renderer/entrada-salida-cell-renderer.component';
import { QuarterPickerComponent } from './quarter-picker/quarter-picker.component';
import { SemesterPickerComponent } from './semester-picker/semester-picker.component';
import { YearPickerComponent } from './year-picker/year-picker.component';
import { AccionesEyeCellrendererComponent } from './acciones-eye-cellrenderer/acciones-eye-cellrenderer.component';
import { DocumentCellrendererComponent } from './document-cellrenderer/document-cellrenderer.component';
import { ModalAdjuntarObservacionComponent } from './modal-adjuntar-observacion/modal-adjuntar-observacion.component';
import { ObservacionCellRenderComponent } from './observacion-cell-render/observacion-cell-render.component';
import { NotificacionesComponent } from './notificaciones/notificaciones.component';
import { AccionesEditarComponent } from './acciones-editar/acciones-editar.component';
import { ModalAyudaPrincipalComponent } from './modal-ayuda-principal/modal-ayuda-principal.component';
import { ModalCrearServicioComponent } from './modal-crear-servicio/modal-crear-servicio.component';
import { AccionesVerDescImpComponent } from './acciones-ver-desc-imp/acciones-ver-desc-imp.component';
import { DecimalDirective } from './directive/decimal.directive';
import { FormatDecimalPipe } from './pipes/format-decimal.pipe';
import { AgGridSharedModule } from '../shared/ag-grid-shared.module';
import { ChatIaComponent } from './chat-ia/chat-ia.component';
import { CalendarCellEditorComponent } from './calendar-cell-editor/calendar-cell-editor.component';
import { FechaEditCellRendererComponent } from './fecha-edit-cell-renderer/fecha-edit-cell-renderer.component';
import { AccionesEnviarComponent } from './acciones-enviar/acciones-enviar.component';
import { VistaFechaHoraRenderComponent } from './vista-fecha-hora-render/vista-fecha-hora-render.component';
import { DataProveedorRenderComponent } from './data-proveedor-render/data-proveedor-render.component';
import { InformacionFeRenderComponent } from './informacion-fe-render/informacion-fe-render.component';

@NgModule({
  declarations: [
    LayoutComponent,
    SidebarComponent,
    HeaderComponent,
    LoaderDirective,
    DecimalDirective,
    FormatDecimalPipe,
    LoaderComponent, 
    EmptyStateComponent,
    AlertComponent,
    ModalConfirmationComponent,
    ModalCrearAtfprodComponent,
    ModalDetalleCuentaComponent,
    ModalGenerarAjusteComponent,
    ToastContainerComponent,
    CalendarPopoverComponent,
    AutocompleteComponent,
    MonthYearPickerComponent,
    MonthYearPickerStringComponent,
    SliderRangoComponent,
    FitroAutocompleteComponent,
    ModalImportarComponent,
    ModalDetalleComponent,
    BaseCalendarNewComponent,
    ChecboxAutocompleteComponent,
    ModalVerActualizacionesComponent,
    VistaCellRenderComponent,
    AccionesEyeCellrendererComponent,
    AutocompleteCellrendererComponent,
    BotonAccionesComponent,
    ModalCuotasComponent,
    AutocompleteMultiComponent,
    SelectorRangoMontosComponent,
    TooltipComponent,
    AccionesCellRenderComponent,
    BilleteCellRenderComponent,
    AcciEditEliminarComponent,
    AccionesHerramientasCellRenderComponent,
    ModalRegistrarIngresosComponent,
    FileUploadComponent,
    IconBuildingCellComponent,
    EntradaSalidaCellRendererComponent,
    QuarterPickerComponent,
    SemesterPickerComponent,
    YearPickerComponent,
    DocumentCellrendererComponent,
    ModalAdjuntarObservacionComponent,
    ObservacionCellRenderComponent,
    NotificacionesComponent,
    AccionesEditarComponent,
    ModalAyudaPrincipalComponent,
    ModalCrearServicioComponent,
    AccionesVerDescImpComponent,
    ChatIaComponent,
    CalendarCellEditorComponent,
    FechaEditCellRendererComponent,
    AccionesEnviarComponent,
    VistaFechaHoraRenderComponent,
    DataProveedorRenderComponent,
    InformacionFeRenderComponent
  ],
  imports: [
    CommonModule,
    IonicModule,
    FontAwesomeModule,
    RouterModule,
    FormsModule,
    ReactiveFormsModule,
    AgGridSharedModule,
  ],
  exports: [
    LayoutComponent,
    SidebarComponent,
    HeaderComponent,
    LoaderDirective,
    DecimalDirective,
    FormatDecimalPipe,
    TooltipComponent,
    EmptyStateComponent,
    ModalConfirmationComponent,   
    ModalCuotasComponent,
    ToastContainerComponent,
    CalendarPopoverComponent,
    AutocompleteComponent,
    MonthYearPickerComponent,
    MonthYearPickerStringComponent,
    SliderRangoComponent,
    FitroAutocompleteComponent,
    ModalImportarComponent,
    BaseCalendarNewComponent,
    ChecboxAutocompleteComponent,
    ModalVerActualizacionesComponent,
    AccionesEyeCellrendererComponent,
    VistaCellRenderComponent,
    AutocompleteCellrendererComponent,
    AutocompleteMultiComponent,
    SelectorRangoMontosComponent,
    AccionesCellRenderComponent,
    BilleteCellRenderComponent,
    AcciEditEliminarComponent,
    AccionesHerramientasCellRenderComponent,
    FileUploadComponent,
    IconBuildingCellComponent,
    EntradaSalidaCellRendererComponent,
    QuarterPickerComponent,
    SemesterPickerComponent,
    YearPickerComponent,
    DocumentCellrendererComponent,
    ModalAdjuntarObservacionComponent,
    ObservacionCellRenderComponent,
    NotificacionesComponent,
    AccionesEditarComponent,
    AccionesVerDescImpComponent,
    ChatIaComponent,
    CalendarCellEditorComponent,
    FechaEditCellRendererComponent,
    AccionesEnviarComponent,
    VistaFechaHoraRenderComponent,
    DataProveedorRenderComponent,
    InformacionFeRenderComponent
  ],
})
export class UiModule { }
