import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ComprasTablasCondicionesDePagoComponent } from './compras-tablas-condiciones-de-pago.component';

describe('ComprasTablasCondicionesDePagoComponent', () => {
  let component: ComprasTablasCondicionesDePagoComponent;
  let fixture: ComponentFixture<ComprasTablasCondicionesDePagoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ComprasTablasCondicionesDePagoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ComprasTablasCondicionesDePagoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
