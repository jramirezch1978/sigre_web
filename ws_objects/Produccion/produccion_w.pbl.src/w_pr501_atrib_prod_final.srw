$PBExportHeader$w_pr501_atrib_prod_final.srw
forward
global type w_pr501_atrib_prod_final from w_ap500_base
end type
type st_2 from statictext within w_pr501_atrib_prod_final
end type
type sle_ot from sle_text within w_pr501_atrib_prod_final
end type
type sle_desc_turno from singlelineedit within w_pr501_atrib_prod_final
end type
type sle_turno from singlelineedit within w_pr501_atrib_prod_final
end type
type st_desc_ot from statictext within w_pr501_atrib_prod_final
end type
type st_4 from statictext within w_pr501_atrib_prod_final
end type
type em_descripcion from editmask within w_pr501_atrib_prod_final
end type
type em_origen from singlelineedit within w_pr501_atrib_prod_final
end type
type sle_desc_producto from singlelineedit within w_pr501_atrib_prod_final
end type
type sle_producto from singlelineedit within w_pr501_atrib_prod_final
end type
type st_1 from statictext within w_pr501_atrib_prod_final
end type
type gb_2 from groupbox within w_pr501_atrib_prod_final
end type
end forward

global type w_pr501_atrib_prod_final from w_ap500_base
integer width = 4151
integer height = 2148
string title = "Atributos del Producto (PR501)"
windowstate windowstate = normal!
st_2 st_2
sle_ot sle_ot
sle_desc_turno sle_desc_turno
sle_turno sle_turno
st_desc_ot st_desc_ot
st_4 st_4
em_descripcion em_descripcion
em_origen em_origen
sle_desc_producto sle_desc_producto
sle_producto sle_producto
st_1 st_1
gb_2 gb_2
end type
global w_pr501_atrib_prod_final w_pr501_atrib_prod_final

on w_pr501_atrib_prod_final.create
int iCurrent
call super::create
this.st_2=create st_2
this.sle_ot=create sle_ot
this.sle_desc_turno=create sle_desc_turno
this.sle_turno=create sle_turno
this.st_desc_ot=create st_desc_ot
this.st_4=create st_4
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.sle_desc_producto=create sle_desc_producto
this.sle_producto=create sle_producto
this.st_1=create st_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_ot
this.Control[iCurrent+3]=this.sle_desc_turno
this.Control[iCurrent+4]=this.sle_turno
this.Control[iCurrent+5]=this.st_desc_ot
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.em_descripcion
this.Control[iCurrent+8]=this.em_origen
this.Control[iCurrent+9]=this.sle_desc_producto
this.Control[iCurrent+10]=this.sle_producto
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_pr501_atrib_prod_final.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.sle_ot)
destroy(this.sle_desc_turno)
destroy(this.sle_turno)
destroy(this.st_desc_ot)
destroy(this.st_4)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.sle_desc_producto)
destroy(this.sle_producto)
destroy(this.st_1)
destroy(this.gb_2)
end on

event ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()
idw_1.Visible = False
st_title.text = idw_1.object.gr_1.title

end event

event ue_retrieve;call super::ue_retrieve;Date		ld_fecha1, ld_fecha2
string	ls_ot_adm, ls_origen, ls_turno, ls_produc, ls_nom
Long		ll_pos

ld_fecha1 	= uo_fecha.of_get_fecha1( )
ld_fecha2 	= uo_fecha.of_get_fecha2( )
ls_ot_adm	= sle_ot.Text

if ld_fecha2 < ld_fecha1 then
	MessageBox('PRODUCCION', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
	return
end if

if ls_ot_adm = '' or IsNull(ls_ot_adm) then
	MessageBox('PRODUCCION', 'OT_ADM ESTA EN BLANCO, POR FAVOR VERFIQUE', StopSign!)
	return
end if

ls_produc = string(sle_producto.text)
//ls_nom_prod = ddlb_produc.Text
if ls_produc = '' or IsNull(ls_produc) then
	MessageBox('PRODUCCION', 'CODIGO DE PRODUCTO ESTA EN BLANCO, POR FAVOR VERFIQUE', StopSign!)
	return
end if

	ls_origen = string(em_origen.text)
	if ls_origen = '' or IsNull(ls_origen) then
		MessageBox('PRODUCCION', 'CODIGO DE ORIGEN ESTA EN BLANCO, POR FAVOR VERFIQUE', StopSign!)
		return
	end if

	ls_turno = string(sle_turno.text)
	if ls_turno = '' or IsNull(ls_turno) then
		MessageBox('PRODUCCION', 'CODIGO DE TURNO ESTA EN BLANCO, POR FAVOR VERFIQUE', StopSign!)
		return
	end if

ls_nom = string(sle_desc_producto.text)

idw_1.Retrieve(ld_fecha1, ld_fecha2, ls_ot_adm, ls_produc, ls_origen, ls_turno)
idw_1.Visible = True
//of_title()	
idw_1.Object.DataWindow.Print.Orientation = '1'
//idw_1.Object.t_prod.text = ls_nom
end event

type dw_report from w_ap500_base`dw_report within w_pr501_atrib_prod_final
integer x = 14
integer y = 368
integer height = 1544
integer taborder = 10
string dataobject = "d_cns_atrib_prod_fin_graph"
end type

type uo_fecha from w_ap500_base`uo_fecha within w_pr501_atrib_prod_final
integer x = 37
integer y = 40
integer width = 1298
end type

type ddlb_param from w_ap500_base`ddlb_param within w_pr501_atrib_prod_final
boolean visible = false
integer x = 320
integer y = 500
integer width = 1010
integer height = 268
end type

event ddlb_param::ue_open_pre;call super::ue_open_pre;// Todos los origenes de los partes diarios
is_dataobject = 'ds_origen_pd_ot_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 10                   // Longitud del campo 1
ii_lc2 = 0							 // Longitud del campo 2
end event

event ddlb_param::constructor;THIS.Event ue_constructor()

THIS.Event ue_open_pre()

//THIS.Event ue_populate()
end event

type cbx_origen from w_ap500_base`cbx_origen within w_pr501_atrib_prod_final
boolean visible = false
integer x = 69
integer y = 208
integer width = 91
long textcolor = 8388608
string text = ""
end type

type st_title from w_ap500_base`st_title within w_pr501_atrib_prod_final
integer x = 1225
integer y = 1532
end type

type st_confirm from w_ap500_base`st_confirm within w_pr501_atrib_prod_final
end type

type st_etiqueta from w_ap500_base`st_etiqueta within w_pr501_atrib_prod_final
integer x = 1495
integer y = 1380
end type

type cb_1 from w_ap500_base`cb_1 within w_pr501_atrib_prod_final
integer x = 3013
integer y = 104
integer width = 443
integer height = 88
end type

event cb_1::clicked;SetPointer(HourGlass!)
parent.event dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type st_2 from statictext within w_pr501_atrib_prod_final
integer x = 1335
integer y = 24
integer width = 251
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Producto"
boolean focusrectangle = false
end type

type sle_ot from sle_text within w_pr501_atrib_prod_final
integer x = 1609
integer y = 212
integer width = 338
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
end type

event modified;call super::modified;string ls_codigo, ls_data

ls_codigo = trim(this.text)

SetNull(ls_data)
SELECT DESCRIPCION  
	into :ls_data
FROM  VW_CAM_USR_ADM 
WHERE COD_USR = :gs_user
  and ot_adm  = :ls_codigo;
  
if ls_data = "" or IsNull(ls_data) then
	Messagebox('Error', "OT_ADM NO EXISTE O NO ESTA AUTORIZADO", StopSign!)
	this.text = ""
	//st_ot_adm.text = ""
	return
end if
		
 st_desc_ot.text = ls_data



end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

ls_sql = 'SELECT OT_ADM AS CODIGO, '&   
		 + 'DESCRIPCION  AS DESCR_OT_ADM  '&   
		 + 'FROM  VW_CAM_USR_ADM '&
		 + 'WHERE COD_USR = '+"'"+gs_user+"'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
if ls_codigo <> '' then
	this.Text 		= ls_codigo
	st_desc_ot.Text = ls_data
end if



end event

type sle_desc_turno from singlelineedit within w_pr501_atrib_prod_final
integer x = 1957
integer y = 120
integer width = 1033
integer height = 72
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type sle_turno from singlelineedit within w_pr501_atrib_prod_final
event dobleclick pbm_lbuttondblclk
integer x = 1609
integer y = 120
integer width = 338
integer height = 72
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT turno as Codigo, trim(descripcion) || ' / ' || to_char(hora_inicio_norm, 'hh24:mi') || ' - ' || to_char(hora_final_norm, 'hh24:mi') as descripcion " &
			+ "FROM turno " &
			+ "WHERE flag_estado = '1'"
			
lb_ret = f_lista(ls_sql, ls_codigo, &
			ls_data, '1')
		
if ls_codigo <> '' then
	
this.text= ls_codigo

sle_desc_turno.text = ls_data

end if
end event

event modified;String ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar una OT_ADM')
	return
end if

SELECT descripcion INTO :ls_desc
FROM turno
WHERE turno =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de OT_ADM no existe')
	return
end if

sle_desc_turno.text = ls_desc


end event

type st_desc_ot from statictext within w_pr501_atrib_prod_final
integer x = 1957
integer y = 208
integer width = 1033
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_4 from statictext within w_pr501_atrib_prod_final
integer x = 1335
integer y = 216
integer width = 251
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Ot Adm"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_descripcion from editmask within w_pr501_atrib_prod_final
integer x = 361
integer y = 212
integer width = 663
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33554431
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from singlelineedit within w_pr501_atrib_prod_final
event dobleclick pbm_lbuttondblclk
integer x = 219
integer y = 212
integer width = 128
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_origen as codigo, " & 
		  +"nombre AS DESCRIPCION " &
		  + "FROM origen " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	return
end if

SELECT nombre INTO :ls_desc
FROM origen
WHERE cod_origen =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	return
end if

em_descripcion.text = ls_desc

end event

type sle_desc_producto from singlelineedit within w_pr501_atrib_prod_final
integer x = 1957
integer y = 20
integer width = 1033
integer height = 72
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type sle_producto from singlelineedit within w_pr501_atrib_prod_final
event dobleclick pbm_lbuttondblclk
integer x = 1609
integer y = 16
integer width = 338
integer height = 72
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

ls_sql = "select a.cod_art as Codigo, "&   
		 + "a.nom_articulo as Descrpción "&   
		 + "from articulo a "&
		 + "where a.flag_estado = '1'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
if ls_codigo <> '' then
	this.Text 		= ls_codigo
	sle_desc_producto.Text = ls_data
end if






end event

event modified;String ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un Articulo')
	return
end if

SELECT nom_articulo INTO :ls_desc
FROM articulo
WHERE cod_art =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Articulo no existe')
	return
end if

sle_desc_producto.text = ls_desc


end event

type st_1 from statictext within w_pr501_atrib_prod_final
integer x = 1335
integer y = 116
integer width = 251
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Turno"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_pr501_atrib_prod_final
integer x = 178
integer y = 148
integer width = 901
integer height = 168
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = " Seleccione Origen "
end type

