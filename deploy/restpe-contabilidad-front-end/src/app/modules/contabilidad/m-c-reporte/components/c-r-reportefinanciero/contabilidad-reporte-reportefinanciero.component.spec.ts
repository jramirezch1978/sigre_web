import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ContabilidadReporteReportefinancieroComponent } from './contabilidad-reporte-reportefinanciero.component';

describe('ContabilidadReporteReportefinancieroComponent', () => {
  let component: ContabilidadReporteReportefinancieroComponent;
  let fixture: ComponentFixture<ContabilidadReporteReportefinancieroComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ContabilidadReporteReportefinancieroComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ContabilidadReporteReportefinancieroComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
