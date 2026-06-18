import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ActivosfijosOperacionesRegistrotrasladoComponent } from './activosfijos-operaciones-registrotraslado.component';

describe('ActivosfijosOperacionesRegistrotrasladoComponent', () => {
  let component: ActivosfijosOperacionesRegistrotrasladoComponent;
  let fixture: ComponentFixture<ActivosfijosOperacionesRegistrotrasladoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivosfijosOperacionesRegistrotrasladoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivosfijosOperacionesRegistrotrasladoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
