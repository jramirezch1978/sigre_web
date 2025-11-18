$PBExportHeader$w_ap030_prov_certificacion.srw
forward
global type w_ap030_prov_certificacion from w_abc_mastdet_smpl
end type
end forward

global type w_ap030_prov_certificacion from w_abc_mastdet_smpl
integer width = 2967
integer height = 2264
string title = "[AP030] Certificaciones de los proveedores"
string menuname = "m_mantto_tablas"
end type
global w_ap030_prov_certificacion w_ap030_prov_certificacion

on w_ap030_prov_certificacion.create
call super::create
if this.MenuName = "m_mantto_tablas" then this.MenuID = create m_mantto_tablas
end on

on w_ap030_prov_certificacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;//Override
dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10

//dw_detail.width  = newwidth  - dw_detail.x - 10

end event

event ue_update;call super::ue_update;//Override

Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	lbo_ok = dw_master.of_save_log()
	lbo_ok = dw_detail.of_save_log()
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	
	dw_detail.ii_update = 0
	dw_detail.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')

END IF

end event

event ue_modify;//Override
dw_detail.of_protect()
end event

event ue_insert;//Override
if idw_1 = dw_master then
	MessageBox('error', "No se puede ingresar en este panel")
	return
end if

Long  ll_row

//IF idw_1 = dw_detail AND dw_master.il_row = 0 THEN
//	MessageBox("Error", "No ha seleccionado registro Maestro")
//	RETURN
//END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

event ue_delete;//Override

if idw_1 = dw_master then
	MessageBox("Eliminacion de Registro", "No esta permitido eliminar registros en este Panel")
	return
end if
Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ap030_prov_certificacion
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 0
integer width = 2793
integer height = 1104
string dataobject = "d_list_prov_mp_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

CHOOSE CASE lower(as_columna)
		
	CASE "proveedor"
		 ls_sql = "Select p.proveedor as proveedor, p.nom_proveedor as razon_social, p.ruc as ruc "&
		 			 + "from proveedor p Where Nvl(p.flag_estado,'0')='1' Order by p.proveedor" 
		
		 lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			THIS.object.proveedor	[al_row] = ls_codigo
			THIS.object.nom_proveedor	[al_row] = ls_data
			THIS.ii_update = 1
		END IF
		
END CHOOSE

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 				dw_master
idw_det  =  		   dw_detail
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;DateTime ldt_fecha

ldt_fecha = f_fecha_actual()

this.object.fecha_registro[al_row] = ldt_fecha
this.object.cod_usr[al_row] = gs_user
this.object.estacion[al_row] = gs_estacion
this.object.flag_estado[al_row] = '1'
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1]) 
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ap030_prov_certificacion
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 1116
integer width = 2793
integer height = 648
string dataobject = "d_abc_prov_certif_tbl"
end type

event dw_detail::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql

CHOOSE CASE lower(as_columna)
		
	CASE "cod_base"
		 ls_sql = "Select t.cod_base as codigo_base, " &
		 		  + "t.desc_base as descripcion_base " &
		 		  + "from ap_bases t " &
				  + "Where flag_estado <> '0' "&
				  + "Order by t.desc_base " 
		
		 lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			THIS.object.cod_base		[al_row] = ls_codigo
			THIS.object.desc_base	[al_row] = ls_data
			THIS.ii_update = 1
		END IF
		
END CHOOSE

end event

event dw_detail::constructor;call super::constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

 
 is_mastdet = 'd'      // 'm' = master sin detalle (default), 'd' =  detalle,
                       // 'md' = master con detalle, 'dd' = detalle con detalle a la vez

is_dwform = 'tabular' // tabular, grid, form
 


ii_ck[1] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = 				dw_master

end event

event dw_detail::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_detail::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_base'
		
		// Verifica que codigo ingresado exista			
		Select desc_base
	     into :ls_desc1
		  from ap_bases
		 Where cod_base = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Codigo de Base o no se encuentra activo, por favor verifique")
			this.object.cod_base		[row] = ls_null
			this.object.desc_base	[row] = ls_null
			return 1
			
		end if

		this.object.desc_base		[row] = ls_desc1
END CHOOSE
end event

