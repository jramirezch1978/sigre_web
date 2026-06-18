import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ModalAgregarMedioDePagoComponent } from './modal-agregar-medio-de-pago.component';

describe('ModalAgregarMedioDePagoComponent', () => {
  let component: ModalAgregarMedioDePagoComponent;
  let fixture: ComponentFixture<ModalAgregarMedioDePagoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ModalAgregarMedioDePagoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ModalAgregarMedioDePagoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
