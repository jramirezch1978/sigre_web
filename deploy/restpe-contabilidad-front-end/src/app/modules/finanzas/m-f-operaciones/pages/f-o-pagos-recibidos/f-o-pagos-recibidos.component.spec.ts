import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FOPagosRecibidosComponent } from './f-o-pagos-recibidos.component';

describe('FOPagosRecibidosComponent', () => {
  let component: FOPagosRecibidosComponent;
  let fixture: ComponentFixture<FOPagosRecibidosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FOPagosRecibidosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FOPagosRecibidosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
