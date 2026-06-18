import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ActivosfijosOperacionesAprobaciontrasladoComponent } from './activosfijos-operaciones-aprobaciontraslado.component';

describe('ActivosfijosOperacionesAprobaciontrasladoComponent', () => {
  let component: ActivosfijosOperacionesAprobaciontrasladoComponent;
  let fixture: ComponentFixture<ActivosfijosOperacionesAprobaciontrasladoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivosfijosOperacionesAprobaciontrasladoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivosfijosOperacionesAprobaciontrasladoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
