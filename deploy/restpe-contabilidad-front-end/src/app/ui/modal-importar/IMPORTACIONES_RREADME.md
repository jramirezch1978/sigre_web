<!-- ASI PUEDES LLAMAR EL MODAL IMPORTAR -->
async modalImportar(){
    const modal = await this.modalController.create({
      component: ModalImportarComponent,
      cssClass: 'promo',
      componentProps: {
        titulo: 'Importar cuentas',
        descripcionSubir: 'Comparte tu archivo de excel con la información de tus cuentas y regístralos automáticamente en la plataforma.',
        buttonName: 'Importar cuentas',
      }
    });
    await modal.present();

    try {
      const result = await modal.onWillDismiss();
      const data = result?.data;
      if (data && data.archivo) {
        // Guardar archivo en el componente padre
        this.archivo = data.archivo;
        // Mostrar toast indicando que el archivo fue subido
        try {
          const nombre = data.archivo?.name ?? 'archivo';
          this.toastService.success('Archivo subido', nombre, 3000);
        } catch (e) {
          console.warn('ToastService falló', e);
        }
        // Llamar al método importar para procesar el archivo
        try { this.importar(data); } catch (e) { 
          this.toastService.danger('Importacion fallida');
         }
      }
    } catch (e) {
      console.warn('Error al obtener resultado del modal', e);
      this.toastService.danger('Error al obtener resultado del modal');
    }
  }

  importar(data:any){
    // Placeholder: aquí se procesaría el archivo (validaciones, parseo, subida, etc.)
    console.log('Importar llamado con:', data);
    // Por ahora solo guardamos el archivo en el estado (ya lo hacemos en modalImportar),
    // y se puede mostrar un toast adicional si se desea.
  }