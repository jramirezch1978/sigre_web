import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ActivofijoReporteResumenrangosComponent } from './activofijo-reporte-resumenrangos.component';

describe('ActivofijoReporteResumenrangosComponent', () => {
  let component: ActivofijoReporteResumenrangosComponent;
  let fixture: ComponentFixture<ActivofijoReporteResumenrangosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoReporteResumenrangosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoReporteResumenrangosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
