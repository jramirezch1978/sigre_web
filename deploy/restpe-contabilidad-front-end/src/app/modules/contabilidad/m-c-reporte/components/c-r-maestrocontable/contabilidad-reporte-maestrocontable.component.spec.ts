import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ContabilidadReporteMaestrocontableComponent } from './contabilidad-reporte-maestrocontable.component';

describe('ContabilidadReporteMaestrocontableComponent', () => {
  let component: ContabilidadReporteMaestrocontableComponent;
  let fixture: ComponentFixture<ContabilidadReporteMaestrocontableComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ContabilidadReporteMaestrocontableComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ContabilidadReporteMaestrocontableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
