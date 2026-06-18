import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ModalController } from '@ionic/angular';

// Font Awesome Icons
import { faInfoCircle, faXmark } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faArrowsRotateReverse, faDownload } from '@fortawesome/pro-solid-svg-icons';

// Facade
import { CatalogosFacade } from 'src/app/shared/application/catalogos.facade';
import { AlmacenExportService } from 'src/app/modules/almacen/infrastructure/export/almacen-export.service';



@Component({
  selector: 'app-modal-recalcular',
  templateUrl: './modal-recalcular.component.html',
  styleUrls: ['./modal-recalcular.component.scss'],
  standalone: false,
})
export class ModalRecalcularComponent  implements OnInit {
  // Font Awesome Icons
  farInfoCircle = faInfoCircle;
  farXmark = faXmark;
  fasAngleDown = faAngleDown;
  fasArrowsRotateReverse = faArrowsRotateReverse;
  fasDownload = faDownload;



  //RANGO DE FECHAS
  startDate: Date | undefined;
  endDate: Date | undefined;
  minDate: Date;
  maxDate: Date;

  filtrarForm!:FormGroup;

  // Facade
  private readonly catalogosFacade = inject(CatalogosFacade);
  almacenes = this.catalogosFacade.almacenes;

  // Exportación. Este modal no tiene grilla propia; Excel no aplica (no-op),
  // PDF imprime la vista actual del recálculo.
  protected readonly exportSvc = inject(AlmacenExportService);
  exportarExcel(): void { this.exportSvc.exportarExcel(null, 'recalculo'); }
  exportarPdf(): void { this.exportSvc.exportarPdf(); }

  constructor(
    private modalController : ModalController,
    private formBuilder: FormBuilder,
  ) { 
    const today = new Date();
    this.maxDate = today;
    this.minDate = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
  }
    
  ngOnInit() {
    this.catalogosFacade.inicializarCatalogos();
    this.filtrarForm = this.formBuilder.group({
      fechaC: ['',Validators.required],
      almacen: ['',Validators.required],
    });
  }
  filtrarPorFechas(range: { start: Date; end: Date }) {
    this.startDate = range.start;
    this.endDate = range.end;
  }

  onAlmacenSeleccionado(almacen: any) {
    this.filtrarForm.patchValue({ almacen: almacen });
  }
  
  dismissModal() {
    this.modalController.dismiss();
  }

}
