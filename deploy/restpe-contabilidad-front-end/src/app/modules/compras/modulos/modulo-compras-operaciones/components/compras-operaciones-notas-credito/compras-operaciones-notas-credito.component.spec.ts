import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ComprasOperacionesNotasCreditoComponent } from './compras-operaciones-notas-credito.component';

describe('ComprasOperacionesNotasCreditoComponent', () => {
  let component: ComprasOperacionesNotasCreditoComponent;
  let fixture: ComponentFixture<ComprasOperacionesNotasCreditoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ComprasOperacionesNotasCreditoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ComprasOperacionesNotasCreditoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
