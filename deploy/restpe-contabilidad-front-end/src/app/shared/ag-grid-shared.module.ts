import { NgModule } from '@angular/core';
import { AgGridAngular } from 'ag-grid-angular';
import {
  ModuleRegistry,
  ClientSideRowModelModule,
  ValidationModule,
  RowSelectionModule,
  CellStyleModule,
  RowStyleModule,
  TextFilterModule,
  NumberFilterModule,
  DateFilterModule,
  QuickFilterModule,
  TextEditorModule,
  NumberEditorModule,
  SelectEditorModule,
  ColumnAutoSizeModule,
  CsvExportModule,
  TooltipModule,
  PaginationModule,
  LocaleModule,
  RowApiModule,
  RenderApiModule,
} from 'ag-grid-community';
import {
  LicenseManager,
  MasterDetailModule,
  RichSelectModule,
  ServerSideRowModelModule,
  ServerSideRowModelApiModule,
  SetFilterModule,
  RowGroupingModule,
  TreeDataModule,
  ColumnMenuModule,
  ContextMenuModule,
  ExcelExportModule,
} from 'ag-grid-enterprise';

// Configurar la licencia de AG Grid
LicenseManager.setLicenseKey(
  "[TRIAL]_this_{AG_Charts_and_AG_Grid}_Enterprise_key_{AG-120125}_is_granted_for_evaluation_only___Use_in_production_is_not_permitted___Please_report_misuse_to_legal@ag-grid.com___For_help_with_purchasing_a_production_key_please_contact_info@ag-grid.com___You_are_granted_a_{Single_Application}_Developer_License_for_one_application_only___All_Front-End_JavaScript_developers_working_on_the_application_would_need_to_be_licensed___This_key_will_deactivate_on_{7 March 2026}____[v3]_[0102]_MTc3Mjg0MTYwMDAwMA==7f9a9475512966b4650e34ff68e2fd00"
);

// Registrar solo los módulos de AG Grid que se usan en el proyecto
ModuleRegistry.registerModules([
  // Community
  ClientSideRowModelModule,
  ValidationModule,
  RowSelectionModule,
  CellStyleModule,
  RowStyleModule,
  TextFilterModule,
  NumberFilterModule,
  DateFilterModule,
  QuickFilterModule,
  TextEditorModule,
  NumberEditorModule,
  SelectEditorModule,
  ColumnAutoSizeModule,
  CsvExportModule,
  TooltipModule,
  PaginationModule,
  LocaleModule,
  RowApiModule,
  RenderApiModule,
  // Enterprise
  MasterDetailModule,
  RichSelectModule,
  ServerSideRowModelModule,
  ServerSideRowModelApiModule,
  SetFilterModule,
  RowGroupingModule,
  TreeDataModule,
  ColumnMenuModule,
  ContextMenuModule,
  ExcelExportModule,
]);

@NgModule({
  imports: [AgGridAngular],
  exports: [AgGridAngular],
})
export class AgGridSharedModule {}
