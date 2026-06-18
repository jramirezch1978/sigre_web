import { Injectable } from '@angular/core';
import { LicenseManager } from 'ag-grid-enterprise';

@Injectable({
  providedIn: 'root'
})
export class KeylicenciaAggrid {
  asdsad=false;
  initializeLicense(): void {
      // 🔑 Cada desarrollador pondrá su propia llave aquí prueba 2
       //const licenseKey = '[TRIAL]_this_{AG_Charts_and_AG_Grid}_Enterprise_key_{AG-104897}_is_granted_for_evaluation_only___Use_in_production_is_not_permitted___Please_report_misuse_to_legal@ag-grid.com___For_help_with_purchasing_a_production_key_please_contact_info@ag-grid.com___You_are_granted_a_{Single_Application}_Developer_License_for_one_application_only___All_Front-End_JavaScript_developers_working_on_the_application_would_need_to_be_licensed___This_key_will_deactivate_on_{30 November 2025}____[v3]_[0102]_MTc2NDQ2MDgwMDAwMA==a97c0b249a2f0bd2a1ed2c10804b61b5';
       //LicenseManager.setLicenseKey(licenseKey);
      console.log('AG Grid Enterprise license initializeddawdadawdadwa.');
    }
}