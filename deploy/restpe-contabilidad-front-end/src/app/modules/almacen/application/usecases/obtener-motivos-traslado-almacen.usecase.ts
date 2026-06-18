import { inject, Injectable } from "@angular/core";
import { MotivoTrasladoAlmacenEntity } from "@modules/almacen/domain/models/motivo-traslado-almacen.entity";
import { IAlmacenMotivoTrasladoRepository } from "@modules/almacen/domain/repositories/ialmacen-motivo-traslado.repository";
import { Observable } from "rxjs";

@Injectable()
export class ObtenerMotivosTrasladoAlmacenesUseCase {
    private readonly repository = inject(IAlmacenMotivoTrasladoRepository);

    execute(): Observable<MotivoTrasladoAlmacenEntity[]> {
        return this.repository.obtenerMotivosTrasladoAlmacenes();
    }
}