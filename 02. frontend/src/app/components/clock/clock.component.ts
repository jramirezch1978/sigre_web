import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-clock',
  standalone: true,
  imports: [CommonModule, MatCardModule, MatIconModule],
  template: `
    <mat-card class="clock-card">
      <mat-card-content class="clock-content">
        <div class="clock-icon">
          <mat-icon>schedule</mat-icon>
        </div>
        <div class="clock-time digital-clock">
          {{ currentTime | date:'hh:mm:ss a' }}
        </div>
        <div class="clock-date">
          {{ currentTime | date:'EEEE, d MMMM yyyy' }}
        </div>
      </mat-card-content>
    </mat-card>
  `,
  styles: [`
    .clock-card {
      background: rgba(255, 255, 255, 0.1);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.2);
      color: white;
      text-align: center;
      padding: 16px;
      min-width: 200px;
    }
    
    .clock-content {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;
    }
    
    .clock-icon {
      margin-bottom: 8px;
    }
    
    .clock-icon mat-icon {
      font-size: 24px;
      width: 24px;
      height: 24px;
      color: rgba(255, 255, 255, 0.8);
    }
    
    .clock-time {
      font-size: 2.5rem;
      font-weight: bold;
      color: white;
      text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
      margin: 8px 0;
    }
    
    .clock-date {
      font-size: 0.9rem;
      color: rgba(255, 255, 255, 0.8);
      font-weight: 300;
      text-transform: capitalize;
    }
    
    @media (max-width: 768px) {
      .clock-card {
        min-width: 160px;
        padding: 12px;
      }
      
      .clock-time {
        font-size: 2rem;
      }
      
      .clock-date {
        font-size: 0.8rem;
      }
    }
  `]
})
export class ClockComponent implements OnInit, OnDestroy {
  currentTime: Date = new Date();
  private timeSubscription: Subscription = new Subscription();

  constructor(private timeService: TimeService) {}

  ngOnInit() {
    // Suscribirse al servicio de tiempo que sincroniza con el servidor
    this.timeSubscription = this.timeService.getCurrentTime().subscribe(
      serverTime => {
        this.currentTime = serverTime;
      }
    );
  }

  ngOnDestroy() {
    if (this.timeSubscription) {
      this.timeSubscription.unsubscribe();
    }
  }
}
