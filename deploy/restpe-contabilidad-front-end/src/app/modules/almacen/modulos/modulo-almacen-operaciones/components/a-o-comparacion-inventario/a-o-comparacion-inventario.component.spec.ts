import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AOComparacionInventarioComponent } from './a-o-comparacion-inventario.component';

describe('AOComparacionInventarioComponent', () => {
  let component: AOComparacionInventarioComponent;
  let fixture: ComponentFixture<AOComparacionInventarioComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AOComparacionInventarioComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AOComparacionInventarioComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
