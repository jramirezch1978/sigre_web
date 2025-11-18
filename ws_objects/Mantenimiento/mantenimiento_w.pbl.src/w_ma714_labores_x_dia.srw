$PBExportHeader$w_ma714_labores_x_dia.srw
forward
global type w_ma714_labores_x_dia from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_ma714_labores_x_dia
end type
type sle_ot_adm from singlelineedit within w_ma714_labores_x_dia
end type
type st_ot_adm from statictext within w_ma714_labores_x_dia
end type
type st_1 from statictext within w_ma714_labores_x_dia
end type
type cb_reporte from commandbutton within w_ma714_labores_x_dia
end type
end forward

global type w_ma714_labores_x_dia from w_report_smpl
integer width = 2272
integer height = 1916
string title = "Reporte Diario de Labores (MA714)"
string menuname = "m_impresion"
long backcolor = 67108864
uo_fecha uo_fecha
sle_ot_adm sle_ot_adm
st_ot_adm st_ot_adm
st_1 st_1
cb_reporte cb_reporte
end type
global w_ma714_labores_x_dia w_ma714_labores_x_dia

on w_ma714_labores_x_dia.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fecha=create uo_fecha
this.sle_ot_adm=create sle_ot_adm
this.st_ot_adm=create st_ot_adm
this.st_1=create st_1
this.cb_reporte=create cb_reporte
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.sle_ot_adm
this.Control[iCurrent+3]=this.st_ot_adm
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_reporte
end on

on w_ma714_labores_x_dia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.sle_ot_adm)
destroy(this.st_ot_adm)
destroy(this.st_1)
destroy(this.cb_reporte)
end on

event ue_retrieve;call super::ue_retrieve;date 		ld_fecha1, ld_fecha2
string	ls_ot_adm
ld_fecha1 	= uo_fecha.of_get_fecha1( )
ld_fecha2 	= uo_fecha.of_get_fecha2( )

if ld_fecha2 < ld_fecha1 then
	MessageBox('PRODUCCION', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
	return
end if

ls_ot_adm = sle_ot_Adm.text

idw_1.Visible = True

idw_1.Retrieve(ld_fecha1, ld_fecha2, ls_ot_adm)
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_cabecera1.text = 'Rango de Fechas: ' &
	+ string(ld_fecha1, 'dd/mm/yyyy') + ' - ' &
	+ string(ld_fecha2, 'dd/mm/yyyy')
idw_1.object.t_cabecera2.text	= 'OT ADM: ' + ls_ot_adm
end event

type dw_report from w_report_smpl`dw_report within w_ma714_labores_x_dia
integer x = 0
integer y = 240
integer width = 2199
integer height = 1528
string dataobject = "d_rpt_labores_x_dia_tbl"
end type

type uo_fecha from u_ingreso_rango_fechas within w_ma714_labores_x_dia
integer x = 91
integer y = 36
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;date 		ld_fecha1, ld_fecha2
Integer 	li_ano, li_mes

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999')) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

li_ano = Year(Today())
li_mes = Month(Today())

if li_mes = 12 then
	li_mes = 1
	li_ano ++
else
	li_mes ++
end if

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( li_mes ,'00' ) &
	+ '/' + string(li_ano, '0000') )

ld_fecha2 = RelativeDate( ld_fecha2, -1 )

This.of_set_fecha( ld_fecha1, ld_fecha2 )
end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type sle_ot_adm from singlelineedit within w_ma714_labores_x_dia
event ue_dobleclick pbm_lbuttondblclk
integer x = 329
integer y = 136
integer width = 457
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT a.ot_adm AS CODIGO_ot_adm, " &
		 + "a.descripcion AS DESCRIPCION_ot_adm " &
		 + "FROM ot_administracion a, " &
		 + "ot_adm_usuario b " &
		 + "where a.ot_adm = b.ot_Adm " &
		 + "and b.cod_usr = '" + gs_user + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 		= ls_codigo
	st_ot_adm.text = ls_data
end if
end event

type st_ot_adm from statictext within w_ma714_labores_x_dia
integer x = 800
integer y = 144
integer width = 1367
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_1 from statictext within w_ma714_labores_x_dia
integer x = 55
integer y = 144
integer width = 261
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
string text = "OT_ADM"
boolean focusrectangle = false
end type

type cb_reporte from commandbutton within w_ma714_labores_x_dia
integer x = 1728
integer y = 28
integer width = 366
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;parent.event dynamic ue_retrieve()
end event

