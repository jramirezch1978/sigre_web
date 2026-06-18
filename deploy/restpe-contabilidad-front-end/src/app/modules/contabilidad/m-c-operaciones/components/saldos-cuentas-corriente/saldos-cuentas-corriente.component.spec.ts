import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { SaldosCuentasCorrienteComponent } from './saldos-cuentas-corriente.component';

describe('SaldosCuentasCorrienteComponent', () => {
  let component: SaldosCuentasCorrienteComponent;
  let fixture: ComponentFixture<SaldosCuentasCorrienteComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ SaldosCuentasCorrienteComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(SaldosCuentasCorrienteComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
