import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ModalController } from '@ionic/angular';
import { ColDef } from 'ag-grid-enterprise';
import { ToastService } from '../services/toast.service';

// Font Awesome Icons
import { faInfoCircle, faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-generar-ajuste',
  templateUrl: './modal-generar-ajuste.component.html',
  styleUrls: ['./modal-generar-ajuste.component.scss'],
  standalone: false,
})
export class ModalGenerarAjusteComponent  implements OnInit {
  // Font Awesome Icons
  farInfoCircle = faInfoCircle;
  farXmark = faXmark;



@Input() totalDebe: string = '';
@Input() totalHaber: string = '';

  ajusteForm!: FormGroup;
  mostrarTablaAsiento: boolean = false;
  botonHabilitado: boolean = false;
  botonGuardarHabilitado: boolean = false;

  @Input() tiposAjuste: any[] = [
    { value: 'comision-bancaria', label: 'Comisión bancaria' },
    { value: 'itf', label: 'ITF (Impuesto transacciones)' },
    { value: 'gasto-bancario', label: 'Gasto bancario' },
    { value: 'intereses', label: 'Intereses' },
    { value: 'otros-gastos', label: 'Otros gastos' }
  ];

  @Input() cuentasContables: any[] = [
    { value: '1041010101', label: '1041010101 - Cajas y bancos BCP soles' },
    { value: '6391010101', label: '6391010101 - Gastos bancarios' },
    { value: '6391010102', label: '6391010102 - Comisiones bancarias' },
    { value: '64912010101', label: '64912010101 - ITF' },
    { value: '6713010101', label: '6713010101 - Intereses por préstamos' }
  ];

  @Input() labelTipoAjuste: string = 'Tipo de ajuste';
  @Input() labelCuentaDebito: string = 'Cuenta débito';
  @Input() labelCuentaCredito: string = 'Cuenta crédito';
  @Input() mostrarObservaciones: boolean = true;

  // Datos de las tablas recibidos desde el componente padre
  @Input() colDefsMovimientosAjustar: ColDef[] = [];
  @Input() colDefsAsiento: ColDef[] = [];
  @Input() rowDataMovimientosAjustar: any[] = [];
  
  rowDataAsiento: any[] = [];

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
  
  constructor(private formBuilder: FormBuilder, private modalController: ModalController, private toastService: ToastService) { }

  ngOnInit() {
    this.ajusteForm = this.formBuilder.group({
      tipoAjuste: [''],
      cuentaCredito: [''],
      cuentaDebito: [''],
      observaciones: ['']
    });

    // Suscribirse a los cambios de los tres selects principales
    this.ajusteForm.valueChanges.subscribe(() => {
      this.verificarCamposCompletos();
    });
  }

  verificarCamposCompletos() {
    const tipoAjuste = this.ajusteForm.get('tipoAjuste')?.value;
    const cuentaCredito = this.ajusteForm.get('cuentaCredito')?.value;
    const cuentaDebito = this.ajusteForm.get('cuentaDebito')?.value;

    // Si los tres selects están completos
    if (tipoAjuste && cuentaCredito && cuentaDebito) {
      this.mostrarTablaAsiento = true;
      this.botonHabilitado = true;
      console.log('Todos los campos completos - Mostrando tabla y habilitando botón');
    } else {
      this.mostrarTablaAsiento = false;
      this.botonHabilitado = false;
    }
  }

  generarAjuste() {
    console.log('Generando ajuste con datos:', this.ajusteForm.value);
    
    // Llenar la tabla de asiento con datos de ejemplo
    this.rowDataAsiento = [
      { cuenta: '6391010102', descripcion: 'Gastos bancarios', debe: 150.00, haber: 0.00 },
      { cuenta: '1041010101', descripcion: 'Cuentas corrientes en instituciones financieras', debe: 0.00, haber: 150.00 },
    ];
    
    // Activar el botón Guardar
    this.botonGuardarHabilitado = true;
    
    console.log('Asiento generado, tabla actualizada');
  }
  
  guardarAjuste() {
    console.log('Guardando ajuste...');
    
    // Mostrar toast de éxito
    this.toastService.success('¡Ajuste realizado exitosamente!');
    
    // Cerrar modal y devolver estado actualizado
    this.modalController.dismiss({
      estado: 'Conciliado',
      ajusteGenerado: true
    }, 'aplicar');
  }
  cerrarModal(){
    this.modalController.dismiss();
  }

}
