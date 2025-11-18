$PBExportHeader$w_cm307_cotizacion_bienes_act.srw
forward
global type w_cm307_cotizacion_bienes_act from w_abc_mid
end type
type dw_1 from u_dw_abc within w_cm307_cotizacion_bienes_act
end type
type st_ori from statictext within w_cm307_cotizacion_bienes_act
end type
type sle_ori from singlelineedit within w_cm307_cotizacion_bienes_act
end type
type st_nro from statictext within w_cm307_cotizacion_bienes_act
end type
type sle_nro from singlelineedit within w_cm307_cotizacion_bienes_act
end type
type cb_1 from commandbutton within w_cm307_cotizacion_bienes_act
end type
end forward

global type w_cm307_cotizacion_bienes_act from w_abc_mid
integer width = 4201
integer height = 2168
string title = "Actualizacion de cotizaciones [cm307]"
string menuname = "m_mtto_imp_mail"
windowstate windowstate = maximized!
dw_1 dw_1
st_ori st_ori
sle_ori sle_ori
st_nro st_nro
sle_nro sle_nro
cb_1 cb_1
end type
global w_cm307_cotizacion_bienes_act w_cm307_cotizacion_bienes_act

forward prototypes
public subroutine of_set_status (string as_cotizo)
public subroutine of_retrieve (string as_origen, string as_nro)
end prototypes

public subroutine of_set_status (string as_cotizo);datetime ld_fecha
String ls_str
Long ll_num
Int j

//if as_cotizo = '1' THEN		// si cotizo		
//	// Activa datos
//	dw_detmast.object.forma_pago.dddw.required	='yes'
//	dw_detmast.object.cod_moneda.dddw.required	='yes'
//	dw_detmast.object.fec_vigencia.edit.required	='yes'
//	dw_detmast.object.forma_pago.tabsequence		=20
//	dw_detmast.object.cod_moneda.tabsequence		=30
//	dw_detmast.object.fec_vigencia.tabsequence	=40
//	
//	dw_detail.object.cant_procesada.editMask.required="yes"
//	dw_detail.object.cant_procesada.tabsequence		=10
//	dw_detail.object.precio_unit.tabsequence			=20
//	dw_detail.object.decuento.tabsequence				=30
//	dw_detail.object.marca.tabsequence					=40
//	dw_detail.object.disponibilidad.tabsequence		=50
//		
//else
//	setnull( ld_fecha )
//	setnull( ls_str )
//	setnull( ll_num )
//	
//	dw_detmast.object.forma_pago.dddw.required	="no"
//	dw_detmast.object.cod_moneda.dddw.required	="no"
//	dw_detmast.object.fec_vigencia.edit.required	="no"
//	dw_detmast.object.forma_pago.tabsequence		=0
//	dw_detmast.object.cod_moneda.tabsequence		=0
//	dw_detmast.object.fec_vigencia.tabsequence	=0
//	dw_detmast.object.forma_pago			[1] = ls_str
//	dw_detmast.object.cod_moneda			[1] = ls_str
//	dw_detmast.object.fec_vigencia		[1] = ld_fecha
//	
//	dw_detail.object.cant_procesada.editMask.required	="no"
//	dw_detail.object.cant_procesada.tabsequence		=0
//	dw_detail.object.precio_unit.tabsequence			=0
//	dw_detail.object.decuento.tabsequence				=0
//	dw_detail.object.marca.tabsequence					=0
//	dw_detail.object.disponibilidad.tabsequence		=0
//	
//	For j = 1 to dw_detail.RowCount()
//		dw_detail.object.cant_procesada	[j]=ll_num
//		dw_detail.object.precio_unit		[j]=ll_num
//	Next
//end if
end subroutine

public subroutine of_retrieve (string as_origen, string as_nro);Long ll_row

ll_row = dw_master.retrieve(as_origen, as_nro)
dw_master.post event ue_refresh_det()

if ll_row > 0 then
	dw_master.il_row = dw_master.getrow()
	idw_1 = dw_master
	idw_1.object.p_logo.FileName = gs_logo
	if is_flag_modificar = '1' then
		m_master.m_file.m_basedatos.m_modificar.enabled = true
	else
		m_master.m_file.m_basedatos.m_modificar.enabled = false
	end if
	
	// Muestra datos segun primera cotizacion
	dw_1.retrieve( as_origen, as_nro)
	
end if


end subroutine

on w_cm307_cotizacion_bienes_act.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_imp_mail" then this.MenuID = create m_mtto_imp_mail
this.dw_1=create dw_1
this.st_ori=create st_ori
this.sle_ori=create sle_ori
this.st_nro=create st_nro
this.sle_nro=create sle_nro
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.st_ori
this.Control[iCurrent+3]=this.sle_ori
this.Control[iCurrent+4]=this.st_nro
this.Control[iCurrent+5]=this.sle_nro
this.Control[iCurrent+6]=this.cb_1
end on

on w_cm307_cotizacion_bienes_act.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.st_ori)
destroy(this.sle_ori)
destroy(this.st_nro)
destroy(this.sle_nro)
destroy(this.cb_1)
end on

event ue_open_pre();call super::ue_open_pre;//ii_help = 101           					// help topic
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)


end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_list_cotizaciones_tbl"
sl_param.titulo = "Cotizaciones de Bienes"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.tipo = '1S'
sl_param.string1 = 'B'

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	// Se ubica la cabecera
	of_retrieve( sl_param.field_ret[1], sl_param.field_ret[2])

END IF
end event

event ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_detmast, "form") <> true then	
	return	
end if	

//// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then	
	return
end if
ib_update_check = True

dw_master.of_set_flag_replicacion()
dw_detmast.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

event ue_insert_pos(long al_row);call super::ue_insert_pos;dw_detail.setcolumn('precio_unit')
end event

type dw_master from w_abc_mid`dw_master within w_cm307_cotizacion_bienes_act
event ue_refresh_det ( )
integer x = 0
integer y = 124
integer width = 3826
integer height = 540
integer taborder = 40
string dataobject = "d_abc_cotizacion_bienes_204_ff"
end type

event dw_master::ue_refresh_det();/*
   Evento creado para reemplazar al evento output sin argumento,
	esto para ser usado en la ventana w_pop             
*/

Long ll_row
ll_row = dw_master.getrow()
if ll_row > 0 then	
	THIS.EVENT ue_retrieve_det(ll_row)
	if idw_det.RowCount() > 0 then
		idw_det.ScrollToRow(1)
	end if
end if
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;
dw_1.reset()
idw_det.retrieve(aa_id[1],aa_id[2], 'B')
dw_1.retrieve(aa_id[1],aa_id[2])
end event

type dw_detail from w_abc_mid`dw_detail within w_cm307_cotizacion_bienes_act
integer x = 0
integer y = 1168
integer width = 3360
integer height = 648
integer taborder = 50
string dataobject = "d_abc_cotizacion_update_det_204_tbl"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2
end event

event dw_detail::itemerror;call super::itemerror;Return 1
end event

event dw_detail::clicked;call super::clicked;this.SetColumn('cant_procesada')
end event

type dw_detmast from w_abc_mid`dw_detmast within w_cm307_cotizacion_bienes_act
integer x = 1993
integer y = 676
integer width = 2144
integer height = 476
integer taborder = 70
string dataobject = "d_abc_cotizacion_update_204_ff"
end type

event dw_detmast::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
is_dwform = 'form'
end event

event dw_detmast::doubleclicked;call super::doubleclicked;String ls_name, ls_prot
Datawindow ldw

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_name = 'fec_vigencia' and ls_prot = '0' then
	ldw = this
	if row < 1 then return 1
	if dwo.type <> 'column' then return 1

	f_call_calendar( ldw, dwo.name, dwo.coltype, row)
	ii_update = 1
//	this.AcceptText()
//   of_get_fecha2(DATE( this.object.fec_requerida[this.getrow()]))
end if
end event

event dw_detmast::itemchanged;call super::itemchanged;if dwo.name = "cotizo" then
	if data = '1' then  // Actualizo fecha de registro de cotizacion
		this.object.fec_registro[row] = TODAY()
	end if
	of_set_status( data)
end if
end event

event dw_detmast::itemerror;call super::itemerror;Return 1
end event

type dw_1 from u_dw_abc within w_cm307_cotizacion_bienes_act
integer y = 676
integer width = 1966
integer height = 476
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_sel_cotizacion_proveedor_205"
end type

event constructor;call super::constructor;THIS.SetTransObject(sqlca)
ii_ck[1] = 1		

is_dwform = 'tabular'
end event

event clicked;call super::clicked;Long ll_row, ll_row2, j
String ls_origen, ls_proveedor, ls_nro_cotiza, ls_cod_Art
double ln_cant

ll_row = this.getrow()
if ll_row > 0 then
	ls_nro_cotiza 	= this.object.nro_cotiza[ll_row]
	ls_origen 		= this.object.cod_origen[ll_row]
	ls_proveedor 	= this.object.proveedor	[ll_row]

	ll_row2 = dw_detmast.retrieve( ls_origen, ls_nro_cotiza, ls_proveedor)  // Muestra proveedor
	dw_detail.reset()
	dw_detail.retrieve( ls_origen, ls_nro_cotiza, ls_proveedor)  // muestra detalle proveedor
	dw_detail.ii_update = 0
	of_set_status( dw_detmast.object.cotizo[ll_row2] )
	// Asigna cantidad cotizada segun articulo
	For j = 1 to dw_detail.rowcount()
		ls_cod_art = dw_detail.object.cod_art[j]
		Select cant_cotizada 
			into :ln_cant 
		from cotizacion_provee_bien_det 
		Where cod_origen 	= :ls_origen 
		  and nro_cotiza 	= :ls_nro_cotiza 
		  and proveedor 	= :ls_proveedor 
		  and cod_art 		= :ls_cod_Art;
		  
		if ln_cant > 0 then
			dw_detail.object.cant_procesada[j] = ln_Cant
		end if
	Next	
end if
end event

type st_ori from statictext within w_cm307_cotizacion_bienes_act
integer x = 82
integer y = 28
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

type sle_ori from singlelineedit within w_cm307_cotizacion_bienes_act
integer x = 311
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

type st_nro from statictext within w_cm307_cotizacion_bienes_act
integer x = 617
integer y = 20
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

type sle_nro from singlelineedit within w_cm307_cotizacion_bienes_act
integer x = 887
integer y = 8
integer width = 512
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;cb_1.event clicked()
end event

type cb_1 from commandbutton within w_cm307_cotizacion_bienes_act
integer x = 1499
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

