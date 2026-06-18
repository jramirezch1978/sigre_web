import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { GestionAsientosAutomaticoComponent } from './gestion-asientos-automatico.component';

describe('GestionAsientosAutomaticoComponent', () => {
  let component: GestionAsientosAutomaticoComponent;
  let fixture: ComponentFixture<GestionAsientosAutomaticoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ GestionAsientosAutomaticoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(GestionAsientosAutomaticoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
