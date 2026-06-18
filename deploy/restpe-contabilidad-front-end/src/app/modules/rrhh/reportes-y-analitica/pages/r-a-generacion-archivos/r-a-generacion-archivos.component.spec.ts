import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { RAGeneracionArchivosComponent } from './r-a-generacion-archivos.component';

describe('RAGeneracionArchivosComponent', () => {
  let component: RAGeneracionArchivosComponent;
  let fixture: ComponentFixture<RAGeneracionArchivosComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ RAGeneracionArchivosComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(RAGeneracionArchivosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
