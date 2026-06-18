import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ActivofijoProcesosGeneracionasientosdepreciacionComponent } from './activofijo-procesos-generacionasientosdepreciacion.component';

describe('ActivofijoProcesosGeneracionasientosdepreciacionComponent', () => {
  let component: ActivofijoProcesosGeneracionasientosdepreciacionComponent;
  let fixture: ComponentFixture<ActivofijoProcesosGeneracionasientosdepreciacionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoProcesosGeneracionasientosdepreciacionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoProcesosGeneracionasientosdepreciacionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
