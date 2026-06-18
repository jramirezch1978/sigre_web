import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ActivofijoProcesosGeneraciondevengoaseguradoresComponent } from './activofijo-procesos-generaciondevengoaseguradores.component';

describe('ActivofijoProcesosGeneraciondevengoaseguradoresComponent', () => {
  let component: ActivofijoProcesosGeneraciondevengoaseguradoresComponent;
  let fixture: ComponentFixture<ActivofijoProcesosGeneraciondevengoaseguradoresComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoProcesosGeneraciondevengoaseguradoresComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoProcesosGeneraciondevengoaseguradoresComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
