import { ComponentFixture, TestBed, waitForAsync } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';

import { AfOReceptTrasladosAfComponent } from './af-o-recept-traslados-af.component';

describe('AfOReceptTrasladosAfComponent', () => {
  let component: AfOReceptTrasladosAfComponent;
  let fixture: ComponentFixture<AfOReceptTrasladosAfComponent>;

  beforeEach(waitForAsync(() => {
    TestBed.configureTestingModule({
      declarations: [ AfOReceptTrasladosAfComponent ],
      imports: [IonicModule.forRoot()]
    }).compileComponents();

    fixture = TestBed.createComponent(AfOReceptTrasladosAfComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
