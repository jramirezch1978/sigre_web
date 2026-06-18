import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FinanzasConsultasConsultasFlujoCajaComponent } from './finanzas-consultas-consultas-flujo-caja.component';

describe('FinanzasConsultasConsultasFlujoCajaComponent', () => {
  let component: FinanzasConsultasConsultasFlujoCajaComponent;
  let fixture: ComponentFixture<FinanzasConsultasConsultasFlujoCajaComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FinanzasConsultasConsultasFlujoCajaComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FinanzasConsultasConsultasFlujoCajaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
