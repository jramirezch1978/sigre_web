$PBExportHeader$w_fl910_prspto_variacion.srw
forward
global type w_fl910_prspto_variacion from w_rpt_general
end type
type st_1 from statictext within w_fl910_prspto_variacion
end type
type em_year from editmask within w_fl910_prspto_variacion
end type
type cbx_todos from checkbox within w_fl910_prspto_variacion
end type
type ddlb_desde from dropdownlistbox within w_fl910_prspto_variacion
end type
type st_2 from statictext within w_fl910_prspto_variacion
end type
type ddlb_hasta from dropdownlistbox within w_fl910_prspto_variacion
end type
type st_3 from statictext within w_fl910_prspto_variacion
end type
type dw_naves from datawindow within w_fl910_prspto_variacion
end type
type cb_reporte from commandbutton within w_fl910_prspto_variacion
end type
type cb_procesar from commandbutton within w_fl910_prspto_variacion
end type
type cb_grafico from commandbutton within w_fl910_prspto_variacion
end type
end forward

global type w_fl910_prspto_variacion from w_rpt_general
integer width = 3049
integer height = 1912
string title = "Variaciones Presupuestales (FL910)"
event ue_procesar ( )
event ue_grafico ( )
st_1 st_1
em_year em_year
cbx_todos cbx_todos
ddlb_desde ddlb_desde
st_2 st_2
ddlb_hasta ddlb_hasta
st_3 st_3
dw_naves dw_naves
cb_reporte cb_reporte
cb_procesar cb_procesar
cb_grafico cb_grafico
end type
global w_fl910_prspto_variacion w_fl910_prspto_variacion

forward prototypes
public function boolean of_prspto_todos ()
public function boolean of_prsp_x_nave ()
end prototypes

event ue_procesar();integer 	li_ano, li_desde, li_hasta
string 	ls_mensaje
str_gen_prspto lstr_param

li_ano 	= long(em_year.text)
li_desde = integer( left( ddlb_desde.text, 2 ) )
li_hasta = integer( left( ddlb_hasta.text, 2 ) )

lstr_param.ai_ano		 = li_ano
lstr_param.ai_mes_ini = li_desde
lstr_param.ai_mes_fin = li_hasta
lstr_param.as_usuario = gs_user

ls_mensaje 	= 'Se van a generar variaciones al presupuesto para '
if li_desde = li_hasta then
	ls_mensaje = ls_mensaje + 'el Mes: ' + string(li_desde) + ', Año: ' + string(li_ano)
else
	ls_mensaje = ls_mensaje + 'el Periodo: ' + string(li_desde) + ' - ' + string(li_hasta) +', Año: '+ string(li_ano)
end if
ls_mensaje 	= ls_mensaje + '~r ¿Esta conforme con los datos mostrados?'
if MessageBox('Aviso', ls_mensaje ,Exclamation!, YesNo!, 1) = 2 then return

OpenWithParm(w_fl911_generar_variaciones, lstr_param )
end event

event ue_grafico();OpenSheet(w_fl521_variacion_grafica, w_main, 0, Layered!)
end event

public function boolean of_prspto_todos ();integer 	li_desde, li_hasta, li_tipo, li_ok, li_ano
string 	ls_mensaje
date 		ld_fecha

ld_fecha = Today()

li_ano 	= long(em_year.text)
li_desde = integer( left( ddlb_desde.text, 2 ) )
li_hasta = integer( left( ddlb_hasta.text, 2 ) )

//create or replace procedure usp_fl_var_prspto_todos(
//       aii_mes_ini          in Integer,
//       aii_mes_fin          in Integer,
//       aii_ano              in Integer,
//       asi_usuario          in String,
//     	aso_mensaje 	      out varchar2,
//       aio_ok      	      out number ) is

DECLARE usp_fl_var_prspto_todos PROCEDURE FOR
	usp_fl_var_prspto_todos( :li_desde, 
									 :li_hasta, 
									 :li_ano  ,
									 :gs_user  );

EXECUTE usp_fl_var_prspto_todos;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_fl_var_prspto_todos: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

FETCH usp_fl_var_prspto_todos INTO :ls_mensaje, :li_ok;
	
CLOSE usp_fl_var_prspto_todos;

if li_ok <> 1 then
	MessageBox('Error PROCEDURE usp_fl_var_prspto_todos', ls_mensaje, StopSign!)	
	return false
end if

return true
end function

public function boolean of_prsp_x_nave ();integer 	li_desde, li_hasta, li_ok, li_ano
string 	ls_nave, ls_mensaje
date 		ld_fecha

ld_fecha = Today()

li_ano 	= long(em_year.text)
li_desde = integer( left( ddlb_desde.text, 2 ) )
li_hasta = integer( left( ddlb_hasta.text, 2 ) )

ls_nave = dw_naves.object.nave[1]
	
//create or replace procedure usp_fl_var_prspto_x_nave(
//       aii_mes_ini          in Integer,
//       aii_mes_fin          in Integer,
//       aii_ano              in Integer,
//       asi_nave             in tg_naves.nave%TYPE,
//       asi_usuario          in usuario.cod_usr%TYPE,
//     	aso_mensaje 	      out varchar2,
//       aio_ok      	      out number 
//) is

declare usp_fl_var_prspto_x_nave procedure for
		usp_fl_var_prspto_x_nave(	:li_desde, 
											:li_hasta, 
											:li_ano  , 
											:ls_nave , 
											:gs_user );
												
execute usp_fl_var_prspto_x_nave;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_fl_var_prspto_x_nave: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

fetch usp_fl_var_prspto_x_nave into :ls_mensaje, :li_ok;
				
close usp_fl_var_prspto_x_nave;

if li_ok <> 1 then
	MessageBox('Error PROCEDURE usp_fl_var_prspto_x_nave', ls_mensaje, StopSign!)	
	return false
end if

return true
end function

on w_fl910_prspto_variacion.create
int iCurrent
call super::create
this.st_1=create st_1
this.em_year=create em_year
this.cbx_todos=create cbx_todos
this.ddlb_desde=create ddlb_desde
this.st_2=create st_2
this.ddlb_hasta=create ddlb_hasta
this.st_3=create st_3
this.dw_naves=create dw_naves
this.cb_reporte=create cb_reporte
this.cb_procesar=create cb_procesar
this.cb_grafico=create cb_grafico
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_year
this.Control[iCurrent+3]=this.cbx_todos
this.Control[iCurrent+4]=this.ddlb_desde
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.ddlb_hasta
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.dw_naves
this.Control[iCurrent+9]=this.cb_reporte
this.Control[iCurrent+10]=this.cb_procesar
this.Control[iCurrent+11]=this.cb_grafico
end on

on w_fl910_prspto_variacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.cbx_todos)
destroy(this.ddlb_desde)
destroy(this.st_2)
destroy(this.ddlb_hasta)
destroy(this.st_3)
destroy(this.dw_naves)
destroy(this.cb_reporte)
destroy(this.cb_procesar)
destroy(this.cb_grafico)
end on

event ue_retrieve;// Ancestor Script has been Override
integer 	li_ano
date 		ld_fecha
boolean	lb_ret

ld_fecha = Date(f_fecha_actual())

li_ano 	= long(em_year.text)

idw_1.visible = true

if cbx_todos.checked then
	lb_ret = this.of_prspto_todos( )	
else
	lb_ret = this.of_prsp_x_nave( )
end if

if lb_ret = false then 
	idw_1.Reset()
	cb_procesar.enabled = false
	cb_grafico.enabled  = false
	return
end if

idw_1.Retrieve()
idw_1.Object.usuario_t.text   = 'Usuario: ' + gs_user
idw_1.object.p_logo.FileName 	= gs_logo
idw_1.object.t_empresa.text	= gs_empresa
idw_1.object.subtitulo_1.Text = 'Año: ' + string(li_ano)

if idw_1.RowCount() > 0 then
	cb_procesar.enabled = true
	cb_grafico.enabled = true
else
	cb_procesar.enabled = false
	cb_grafico.enabled = false
end if

end event

event ue_open_pre;call super::ue_open_pre;Integer li_ano

li_ano = year(Today())

em_year.text = string(li_ano)

dw_naves.SetTransObject(SQLCA)

end event

type dw_report from w_rpt_general`dw_report within w_fl910_prspto_variacion
integer y = 264
integer width = 2958
integer height = 1452
string dataobject = "d_presup_compara_v2_tbl"
end type

type st_1 from statictext within w_fl910_prspto_variacion
integer x = 27
integer y = 24
integer width = 151
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
string text = "Año"
boolean focusrectangle = false
end type

type em_year from editmask within w_fl910_prspto_variacion
integer x = 137
integer y = 16
integer width = 270
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
string minmax = "~~9999"
end type

type cbx_todos from checkbox within w_fl910_prspto_variacion
integer x = 1669
integer y = 24
integer width = 453
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todas las naves"
boolean checked = true
end type

event clicked;integer li_ano, li_return
DataWindowChild ldwc_child

if this.checked then
	dw_naves.visible = false
	dw_naves.enabled = false
	dw_naves.Reset()
else
	li_ano = integer(em_year.Text)

	dw_naves.visible = true
	dw_naves.enabled = true
	dw_naves.InsertRow(0)
	
	li_return = dw_naves.GetChild('nave', ldwc_child)

	IF li_return = -1 THEN 
		MessageBox( "Error", "Nave no es un DataWindowChild", StopSign!)
		return
	end if
	
	ldwc_child.SetTransObject(SQLCA)
	ldwc_child.Retrieve(li_ano)
	
	if ldwc_child.RowCount() > 0 then
		dw_naves.object.nave[1] = ldwc_child.GetItemString(1, 'nave')
	end if

end if
end event

type ddlb_desde from dropdownlistbox within w_fl910_prspto_variacion
integer x = 581
integer y = 16
integer width = 466
integer height = 468
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"01. Enero","02. Febrero","03. Marzo","04. Abril","05. Mayo","06. Junio","07. Julio","08. Agosto","09. Setiembre","10. Octubre","11. Noviembre","12. Diciembre"}
borderstyle borderstyle = stylelowered!
end type

event constructor;THIS.SELECTITEM(1)
end event

type st_2 from statictext within w_fl910_prspto_variacion
integer x = 402
integer y = 24
integer width = 178
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
string text = "Desde:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_hasta from dropdownlistbox within w_fl910_prspto_variacion
integer x = 1202
integer y = 16
integer width = 466
integer height = 468
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"01. Enero","02. Febrero","03. Marzo","04. Abril","05. Mayo","06. Junio","07. Julio","08. Agosto","09. Setiembre","10. Octubre","11. Noviembre","12. Diciembre"}
borderstyle borderstyle = stylelowered!
end type

event constructor;THIS.SELECTITEM(12)
end event

event selectionchanged;integer li_desde, li_hasta
li_desde = integer(left(right(trim(ddlb_desde.text),3),2))
li_hasta = integer(left(right(trim(ddlb_hasta.text),3),2))
if li_desde > li_hasta then
	messagebox('Flota', 'Rango de fechas no válido...',StopSign!)
	ddlb_hasta.selectitem(li_desde)
end if
end event

type st_3 from statictext within w_fl910_prspto_variacion
integer x = 1047
integer y = 24
integer width = 155
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
string text = "Hasta:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_naves from datawindow within w_fl910_prspto_variacion
boolean visible = false
integer x = 2139
integer y = 16
integer width = 814
integer height = 92
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_selec_nave_ff"
boolean border = false
boolean livescroll = true
end type

type cb_reporte from commandbutton within w_fl910_prspto_variacion
integer x = 681
integer y = 128
integer width = 402
integer height = 112
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

type cb_procesar from commandbutton within w_fl910_prspto_variacion
integer x = 1083
integer y = 128
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Procesar"
end type

event clicked;parent.event dynamic ue_retrieve()
parent.event dynamic ue_procesar()
end event

type cb_grafico from commandbutton within w_fl910_prspto_variacion
integer x = 1490
integer y = 128
integer width = 402
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Grafico"
end type

event clicked;parent.event dynamic ue_retrieve()
parent.event dynamic ue_grafico()
end event

