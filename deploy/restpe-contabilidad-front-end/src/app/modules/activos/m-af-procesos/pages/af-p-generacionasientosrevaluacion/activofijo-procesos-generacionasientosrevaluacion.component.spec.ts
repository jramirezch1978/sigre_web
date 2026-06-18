import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ActivofijoProcesosGeneracionasientosrevaluacionComponent } from './activofijo-procesos-generacionasientosrevaluacion.component';

describe('ActivofijoProcesosGeneracionasientosrevaluacionComponent', () => {
  let component: ActivofijoProcesosGeneracionasientosrevaluacionComponent;
  let fixture: ComponentFixture<ActivofijoProcesosGeneracionasientosrevaluacionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoProcesosGeneracionasientosrevaluacionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoProcesosGeneracionasientosrevaluacionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
