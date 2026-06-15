import { Injectable } from "@angular/core";
import { Subject } from "rxjs";

export interface ToastMessage {
    id: string;
    type: "success" | "warning" | "danger";
    title: string;
    description?: string;
    duration?: number;
}

@Injectable({
    providedIn: "root",
})
export class ToastService {
    private toastSubject = new Subject<ToastMessage>();
    public toast$ = this.toastSubject.asObservable();

    private generateId(): string {
        return Math.random().toString(36).substr(2, 9);
    }

    success(
        title: string,
        description?: string,
        duration: number = 6000
    ): void {
        this.show("success", title, description, duration);
    }

    warning(
        title: string,
        description?: string,
        duration: number = 6000
    ): void {
        this.show("warning", title, description, duration);
    }

    danger(
        title: string,
        description?: string,
        duration: number = 6000
    ): void {
        this.show("danger", title, description, duration);
    }

    private show(
        type: "success" | "warning" | "danger",
        title: string,
        description?: string,
        duration: number = 2000
    ): void {
        const toast: ToastMessage = {
            id: this.generateId(),
            type,
            title,
            description,
            duration,
        };

        this.toastSubject.next(toast);
    }
}
