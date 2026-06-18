import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { VRReporteTributarioPorPeriodoComponent } from './v-r-reporte-tributario-por-periodo.component';

describe('VRReporteTributarioPorPeriodoComponent', () => {
  let component: VRReporteTributarioPorPeriodoComponent;
  let fixture: ComponentFixture<VRReporteTributarioPorPeriodoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ VRReporteTributarioPorPeriodoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(VRReporteTributarioPorPeriodoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
