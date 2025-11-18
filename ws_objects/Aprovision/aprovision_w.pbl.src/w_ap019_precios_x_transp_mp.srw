$PBExportHeader$w_ap019_precios_x_transp_mp.srw
forward
global type w_ap019_precios_x_transp_mp from w_abc_mastdet_smpl
end type
end forward

global type w_ap019_precios_x_transp_mp from w_abc_mastdet_smpl
integer width = 3067
integer height = 2028
string title = "Tarifas por Transportista de MP"
string menuname = "m_mantto_smpl"
end type
global w_ap019_precios_x_transp_mp w_ap019_precios_x_transp_mp

on w_ap019_precios_x_transp_mp.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_ap019_precios_x_transp_mp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_insert;//Override
Long  ll_row

IF idw_1 = dw_master THEN
	MessageBox("Error", "No se está permitido insertar en el maestro")
	RETURN
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE


end event

event ue_open_pos;call super::ue_open_pos;if dw_master.Rowcount() > 0 then
	dw_master.il_Row = 1
	dw_master.setRow( 1 )
	dw_master.SelectRow( 1, true )
	dw_master.event ue_output( 1 )
	
end if
end event

event ue_delete;//Overrides
Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

if idw_1 = dw_master then
	MessageBox('Error', 'No se pueden hacer modificaciones en esta parte')
	return
end if

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF
end event

event ue_update_pre;call super::ue_update_pre;long ll_row

// Verifica que campos son requeridos y tengan valores
ib_update_check = False

if f_row_Processing( dw_master, idw_1.is_dwform) <> true then return
if f_row_Processing( dw_detail, idw_1.is_dwform) <> true then return

ib_update_check = true

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ap019_precios_x_transp_mp
integer x = 0
integer y = 0
integer width = 2839
integer height = 932
string dataobject = "d_abc_prov_transporte_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

ii_dk[1] = 1				// columnas de lectrua de este dw
ii_dk[2] = 2

//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;dw_detail.retrieve(aa_id[1], aa_id[2] )
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ap019_precios_x_transp_mp
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 944
integer width = 2656
integer height = 712
string dataobject = "d_abc_tarifa_x_transportista_tbl"
borderstyle borderstyle = styleraised!
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

CHOOSE CASE lower(as_columna)
		
	CASE "cod_moneda"
		 ls_sql = "Select cod_moneda as codigo_moneda, " &
		 			 + "descripcion as descripcion_moneda " &
					 + "From moneda " &
					 + "Where flag_estado = '1' " 
		
		 lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			THIS.object.cod_moneda	[al_row] = ls_codigo
			THIS.ii_update = 1
		END IF
		
END CHOOSE

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr 			[al_row] = gs_user
this.object.estacion 		[al_row] = gs_estacion
this.object.fecha_registro [al_row] = f_fecha_actual()
this.object.nro_item 		[al_row] = of_nro_item(this)
this.object.fecha_inicio 	[al_row] = date(f_fecha_actual())
this.object.fecha_fin 		[al_row] = relativeDate(date(f_fecha_actual()), 30)

end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				
ii_ck[2] = 2
ii_ck[3] = 3



ii_rk[1] = 1				
ii_rk[2] = 2

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

event dw_detail::keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_detail::itemchanged;call super::itemchanged;string ls_desc, ls_null
SetNull(ls_null)
this.accepttext( )

choose case lower(dwo.name)
	case 'cod_moneda'
		select descripcion
			into :ls_desc
		from moneda
		where cod_moneda = :data
		  and flag_estado = '1';
		
		if sqlca.sqlcode = 100 then 
			messagebox(parent.title, 'Codigo de moneda no existe o no está activo')
			this.object.cod_moneda	[row] = ls_null
			return 1
		end if

end choose
end event

