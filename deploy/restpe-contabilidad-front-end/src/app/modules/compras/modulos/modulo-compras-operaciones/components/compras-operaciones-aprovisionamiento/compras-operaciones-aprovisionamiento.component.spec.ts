import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ComprasOperacionesAprovisionamientoComponent } from './compras-operaciones-aprovisionamiento.component';

describe('ComprasOperacionesAprovisionamientoComponent', () => {
  let component: ComprasOperacionesAprovisionamientoComponent;
  let fixture: ComponentFixture<ComprasOperacionesAprovisionamientoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ComprasOperacionesAprovisionamientoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ComprasOperacionesAprovisionamientoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
