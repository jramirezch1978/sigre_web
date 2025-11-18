$PBExportHeader$w_cm308_cotizacion_bienes_eva.srw
forward
global type w_cm308_cotizacion_bienes_eva from w_abc
end type
type cb_ganardor from commandbutton within w_cm308_cotizacion_bienes_eva
end type
type sle_nro from u_sle_codigo within w_cm308_cotizacion_bienes_eva
end type
type tab_1 from tab within w_cm308_cotizacion_bienes_eva
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tab_1 from tab within w_cm308_cotizacion_bienes_eva
tabpage_1 tabpage_1
end type
type st_evalua_art from statictext within w_cm308_cotizacion_bienes_eva
end type
type cb_1 from commandbutton within w_cm308_cotizacion_bienes_eva
end type
type st_nro from statictext within w_cm308_cotizacion_bienes_eva
end type
type sle_ori from singlelineedit within w_cm308_cotizacion_bienes_eva
end type
type st_ori from statictext within w_cm308_cotizacion_bienes_eva
end type
type dw_master from u_dw_abc within w_cm308_cotizacion_bienes_eva
end type
type dw_evalua_art from u_dw_abc within w_cm308_cotizacion_bienes_eva
end type
end forward

global type w_cm308_cotizacion_bienes_eva from w_abc
integer width = 3122
integer height = 2576
string title = "Evaluacion de cotizaciones [CM308]"
string menuname = "m_mtto_imp_mail"
cb_ganardor cb_ganardor
sle_nro sle_nro
tab_1 tab_1
st_evalua_art st_evalua_art
cb_1 cb_1
st_nro st_nro
sle_ori sle_ori
st_ori st_ori
dw_master dw_master
dw_evalua_art dw_evalua_art
end type
global w_cm308_cotizacion_bienes_eva w_cm308_cotizacion_bienes_eva

type variables
u_dw_abc	idw_evalua_prov
end variables

forward prototypes
public subroutine of_retrieve (string as_origen, string as_nro)
end prototypes

public subroutine of_retrieve (string as_origen, string as_nro);Long ll_row

ll_row = dw_master.retrieve(as_origen, as_nro)

if ll_row > 0 then
	dw_master.il_row = dw_master.getrow()
	idw_1 = dw_master
	if is_flag_modificar = '1' then
		m_master.m_file.m_basedatos.m_modificar.enabled = true
	else
		m_master.m_file.m_basedatos.m_modificar.enabled = false
	end if

	// Muestra datos segun primera cotizacion
	dw_master.post event ue_refresh_det()
	dw_master.object.p_logo.FileName = gs_logo
	idw_evalua_prov.ii_protect = 0
	idw_evalua_prov.of_protect()
end if

end subroutine

on w_cm308_cotizacion_bienes_eva.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_imp_mail" then this.MenuID = create m_mtto_imp_mail
this.cb_ganardor=create cb_ganardor
this.sle_nro=create sle_nro
this.tab_1=create tab_1
this.st_evalua_art=create st_evalua_art
this.cb_1=create cb_1
this.st_nro=create st_nro
this.sle_ori=create sle_ori
this.st_ori=create st_ori
this.dw_master=create dw_master
this.dw_evalua_art=create dw_evalua_art
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ganardor
this.Control[iCurrent+2]=this.sle_nro
this.Control[iCurrent+3]=this.tab_1
this.Control[iCurrent+4]=this.st_evalua_art
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.st_nro
this.Control[iCurrent+7]=this.sle_ori
this.Control[iCurrent+8]=this.st_ori
this.Control[iCurrent+9]=this.dw_master
this.Control[iCurrent+10]=this.dw_evalua_art
end on

on w_cm308_cotizacion_bienes_eva.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_ganardor)
destroy(this.sle_nro)
destroy(this.tab_1)
destroy(this.st_evalua_art)
destroy(this.cb_1)
destroy(this.st_nro)
destroy(this.sle_ori)
destroy(this.st_ori)
destroy(this.dw_master)
destroy(this.dw_evalua_art)
end on

event ue_open_pre;idw_evalua_prov 	= tab_1.tabpage_1.dw_1

dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
dw_evalua_art.SetTransObject(sqlca)
idw_evalua_prov.SetTransObject(sqlca)

idw_1 = dw_master              		// asignar dw corriente
dw_master.of_protect()         		// bloquear modificaciones 
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)


end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

idw_evalua_prov.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	idw_evalua_prov.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_evalua_prov.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		MessageBox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF
IF lbo_ok THEN
	COMMIT using SQLCA;	
	idw_evalua_prov.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
END IF
end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_list_cotizaciones_eval_tbl"
sl_param.titulo = "Cotizaciones de Bienes"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.tipo = '1S'
sl_param.string1 = 'B'

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	// Se ubica la cabecera
	this.of_retrieve(sl_param.field_ret[1], sl_param.field_ret[2])
END IF
end event

event type long ue_scrollrow(string as_value);Long ll_rc

ll_rc = dw_master.of_ScrollRow(as_value)
dw_master.event ue_refresh_det()
RETURN ll_rc
end event

event resize;call super::resize;idw_evalua_prov 	= tab_1.tabpage_1.dw_1

dw_master.width  		= newwidth  - dw_master.x - 10

dw_evalua_art.width  = newwidth  - dw_evalua_art.x - 10
st_evalua_art.X 		= dw_evalua_art.x
st_evalua_art.width 	= dw_evalua_art.width

tab_1.width = newwidth  - tab_1.x - 10
tab_1.height= newheight  - tab_1.y - 10

idw_evalua_prov.width  = tab_1.width - idw_evalua_prov.x - 50
idw_evalua_prov.height = tab_1.height - idw_evalua_prov.y - 150
end event

event ue_modify;call super::ue_modify;idw_evalua_prov.of_protect()
end event

event ue_update_request;call super::ue_update_request;//
Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF idw_evalua_prov.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		idw_evalua_prov.ii_update = 0
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;idw_evalua_prov.of_set_flag_replicacion()
dw_master.of_set_flag_replicacion()
end event

type cb_ganardor from commandbutton within w_cm308_cotizacion_bienes_eva
integer x = 2066
integer y = 1296
integer width = 626
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Seleccion automática"
end type

event clicked;if MessageBox('Informacion', &
				  'Desea que el sistema seleccione el ganador de manera automática?', &
				  Question!, &
				  YesNo!, 2) = 2 then return
				  

				  
MessageBox('', 'opcion todavía en desarrollo')				  
end event

type sle_nro from u_sle_codigo within w_cm308_cotizacion_bienes_eva
integer x = 896
integer y = 12
integer height = 92
integer taborder = 20
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;cb_1.event clicked()
end event

type tab_1 from tab within w_cm308_cotizacion_bienes_eva
event create ( )
event destroy ( )
integer y = 1304
integer width = 2990
integer height = 840
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.Control[]={this.tabpage_1}
end on

on tab_1.destroy
destroy(this.tabpage_1)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2953
integer height = 712
long backcolor = 79741120
string text = "Proveedores que cotizaron"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from u_dw_abc within tabpage_1
integer width = 2917
integer height = 696
integer taborder = 50
string dataobject = "d_abc_cotizacion_evalua_prov_204_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'	
ii_rk[1] = 1 
ii_rk[2] = 2 
ii_rk[3] = 3 
end event

event itemchanged;call super::itemchanged;// solo acepta aquellos que han sido cotizados
String 			ls_origen, ls_nro, ls_prov, ls_art
Long 				ln_count, ll_row_mas
Date 				ld_fecha
str_parametros  lstr_param
w_rpt_preview	lw_1

ll_row_mas = dw_master.GetRow()
if ll_row_mas <= 0 then return 1

if dwo.name = "flag_ganador" then
	if this.object.cotizo[row] = "0" then		
		Messagebox( "Atencion", "Este proveedor no ha cotizado", Exclamation!)
		return 0
	end if
	
	ls_origen = dw_master.object.cod_origen	[ll_row_mas]
	ls_nro    = dw_master.object.nro_cotiza	[ll_row_mas]
	ls_prov   = this.object.proveedor			[row]
	ls_art    = dw_evalua_art.object.cod_art	[dw_evalua_art.getrow()]
	
	// Verifica que no se duplique articulo ganador
	if data = '1' then
		ld_fecha = DATE(f_fecha_actual())
		Select count( * ) 
			into :ln_count 
		from 	cotizacion_provee_bien_det cd, 
				cotizacion_provee cp
		where cp.cod_origen = cd.cod_origen 
		  and cp.nro_cotiza = cd.nro_cotiza 
		  and cp.proveedor  = cd.proveedor
		  and cd.cod_art = :ls_art 
		  and cd.flag_ganador = '1' 
		  and trunc(cp.fec_vigencia) >= trunc(:ld_fecha);
		
		if SQLCA.SQlCode < 0 then
			MessageBox( 'Aviso', sqlca.sqlerrtext, StopSign!)
			return 0
		end if
		
		if ln_count > 0 then
			if messagebox( "Atencion", "Codigo ya tiene proveedor ganador, Desea visualizar las cotizaciones que esta relacionadas?", &
				StopSign!, YesNo!, 2) = 1 then
				
				lstr_param.dw1     = 'd_cns_cotizacion_vigente'
				lstr_param.titulo  = 'Cotizaciones Vigentes por Artículo y proveedor'
				lstr_param.tipo 	 = '1S1D'
				lstr_param.fecha1  = ld_fecha
				lstr_param.string1 = ls_art
	
				OpenSheetWithParm( lw_1, lstr_param, w_main, 0, Layered!)
				
			end if

			this.object.flag_ganador[row] = '0'

			return 0
		end if
		  
	end if
	
end if
end event

event rowfocuschanged;call super::rowfocuschanged;IF CurrentRow = 0 OR is_dwform = 'form' THEN RETURN

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event itemerror;call super::itemerror;Return 1		// Fuerza a no mostrar mensaje de error
end event

type st_evalua_art from statictext within w_cm308_cotizacion_bienes_eva
integer x = 859
integer y = 592
integer width = 1161
integer height = 64
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Articulos que se han cotizado"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cm308_cotizacion_bienes_eva
integer x = 1449
integer y = 8
integer width = 402
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;EVENT ue_update_request()
of_retrieve(sle_ori.text, sle_nro.text)
end event

type st_nro from statictext within w_cm308_cotizacion_bienes_eva
integer x = 613
integer y = 24
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero:"
boolean focusrectangle = false
end type

type sle_ori from singlelineedit within w_cm308_cotizacion_bienes_eva
integer x = 329
integer y = 12
integer width = 229
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_ori from statictext within w_cm308_cotizacion_bienes_eva
integer x = 78
integer y = 24
integer width = 247
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_cm308_cotizacion_bienes_eva
event ue_refresh_det ( )
integer x = 23
integer y = 140
integer width = 2990
integer height = 412
integer taborder = 40
string dataobject = "d_abc_cotizacion_bienes_204_ff"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_refresh_det();/*
   Evento creado para reemplazar al evento output sin argumento,
	esto para ser usado en la ventana w_pop             
*/

Long ll_row
ll_row = dw_master.getrow()

THIS.EVENT ue_retrieve_det(ll_row)
if idw_det.RowCount() > 1 then
	idw_det.SetRow(1)
	f_select_current_row(idw_det)
end if


end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'md'		
is_dwform = 'form'	// tabular, form (default)

ii_ss = 1
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

idw_mst  = dw_master
idw_det  = dw_evalua_art
end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2], 'B')


end event

type dw_evalua_art from u_dw_abc within w_cm308_cotizacion_bienes_eva
integer y = 672
integer width = 2994
integer height = 616
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_abc_cotizacion_bienes_eva_206_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'	
ii_dk[1] = 1 	
ii_dk[2] = 2
ii_dk[3] = 3

idw_det  = tab_1.tabpage_1.dw_1
end event

event rowfocuschanged;call super::rowfocuschanged;IF CurrentRow = 0 OR is_dwform = 'form' THEN RETURN

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event ue_output;call super::ue_output;parent.event ue_update_request()
THIS.EVENT ue_retrieve_det(al_row)

if idw_det.RowCount() > 0 then
	idw_det.SetRow(1)
	idw_det.SelectRow(0, False)
	idw_det.SelectRow(1, True)
end if

end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;String ls_cod_art

ls_cod_art = this.object.cod_art[this.getrow()]
idw_det.retrieve(aa_id[1],aa_id[2], ls_cod_art)
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

