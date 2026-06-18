import { Component, Input, OnInit, ViewChild, ElementRef, input } from '@angular/core';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faArrowUpFromBracket, faInfoCircle, faXmark } from '@fortawesome/pro-regular-svg-icons';
import { faDownload, faQuestionCircle, faUpload } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-modal-importar',
  templateUrl: './modal-importar.component.html',
  styleUrls: ['./modal-importar.component.scss'],
  standalone: false,
})
export class ModalImportarComponent  implements OnInit {
  // Font Awesome Icons
  farArrowUpFromBracket = faArrowUpFromBracket;
  farInfoCircle = faInfoCircle;
  farXmark = faXmark;
  fasDownload = faDownload;
  fasQuestionCircle = faQuestionCircle;
  fasUpload = faUpload;



  @Input() titulo: string = 'Importar datos';
  @Input() habilitarformatonumerico= false;
  @Input() descripcionpaso1: string = 'Descargar formato de importación';
  @Input() descripcionpaso2: string = 'El sistema validará duplicados y campos obligatorios antes de importar los datos.';
  @Input() habilitarperiodo= false;
  @Input() nombreselector: string = '';
  @Input() placeholderselector: string = '';
  @Input() habilitarselector= false;
  @Input() opcionesSelector: any[] = [];
  @Input() descripcionSubir: string = 'Comparte tu archivo de excel con la información y regístralos automáticamente en la plataforma.';
  @Input() buttonName: string = 'Importar datos';
  @Input() archivo: any;
  @Input() onImportar?: (data: any) => void;

  @ViewChild('fileInput') fileInput!: ElementRef;

  constructor(
      private modalController : ModalController,
    ) { }
  
    ngOnInit() {}

    /**
     * Botón principal: si no hay archivo, abre el selector. Si ya hay archivo, lo devuelve/despacha.
     */
    Importar(){
      // Si no existe archivo, abrir selector de archivos
      if (!this.archivo) {
        // abrir input file
        try {
          this.fileInput.nativeElement.click();
        } catch (e) {
          // fallback: simplemente cerrar sin archivo
          
        }
        return;
      }

      // Si hay archivo seleccionado, se envía al padre (si existe callback) y se cierra modal
      const data = { mensaje: 'Archivo seleccionado', archivo: this.archivo };
      if (this.onImportar) {
        try { this.onImportar(data); } catch(e) { console.warn('onImportar falló', e); }
      }
      this.modalController.dismiss(data);

    }

    /**
     * Handler cuando el usuario selecciona un archivo desde el input
     */
    onArchivoSeleccionado(event: any) {
      const file = event?.target?.files?.[0];
      if (file) {
        this.archivo = file;
        // Archivo guardado en estado local del modal; el componente padre decidirá mostrar toasts
        // Guardar y enviar inmediatamente
        this.Importar();
      }
    }
  
     dismissModal() {
      this.modalController.dismiss();
    }

}
