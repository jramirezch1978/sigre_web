import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FinanzasConsultasConsultasCajaBancoComponent } from './finanzas-consultas-consultas-caja-banco.component';

describe('FinanzasConsultasConsultasCajaBancoComponent', () => {
  let component: FinanzasConsultasConsultasCajaBancoComponent;
  let fixture: ComponentFixture<FinanzasConsultasConsultasCajaBancoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FinanzasConsultasConsultasCajaBancoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FinanzasConsultasConsultasCajaBancoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
