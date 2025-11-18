$PBExportHeader$w_ma521_maquina_historial.srw
forward
global type w_ma521_maquina_historial from w_cns
end type
type sle_nombre from singlelineedit within w_ma521_maquina_historial
end type
type pb_1 from picturebutton within w_ma521_maquina_historial
end type
type uo_1 from u_ingreso_rango_fechas within w_ma521_maquina_historial
end type
type cb_1 from commandbutton within w_ma521_maquina_historial
end type
type sle_maquina from singlelineedit within w_ma521_maquina_historial
end type
type st_1 from statictext within w_ma521_maquina_historial
end type
type tab_1 from tab within w_ma521_maquina_historial
end type
type tabpage_1 from userobject within tab_1
end type
type dw_parte_diario from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_parte_diario dw_parte_diario
end type
type tabpage_2 from userobject within tab_1
end type
type dw_asistencia from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_asistencia dw_asistencia
end type
type tabpage_3 from userobject within tab_1
end type
type dw_fallas from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_fallas dw_fallas
end type
type tabpage_4 from userobject within tab_1
end type
type dw_orden_trab from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_orden_trab dw_orden_trab
end type
type tab_1 from tab within w_ma521_maquina_historial
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
end forward

global type w_ma521_maquina_historial from w_cns
integer width = 3232
integer height = 2132
string title = "Historial de equipos o maquinarias (MA521)"
string menuname = "m_cns_smpl_print"
sle_nombre sle_nombre
pb_1 pb_1
uo_1 uo_1
cb_1 cb_1
sle_maquina sle_maquina
st_1 st_1
tab_1 tab_1
end type
global w_ma521_maquina_historial w_ma521_maquina_historial

type variables
u_dw_abc   idw_2
end variables

on w_ma521_maquina_historial.create
int iCurrent
call super::create
if this.MenuName = "m_cns_smpl_print" then this.MenuID = create m_cns_smpl_print
this.sle_nombre=create sle_nombre
this.pb_1=create pb_1
this.uo_1=create uo_1
this.cb_1=create cb_1
this.sle_maquina=create sle_maquina
this.st_1=create st_1
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_nombre
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.sle_maquina
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.tab_1
end on

on w_ma521_maquina_historial.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_nombre)
destroy(this.pb_1)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.sle_maquina)
destroy(this.st_1)
destroy(this.tab_1)
end on

event ue_open_pre;call super::ue_open_pre;tab_1.tabpage_1.dw_parte_diario.SetTransObject(sqlca)
tab_1.tabpage_2.dw_asistencia.SetTransObject(sqlca)
tab_1.tabpage_3.dw_fallas.SetTransObject(sqlca)
tab_1.tabpage_4.dw_orden_trab.SetTransObject(sqlca)

//idw_1 = dw_master              // asignar dw corriente
//dw_detail.BorderStyle = StyleRaised! // indicar dw_detail como no activado

// ii_help = 101           // help topic
of_position_window(0,0)      

idw_2 = tab_1.tabpage_1.dw_parte_diario
end event

event resize;call super::resize;tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

tab_1.tabpage_1.dw_parte_diario.height = newheight - tab_1.tabpage_1.dw_parte_diario.y - 700
tab_1.tabpage_1.dw_parte_diario.width  = newwidth  - tab_1.tabpage_1.dw_parte_diario.x - 100

tab_1.tabpage_2.dw_asistencia.height = newheight - tab_1.tabpage_2.dw_asistencia.y - 700
tab_1.tabpage_2.dw_asistencia.width  = newwidth  - tab_1.tabpage_2.dw_asistencia.x - 100

tab_1.tabpage_3.dw_fallas.height     = newheight  - tab_1.tabpage_3.dw_fallas.y    - 700
tab_1.tabpage_3.dw_fallas.width      = newwidth  - tab_1.tabpage_3.dw_fallas.x     - 100

tab_1.tabpage_4.dw_orden_trab.height = newheight - tab_1.tabpage_4.dw_orden_trab.y - 700
tab_1.tabpage_4.dw_orden_trab.width  = newwidth  - tab_1.tabpage_4.dw_orden_trab.x - 100




end event

event ue_print;//Overriding
idw_2.EVENT ue_print()
end event

type sle_nombre from singlelineedit within w_ma521_maquina_historial
integer x = 974
integer y = 24
integer width = 1495
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217750
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_ma521_maquina_historial
integer x = 841
integer y = 20
integer width = 101
integer height = 88
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "Custom050!"
alignment htextalign = left!
end type

event clicked;String ls_name, ls_prot
Datawindow ldw
str_seleccionar lstr_seleccionar


lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS CODIGO,'&
						 		 +'MAQUINA.DESC_MAQ AS DESCRIPCION,'&
								 +'MAQUINA.FLAG_ESTADO AS ST '&
								 +'FROM MAQUINA '

IF lstr_seleccionar.s_seleccion = 'S' THEN
	OpenWithParm(w_seleccionar,lstr_seleccionar)	
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_maquina.text = lstr_seleccionar.param1[1]
		sle_nombre.text = lstr_seleccionar.param2[1]
	END IF
END IF

end event

type uo_1 from u_ingreso_rango_fechas within w_ma521_maquina_historial
integer x = 64
integer y = 144
integer taborder = 30
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
//of_set_fecha(date('01/01/1900'), date('31/12/9999')) // para seatear el titulo del boton
of_set_fecha(today(), today()) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_1 from commandbutton within w_ma521_maquina_historial
integer x = 1390
integer y = 136
integer width = 311
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ubicar"
end type

event clicked;Date ld_fec_ini, ld_fec_fin
String ls_cod_maquina

ls_cod_maquina = sle_maquina.text

ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

tab_1.tabpage_1.dw_parte_diario.Retrieve(ls_cod_maquina, ld_fec_ini, ld_fec_fin)
tab_1.tabpage_2.dw_asistencia.Retrieve(ls_cod_maquina, ld_fec_ini, ld_fec_fin)
tab_1.tabpage_3.dw_fallas.Retrieve(ls_cod_maquina, ld_fec_ini, ld_fec_fin)
tab_1.tabpage_4.dw_orden_trab.Retrieve(ls_cod_maquina, ld_fec_ini, ld_fec_fin)
end event

type sle_maquina from singlelineedit within w_ma521_maquina_historial
integer x = 352
integer y = 24
integer width = 466
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_cod_maquina, ls_nombre
Long ll_count

ls_cod_maquina = sle_maquina.text

SELECT count(*) INTO :ll_count FROM maquina m
WHERE m.cod_maquina=:ls_cod_maquina ;

IF ll_count > 0 THEN
	SELECT m.desc_maq INTO :ls_nombre FROM maquina m
	 WHERE m.cod_maquina=:ls_cod_maquina ;
	 
	sle_nombre.text = ls_nombre
ELSE
	MessageBox('Aviso', 'Código de máquina errado')
	return
END IF

end event

type st_1 from statictext within w_ma521_maquina_historial
integer x = 59
integer y = 32
integer width = 288
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Máquina:"
boolean focusrectangle = false
end type

type tab_1 from tab within w_ma521_maquina_historial
integer x = 32
integer y = 292
integer width = 3136
integer height = 1604
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3099
integer height = 1476
long backcolor = 79741120
string text = "  Partes diarios"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom092!"
long picturemaskcolor = 536870912
dw_parte_diario dw_parte_diario
end type

on tabpage_1.create
this.dw_parte_diario=create dw_parte_diario
this.Control[]={this.dw_parte_diario}
end on

on tabpage_1.destroy
destroy(this.dw_parte_diario)
end on

type dw_parte_diario from u_dw_abc within tabpage_1
integer x = 46
integer y = 36
integer width = 3017
integer height = 1432
string dataobject = "d_cns_hist_maquina_labor_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectura de este dw

end event

event clicked;call super::clicked;idw_2.BorderStyle = StyleRaised!
idw_2 = THIS
idw_2.BorderStyle = StyleLowered!
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3099
integer height = 1476
long backcolor = 79741120
string text = "  Asistencia"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom076!"
long picturemaskcolor = 536870912
dw_asistencia dw_asistencia
end type

on tabpage_2.create
this.dw_asistencia=create dw_asistencia
this.Control[]={this.dw_asistencia}
end on

on tabpage_2.destroy
destroy(this.dw_asistencia)
end on

type dw_asistencia from u_dw_abc within tabpage_2
integer x = 23
integer y = 28
integer width = 3054
integer height = 1428
integer taborder = 20
string dataobject = "d_cns_hist_maquina_asistencia_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event clicked;call super::clicked;idw_2.BorderStyle = StyleRaised!
idw_2 = THIS
idw_2.BorderStyle = StyleLowered!
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3099
integer height = 1476
long backcolor = 79741120
string text = "  Causas de fallas"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Move!"
long picturemaskcolor = 536870912
dw_fallas dw_fallas
end type

on tabpage_3.create
this.dw_fallas=create dw_fallas
this.Control[]={this.dw_fallas}
end on

on tabpage_3.destroy
destroy(this.dw_fallas)
end on

type dw_fallas from u_dw_abc within tabpage_3
integer x = 27
integer y = 48
integer width = 3045
integer height = 1400
integer taborder = 20
string dataobject = "d_cns_hist_maquina_fallas_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event clicked;call super::clicked;idw_2.BorderStyle = StyleRaised!
idw_2 = THIS
idw_2.BorderStyle = StyleLowered!
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3099
integer height = 1476
long backcolor = 79741120
string text = "  Ordenes de trabajo"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "DataWindow!"
long picturemaskcolor = 536870912
dw_orden_trab dw_orden_trab
end type

on tabpage_4.create
this.dw_orden_trab=create dw_orden_trab
this.Control[]={this.dw_orden_trab}
end on

on tabpage_4.destroy
destroy(this.dw_orden_trab)
end on

type dw_orden_trab from u_dw_abc within tabpage_4
integer x = 32
integer y = 40
integer width = 3049
integer height = 1408
integer taborder = 20
string dataobject = "d_cns_hist_maquina_orden_trab_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event clicked;call super::clicked;idw_2.BorderStyle = StyleRaised!
idw_2 = THIS
idw_2.BorderStyle = StyleLowered!
end event

