import { Component, Input, OnInit } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { ColDef, GridApi, GridReadyEvent } from 'ag-grid-community';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { CountryService } from 'src/app/ui/services/countryservice.service';

// Font Awesome Icons
import { faXmark } from '@fortawesome/pro-regular-svg-icons';



@Component({
  selector: 'app-modal-detalle-asiento',
  templateUrl: './modal-detalle-asiento.component.html',
  styleUrls: ['./modal-detalle-asiento.component.scss'],
  standalone: false
})
export class ModalDetalleAsientoComponent implements OnInit {
  // Font Awesome Icons
  farXmark = faXmark;


  pais= this.countryService.getCountryCode();
  countries= ALL_COUNTRIES;
  monedasignificado='';
  @Input() nroAsiento!: string;
  @Input() fechaRegistro!: string;
  @Input() fechaContable!: string;
  @Input() glosa!: string;
  @Input() total!: string;
  @Input() duplicado!: string;
  @Input() asientoData: any[] = [];
  @Input() colDefs!: ColDef[];
  @Input() totalDebeS!: string;
  @Input() totalHaberS!: string;
  @Input() totalDebeD!: string;
  @Input() totalHaberD!: string;

  private gridApi!: GridApi;

  constructor(private modalController: ModalController, private countryService: CountryService) { }

  ngOnInit() {
    // Los datos vienen desde el componente padre
    this.obtenerdatospais();
  }
  obtenerdatospais(){
    this.countries.find((country: any) => {
      if(country.codigo === this.pais){
        this.monedasignificado=country.monedapais[0].value
      }
    });
  }
  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
  }

  dismissModal() {
    this.modalController.dismiss();
  }

}
