import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ContabilidadTablaTipodecambioComponent } from './contabilidad-tabla-tipodecambio.component';

describe('ContabilidadTablaTipodecambioComponent', () => {
  let component: ContabilidadTablaTipodecambioComponent;
  let fixture: ComponentFixture<ContabilidadTablaTipodecambioComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ContabilidadTablaTipodecambioComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ContabilidadTablaTipodecambioComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
