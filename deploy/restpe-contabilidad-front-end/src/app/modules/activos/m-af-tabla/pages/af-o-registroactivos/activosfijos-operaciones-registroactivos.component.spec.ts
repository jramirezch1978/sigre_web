import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ActivosfijosOperacionesRegistroactivosComponent } from './activosfijos-operaciones-registroactivos.component';

describe('ActivosfijosOperacionesRegistroactivosComponent', () => {
  let component: ActivosfijosOperacionesRegistroactivosComponent;
  let fixture: ComponentFixture<ActivosfijosOperacionesRegistroactivosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivosfijosOperacionesRegistroactivosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivosfijosOperacionesRegistroactivosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
