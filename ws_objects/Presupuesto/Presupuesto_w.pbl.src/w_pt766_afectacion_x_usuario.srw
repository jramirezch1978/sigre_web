$PBExportHeader$w_pt766_afectacion_x_usuario.srw
$PBExportComments$Control presupuestario por centro de costo
forward
global type w_pt766_afectacion_x_usuario from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_pt766_afectacion_x_usuario
end type
type cb_3 from commandbutton within w_pt766_afectacion_x_usuario
end type
type rb_1 from radiobutton within w_pt766_afectacion_x_usuario
end type
type rb_2 from radiobutton within w_pt766_afectacion_x_usuario
end type
type rb_3 from radiobutton within w_pt766_afectacion_x_usuario
end type
type rb_4 from radiobutton within w_pt766_afectacion_x_usuario
end type
type rb_5 from radiobutton within w_pt766_afectacion_x_usuario
end type
type rb_6 from radiobutton within w_pt766_afectacion_x_usuario
end type
type ddlb_ingr_egr from dropdownlistbox within w_pt766_afectacion_x_usuario
end type
type rb_7 from radiobutton within w_pt766_afectacion_x_usuario
end type
type rb_8 from radiobutton within w_pt766_afectacion_x_usuario
end type
type gb_1 from groupbox within w_pt766_afectacion_x_usuario
end type
type gb_2 from groupbox within w_pt766_afectacion_x_usuario
end type
type gb_4 from groupbox within w_pt766_afectacion_x_usuario
end type
type gb_3 from groupbox within w_pt766_afectacion_x_usuario
end type
type gb_5 from groupbox within w_pt766_afectacion_x_usuario
end type
type gb_6 from groupbox within w_pt766_afectacion_x_usuario
end type
end forward

global type w_pt766_afectacion_x_usuario from w_report_smpl
integer width = 3744
integer height = 5972
string title = "Afectacion Presupuestal x Usuario (PT766)"
string menuname = "m_impresion"
long backcolor = 67108864
uo_fecha uo_fecha
cb_3 cb_3
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
ddlb_ingr_egr ddlb_ingr_egr
rb_7 rb_7
rb_8 rb_8
gb_1 gb_1
gb_2 gb_2
gb_4 gb_4
gb_3 gb_3
gb_5 gb_5
gb_6 gb_6
end type
global w_pt766_afectacion_x_usuario w_pt766_afectacion_x_usuario

type variables

end variables

on w_pt766_afectacion_x_usuario.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fecha=create uo_fecha
this.cb_3=create cb_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_6=create rb_6
this.ddlb_ingr_egr=create ddlb_ingr_egr
this.rb_7=create rb_7
this.rb_8=create rb_8
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_4=create gb_4
this.gb_3=create gb_3
this.gb_5=create gb_5
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.rb_4
this.Control[iCurrent+7]=this.rb_5
this.Control[iCurrent+8]=this.rb_6
this.Control[iCurrent+9]=this.ddlb_ingr_egr
this.Control[iCurrent+10]=this.rb_7
this.Control[iCurrent+11]=this.rb_8
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_4
this.Control[iCurrent+15]=this.gb_3
this.Control[iCurrent+16]=this.gb_5
this.Control[iCurrent+17]=this.gb_6
end on

on w_pt766_afectacion_x_usuario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.ddlb_ingr_egr)
destroy(this.rb_7)
destroy(this.rb_8)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.gb_5)
destroy(this.gb_6)
end on

type dw_report from w_report_smpl`dw_report within w_pt766_afectacion_x_usuario
integer x = 0
integer y = 396
integer width = 3063
integer height = 1052
string dataobject = "d_rpt_ejec_x_usuario"
end type

type uo_fecha from u_ingreso_rango_fechas within w_pt766_afectacion_x_usuario
integer x = 9
integer y = 68
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor; string ls_inicio 

 of_set_label('Desde','Hasta') //para setear la fecha inicial

//Obtenemos el Primer dia del Mes

ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

 of_set_fecha(date(ls_inicio),today())
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas
 
//Controles a Observar en el Windows

end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_3 from commandbutton within w_pt766_afectacion_x_usuario
integer x = 2679
integer y = 52
integer width = 306
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Reporte"
end type

event clicked;Date 		ld_fecha1, ld_fecha2
Integer	li_year1, li_year2
String	ls_mensaje

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

Setpointer(Hourglass!)

li_year1 = integer(string(ld_fecha1, 'yyyy'))
li_year2 = integer(string(ld_fecha2, 'yyyy'))

if li_year1 <> li_year2 then
	MessageBox('Aviso', 'El Periodo debe ser del mismo año')
	return
end if

dw_report.visible = true
dw_report.retrieve(ld_Fecha1, ld_Fecha2)

dw_report.object.t_titulo1.text = 'Del ' + STRING(ld_fecha1, "DD/MM/YYYY") + &
								' Al ' + STRING(ld_fecha2, "DD/MM/YYYY")
dw_report.object.t_usuario.text = gs_user
dw_report.Object.p_logo.filename = gs_logo
dw_report.Object.t_objeto.text = parent.classname( )
end event

type rb_1 from radiobutton within w_pt766_afectacion_x_usuario
integer x = 23
integer y = 276
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;// Inserta todos los registros en tabla temporal
Date		ld_fecha1, ld_fecha2
Integer 	li_year1, li_year2
String 	ls_ingr_egr

if ddlb_ingr_egr.text = '' then
	MessageBox('Aviso', 'Debe seleccionar Si es Ingreso o Egreso')
	this.checked = false
	return 1
end if

ls_ingr_egr = left(ddlb_ingr_egr.text,1)

if ls_ingr_egr = 'Z' then ls_ingr_egr = '%%'

ld_Fecha1 = uo_fecha.of_get_fecha1()
ld_Fecha2 = uo_fecha.of_get_fecha2()

li_year1 = Integer(string(ld_fecha1, 'yyyy'))
li_year2 = Integer(string(ld_fecha2, 'yyyy'))

if li_year1 <> li_year2 then
	MessageBox('Error', 'El periodo no puede coger años distintos')
	return
end if

Delete from tt_pto_cencos;

insert into tt_pto_cencos ( cencos) 
	SELECT DISTINCT p.CENCOS
	FROM PRESUPUESTO_PARTIDA p,
		  tt_pto_tipo_prtda	 t
	WHERE t.tipo_prtda_prsp = p.tipo_prtda_prsp
	  and p.ANO =  :li_year1 
	  and p.flag_ingr_egr like :ls_ingr_egr;

Commit;
end event

type rb_2 from radiobutton within w_pt766_afectacion_x_usuario
integer x = 329
integer y = 276
integer width = 389
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona"
end type

event clicked;Date		ld_fecha1, ld_fecha2
Integer 	li_year1, li_year2
String 	ls_ingr_egr, ls_tipo

if ddlb_ingr_egr.text = '' then
	MessageBox('Aviso', 'Debe seleccionar Si es Ingreso o Egreso')
	this.checked = false
	return 1
end if

ls_ingr_egr = left(ddlb_ingr_egr.text,1)
if ls_ingr_egr = 'Z' then ls_ingr_egr = '%%'

ld_Fecha1 = uo_fecha.of_get_fecha1()
ld_Fecha2 = uo_fecha.of_get_fecha2()

li_year1 = Integer(string(ld_fecha1, 'yyyy'))
li_year2 = Integer(string(ld_fecha2, 'yyyy'))

if li_year1 <> li_year2 then
	MessageBox('Error', 'El periodo no puede coger años distintos')
	return
end if

str_parametros sl_param

// Asigna valores a structura 
sl_param.dw1 = "d_sel_prsp_prtda_cencos_ano"	
sl_param.tipo = '1L1S'	
sl_param.long1 = li_year1
sl_param.string1 = ls_ingr_egr
sl_param.titulo = "Centros de costo"
sl_param.opcion = 8

OpenWithParm( w_rpt_listas, sl_param)
end event

type rb_3 from radiobutton within w_pt766_afectacion_x_usuario
integer x = 1486
integer y = 276
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;// Inserta todos los registros en tabla temporal
Date		ld_fecha1, ld_fecha2
Integer 	li_year1, li_year2
String 	ls_ingr_egr, ls_tipo, ls_mensaje

if ddlb_ingr_egr.text = '' then
	MessageBox('Aviso', 'Debe seleccionar Si es Ingreso o Egreso')
	this.checked = false
	return 1
end if

ls_ingr_egr = left(ddlb_ingr_egr.text,1)
if ls_ingr_egr = 'Z' then ls_ingr_egr = '%%'

ld_Fecha1 = uo_fecha.of_get_fecha1()
ld_Fecha2 = uo_fecha.of_get_fecha2()

li_year1 = Integer(string(ld_fecha1, 'yyyy'))
li_year2 = Integer(string(ld_fecha2, 'yyyy'))

if li_year1 <> li_year2 then
	MessageBox('Error', 'El periodo no puede coger años distintos')
	return
end if

Delete from tt_pto_usuario;

insert into tt_pto_usuario ( cod_usr ) 
	SELECT DISTINCT pe.cod_usr
	FROM presupuesto_partida pp,
        presupuesto_ejec    pe,
		  tt_pto_tipo_prtda	 t
	WHERE pp.ano = pe.ano
     AND pp.cencos = pe.cencos
     AND pp.cnta_prsp = pe.cnta_prsp
	  and t.tipo_prtda_prsp = pp.tipo_prtda_prsp
     AND to_number(to_char(pe.fecha, 'yyyy')) = :li_year1
	  and pp.flag_ingr_egr like :ls_ingr_egr;

IF SQLCA.SQLCode = -1 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'No se pudo insertar fila en tt_pto_usuario: ' + ls_mensaje)
	return
end if

Commit;
end event

type rb_4 from radiobutton within w_pt766_afectacion_x_usuario
integer x = 1778
integer y = 276
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona"
end type

event clicked;str_parametros sl_param
Date		ld_fecha1, ld_fecha2
Integer 	li_year1, li_year2
String 	ls_ingr_egr

if ddlb_ingr_egr.text = '' then
	MessageBox('Aviso', 'Debe seleccionar Si es Ingreso o Egreso')
	this.checked = false
	return 1
end if

ls_ingr_egr = left(ddlb_ingr_egr.text,1)
if ls_ingr_egr = 'Z' then ls_ingr_egr = '%%'

ld_Fecha1 = uo_fecha.of_get_fecha1()
ld_Fecha2 = uo_fecha.of_get_fecha2()

li_year1 = Integer(string(ld_fecha1, 'yyyy'))
li_year2 = Integer(string(ld_fecha2, 'yyyy'))

if li_year1 <> li_year2 then
	MessageBox('Error', 'El periodo no puede coger años distintos')
	return
end if

// Asigna valores a structura 
sl_param.dw1 = "d_sel_prsp_partida_usuario"
sl_param.titulo = "usuarios"
sl_param.opcion = 10
sl_param.tipo = '1L1S'
sl_param.long1 = li_year1
sl_param.string1 = ls_ingr_egr

OpenWithParm( w_rpt_listas, sl_param)
end event

type rb_5 from radiobutton within w_pt766_afectacion_x_usuario
integer x = 768
integer y = 276
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;// Inserta todos los registros en tabla temporal
Date		ld_fecha1, ld_fecha2
Integer 	li_year1, li_year2
String 	ls_ingr_egr

if ddlb_ingr_egr.text = '' then
	MessageBox('Aviso', 'Debe seleccionar Si es Ingreso o Egreso')
	this.checked = false
	return 1
end if

ls_ingr_egr = left(ddlb_ingr_egr.text,1)
if ls_ingr_egr = 'Z' then ls_ingr_egr = '%%'

ld_Fecha1 = uo_fecha.of_get_fecha1()
ld_Fecha2 = uo_fecha.of_get_fecha2()

li_year1 = Integer(string(ld_fecha1, 'yyyy'))
li_year2 = Integer(string(ld_fecha2, 'yyyy'))

if li_year1 <> li_year2 then
	MessageBox('Error', 'El periodo no puede coger años distintos')
	return
end if

Delete from tt_pto_cnta_prsp;

insert into tt_pto_cnta_prsp ( cnta_prsp ) 
	SELECT DISTINCT cnta_prsp
	FROM PRESUPUESTO_PARTIDA p,
		  tt_pto_tipo_prtda	 t	
	WHERE t.tipo_prtda_prsp = p.tipo_prtda_prsp
	  and p.ANO =  :li_year1 
	  and p.flag_ingr_egr like :ls_ingr_egr;

Commit;
end event

type rb_6 from radiobutton within w_pt766_afectacion_x_usuario
integer x = 1051
integer y = 276
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona"
end type

event clicked;str_parametros sl_param
Date		ld_fecha1, ld_fecha2
Integer 	li_year1, li_year2
String 	ls_ingr_egr

if ddlb_ingr_egr.text = '' then
	MessageBox('Aviso', 'Debe seleccionar Si es Ingreso o Egreso')
	this.checked = false
	return 1
end if

ls_ingr_egr = left(ddlb_ingr_egr.text,1)
if ls_ingr_egr = 'Z' then ls_ingr_egr = '%%'

ld_Fecha1 = uo_fecha.of_get_fecha1()
ld_Fecha2 = uo_fecha.of_get_fecha2()

li_year1 = Integer(string(ld_fecha1, 'yyyy'))
li_year2 = Integer(string(ld_fecha2, 'yyyy'))

if li_year1 <> li_year2 then
	MessageBox('Error', 'El periodo no puede coger años distintos')
	return
end if

// Asigna valores a structura 
sl_param.dw1 = "d_sel_prsp_partida_cnta_prsp"
sl_param.titulo = "Cuentas presupuestales"
sl_param.opcion = 9
sl_param.tipo = '1L1S'
sl_param.long1 = li_year1
sl_param.string1 = ls_ingr_egr

OpenWithParm( w_rpt_listas, sl_param)
end event

type ddlb_ingr_egr from dropdownlistbox within w_pt766_afectacion_x_usuario
integer x = 2039
integer y = 68
integer width = 539
integer height = 388
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"I - Ingreso","E - Egreso","Z - Todos"}
borderstyle borderstyle = stylelowered!
end type

type rb_7 from radiobutton within w_pt766_afectacion_x_usuario
integer x = 1349
integer y = 84
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;// Inserta todos los registros en tabla temporal

Delete from TT_PTO_TIPO_PRTDA;

insert into TT_PTO_TIPO_PRTDA ( TIPO_PRTDA_PRSP ) 
SELECT DISTINCT TIPO_PRTDA_PRSP
	FROM TIPO_PRTDA_PRSP_DET;            

Commit;
end event

type rb_8 from radiobutton within w_pt766_afectacion_x_usuario
integer x = 1618
integer y = 88
integer width = 389
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona"
end type

event clicked;Long ll_count
str_parametros lstr_param

// Asigna valores a structura 
lstr_param.dw_master = 'd_lista_tipo_prtda_prsp_tbl'
lstr_param.dw1 	= "d_lista_tipo_prtda_prsp_det_tbl"
lstr_param.titulo = "Tipos de Partidas Presupuestales"
lstr_param.opcion = 1
lstr_param.tipo 	= ''

OpenWithParm( w_abc_seleccion_md, lstr_param)

select count(*)
  into :ll_count
  from tt_pto_tipo_prtda;

if ll_count = 0 then
	this.checked = false
	return
end if
end event

type gb_1 from groupbox within w_pt766_afectacion_x_usuario
integer width = 1307
integer height = 188
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
end type

type gb_2 from groupbox within w_pt766_afectacion_x_usuario
integer y = 192
integer width = 736
integer height = 192
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "C.Costo"
end type

type gb_4 from groupbox within w_pt766_afectacion_x_usuario
integer x = 1467
integer y = 192
integer width = 727
integer height = 192
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Usuarios"
end type

type gb_3 from groupbox within w_pt766_afectacion_x_usuario
integer x = 736
integer y = 192
integer width = 727
integer height = 192
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cta. Presup."
end type

type gb_5 from groupbox within w_pt766_afectacion_x_usuario
integer x = 2016
integer width = 576
integer height = 188
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Ingr/Egreso"
end type

type gb_6 from groupbox within w_pt766_afectacion_x_usuario
integer x = 1317
integer width = 699
integer height = 188
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Prtda Prsp"
end type

