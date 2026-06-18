import { Component, OnInit, inject, effect } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalVerActualizacionesComponent } from 'src/app/ui/modal-ver-actualizaciones/modal-ver-actualizaciones.component';
import { ModalController } from '@ionic/angular';
import { ConfiguracionFacade } from '../../application/facades/configuracion.facade';
import { HistorialActualizacionEntity } from '../../domain/models/historial-actualizacion.entity';
import { PlanEntity } from '../../domain/models/plan.entity';

// Font Awesome Icons
import { faBadgeCheck, faBook, faCirclePlus } from '@fortawesome/pro-regular-svg-icons';
import { faCashRegister, faFileInvoiceDollar, faUsers } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-c-a-datos-generales',
  templateUrl: './c-a-datos-generales.component.html',
  styleUrls: ['./c-a-datos-generales.component.scss'],
  standalone: false,
})
export class CADatosGeneralesComponent  implements OnInit {
  // Font Awesome Icons
  farBadgeCheck = faBadgeCheck;
  farBook = faBook;
  farCirclePlus = faCirclePlus;
  fasCashRegister = faCashRegister;
  fasFileInvoiceDollar = faFileInvoiceDollar;
  fasUsers = faUsers;



  direccionForm: FormGroup;
  valoresIniciales: any;
  hayCambios: boolean = false;
  
  // Inyección del Facade
  private readonly configuracionFacade = inject(ConfiguracionFacade);
  
  // Selectores del store
  readonly historialDatosGenerales = this.configuracionFacade.historialDatosGenerales;
  readonly planes = this.configuracionFacade.planes;
  readonly loadingHistorial = this.configuracionFacade.loadingHistorialDatosGenerales;
  readonly loadingPlanes = this.configuracionFacade.loadingPlanes;
  readonly isLoading = this.configuracionFacade.isLoading;

  constructor(private fb: FormBuilder, private modalController: ModalController) {
    this.direccionForm = this.fb.group({
      razonSocial: ['Restaurantes del Pacífico S.A.C.', Validators.required],
      ruc: ['20601234567', [Validators.required, Validators.pattern('^[0-9]+$')]],
      direccion: ['Av. José Larco 1301, Miraflores, Lima', Validators.required],
      correoElectronico: ['facturacion@restaurantepacífico.com', [Validators.required, Validators.email]]
    });

    // Guardar los valores iniciales
    this.valoresIniciales = { ...this.direccionForm.value };
  }

  ngOnInit() {
    // Cargar planes desde el JSON
    this.configuracionFacade.cargarPlanes();
    
    // Suscribirse a los cambios del formulario
    this.direccionForm.valueChanges.subscribe(() => {
      this.verificarCambios();
    });
  }

  verificarCambios() {
    const valoresActuales = this.direccionForm.value;
    this.hayCambios = JSON.stringify(this.valoresIniciales) !== JSON.stringify(valoresActuales);
  }

  guardar() {
    console.log('Datos guardados:', this.direccionForm.value);
    // Aquí puedes agregar la lógica para guardar los datos en el backend
    
    // Actualizar los valores iniciales después de guardar
    this.valoresIniciales = { ...this.direccionForm.value };
    this.hayCambios = false;
  }

  suscribirse(planSeleccionado: PlanEntity) {
    // Desactivar todos los planes
    this.planes().forEach(plan => plan.plan_is_actual = false);
    // Activar el plan seleccionado
    planSeleccionado.plan_is_actual = true;
    console.log('Plan seleccionado:', planSeleccionado.plan_nombre);
  }
  
   async modalverActualizaciones() {
      // Cargar datos si no están cargados
      if (this.historialDatosGenerales().length === 0) {
        this.configuracionFacade.cargarHistorialDatosGenerales();
      }
      
      // Definir las columnas
      const colDefs = [
        { headerName: 'Fecha y hora', field: 'historial_actualizacion_fecha_hora', width: 150, },
        { headerName: 'Usuario', field: 'historial_actualizacion_usuario', width: 120, },
        {
          headerName: 'Acción', field: 'historial_actualizacion_accion', width: 150,
          wrapText: true,
          autoHeight: true,
          cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
        },
        {
          headerName: 'Detalle del cambio', field: 'historial_actualizacion_detalle_cambio', flex: 1,
          wrapText: true,
          autoHeight: true,
          cellStyle: { textAlign: 'left', lineHeight: '1.5', padding: '8px' },
        },
      ];
  
      // Obtener datos del store
      const rowData = this.historialDatosGenerales();
      
      const modal = await this.modalController.create({
        component: ModalVerActualizacionesComponent,
        cssClass: 'promo',
        componentProps: {
          titulo: 'Historial de Actualizaciones - Datos Generales de la cuenta',
          rowData: rowData,
          colDefs: colDefs,
          anchoModal: '700px',
        },
      });
  
      await modal.present();
    }

}
