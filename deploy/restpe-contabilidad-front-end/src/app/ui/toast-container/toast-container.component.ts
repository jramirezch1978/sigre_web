import { animate, style, transition, trigger } from "@angular/animations";
import { Component, OnDestroy, OnInit, HostListener } from "@angular/core";
import { Subscription } from "rxjs";
import {ToastMessage, ToastService} from "src/app/ui/services/toast.service";

// Font Awesome Icons
import { faXmark, faXmarkCircle } from '@fortawesome/pro-regular-svg-icons';
import { faCheckCircle, faExclamationTriangle } from '@fortawesome/pro-solid-svg-icons';



@Component({
    selector: "app-toast-container",
    templateUrl: "./toast-container.component.html",
    styleUrls: ["./toast-container.component.scss"],
    animations: [
        trigger("slideIn", [
            transition(":enter", [
                style({ transform: "translateX(100%)", opacity: 0 }),
                animate(
                    "300ms ease-out",
                    style({ transform: "translateX(0)", opacity: 1 })
                ),
            ]),
            transition(":leave", [
                animate(
                    "300ms ease-in",
                    style({ transform: "translateX(100%)", opacity: 0 })
                ),
            ]),
        ]),
    ],
    standalone: false,

})
export class ToastContainerComponent implements OnInit, OnDestroy {
  // Font Awesome Icons
  farXmark = faXmark;
  farXmarkCircle = faXmarkCircle;
  fasCheckCircle = faCheckCircle;
  fasExclamationTriangle = faExclamationTriangle;


    toasts: ToastMessage[] = [];
    private subscription!: Subscription;
    icono: any;
    clases: any;
    fondoicono: any;
    clasestoast: any;
    
    constructor(private toastService: ToastService) {}

    ngOnInit(): void {
        this.subscription = this.toastService.toast$.subscribe((toast) => {
            this.addToast(toast);
            this.icono = this.IconName(toast.type);
            this.clases = this.IconClasses(toast.type);
            this.fondoicono = this.FondoIconToastClasses(toast.type);
            this.clasestoast = this.ToastClasses(toast.type);
        });
    }

    ngOnDestroy(): void {
        if (this.subscription) {
            this.subscription.unsubscribe();
        }
    }

    addToast(toast: ToastMessage): void {
        // Eliminar todos los toasts anteriores antes de agregar el nuevo
        this.toasts = [];
        
        // Agregar el nuevo toast
        this.toasts.push(toast);

        // Auto-remove después del tiempo especificado
        setTimeout(() => {
            this.removeToast(toast.id);
        }, toast.duration || 15000);
    }

    removeToast(id: string): void {
        this.toasts = this.toasts.filter((toast) => toast.id !== id);
    }

    removeAllToasts(): void {
        this.toasts = [];
    }

    private ToastClasses(type: string): string {
        const baseClasses =
            "min-w-[330px] max-w-[500px] cursor-pointer overflow-hidden min-h-[57px] rounded-lg bg-white sombra border flex gap-3 transform transition-all duration-300 ease-in-out";

        switch (type) {
            case "success":
                return `${baseClasses} border-success`;
            case "warning":
                return `${baseClasses} border-warning`;
            case "danger":
                return `${baseClasses} border-danger`;
            default:
                return `${baseClasses} border-text-10`;
        }
    }
    private FondoIconToastClasses(type: string): string {
        const baseClasses = "w-12 flex items-center justify-center ";
        switch (type) {
            case "success":
                return `${baseClasses} bg-[#6DC560] text-success`;
            case "warning":
                return `${baseClasses} bg-warning-5 text-warning`;
            case "danger":
                return `${baseClasses} bg-danger-5 text-danger`;
            default:
                return `${baseClasses} bg-text-85 text-text-85`;
        }

    }

    private IconClasses(type: string): string {
        switch (type) {
            case "success":
                return "text-white";
            case "warning":
                return "text-warning";
            case "danger":
                return "text-red-500";
            default:
                return "text-gray-500";
        }
    }

    private IconName(type: string): any {
        switch (type) {
            case "success":
                return this.fasCheckCircle;
            case "warning":
                return this.fasExclamationTriangle;
            case "danger":
                return this.farXmarkCircle;
            default:
                return '';
        }
    }

    trackByToastId(index: number, toast: ToastMessage): string {
        return toast.id;
    }
}
