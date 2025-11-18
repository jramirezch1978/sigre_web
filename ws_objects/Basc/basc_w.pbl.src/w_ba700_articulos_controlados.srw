$PBExportHeader$w_ba700_articulos_controlados.srw
forward
global type w_ba700_articulos_controlados from w_report_smpl
end type
type cb_1 from commandbutton within w_ba700_articulos_controlados
end type
type sle_1 from singlelineedit within w_ba700_articulos_controlados
end type
type cb_2 from commandbutton within w_ba700_articulos_controlados
end type
type dp_1 from datepicker within w_ba700_articulos_controlados
end type
type st_1 from statictext within w_ba700_articulos_controlados
end type
type dp_2 from datepicker within w_ba700_articulos_controlados
end type
type gb_1 from groupbox within w_ba700_articulos_controlados
end type
type gb_2 from groupbox within w_ba700_articulos_controlados
end type
end forward

global type w_ba700_articulos_controlados from w_report_smpl
integer width = 2853
integer height = 1203
string title = "(BA700) Movimientos de Articulos Controlados"
string menuname = "m_reporte"
cb_1 cb_1
sle_1 sle_1
cb_2 cb_2
dp_1 dp_1
st_1 st_1
dp_2 dp_2
gb_1 gb_1
gb_2 gb_2
end type
global w_ba700_articulos_controlados w_ba700_articulos_controlados

type variables
string is_grupobasc, is_almacenbasc, is_moving, is_movsal
end variables

on w_ba700_articulos_controlados.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.sle_1=create sle_1
this.cb_2=create cb_2
this.dp_1=create dp_1
this.st_1=create st_1
this.dp_2=create dp_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.dp_1
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.dp_2
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_ba700_articulos_controlados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.cb_2)
destroy(this.dp_1)
destroy(this.st_1)
destroy(this.dp_2)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;try 
	is_grupobasc = gnvo_app.of_get_parametro("GRUPO_ART_BASC", "BASC")
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "")
finally
	/*statementBlock*/
end try

try 
	is_almacenbasc = gnvo_app.of_get_parametro("ALMACEN_BASC", "ALLM02")
catch ( Exception ex2 )
	gnvo_app.of_catch_exception(ex2, "")
finally
	/*statementBlock*/
end try

select oper_ing_oc, oper_cons_interno 
  into :is_moving, :is_movsal
 from logparam where reckey = '1';

dw_report.settransobject(Sqlca)
end event

event ue_retrieve;call super::ue_retrieve;string ls_codart
datetime ldt_ini, ldt_fin

ls_codart = trim(sle_1.text)

if ls_codart = '' or isnull(ls_codart) then
	ls_codart = '%'
else
	ls_codart += '%'
end if

ldt_ini = datetime(date(dp_1.value),time('00:00:00'))
ldt_fin = datetime(date(dp_2.value),time('23:59:59'))

dw_report.RETRIEVE( is_moving, is_movsal, is_almacenbasc, ldt_ini, ldt_fin, is_grupobasc, ls_codart)
dw_report.object.t_titulobasc1.text = 'CONTROL DE ENTREGA Y DEVOLUCION'
dw_report.object.t_titulobasc2.text = 'DE ARTICULOS'
dw_report.object.t_codigobasc.text = 'CANT.FO.06.1'
dw_report.object.t_versionbasc.text = 'VERSIÓN: 00'
dw_report.object.t_usuario.text = upper(gs_user)
dw_report.object.p_logo.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_ba700_articulos_controlados
integer x = 37
integer y = 320
integer width = 2747
integer height = 675
string dataobject = "d_rpt_control_movimiento_articulos"
end type

type cb_1 from commandbutton within w_ba700_articulos_controlados
integer x = 2085
integer y = 192
integer width = 369
integer height = 99
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Aceptar"
end type

event clicked;parent.event ue_retrieve()
end event

type sle_1 from singlelineedit within w_ba700_articulos_controlados
integer x = 1328
integer y = 141
integer width = 472
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
integer limit = 12
borderstyle borderstyle = stylelowered!
end type

event modified;string ls_desc

select cod_art into :ls_desc
  from rel_articulo_grupo
 where grupo_art = :is_grupobasc
     and (trim(cod_art) = trim(:this.text));

if sqlca.sqlcode = 100 then
	
	this.text = ''
	Messagebox('Aviso', 'Articulo Inexistente')
	
end if
end event

type cb_2 from commandbutton within w_ba700_articulos_controlados
integer x = 1829
integer y = 141
integer width = 154
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "..."
end type

event clicked;string ls_sql, ls_return1, ls_return2
ls_sql = "select a.cod_art as codigo, b.nom_articulo as descripcion from rel_articulo_grupo a, articulo b where a.grupo_art = '"+is_grupobasc+"' and a.cod_art = b.cod_art" 
f_lista(ls_sql, ls_return1, ls_return2, '2')
if isnull(ls_return1) or trim(ls_return1) = '' then return
sle_1.text= ls_return1
end event

type dp_1 from datepicker within w_ba700_articulos_controlados
integer x = 80
integer y = 138
integer width = 512
integer height = 99
integer taborder = 20
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2015-09-04"), Time("15:05:27.000000"))
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type st_1 from statictext within w_ba700_articulos_controlados
integer x = 589
integer y = 154
integer width = 88
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type dp_2 from datepicker within w_ba700_articulos_controlados
integer x = 680
integer y = 138
integer width = 512
integer height = 99
integer taborder = 20
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2015-09-04"), Time("15:05:27.000000"))
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type gb_1 from groupbox within w_ba700_articulos_controlados
integer x = 1280
integer y = 32
integer width = 772
integer height = 259
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "(Opcional) Articulo"
end type

type gb_2 from groupbox within w_ba700_articulos_controlados
integer x = 37
integer y = 32
integer width = 1211
integer height = 259
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

