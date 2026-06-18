import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AfORegistroactivosRegistrarTrasladoComponent } from './af-o-registroactivos-registrar-traslado.component';

describe('AfORegistroactivosRegistrarTrasladoComponent', () => {
  let component: AfORegistroactivosRegistrarTrasladoComponent;
  let fixture: ComponentFixture<AfORegistroactivosRegistrarTrasladoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AfORegistroactivosRegistrarTrasladoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AfORegistroactivosRegistrarTrasladoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
