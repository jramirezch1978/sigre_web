import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FTConceptoFinancieroComponent } from './f-t-concepto-financiero.component';

describe('FTConceptoFinancieroComponent', () => {
  let component: FTConceptoFinancieroComponent;
  let fixture: ComponentFixture<FTConceptoFinancieroComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FTConceptoFinancieroComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FTConceptoFinancieroComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
