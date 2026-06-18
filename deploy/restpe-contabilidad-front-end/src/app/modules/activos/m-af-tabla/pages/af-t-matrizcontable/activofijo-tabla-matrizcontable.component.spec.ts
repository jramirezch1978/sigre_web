import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { ActivofijoTablaMatrizcontableComponent } from './activofijo-tabla-matrizcontable.component';

describe('ActivofijoTablaMatrizcontableComponent', () => {
  let component: ActivofijoTablaMatrizcontableComponent;
  let fixture: ComponentFixture<ActivofijoTablaMatrizcontableComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ ActivofijoTablaMatrizcontableComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(ActivofijoTablaMatrizcontableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
