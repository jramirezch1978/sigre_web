import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AoReqTrasladoComponent } from './a-o-req-traslado.component';

describe('AoReqTrasladoComponent', () => {
  let component: AoReqTrasladoComponent;
  let fixture: ComponentFixture<AoReqTrasladoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AoReqTrasladoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AoReqTrasladoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
