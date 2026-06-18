import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FOTransaccionesPeriodicasComponent } from './f-o-transacciones-periodicas.component';

describe('FOTransaccionesPeriodicasComponent', () => {
  let component: FOTransaccionesPeriodicasComponent;
  let fixture: ComponentFixture<FOTransaccionesPeriodicasComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FOTransaccionesPeriodicasComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FOTransaccionesPeriodicasComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
