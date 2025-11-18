$PBExportHeader$w_pr500_prod_fin.srw
forward
global type w_pr500_prod_fin from w_ap500_base
end type
type sle_ot_adm from sle_text within w_pr500_prod_fin
end type
type st_ot_adm from statictext within w_pr500_prod_fin
end type
type st_1 from statictext within w_pr500_prod_fin
end type
type cbx_turno from cbx_origen within w_pr500_prod_fin
end type
type sle_turno from singlelineedit within w_pr500_prod_fin
end type
type sle_desc_turno from singlelineedit within w_pr500_prod_fin
end type
type em_origen from singlelineedit within w_pr500_prod_fin
end type
type em_descripcion from editmask within w_pr500_prod_fin
end type
type gb_3 from groupbox within w_pr500_prod_fin
end type
type gb_2 from groupbox within w_pr500_prod_fin
end type
end forward

global type w_pr500_prod_fin from w_ap500_base
integer width = 3154
integer height = 2284
string title = "Produccion Por Dia (PR500)"
windowstate windowstate = normal!
sle_ot_adm sle_ot_adm
st_ot_adm st_ot_adm
st_1 st_1
cbx_turno cbx_turno
sle_turno sle_turno
sle_desc_turno sle_desc_turno
em_origen em_origen
em_descripcion em_descripcion
gb_3 gb_3
gb_2 gb_2
end type
global w_pr500_prod_fin w_pr500_prod_fin

on w_pr500_prod_fin.create
int iCurrent
call super::create
this.sle_ot_adm=create sle_ot_adm
this.st_ot_adm=create st_ot_adm
this.st_1=create st_1
this.cbx_turno=create cbx_turno
this.sle_turno=create sle_turno
this.sle_desc_turno=create sle_desc_turno
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.gb_3=create gb_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ot_adm
this.Control[iCurrent+2]=this.st_ot_adm
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cbx_turno
this.Control[iCurrent+5]=this.sle_turno
this.Control[iCurrent+6]=this.sle_desc_turno
this.Control[iCurrent+7]=this.em_origen
this.Control[iCurrent+8]=this.em_descripcion
this.Control[iCurrent+9]=this.gb_3
this.Control[iCurrent+10]=this.gb_2
end on

on w_pr500_prod_fin.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ot_adm)
destroy(this.st_ot_adm)
destroy(this.st_1)
destroy(this.cbx_turno)
destroy(this.sle_turno)
destroy(this.sle_desc_turno)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.gb_3)
destroy(this.gb_2)
end on

event ue_retrieve;Date		ld_fecha1, ld_fecha2
string	ls_ot_adm, ls_origen, ls_turno

ld_fecha1 	= uo_fecha.of_get_fecha1( )
ld_fecha2 	= uo_fecha.of_get_fecha2( )
ls_ot_adm	= sle_ot_adm.Text

if ld_fecha2 < ld_fecha1 then
	MessageBox('PRODUCCION', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
	return
end if

if ls_ot_adm = '' or IsNull(ls_ot_adm) then
	MessageBox('PRODUCCION', 'OT_ADM ESTA EN BLANCO, POR FAVOR VERFIQUE', StopSign!)
	return
end if

if cbx_origen.checked then
	ls_origen = string(em_origen.text)
else
	ls_origen = '%%'
end if

if cbx_turno.checked then
	ls_turno = string(sle_turno.text)
	if ls_turno = '' or IsNull(ls_turno) then
		MessageBox('PRODUCCION', 'CODIGO DE TURNO ESTA EN BLANCO, POR FAVOR VERFIQUE', StopSign!)
		return
	end if
else
	ls_turno = '%%'
end if


idw_1.Retrieve(ld_fecha1, ld_fecha2, ls_ot_adm, ls_origen, ls_turno)
of_title()	
idw_1.Visible = True
end event

type dw_report from w_ap500_base`dw_report within w_pr500_prod_fin
integer x = 23
integer y = 424
integer width = 2958
integer height = 1440
string dataobject = "d_grf_prod_final"
end type

type uo_fecha from w_ap500_base`uo_fecha within w_pr500_prod_fin
integer x = 32
integer y = 48
integer width = 1289
end type

type ddlb_param from w_ap500_base`ddlb_param within w_pr500_prod_fin
boolean visible = false
integer x = 1097
integer y = 656
integer width = 928
end type

event ddlb_param::constructor;call super::constructor;// Todos los origenes de los partes diarios
is_dataobject = 'ds_origen_pd_ot_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 10                   // Longitud del campo 1
ii_lc2 = 0							 // Longitud del campo 2
end event

type cbx_origen from w_ap500_base`cbx_origen within w_pr500_prod_fin
boolean visible = false
integer x = 471
integer y = 900
integer width = 283
long textcolor = 8388608
boolean enabled = false
string text = "Origen"
end type

type st_title from w_ap500_base`st_title within w_pr500_prod_fin
integer x = 850
integer y = 1796
integer height = 84
end type

type st_confirm from w_ap500_base`st_confirm within w_pr500_prod_fin
end type

type st_etiqueta from w_ap500_base`st_etiqueta within w_pr500_prod_fin
integer x = 2560
integer y = 1808
end type

type cb_1 from w_ap500_base`cb_1 within w_pr500_prod_fin
integer x = 2574
integer y = 260
integer height = 100
end type

event cb_1::ue_procesar;call super::ue_procesar;SetPointer(HourGlass!)
parent.event dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type sle_ot_adm from sle_text within w_pr500_prod_fin
integer x = 1646
integer y = 128
integer width = 297
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
	st_ot_adm.text = ""
	parent.event dynamic ue_reset( )
	return
end if
		
st_ot_adm.text = ls_data

parent.event dynamic ue_retrieve()

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
	st_ot_adm.Text = ls_data
end if

parent.event dynamic ue_retrieve()

end event

type st_ot_adm from statictext within w_pr500_prod_fin
integer x = 1943
integer y = 16
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
long backcolor = 134217739
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_1 from statictext within w_pr500_prod_fin
integer x = 1376
integer y = 136
integer width = 261
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

type cbx_turno from cbx_origen within w_pr500_prod_fin
boolean visible = true
integer x = 1381
integer y = 16
integer width = 251
boolean enabled = true
string text = "Turno"
end type

event clicked;if this.checked = true then
	sle_turno.enabled = true
	sle_turno.text = ""
else
	sle_turno.enabled = false
	sle_turno.text = ""
end if
end event

type sle_turno from singlelineedit within w_pr500_prod_fin
event dobleclick pbm_lbuttondblclk
integer x = 1646
integer y = 16
integer width = 297
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

type sle_desc_turno from singlelineedit within w_pr500_prod_fin
integer x = 1938
integer y = 124
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
borderstyle borderstyle = stylelowered!
end type

type em_origen from singlelineedit within w_pr500_prod_fin
event dobleclick pbm_lbuttondblclk
integer x = 64
integer y = 236
integer width = 128
integer height = 80
integer taborder = 50
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

type em_descripcion from editmask within w_pr500_prod_fin
integer x = 206
integer y = 236
integer width = 663
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33554431
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type gb_3 from groupbox within w_pr500_prod_fin
integer x = 18
integer width = 1349
integer height = 156
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Rango de Fechas"
end type

type gb_2 from groupbox within w_pr500_prod_fin
integer x = 23
integer y = 172
integer width = 901
integer height = 168
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

