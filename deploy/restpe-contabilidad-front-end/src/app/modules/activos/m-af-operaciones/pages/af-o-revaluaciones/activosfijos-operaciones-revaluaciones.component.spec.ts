import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ActivosfijosOperacionesRevaluacionesComponent } from './activosfijos-operaciones-revaluaciones.component';

describe('ActivosfijosOperacionesRevaluacionesComponent', () => {
  let component: ActivosfijosOperacionesRevaluacionesComponent;
  let fixture: ComponentFixture<ActivosfijosOperacionesRevaluacionesComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivosfijosOperacionesRevaluacionesComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivosfijosOperacionesRevaluacionesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
