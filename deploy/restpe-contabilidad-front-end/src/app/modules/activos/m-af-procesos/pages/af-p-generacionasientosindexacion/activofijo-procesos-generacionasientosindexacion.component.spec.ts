import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ActivofijoProcesosGeneracionasientosindexacionComponent } from './activofijo-procesos-generacionasientosindexacion.component';

describe('ActivofijoProcesosGeneracionasientosindexacionComponent', () => {
  let component: ActivofijoProcesosGeneracionasientosindexacionComponent;
  let fixture: ComponentFixture<ActivofijoProcesosGeneracionasientosindexacionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoProcesosGeneracionasientosindexacionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoProcesosGeneracionasientosindexacionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
