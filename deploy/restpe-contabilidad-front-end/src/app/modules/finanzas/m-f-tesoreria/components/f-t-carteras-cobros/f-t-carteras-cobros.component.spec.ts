import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FTCarterasCobrosComponent } from './f-t-carteras-cobros.component';

describe('FTCarterasCobrosComponent', () => {
  let component: FTCarterasCobrosComponent;
  let fixture: ComponentFixture<FTCarterasCobrosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FTCarterasCobrosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FTCarterasCobrosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
