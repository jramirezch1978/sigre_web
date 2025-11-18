$PBExportHeader$w_ve019_vendedor_cuota.srw
forward
global type w_ve019_vendedor_cuota from w_abc_master
end type
type dw_lista from datawindow within w_ve019_vendedor_cuota
end type
end forward

global type w_ve019_vendedor_cuota from w_abc_master
integer width = 2789
integer height = 1528
string title = "[VE019] Cuota de los Vendedores"
string menuname = "m_mantenimiento_vendedor_cuota"
boolean maxbox = false
boolean resizable = false
event ue_delete_vendedor ( )
dw_lista dw_lista
end type
global w_ve019_vendedor_cuota w_ve019_vendedor_cuota

event ue_delete_vendedor();//Codigo
dw_master.deleterow( dw_master.getrow() )
dw_master.ii_update = 1
end event

on w_ve019_vendedor_cuota.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_vendedor_cuota" then this.MenuID = create m_mantenimiento_vendedor_cuota
this.dw_lista=create dw_lista
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
end on

on w_ve019_vendedor_cuota.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
end on

event ue_update;// Ancestor Script has been Override
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

//IF ib_log THEN
//	Datastore		lds_log
//	lds_log = Create DataStore
//	lds_log.DataObject = 'd_log_diario_tbl'
//	lds_log.SetTransObject(SQLCA)
//	in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
//END IF
//
////Open(w_log)
////lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)
//
//IF	dw_master.ii_update = 1 THEN
//	IF dw_master.Update() = -1 then		// Grabacion del Master
//		lbo_ok = FALSE
//		ROLLBACK USING SQLCA;
//		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
//	END IF
//END IF
//
//IF ib_log THEN
//	IF lbo_ok THEN
//		IF lds_log.Update() = -1 THEN
//			lbo_ok = FALSE
//			ROLLBACK USING SQLCA;
//			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
//		END IF
//	END IF
//	DESTROY lds_log
//END IF
//

date ld_fecha_ini, ld_fecha_fin
long ll_i
decimal{4} ldc_cuota
string ls_vendedor, ls_canal, ls_und

if dw_master.dataobject = 'd_abc_vendedor_cuota' then
	
	if dw_master.rowcount( ) > 0 then
		
		for ll_i = 1 to dw_master.rowcount( )
			
			ls_vendedor  = dw_master.object.vendedor[ll_i]
			ls_canal	    = dw_master.object.canal[ll_i]
			ld_fecha_ini = date(dw_master.object.fecha_ini[ll_i])
			ld_fecha_fin = date(dw_master.object.fecha_fin[ll_i])
			ldc_cuota	 = dec(dw_master.object.cant_cuota_men[ll_i])
			ls_und	    = dw_master.object.und[ll_i]
			
			update vendedor_cuota
			   set fecha_fin 		   = :ld_fecha_fin,
					 cant_cuota_men   = :ldc_cuota,
					 und		  		   = :ls_und,
					 flag_replicacion = '1'
			 where vendedor  = :ls_vendedor
			   and canal	  = :ls_canal
				and fecha_ini = :ld_fecha_ini;
			
			if sqlca.sqlnrows = 0 then
				insert into vendedor_cuota (vendedor, canal, fecha_ini, fecha_fin, 
								cant_cuota_men, und, flag_replicacion)
				     values (:ls_vendedor, :ls_canal, :ld_fecha_ini, :ld_fecha_fin,
					  			:ldc_cuota, :ls_und, '1');
			end if
			
			if sqlca.sqlcode <> 0 then
				MessageBox('Error en Base de Datos', string(sqlca.sqlcode) + ' ' + string(sqlca.sqlerrtext ) )
			end if
			
		next
		
		if sqlca.sqlcode = 0 then
			COMMIT using SQLCA;
			dw_master.ii_protect = 0
		else
			lbo_ok = false
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', string(sqlca.sqlcode) + ' ' + string(sqlca.sqlerrtext ) )
		end if
		
	end if
	
else
	
	IF	dw_master.ii_update = 1 THEN
		IF dw_master.Update() = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
		else
			if dw_master.rowcount( ) > 0 then
				ld_fecha_ini = date(dw_master.object.fecha_ini[1])
			end if
		END IF
	END IF
	
end if

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.dataobject = 'd_abc_vendedor_cuota_real'
	dw_master.settransobject( sqlca )
	dw_master.retrieve( ld_fecha_ini )
	dw_lista.retrieve( )
	dw_lista.scrolltorow( dw_lista.rowcount() )
	dw_master.ii_update 	= 0
	dw_master.il_totdel 	= 0
	dw_master.ii_protect = 0
	dw_master.of_protect( )
END IF


end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if dw_master.rowcount( ) = 0 then
	ib_update_check = false
	return
end if

date ld_fecha, ld_fecha_ini

ld_fecha = date(dw_master.object.fecha_ini[1])

select max(fecha_ini)
  into :ld_fecha_ini
  from vendedor_cuota;
 
if ld_fecha_ini > ld_fecha then
	ib_update_check = false
	messagebox('Aviso','No se pueden Modificar Las Cuotas una vez que ya han caducado')
	return
end if
end event

event ue_open_pre;call super::ue_open_pre;long ll_rows
date ld_fecha

dw_lista.settransobject( sqlca )
ll_rows = dw_lista.retrieve( )

if ll_rows > 0 then
	ld_fecha = date(dw_lista.object.fecha_ini[ll_rows])
	dw_master.dataobject = 'd_abc_vendedor_cuota_real'
	dw_master.settransobject( sqlca )
	dw_master.retrieve( ld_fecha )
	
//	dw_master.of_protect( )
	
	if dw_master.object.und.protect = '0' then
		dw_master.of_protect( )
	end if
		
end if

of_position_window(50,50)

dw_master.of_protect( )


	
end event

event resize;//Override

end event

event ue_delete;//Override

dw_master.event ue_delete_all()
end event

type dw_master from w_abc_master`dw_master within w_ve019_vendedor_cuota
event ue_delete_vendedor ( )
integer x = 695
integer y = 32
integer width = 2021
integer height = 1252
string dataobject = "d_abc_vendedor_cuota"
boolean vscrollbar = true
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
idw_mst  = 	dw_master

end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

event dw_master::ue_insert;//Override
integer li_rpta
long ll_i

if dw_master.rowcount( ) > 0 then

	li_rpta = messagebox('Aviso','Insertar un Nuevo registro hara que el otro periodo de Cuotas termine, ~n Desea Ingresar un nuevo Periodo de Cuotas', Question!, YesNo!, 1)
	
	if li_rpta = 2 then return 2
	
end if

dw_master.dataobject = 'd_abc_vendedor_cuota'
dw_master.settransobject( sqlca )
dw_master.retrieve( )

return 1
end event

type dw_lista from datawindow within w_ve019_vendedor_cuota
integer x = 37
integer y = 32
integer width = 635
integer height = 1252
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_abc_lista_fechas_vendedor_cuota"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row = 0 then return

date ld_fecha

ld_fecha = date(this.object.fecha_ini[row])

dw_master.dataobject = 'd_abc_vendedor_cuota_real'
dw_master.settransobject( sqlca )
dw_master.retrieve( ld_fecha )
end event

event rowfocuschanged;f_select_current_row(this)
end event

