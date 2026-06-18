import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ActivosfijosOperacionesOperacionesactivosComponent } from './activosfijos-operaciones-operacionesactivos.component';

describe('ActivosfijosOperacionesOperacionesactivosComponent', () => {
  let component: ActivosfijosOperacionesOperacionesactivosComponent;
  let fixture: ComponentFixture<ActivosfijosOperacionesOperacionesactivosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivosfijosOperacionesOperacionesactivosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivosfijosOperacionesOperacionesactivosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
