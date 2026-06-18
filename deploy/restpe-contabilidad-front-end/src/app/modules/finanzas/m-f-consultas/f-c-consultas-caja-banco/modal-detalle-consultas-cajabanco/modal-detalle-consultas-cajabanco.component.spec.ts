import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ModalDetalleConsultasCajabancoComponent } from './modal-detalle-consultas-cajabanco.component';

describe('ModalDetalleConsultasCajabancoComponent', () => {
  let component: ModalDetalleConsultasCajabancoComponent;
  let fixture: ComponentFixture<ModalDetalleConsultasCajabancoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ModalDetalleConsultasCajabancoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ModalDetalleConsultasCajabancoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
