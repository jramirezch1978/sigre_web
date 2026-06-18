import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { VOFacturacionDeRegaliasComponent } from './v-o-facturacion-de-regalias.component';

describe('VOFacturacionDeRegaliasComponent', () => {
  let component: VOFacturacionDeRegaliasComponent;
  let fixture: ComponentFixture<VOFacturacionDeRegaliasComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ VOFacturacionDeRegaliasComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(VOFacturacionDeRegaliasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
