import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ComprasReportesReporteDeComprasComponent } from './compras-reportes-reporte-de-compras.component';

describe('ComprasReportesReporteDeComprasComponent', () => {
  let component: ComprasReportesReporteDeComprasComponent;
  let fixture: ComponentFixture<ComprasReportesReporteDeComprasComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ComprasReportesReporteDeComprasComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ComprasReportesReporteDeComprasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
