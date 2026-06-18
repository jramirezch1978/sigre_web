import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { FTGestionCatalogoComponent } from './f-t-gestion-catalogo.component';

describe('FTGestionCatalogoComponent', () => {
  let component: FTGestionCatalogoComponent;
  let fixture: ComponentFixture<FTGestionCatalogoComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ FTGestionCatalogoComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(FTGestionCatalogoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
