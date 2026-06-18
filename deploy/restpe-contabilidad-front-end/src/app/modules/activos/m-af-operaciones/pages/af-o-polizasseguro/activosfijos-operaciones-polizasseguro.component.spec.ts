import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ActivosfijosOperacionesPolizasseguroComponent } from './activosfijos-operaciones-polizasseguro.component';

describe('ActivosfijosOperacionesPolizasseguroComponent', () => {
  let component: ActivosfijosOperacionesPolizasseguroComponent;
  let fixture: ComponentFixture<ActivosfijosOperacionesPolizasseguroComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivosfijosOperacionesPolizasseguroComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivosfijosOperacionesPolizasseguroComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
