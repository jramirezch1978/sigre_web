$PBExportHeader$w_cn231_anexos_conceptos.srw
forward
global type w_cn231_anexos_conceptos from w_abc_mastdet
end type
type dw_asientos from datawindow within w_cn231_anexos_conceptos
end type
type em_ano from uo_ingreso_numerico within w_cn231_anexos_conceptos
end type
type st_1 from statictext within w_cn231_anexos_conceptos
end type
type st_2 from statictext within w_cn231_anexos_conceptos
end type
type sle_cnta_cntbl from singlelineedit within w_cn231_anexos_conceptos
end type
type cb_buscar from commandbutton within w_cn231_anexos_conceptos
end type
type pb_importar from picturebutton within w_cn231_anexos_conceptos
end type
type cb_1 from commandbutton within w_cn231_anexos_conceptos
end type
type gb_busqueda from groupbox within w_cn231_anexos_conceptos
end type
end forward

global type w_cn231_anexos_conceptos from w_abc_mastdet
integer width = 2670
integer height = 1840
string title = "[CN231] Conceptos de Cuentas Contables"
string menuname = "m_mastdet_eliminar"
dw_asientos dw_asientos
em_ano em_ano
st_1 st_1
st_2 st_2
sle_cnta_cntbl sle_cnta_cntbl
cb_buscar cb_buscar
pb_importar pb_importar
cb_1 cb_1
gb_busqueda gb_busqueda
end type
global w_cn231_anexos_conceptos w_cn231_anexos_conceptos

on w_cn231_anexos_conceptos.create
int iCurrent
call super::create
if this.MenuName = "m_mastdet_eliminar" then this.MenuID = create m_mastdet_eliminar
this.dw_asientos=create dw_asientos
this.em_ano=create em_ano
this.st_1=create st_1
this.st_2=create st_2
this.sle_cnta_cntbl=create sle_cnta_cntbl
this.cb_buscar=create cb_buscar
this.pb_importar=create pb_importar
this.cb_1=create cb_1
this.gb_busqueda=create gb_busqueda
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_asientos
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_cnta_cntbl
this.Control[iCurrent+6]=this.cb_buscar
this.Control[iCurrent+7]=this.pb_importar
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.gb_busqueda
end on

on w_cn231_anexos_conceptos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_asientos)
destroy(this.em_ano)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_cnta_cntbl)
destroy(this.cb_buscar)
destroy(this.pb_importar)
destroy(this.cb_1)
destroy(this.gb_busqueda)
end on

event resize;call super::resize;//Override

gb_busqueda.width = newwidth - gb_busqueda.x - 28

cb_buscar.x = gb_busqueda.width - cb_buscar.width - 28

pb_importar.y = ( gb_busqueda.y + gb_busqueda.height ) + 28
pb_importar.x = gb_busqueda.width - pb_importar.width + gb_busqueda.x

dw_master.width = newwidth - pb_importar.width - 56 - dw_master.x //(newwidth - dw_master.x)
dw_master.y = ( gb_busqueda.y + gb_busqueda.height ) + 28
dw_master.height = ( newheight - dw_master.y ) / 2

dw_asientos.y = ( dw_master.height + dw_master.y + 28 )
dw_asientos.height = dw_master.height - 48
dw_asientos.width = ( (newwidth - dw_master.x) / 2 ) - 14

dw_detail.y = ( dw_master.height + dw_master.y + 28 )
dw_detail.x = ( dw_asientos.width + dw_asientos.x ) + 28
dw_detail.height = dw_master.height - 48
dw_detail.width  = ( (newwidth - dw_master.x) / 2 ) - 14
end event

event ue_open_pre;//Override

THIS.EVENT POST ue_set_access()					// setear los niveles de acceso IEMC
THIS.EVENT POST ue_set_access_cb()				// setear los niveles de acceso IEMC
THIS.EVENT Post ue_open_pos()
im_1 = CREATE m_rButton      	

dw_master.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)
dw_asientos.Settransobject(sqlca)
idw_1 = dw_master              			// asignar dw corriente
//dw_master.of_protect()         			// bloquear modificaciones 
dw_detail.of_protect()
end event

type dw_master from w_abc_mastdet`dw_master within w_cn231_anexos_conceptos
integer x = 37
integer y = 256
integer width = 2235
integer height = 740
string dataobject = "d_abc_concepto_anexo"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 				dw_master
idw_det  =  			dw_detail
end event

event dw_master::clicked;call super::clicked;if row = 0 then return

idw_1.BorderStyle = StyleLowered!

integer li_ano
string ls_cnta, ls_concep

li_ano = this.object.ano[row]
ls_cnta = this.object.cnta_ctbl[row]
ls_concep = this.object.concepto_cnt[row]

dw_asientos.retrieve( li_ano , ls_cnta )
dw_detail.retrieve(  li_ano , trim(ls_cnta) , trim(ls_concep) )
end event

type dw_detail from w_abc_mastdet`dw_detail within w_cn231_anexos_conceptos
integer x = 1317
integer y = 1024
integer width = 1248
integer height = 548
string dataobject = "d_abc_concepto_anexo_det"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 				dw_master
idw_det  =  			dw_detail
end event

event dw_detail::clicked;call super::clicked;idw_1.BorderStyle = StyleLowered!
end event

event dw_detail::dragdrop;call super::dragdrop;if source = dw_asientos then
	
	long ll_ano, ll_mes, ll_libro, ll_asiento, ll_item_lista, ll_item_master, ll_row
	string ls_origen, ls_cnta, ls_concep
	
	ll_ano     	   = dw_master.object.ano[dw_master.getrow( )]
	ll_item_master = dw_master.object.nro_item[dw_master.getrow( )]
	ls_cnta			= dw_master.object.cnta_ctbl[dw_master.getrow( )]
	ls_concep		= dw_master.object.concepto_cnt[dw_master.getrow( )]
	
	ls_origen		= dw_asientos.object.origen[dw_asientos.getrow( )]
	ll_mes     	   = dw_asientos.object.mes[dw_asientos.getrow( )]
	ll_libro       = dw_asientos.object.nro_libro[dw_asientos.getrow( )]
	ll_asiento     = dw_asientos.object.nro_asiento[dw_asientos.getrow( )]
	ll_item_lista  = dw_asientos.object.item[dw_asientos.getrow( )]
	
	ll_row = this.insertrow( 0 )
	
	this.object.nro_item[ll_row] = ll_item_master
	this.object.cnta_ctbl[ll_row] = ls_cnta
	this.object.concepto_cnt[ll_row] = ls_concep
	this.object.origen[ll_row] = ls_origen
	this.object.ano[ll_row] = ll_ano
	this.object.mes[ll_row] = ll_mes
	this.object.nro_libro[ll_row] = ll_libro
	this.object.nro_asiento[ll_row] = ll_asiento
	this.object.item[ll_row] = ll_item_lista
	
	this.groupcalc( )
	
	this.ii_update = 1
	
	dw_asientos.deleterow( dw_asientos.getrow() )
	
	parent.event ue_update()
	
	this.retrieve( ll_ano, trim(ls_cnta), trim(ls_concep) )
	
end if
end event

event dw_detail::doubleclicked;call super::doubleclicked;if row = 0 then return

str_parametros lstr_parametros

lstr_parametros.string1 = this.object.origen[row]
lstr_parametros.string2 = string(this.object.ano[row])
lstr_parametros.string3 = string(this.object.mes[row])
lstr_parametros.string4 = string(this.object.nro_libro[row])
lstr_parametros.string5 = string(this.object.nro_asiento[row])

openwithparm(w_cn233_anexos_conceptos_Det,lstr_parametros)
end event

type dw_asientos from datawindow within w_cn231_anexos_conceptos
integer x = 37
integer y = 1024
integer width = 1248
integer height = 548
integer taborder = 30
string dragicon = "H:\source\Ico\row2.ico"
boolean bringtotop = true
string title = "none"
string dataobject = "d_abc_concepto_anexo_lista"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;f_select_current_row(this)
end event

event doubleclicked;if row = 0 then return

str_parametros lstr_parametros

lstr_parametros.string1 = this.object.origen[row]
lstr_parametros.string2 = string(this.object.ano[row])
lstr_parametros.string3 = string(this.object.mes[row])
lstr_parametros.string4 = string(this.object.nro_libro[row])
lstr_parametros.string5 = string(this.object.nro_asiento[row])

openwithparm(w_cn233_anexos_conceptos_Det,lstr_parametros)
end event

event clicked;this.drag( begin! )
end event

type em_ano from uo_ingreso_numerico within w_cn231_anexos_conceptos
integer x = 229
integer y = 108
integer width = 242
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
string text = "2004"
string mask = "####"
double increment = 1
end type

event constructor;call super::constructor;this.text = string(today(),'yyyy')
end event

type st_1 from statictext within w_cn231_anexos_conceptos
integer x = 73
integer y = 120
integer width = 133
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn231_anexos_conceptos
integer x = 498
integer y = 120
integer width = 425
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cuenta Contable:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_cnta_cntbl from singlelineedit within w_cn231_anexos_conceptos
integer x = 937
integer y = 108
integer width = 425
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event losefocus;string ls_cuenta
long ll_count

ls_cuenta = trim(this.text)

if ls_cuenta = '' or isnull(ls_cuenta) then return

select count(*)
  into :ll_count
  from cntbl_cnta
 where cnta_ctbl = :ls_cuenta;
	
if ll_count = 0 then
	messagebox('Aviso','Cuenta Contable no existe')
	this.text = ''
end if
end event

type cb_buscar from commandbutton within w_cn231_anexos_conceptos
integer x = 2181
integer y = 96
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;integer li_ano
string  ls_cnta_ctbl

li_ano = integer(em_ano.text)

ls_cnta_ctbl = trim(string(sle_cnta_cntbl.text))

if trim(ls_cnta_ctbl) = '' or isnull(ls_cnta_ctbl) then
	ls_cnta_ctbl = '%'
end if

dw_master.retrieve( li_ano, ls_cnta_ctbl )
end event

type pb_importar from picturebutton within w_cn231_anexos_conceptos
integer x = 2304
integer y = 256
integer width = 261
integer height = 164
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\Gif\importar.gif"
string powertiptext = "Importar Cuentas y Conceptos"
end type

event clicked;integer li_ano

open(w_cn232_importar_cntas_conceptos)

if message.stringparm <> '' then
	
	li_ano = integer(message.stringparm)
	
	dw_master.retrieve( li_ano , '%' )
	
end if
end event

type cb_1 from commandbutton within w_cn231_anexos_conceptos
integer x = 1381
integer y = 108
integer width = 96
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
								 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
								 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
								 +'FROM CNTBL_CNTA ' &
								 +'WHERE CNTBL_CNTA.FLAG_PERMITE_MOV = 1 AND FLAG_ESTADO <> 0 '
									  
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_cnta_cntbl.text = lstr_seleccionar.param1[1]
END IF
end event

type gb_busqueda from groupbox within w_cn231_anexos_conceptos
integer x = 37
integer y = 32
integer width = 2528
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda"
end type

