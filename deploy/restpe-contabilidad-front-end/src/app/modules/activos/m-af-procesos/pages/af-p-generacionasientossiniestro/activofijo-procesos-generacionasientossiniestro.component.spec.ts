import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ActivofijoProcesosGeneracionasientossiniestroComponent } from './activofijo-procesos-generacionasientossiniestro.component';

describe('ActivofijoProcesosGeneracionasientossiniestroComponent', () => {
  let component: ActivofijoProcesosGeneracionasientossiniestroComponent;
  let fixture: ComponentFixture<ActivofijoProcesosGeneracionasientossiniestroComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoProcesosGeneracionasientossiniestroComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoProcesosGeneracionasientossiniestroComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
