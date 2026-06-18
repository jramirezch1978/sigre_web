import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-c-p-cierre-contable',
  templateUrl: './c-p-cierre-contable.component.html',
  styleUrls: ['./c-p-cierre-contable.component.scss'],
  standalone: false,
})
export class CPCierreContableComponent  implements OnInit {

  tabSeleccionado: string = 'mensual';

  constructor() { }

  ngOnInit() {}

  tabs = [
    { value: 'mensual', label: 'Cierre de Periodo Contable ' },
    { value: 'anual', label: 'Cierre Contable Anual' },
  ];

}
