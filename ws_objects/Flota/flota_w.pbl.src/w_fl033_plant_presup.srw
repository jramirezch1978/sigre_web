$PBExportHeader$w_fl033_plant_presup.srw
forward
global type w_fl033_plant_presup from w_abc
end type
type st_detail from statictext within w_fl033_plant_presup
end type
type st_master from statictext within w_fl033_plant_presup
end type
type dw_master from u_dw_abc within w_fl033_plant_presup
end type
type dw_detail from u_dw_abc within w_fl033_plant_presup
end type
end forward

global type w_fl033_plant_presup from w_abc
integer width = 2962
integer height = 1904
string title = "Plantillas Presupuestales (FL033)"
string menuname = "m_mto_smpl_cslta_retrieve"
st_detail st_detail
st_master st_master
dw_master dw_master
dw_detail dw_detail
end type
global w_fl033_plant_presup w_fl033_plant_presup

type variables
string	is_plantilla, is_accion

end variables

forward prototypes
public subroutine of_retrieve (string as_plantilla)
public function boolean of_validar_plant_det (string as_cencos, string as_cntaprsp, string as_plantilla)
end prototypes

public subroutine of_retrieve (string as_plantilla);dw_master.Retrieve(as_plantilla)
dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect()

dw_detail.Retrieve(as_plantilla)
dw_detail.ii_update = 0
dw_detail.ii_protect = 0
dw_detail.of_protect()

is_accion = "retrieve"
end subroutine

public function boolean of_validar_plant_det (string as_cencos, string as_cntaprsp, string as_plantilla);string ls_cencos, ls_cntaprsp, ls_mensaje
long ll_row
integer li_ok

if IsNull(as_cencos) or trim(as_cencos) = '' &
	or IsNull(as_cntaprsp) or trim(as_cntaprsp) = '' then
	return true
end if

for ll_row = 1 to dw_detail.RowCount()
	ls_cencos 	= trim( dw_detail.object.cencos[ll_row] )
	ls_cntaprsp = trim( dw_detail.object.cnta_prsp[ll_row] )
	
	if trim(ls_cencos) = trim(as_cencos) &
		and trim(ls_cntaprsp) = trim(as_cntaprsp) then
		
		return false
		
	end if

next

////create or replace procedure USP_FL_VALIDA_PLANT_DET(
////		asi_cencos 		in centros_costo.cencos%TYPE, 
////    asi_cntaprsp 	in presupuesto_cuenta.cnta_prsp%TYPE, 
////    asi_plant 		in fl_plant_presup.cod_fl_plantilla%TYPE,
////   	aso_mensaje 	out varchar2,
////    aio_ok      	out number) is
//
//DECLARE USP_FL_VALIDA_PLANT_DET PROCEDURE FOR
//	USP_FL_VALIDA_PLANT_DET( :as_cencos, 
//		:as_cntaprsp, :as_plantilla );
//
//EXECUTE USP_FL_VALIDA_PLANT_DET;
//
//IF SQLCA.sqlcode = -1 THEN
//	ls_mensaje = "PROCEDURE USP_FL_VALIDA_PLANT_DET: " + SQLCA.SQLErrText
//	Rollback ;
//	MessageBox('SQL error', ls_mensaje, StopSign!)	
//	return false
//END IF
//
//FETCH USP_FL_VALIDA_PLANT_DET INTO :ls_mensaje, :li_ok;
//CLOSE USP_FL_VALIDA_PLANT_DET;
//
//if li_ok <> 1 then
//	MessageBox('Error de validacion', ls_mensaje, StopSign!)	
//	return false
//end if

return true


end function

on w_fl033_plant_presup.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl_cslta_retrieve" then this.MenuID = create m_mto_smpl_cslta_retrieve
this.st_detail=create st_detail
this.st_master=create st_master
this.dw_master=create dw_master
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_detail
this.Control[iCurrent+2]=this.st_master
this.Control[iCurrent+3]=this.dw_master
this.Control[iCurrent+4]=this.dw_detail
end on

on w_fl033_plant_presup.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_detail)
destroy(this.st_master)
destroy(this.dw_master)
destroy(this.dw_detail)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
st_master.X			= dw_master.X
st_master.width 	= dw_master.width

dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
st_detail.X		  = dw_detail.X
st_detail.width  = dw_detail.width

end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'ds_plantillas_pspto_grid'
sl_param.titulo = "Plantillas Presupuestales"
sl_param.field_ret_i[1] = 1

sl_param.tipo    = ''
OpenWithParm( w_lista, sl_param )

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	is_plantilla = sl_param.field_ret[1]
	This.of_retrieve (is_plantilla)	
END IF
end event

event ue_query_retrieve;// Ancestor Script has been Override
this.of_retrieve(is_plantilla)
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente

idw_1.object.p_logo.FileName 	= gs_logo
idw_1.object.empresa_t.text 	= gs_empresa



end event

event ue_insert;call super::ue_insert;Long  	ll_row, ll_row_master
string 	ls_plantilla

choose case idw_1
	case dw_master
		This.event ue_update_request( )
		
		dw_detail.Reset()
	
	case dw_detail
		
		if dw_master.ii_update = 1 then
			MessageBox('Aviso', 'DEBE GRABAR PRIMERO LA CABECERA, POR FAVOR VERIFIQUE',StopSign!)
			return
		end if
		
		ll_row_master = dw_master.GetRow()
		if ll_row_master = 0 then
			MessageBox('Aviso', 'NO EXISTE CABECERA, POR FAVOR VERIFIQUE',StopSign!)
			return
		end if
		
		ls_plantilla = dw_master.object.cod_plantilla [ll_row_master]
		if ls_plantilla = '' or IsNull(ls_plantilla) then
			MessageBox('Aviso', 'CODIGO DE PLANTILLA NO EXISTE, POR FAVOR VERIFIQUE',StopSign!)
			return
		end if
		
end choose


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN 
	THIS.EVENT ue_insert_pos(ll_row)
	is_accion = "new"
end if


end event

event ue_update;call super::ue_update;Boolean 	lbo_ok = TRUE
string 	ls_disable, ls_enable

ls_disable = "ALTER TRIGGER TIB_AP_PLANT_PRESUP DISABLE "
ls_enable  = "ALTER TRIGGER TIB_AP_PLANT_PRESUP ENABLE "

dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

EXECUTE IMMEDIATE :ls_disable;

if SQLCA.SQLCode <> 0 then
	lbo_ok = FALSE
  	Rollback ;
	MessageBox('', SQLCA.SQLErrText)
end if

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
END IF

EXECUTE IMMEDIATE :ls_enable;
if SQLCA.SQLCode <> 0 then
	MessageBox('', SQLCA.SQLErrText)
end if

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;string	ls_plantilla
Long		ll_row, ll_i
DwItemStatus ldis_status

ib_update_check = true

if f_row_processing( dw_master, 'form') = false then
	ib_update_check = false
	return
end if

if f_row_processing( dw_detail, 'tabular') = false then
	ib_update_check = false
	return
end if

ll_row = dw_master.GetRow()
if ll_row <= 0 then
	ib_update_check = false
	return
end if

ls_plantilla = dw_master.object.cod_plantilla[ll_row]

ldis_status = dw_master.GetItemStatus(ll_row,0,Primary!)

IF ldis_status = NewModified! THEN
	IF f_get_nro_plant_pspto( gs_origen, 'FL', ls_plantilla ) = FALSE THEN
		ib_update_check = False	
		RETURN
	ELSE
		dw_master.Object.cod_plantilla [ll_row] = ls_plantilla
	END IF
END IF

FOR ll_i = 1 TO dw_detail.Rowcount() 
	
	//asignar Plantilla cuando registro sea nuevo
	 ldis_status = dw_detail.GetItemStatus(ll_i,0,Primary!)

	 IF ldis_status = NewModified! THEN
		 dw_detail.Object.cod_plantilla [ll_i] = ls_plantilla
	 END IF
	 
next

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

event ue_modify;call super::ue_modify;idw_1.of_protect()
is_accion = "modify"
end event

type st_detail from statictext within w_fl033_plant_presup
integer x = 818
integer y = 628
integer width = 1143
integer height = 68
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Partidas Presupuestales y ratios"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_master from statictext within w_fl033_plant_presup
integer x = 818
integer y = 44
integer width = 896
integer height = 68
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Plantilla Presupuestal"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_fl033_plant_presup
event ue_display ( string as_columna,  long al_row )
integer y = 140
integer width = 2839
integer height = 460
string dataobject = "d_plantilla_presup_ff"
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "UNID"
		
		ls_sql = "SELECT UND AS CODIGO, " &
				  + "DESC_UNIDAD AS DESCRIPCION " &
				  + "FROM UNIDAD " &
				  + "WHERE TIPO_UND = 'P'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.unid[al_row] = ls_codigo
			this.object.desc_unidad[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose

end event

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event keydwn;call super::keydwn;string 	ls_columna, ls_cadena
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

event ue_insert_pre;call super::ue_insert_pre;string ls_ult_nro

if f_get_nro_plant_pspto(gs_origen, 'FL', ls_ult_nro ) = false then
	this.event dynamic ue_delete()
	return
end if

this.object.cod_plantilla	[al_row] = ls_ult_nro
this.object.origen			[al_row] = gs_origen
this.object.fecha_registro	[al_row] = Today()
this.object.inicio_vigencia[al_row] = Today()
this.object.fin_vigencia	[al_row] = Today()



end event

event itemchanged;call super::itemchanged;string ls_codigo, ls_data
this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
	case "UNID"
		
		ls_codigo = this.object.unid[row]

		SetNull(ls_data)
		select desc_unidad
			into :ls_data
		from unidad
		where und = :ls_codigo
		  and tipo_und <> 'P';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Aviso', "CODIGO DE UNIDAD NO EXISTE O CORRESPONDE A UN ARTICULO", StopSign!)
			SetNull(ls_codigo)
			this.object.unid			[row] = ls_codigo
			this.object.desc_unidad	[row] = ls_codigo
			return 1
		end if

		this.object.desc_unidad[row] = ls_data
		
end choose

end event

event itemerror;call super::itemerror;return 1
end event

type dw_detail from u_dw_abc within w_fl033_plant_presup
event ue_display ( string as_columna,  long al_row )
integer y = 740
integer width = 2688
integer height = 1044
string dataobject = "d_plant_presup_det_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_cnta_prsp, ls_data, ls_sql, ls_plantilla, ls_cencos
long ll_count
integer li_i
str_seleccionar lstr_seleccionar

this.AcceptText()
choose case upper(as_columna)
		
	case "CNTA_PRSP"

		ls_sql = "SELECT CNTA_PRSP AS CODIGO_CUENTA, " &
				 + "DESCRIPCION AS DESCR_CUENTA_PRSP " &
             + "FROM PRESUPUESTO_CUENTA"	
				 
		lb_ret = f_lista(ls_sql, ls_cnta_prsp, &
					ls_data, '1')
		
		if ls_cnta_prsp <> '' then
			ls_cencos 	 = trim( this.object.cencos			[al_row] )
			ls_plantilla = trim( this.object.cod_plantilla	[al_row] )
			
			if not parent.of_validar_plant_det( ls_cencos, ls_cnta_prsp, ls_plantilla ) then 
				MessageBox('Error', 'CUENTA PRESUPUESTAL YA ESTA ASIGNADA A OTRA PLANTILLA', StopSign! )
				SetNull(ls_cnta_prsp)
				this.object.cnta_prsp	[al_row] = ls_cnta_prsp
				this.object.descr_cuenta[al_row] = ls_data		
				return 
			end if
	
			this.object.descr_cuenta[al_row] 	= ls_data		
			this.object.cnta_prsp	[al_row]   	= ls_cnta_prsp

			this.ii_update = 1
		end if

	case "CENCOS"

		ls_sql = "SELECT CENCOS AS CODIGO_CENCOS, " &
				 + "DESC_CENCOS AS DESCRIPCION_CENTRO_COSTOS " &
             + "FROM CENTROS_COSTO " &
				 + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_cencos, &
					ls_data, '1')
		
		if ls_cencos <> '' then
			ls_plantilla = trim( this.object.cod_plantilla	[al_row] )
			ls_cnta_prsp = trim( this.object.cnta_prsp		[al_row] )
			
			if not parent.of_validar_plant_det( ls_cencos, ls_cnta_prsp, ls_plantilla ) then 
				MessageBox('Error', 'CENTRO DE COSTOS YA ESTA ASIGNADO A OTRA PLANTILLA', StopSign! )
				SetNull(ls_cencos)
				this.object.cencos		[al_row] = ls_cencos
				this.object.descr_cencos[al_row] = ls_data		
				return 
			end if
	
			this.object.desc_cencos	[al_row] = ls_data		
			this.object.cencos		[al_row] = ls_cencos
			this.ii_update = 1
		end if

end choose
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event keydwn;call super::keydwn;string 	ls_columna, ls_cadena
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

event ue_insert_pre;call super::ue_insert_pre;string 	ls_cencos, ls_desc_cencos, ls_plantilla
long 		ll_item, ll_row

ll_row = dw_master.GetRow()
if ll_row = 0 then
	return
end if

ls_plantilla = dw_master.object.cod_plantilla[ll_row]
if ls_plantilla = '' or IsNull(ls_plantilla) then
	return
end if

this.object.cod_plantilla	[al_row] = ls_plantilla
this.object.ratio				[al_row] = 0.0

if al_row > 1 then
	ls_cencos = trim( this.object.cencos[al_row - 1] )
	ll_item	 = long( this.object.item	[al_row - 1] )
	
	select desc_cencos
		into :ls_desc_cencos
	from centros_costo
	where cencos = :ls_cencos;
	
	this.object.item			[al_row] = ll_item +1
	this.object.cencos		[al_row] = ls_cencos
	this.object.desc_cencos	[al_row] = ls_desc_cencos
	
else
	this.object.item			[al_row]	= 1
end if

end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;string 	ls_cnta_prsp, ls_data, ls_imagen, ls_plantilla, ls_cencos, &
			ls_estado, ls_null
long 		ll_count

this.AcceptText()
SetNull(ls_null)

choose case upper(dwo.name)
	case "CNTA_PRSP"
		
		ls_cnta_prsp = this.object.cnta_prsp[row]
		
		SetNull(ls_data)
		select descripcion
			into :ls_data
		from presupuesto_cuenta
		where cnta_prsp = :ls_cnta_prsp
		  and NVL(flag_Estado, '0') = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "CUENTA PRESUPUESTAL NO EXISTE O NO ESTA ACTIVA", StopSign!)
			this.object.cnta_prsp	[row] = ls_null
			this.object.descr_cuenta[row] = ls_null
			this.SetColumn('cnta_prsp')
			return 1
		end if

		ls_cencos 	 = trim( this.object.cencos			[row] )
		ls_plantilla = trim( this.object.cod_plantilla	[row] )
		
		if not parent.of_validar_plant_det( ls_cencos, ls_cnta_prsp, ls_plantilla ) then 
			MessageBox('Error', 'PARTIDA PRESUPUESTAL YA FUE ASIGNADA A LA PLANTILLA', StopSign! )
			this.object.cnta_prsp	[row] = ls_null
			this.object.descr_cuenta[row] = ls_null
			this.SetColumn('cnta_prsp')
			return 1
		end if

		this.object.descr_cuenta[row] = ls_data

	case "CENCOS"
		
		ls_cencos = this.object.cencos[row]
		
		SetNull(ls_data)
		select desc_cencos
			into :ls_data
		from centros_costo
		where cencos = :ls_cencos
		  and NVL(flag_estado, '0') = '1';
		
		if SQLCA.sqlcode = 100 then
			Messagebox('Error', "CENTRO DE COSTO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cencos		[row] = ls_null
			this.object.desc_cencos	[row] = ls_null
			this.SetColumn('cencos')
			return 1
		end if
		
		ls_cnta_prsp = trim( this.object.cnta_prsp[row] )
		ls_plantilla = trim( this.object.cod_plantilla[row] )
		
		if not parent.of_validar_plant_det( ls_cencos, ls_cnta_prsp, ls_plantilla ) then 
			MessageBox('Error', 'PARTIDA PRESUPUESTAL YA FUE ASIGNADA A LA PLANTILLA', StopSign! )
			this.object.cencos		[row] = ls_null
			this.object.desc_cencos	[row] = ls_null
			this.SetColumn('cencos')
			return 1
		end if

		this.object.desc_cencos[row] = ls_data

end choose

end event

