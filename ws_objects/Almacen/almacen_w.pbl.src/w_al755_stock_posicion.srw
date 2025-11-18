$PBExportHeader$w_al755_stock_posicion.srw
forward
global type w_al755_stock_posicion from w_report_smpl
end type
type cb_1 from commandbutton within w_al755_stock_posicion
end type
type cbx_almacen from checkbox within w_al755_stock_posicion
end type
type sle_almacen from singlelineedit within w_al755_stock_posicion
end type
type sle_descrip from singlelineedit within w_al755_stock_posicion
end type
type uo_fecha from u_ingreso_fecha within w_al755_stock_posicion
end type
type cbx_articulo from checkbox within w_al755_stock_posicion
end type
type sle_cod_art from singlelineedit within w_al755_stock_posicion
end type
type sle_desc_art from singlelineedit within w_al755_stock_posicion
end type
type cbx_pallet from checkbox within w_al755_stock_posicion
end type
type sle_pallet from singlelineedit within w_al755_stock_posicion
end type
type cbx_saldo from checkbox within w_al755_stock_posicion
end type
type st_2 from statictext within w_al755_stock_posicion
end type
type em_origen from editmask within w_al755_stock_posicion
end type
type cb_origen from commandbutton within w_al755_stock_posicion
end type
type em_descripcion from editmask within w_al755_stock_posicion
end type
type st_1 from statictext within w_al755_stock_posicion
end type
type em_cod_clase from editmask within w_al755_stock_posicion
end type
type cb_2 from commandbutton within w_al755_stock_posicion
end type
type em_desc_clase from editmask within w_al755_stock_posicion
end type
type rb_1 from radiobutton within w_al755_stock_posicion
end type
type rb_2 from radiobutton within w_al755_stock_posicion
end type
type gb_1 from groupbox within w_al755_stock_posicion
end type
end forward

global type w_al755_stock_posicion from w_report_smpl
integer width = 4087
integer height = 2472
string title = "[AL755] Saldo Resumen de Articulos por posicion"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
cb_1 cb_1
cbx_almacen cbx_almacen
sle_almacen sle_almacen
sle_descrip sle_descrip
uo_fecha uo_fecha
cbx_articulo cbx_articulo
sle_cod_art sle_cod_art
sle_desc_art sle_desc_art
cbx_pallet cbx_pallet
sle_pallet sle_pallet
cbx_saldo cbx_saldo
st_2 st_2
em_origen em_origen
cb_origen cb_origen
em_descripcion em_descripcion
st_1 st_1
em_cod_clase em_cod_clase
cb_2 cb_2
em_desc_clase em_desc_clase
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_al755_stock_posicion w_al755_stock_posicion

type variables

end variables

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al755_stock_posicion.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.cbx_almacen=create cbx_almacen
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.uo_fecha=create uo_fecha
this.cbx_articulo=create cbx_articulo
this.sle_cod_art=create sle_cod_art
this.sle_desc_art=create sle_desc_art
this.cbx_pallet=create cbx_pallet
this.sle_pallet=create sle_pallet
this.cbx_saldo=create cbx_saldo
this.st_2=create st_2
this.em_origen=create em_origen
this.cb_origen=create cb_origen
this.em_descripcion=create em_descripcion
this.st_1=create st_1
this.em_cod_clase=create em_cod_clase
this.cb_2=create cb_2
this.em_desc_clase=create em_desc_clase
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cbx_almacen
this.Control[iCurrent+3]=this.sle_almacen
this.Control[iCurrent+4]=this.sle_descrip
this.Control[iCurrent+5]=this.uo_fecha
this.Control[iCurrent+6]=this.cbx_articulo
this.Control[iCurrent+7]=this.sle_cod_art
this.Control[iCurrent+8]=this.sle_desc_art
this.Control[iCurrent+9]=this.cbx_pallet
this.Control[iCurrent+10]=this.sle_pallet
this.Control[iCurrent+11]=this.cbx_saldo
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.em_origen
this.Control[iCurrent+14]=this.cb_origen
this.Control[iCurrent+15]=this.em_descripcion
this.Control[iCurrent+16]=this.st_1
this.Control[iCurrent+17]=this.em_cod_clase
this.Control[iCurrent+18]=this.cb_2
this.Control[iCurrent+19]=this.em_desc_clase
this.Control[iCurrent+20]=this.rb_1
this.Control[iCurrent+21]=this.rb_2
this.Control[iCurrent+22]=this.gb_1
end on

on w_al755_stock_posicion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cbx_almacen)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.uo_fecha)
destroy(this.cbx_articulo)
destroy(this.sle_cod_art)
destroy(this.sle_desc_art)
destroy(this.cbx_pallet)
destroy(this.sle_pallet)
destroy(this.cbx_saldo)
destroy(this.st_2)
destroy(this.em_origen)
destroy(this.cb_origen)
destroy(this.em_descripcion)
destroy(this.st_1)
destroy(this.em_cod_clase)
destroy(this.cb_2)
destroy(this.em_desc_clase)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Date 		ld_fecha
String 	ls_alm, ls_articulo, ls_pallet, ls_flag_saldo, ls_origen, ls_clase

ld_fecha = uo_fecha.of_get_fecha()

if trim(em_origen.text) = '' then
	MessageBox('Error', 'Debe especificar un origen, por favor corrija', StopSign!)
	em_origen.setFocus()
	return
end if

ls_origen = em_origen.text

if trim(em_cod_clase.text) = '' then
	MessageBox('Error', 'Debe especificar UNA CLASE DE ARTICULO, por favor corrija', StopSign!)
	em_cod_clase.setFocus()
	return
end if

ls_clase = em_cod_clase.text


if cbx_almacen.checked then
	ls_alm = '%%'
else
	if trim(sle_almacen.text) = '' then
		MessageBox('Error', 'Debe especificar un almacen, por favor corrija', StopSign!)
		sle_almacen.setFocus()
		return
	end if
	
	ls_alm = trim(sle_almacen.text) + '%'
end if

if cbx_articulo.checked then
	ls_articulo = '%%'
else
	if trim(sle_cod_art.text) = '' then
		MessageBox('Error', 'Debe especificar un ARTICULO, por favor corrija', StopSign!)
		sle_cod_art.setFocus()
		return
	end if
	
	ls_articulo = trim(sle_cod_art.text) + '%'
end if

if cbx_pallet.checked then
	ls_pallet = '%%'
else
	if trim(sle_pallet.text) = '' then
		MessageBox('Error', 'Debe especificar un PALLET, por favor corrija', StopSign!)
		sle_pallet.setFocus()
		return
	end if
	
	ls_pallet = trim(sle_pallet.text) + '%'
end if

if cbx_saldo.checked then
	ls_flag_saldo = '1'
else
	ls_flag_saldo = '0'
end if

if rb_1.checked then
	dw_report.DataObject = 'd_rpt_resumen_posicion_tbl'
elseif rb_2.checked then
	dw_report.DataObject = 'd_rpt_resumen_posicion_conservas_tbl'
end if
dw_report.setTransObject(SQLCA)

dw_report.visible = true

ib_preview=true
this.event ue_preview()

dw_report.SetTransObject( sqlca)
dw_report.retrieve(ls_alm, ls_articulo, ls_pallet, ls_flag_saldo, ld_fecha, ls_origen, ls_clase)	


dw_report.object.t_fecha.text 	= 'Stock hasta el : ' & 
		+ STRING(ld_fecha, "DD/MM/YYYY") 	
dw_report.object.t_almacen.text = sle_descrip.text		
dw_report.object.t_user.text 		= gs_user
dw_report.Object.p_logo.filename = gs_logo

dw_report.Object.t_empresa.text = gs_empresa
dw_report.Object.t_objeto.text = dw_report.dataobject


end event

event ue_open_pre;String ls_desc_origen, ls_desc_clase

idw_1 = dw_report
idw_1.SetTransObject(sqlca)

select nombre
	into :ls_Desc_origen
from origen
where cod_origen = :gs_origen;

select desc_clase	
	into :ls_desc_clase
from articulo_clase ac
where ac.cod_clase = :gnvo_app.almacen.is_clase_pptt;


em_origen.text 		= gs_origen
em_descripcion.text 	= ls_Desc_origen

em_cod_clase.text		= gnvo_app.almacen.is_clase_pptt
em_Desc_clase.text	= ls_desc_clase


idw_1.Visible = False

dw_report.Object.DataWindow.Print.Orientation = 1
dw_report.Object.DataWindow.Print.Paper.Size = 8

ib_preview = true
event ue_preview()
end event

type dw_report from w_report_smpl`dw_report within w_al755_stock_posicion
integer x = 0
integer y = 532
integer width = 3378
integer height = 1236
string dataobject = "d_rpt_resumen_posicion_tbl"
end type

event dw_report::rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return

gnvo_app.of_select_current_row(this)
end event

event dw_report::doubleclicked;call super::doubleclicked;String 							ls_cod_art, ls_almacen, ls_nro_pallet
str_parametros					lstr_param
w_al762_consulta_detalle 	lw_1


if row = 0 then return

ls_cod_Art 		= this.object.cod_art 		[row]
ls_almacen		= this.object.almacen		[row]
ls_nro_pallet 	= this.object.nro_pallet	[row]


lstr_param.string1 = ls_cod_Art
lstr_param.string2 = ls_nro_pallet
lstr_param.string3 = ls_almacen

OpenSheetWithParm (lw_1, lstr_param, w_main, 0, layered!)


end event

type cb_1 from commandbutton within w_al755_stock_posicion
integer x = 2825
integer y = 48
integer width = 526
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Generar Reporte"
end type

event clicked;SetPointer( Hourglass!)
Parent.Event ue_retrieve()
SetPointer( Arrow!)
end event

type cbx_almacen from checkbox within w_al755_stock_posicion
integer x = 727
integer y = 232
integer width = 608
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los almacenes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type sle_almacen from singlelineedit within w_al755_stock_posicion
event dobleclick pbm_lbuttondblclk
integer x = 1344
integer y = 228
integer width = 270
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "c:\sigre\resources\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen 
  and FLAG_TIPO_ALMACEN <> 'T';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc

end event

type sle_descrip from singlelineedit within w_al755_stock_posicion
integer x = 1623
integer y = 228
integer width = 1157
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type uo_fecha from u_ingreso_fecha within w_al755_stock_posicion
event destroy ( )
integer x = 23
integer y = 60
integer taborder = 80
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))		
end event

type cbx_articulo from checkbox within w_al755_stock_posicion
integer x = 727
integer y = 324
integer width = 608
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los articulos"
boolean checked = true
end type

event clicked;if this.checked then
	sle_cod_art.enabled = false
else
	sle_cod_art.enabled = true
end if
end event

type sle_cod_art from singlelineedit within w_al755_stock_posicion
event dobleclick pbm_lbuttondblclk
integer x = 1344
integer y = 320
integer width = 270
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "c:\sigre\resources\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_almacen

if cbx_almacen.checked then
	ls_almacen = '%%'
else
	ls_almacen = trim(sle_almacen.text) + '%'
end if


ls_sql = "select distinct a.cod_art as codigo_articulo, " &
		 + "a.desc_Art as descripcion_articulo " &
		 + "from vale_mov vm, " &
		 + "     articulo_mov am, " &
		 + "     articulo     a " &
		 + "where vm.nro_vale = am.nro_Vale " &
		 + "  and am.cod_art  = a.cod_art " &
		 + "  and vm.flag_estado <> '0' " &
		 + "  and am.flag_estado <> '0' " &
		 + "  and a.cod_clase = '01' " &
		 + "  and vm.almacen     like '" + ls_almacen + "'" 
				 

if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	this.text 			= ls_codigo
	sle_desc_art.text = ls_data
end if

end event

event modified;String 	ls_articulo, ls_desc

ls_articulo = trim(this.text)
if ls_articulo = '' or IsNull(ls_articulo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de ARTICULO, por favor corrija', StopSign!)
	return
end if

SELECT desc_art 
	INTO :ls_desc
FROM articulo 
where cod_art = :ls_articulo;


IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de ARTICULO no existe, por favor correjir', StopSign!)
	return
end if

sle_Desc_art.text = ls_desc

end event

type sle_desc_art from singlelineedit within w_al755_stock_posicion
integer x = 1623
integer y = 320
integer width = 1157
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cbx_pallet from checkbox within w_al755_stock_posicion
integer x = 727
integer y = 416
integer width = 608
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los pallets"
boolean checked = true
end type

event clicked;if this.checked then
	sle_pallet.enabled = false
else
	sle_pallet.enabled = true
end if
end event

type sle_pallet from singlelineedit within w_al755_stock_posicion
event dobleclick pbm_lbuttondblclk
integer x = 1344
integer y = 412
integer width = 896
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "c:\sigre\resources\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_almacen, ls_articulo

if cbx_almacen.checked then
	ls_almacen = '%%'
else
	ls_almacen = trim(sle_almacen.text) + '%'
end if

if cbx_articulo.checked then
	ls_articulo = '%%'
else
	ls_articulo = trim(sle_cod_art.text) + '%'
end if


ls_sql = "select am.nro_pallet as numero_pallet, " &
		 + "       am.nro_lote as numero_lote, " &
		 + "       s.fec_produccion as fecha_produccion, " &
		 + "       s.nro_ot as numero_ot, " &
		 + "       s.cant_promedio as cantidad_promedio, " &
		 + "       a.und as und, " &
		 + "       s.cod_art_pptt as cod_art, " &
		 + "       sum(am.cant_procesada * amt.factor_sldo_total) as saldo " &
		 + "from vale_mov vm, " &
		 + "     articulo_mov am, " &
		 + "     articulo_mov_tipo amt, " &
		 + "     articulo a,  " &
		 + "     (select teu.codigo_cu, " &  
		 + "             te.nro_trazabilidad, " & 
		 + "             te.fec_produccion, te.nro_ot, " &  
		 + "             te.cant_producida / te.total_caja as cant_promedio, " &
		 + "             te.cod_art_pptt " &
		 + "        from tg_parte_empaque_und teu, " &
		 + "             tg_parte_empaque     te " &
		 + "        where teu.nro_parte = te.nro_parte) s " &
		 + "where vm.nro_vale = am.nro_vale " &
		 + "  and vm.tipo_mov = amt.tipo_mov  " &
		 + "  and am.cod_art  = a.cod_art  " &
		 + "  and am.cus      = s.codigo_cu   (+) " &
		 + "  and am.flag_estado <> '0' " &
		 + "  and vm.flag_estado <> '0' " &
		 + "  and vm.almacen like '" + ls_almacen + "' " &
		 + "  and am.cod_art like '" + ls_articulo + "' " &
		 + "group by  am.nro_pallet, " &
		 + "       am.nro_lote, " &
		 + "       s.fec_produccion, " &
		 + "       s.nro_ot, " &
		 + "       s.cant_promedio, " &
		 + "       a.und, " &
		 + "       s.cod_art_pptt " &
		 + "having sum(am.cant_procesada * amt.factor_sldo_total) > 0" 
				 

if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	this.text 			= ls_codigo
end if

end event

event modified;String 	ls_pallet, ls_desc

ls_pallet = trim(this.text)

if ls_pallet = '' or IsNull(ls_pallet) then
	MessageBox('Aviso', 'Debe Ingresar un NUMERO de PALLET', StopSign!)
	return
end if

select distinct am.nro_pallet
	into :ls_desc
from vale_mov vm, 
     articulo_mov am, 
     articulo_mov_tipo amt, 
     articulo a,  
     (select teu.codigo_cu,  
             te.nro_trazabilidad,  
             te.fec_produccion, te.nro_ot,  
             te.cant_producida / te.total_caja as cant_promedio, 
             te.cod_art_pptt 
        from tg_parte_empaque_und teu, 
             tg_parte_empaque     te 
        where teu.nro_parte = te.nro_parte) s 
where vm.nro_vale = am.nro_vale 
  and vm.tipo_mov = amt.tipo_mov  
  and am.cod_art  = a.cod_art  
  and am.cus      = s.codigo_cu   (+) 
  and am.flag_estado <> '0' 
  and vm.flag_estado <> '0'   
  and am.nro_pallet = :ls_pallet;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'NUMERO de PALLET ' + ls_pallet + ' no existe, por favor corrija', StopSign!)
	this.text = ''
	return
end if



end event

type cbx_saldo from checkbox within w_al755_stock_posicion
integer x = 2523
integer y = 416
integer width = 814
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Mostrar solo los que tangan saldo"
boolean checked = true
end type

event clicked;if this.checked then
	sle_pallet.enabled = false
else
	sle_pallet.enabled = true
end if
end event

type st_2 from statictext within w_al755_stock_posicion
integer x = 727
integer y = 56
integer width = 608
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_origen from editmask within w_al755_stock_posicion
integer x = 1344
integer y = 44
integer width = 270
integer height = 88
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_data,  ls_texto

ls_texto = this.text

select nombre
	into :ls_data
from origen
where cod_origen = :ls_texto
  and flag_estado = '1';

if SQLCA.SQLCode = 100 then
	Messagebox('ALMACEN', "CODIGO DE ORIGEN NO EXISTE O NO ESTA ACTIVO", StopSign!)
	this.text 				= gnvo_app.is_null
	em_descripcion.text 	= gnvo_app.is_null
end if

em_descripcion.text = ls_data


end event

type cb_origen from commandbutton within w_al755_stock_posicion
integer x = 1623
integer y = 44
integer width = 87
integer height = 88
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql
ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
		  + "nombre AS nombre_origen " &
		  + "FROM origen " &
		  + "WHERE FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_origen.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

type em_descripcion from editmask within w_al755_stock_posicion
integer x = 1714
integer y = 44
integer width = 1065
integer height = 88
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_1 from statictext within w_al755_stock_posicion
integer x = 727
integer y = 140
integer width = 608
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Clase Articulo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_cod_clase from editmask within w_al755_stock_posicion
integer x = 1344
integer y = 136
integer width = 270
integer height = 88
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_data,  ls_texto

ls_texto = this.text

select desc_clase
	into :ls_data
from articulo_clase
where cod_clase = :ls_texto
  and flag_estado = '1';

if SQLCA.SQLCode = 100 then
	Messagebox('ALMACEN', "CODIGO DE CLASE NO EXISTE O NO ESTA ACTIVO", StopSign!)
	this.text 				= gnvo_app.is_null
	em_desc_clase.text 	= gnvo_app.is_null
end if

em_desc_clase.text = ls_data


end event

type cb_2 from commandbutton within w_al755_stock_posicion
integer x = 1623
integer y = 136
integer width = 87
integer height = 88
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select ac.cod_clase as codigo_clase, " &
		 + "ac.desc_clase as descripcion_clase " &
		 + "from articulo_clase ac " &
		 + "where ac.flag_estado = '1'"

if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	em_cod_clase.text = ls_codigo
	em_desc_clase.text = ls_data
end if

end event

type em_desc_clase from editmask within w_al755_stock_posicion
integer x = 1714
integer y = 136
integer width = 1065
integer height = 88
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type rb_1 from radiobutton within w_al755_stock_posicion
integer x = 2825
integer y = 200
integer width = 663
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Formato 01"
boolean checked = true
end type

type rb_2 from radiobutton within w_al755_stock_posicion
integer x = 2825
integer y = 280
integer width = 663
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Formato Conservas"
end type

type gb_1 from groupbox within w_al755_stock_posicion
integer width = 3831
integer height = 516
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Filtros para el reporte"
end type

