import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { PParametrosImpuestosComponent } from './p-parametros-impuestos.component';

describe('PParametrosImpuestosComponent', () => {
  let component: PParametrosImpuestosComponent;
  let fixture: ComponentFixture<PParametrosImpuestosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ PParametrosImpuestosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(PParametrosImpuestosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
