import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { TimeService } from '../../services/time.service';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-clock',
  standalone: true,
  imports: [CommonModule, MatCardModule, MatIconModule],
  template: `
    <mat-card class="clock-card">
      <mat-card-content class="clock-content">
        <div class="clock-icon">
          <mat-icon>schedule</mat-icon>
          <div class="connection-status" [class.connected]="isServerConnected" [class.disconnected]="!isServerConnected">
            <mat-icon class="status-icon">{{ isServerConnected ? 'wifi' : 'wifi_off' }}</mat-icon>
            <span class="status-text">{{ isServerConnected ? 'Servidor' : 'Local' }}</span>
          </div>
        </div>
        <div class="clock-time digital-clock">
          {{ formatTime(currentTime) }}
        </div>
        <div class="clock-date">
          {{ formatDate(currentTime) }}
        </div>
      </mat-card-content>
    </mat-card>
  `,
  styles: [`
    .clock-card {
      background: rgba(255, 255, 255, 0.9);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(0, 0, 0, 0.1);
      color: #1e293b;
      text-align: center;
      padding: 16px;
      min-width: 200px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
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
      color: #64748b;
    }
    
    .clock-time {
      font-size: 2.5rem;
      font-weight: bold;
      color: #1e293b;
      text-shadow: none;
      margin: 8px 0;
      font-family: 'Courier New', monospace;
    }
    
    .clock-date {
      font-size: 0.9rem;
      color: #64748b;
      font-weight: 400;
      text-transform: capitalize;
    }
    
    .connection-status {
      display: flex;
      align-items: center;
      gap: 4px;
      margin-top: 4px;
      font-size: 10px;
      padding: 2px 6px;
      border-radius: 12px;
      transition: all 0.3s ease;
    }
    
    .connection-status.connected {
      background: rgba(16, 185, 129, 0.1);
      color: #10b981;
    }
    
    .connection-status.disconnected {
      background: rgba(239, 68, 68, 0.1);
      color: #ef4444;
    }
    
    .status-icon {
      font-size: 12px;
      width: 12px;
      height: 12px;
    }
    
    .status-text {
      font-weight: 500;
      font-size: 9px;
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
  isServerConnected = false;

  constructor(private timeService: TimeService) {}

  ngOnInit() {
    // Suscribirse al servicio de tiempo del servidor
    this.timeSubscription = this.timeService.getCurrentTime().subscribe({
      next: (serverTime) => {
        this.currentTime = serverTime;
        this.isServerConnected = true;
      },
      error: (error) => {
        console.warn('Error conectando al servidor, usando hora local:', error);
        this.isServerConnected = false;
        // Fallback a hora local
        setInterval(() => {
          this.currentTime = new Date();
        }, 1000);
      }
    });
  }

  ngOnDestroy() {
    if (this.timeSubscription) {
      this.timeSubscription.unsubscribe();
    }
  }

  formatTime(date: Date): string {
    const hours = date.getHours();
    const minutes = date.getMinutes();
    const seconds = date.getSeconds();
    const ampm = hours >= 12 ? 'PM' : 'AM';
    
    const displayHours = hours % 12 || 12;
    const formattedHours = displayHours.toString().padStart(2, '0');
    const formattedMinutes = minutes.toString().padStart(2, '0');
    const formattedSeconds = seconds.toString().padStart(2, '0');
    
    return `${formattedHours}:${formattedMinutes}:${formattedSeconds} ${ampm}`;
  }

  formatDate(date: Date): string {
    const options: Intl.DateTimeFormatOptions = {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    };
    
    return date.toLocaleDateString('es-PE', options);
  }
}
