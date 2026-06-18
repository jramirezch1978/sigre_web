import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ActivofijoProcesosCalculodepreciacionComponent } from './activofijo-procesos-calculodepreciacion.component';

describe('ActivofijoProcesosCalculodepreciacionComponent', () => {
  let component: ActivofijoProcesosCalculodepreciacionComponent;
  let fixture: ComponentFixture<ActivofijoProcesosCalculodepreciacionComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoProcesosCalculodepreciacionComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoProcesosCalculodepreciacionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
