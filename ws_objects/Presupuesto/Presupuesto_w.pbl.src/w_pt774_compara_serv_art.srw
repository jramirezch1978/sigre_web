$PBExportHeader$w_pt774_compara_serv_art.srw
$PBExportComments$Control presupuestario por centro de costo
forward
global type w_pt774_compara_serv_art from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_pt774_compara_serv_art
end type
type cb_3 from commandbutton within w_pt774_compara_serv_art
end type
type rb_1 from radiobutton within w_pt774_compara_serv_art
end type
type rb_2 from radiobutton within w_pt774_compara_serv_art
end type
type rb_5 from radiobutton within w_pt774_compara_serv_art
end type
type rb_6 from radiobutton within w_pt774_compara_serv_art
end type
type gb_1 from groupbox within w_pt774_compara_serv_art
end type
type gb_2 from groupbox within w_pt774_compara_serv_art
end type
type gb_3 from groupbox within w_pt774_compara_serv_art
end type
end forward

global type w_pt774_compara_serv_art from w_report_smpl
integer width = 3890
integer height = 6692
string title = "Afectacion Presupuestal x Usuario (PT766)"
string menuname = "m_impresion"
long backcolor = 67108864
uo_fecha uo_fecha
cb_3 cb_3
rb_1 rb_1
rb_2 rb_2
rb_5 rb_5
rb_6 rb_6
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_pt774_compara_serv_art w_pt774_compara_serv_art

type variables

end variables

on w_pt774_compara_serv_art.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fecha=create uo_fecha
this.cb_3=create cb_3
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_5=create rb_5
this.rb_6=create rb_6
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_5
this.Control[iCurrent+6]=this.rb_6
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.gb_3
end on

on w_pt774_compara_serv_art.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_3)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;Date 		ld_fecha1, ld_fecha2
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

//create or replace procedure USP_PTO_COMPARA_SERV_ART(
//       ani_ano     in NUMBER,
//       adi_fecha1  IN DATE,
//       adi_fecha2  IN DATE
//) is

// genera archivo de articulos, solo los que se han movido segun compras
DECLARE USP_PTO_COMPARA_SERV_ART PROCEDURE FOR 
	USP_PTO_COMPARA_SERV_ART(:li_year1,
									 :ld_fecha1,
									 :ld_fecha2 );
EXECUTE USP_PTO_COMPARA_SERV_ART;

If sqlca.sqlcode = -1 then
	ls_mensaje = SQLCA.SQLErrtext
	ROLLBACK;
	messagebox("Error USP_PTO_COMPARA_SERV_ART", ls_mensaje)
	return 
end if

CLOSE USP_PTO_COMPARA_SERV_ART;

dw_report.visible = true
dw_report.retrieve(ld_Fecha1, ld_Fecha2)

dw_report.object.t_titulo1.text = 'Del ' + STRING(ld_fecha1, "DD/MM/YYYY") + &
								' Al ' + STRING(ld_fecha2, "DD/MM/YYYY")
dw_report.object.t_usuario.text = gs_user
dw_report.Object.p_logo.filename = gs_logo
dw_report.Object.t_objeto.text = this.classname( )
end event

type dw_report from w_report_smpl`dw_report within w_pt774_compara_serv_art
integer x = 0
integer y = 212
integer width = 3063
integer height = 1528
string dataobject = "d_rpt_compara_serv_articulos"
end type

type uo_fecha from u_ingreso_rango_fechas within w_pt774_compara_serv_art
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

type cb_3 from commandbutton within w_pt774_compara_serv_art
integer x = 2811
integer y = 64
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

event clicked;parent.event ue_retrieve()
end event

type rb_1 from radiobutton within w_pt774_compara_serv_art
integer x = 1349
integer y = 88
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
	FROM PRESUPUESTO_PARTIDA p
	WHERE p.ANO =  :li_year1; 

Commit;
end event

type rb_2 from radiobutton within w_pt774_compara_serv_art
integer x = 1655
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

event clicked;Date		ld_fecha1, ld_fecha2
Integer 	li_year1, li_year2

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
sl_param.dw1 = "d_lista_prsp_prtda_cencos_anual"	
sl_param.tipo = '1L'	
sl_param.long1 = li_year1
sl_param.titulo = "Centros de costo"
sl_param.opcion = 8

OpenWithParm( w_rpt_listas, sl_param)
end event

type rb_5 from radiobutton within w_pt774_compara_serv_art
integer x = 2094
integer y = 88
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
	FROM PRESUPUESTO_PARTIDA p	
	WHERE p.ANO =  :li_year1; 

Commit;
end event

type rb_6 from radiobutton within w_pt774_compara_serv_art
integer x = 2377
integer y = 88
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

ld_Fecha1 = uo_fecha.of_get_fecha1()
ld_Fecha2 = uo_fecha.of_get_fecha2()

li_year1 = Integer(string(ld_fecha1, 'yyyy'))
li_year2 = Integer(string(ld_fecha2, 'yyyy'))

if li_year1 <> li_year2 then
	MessageBox('Error', 'El periodo no puede coger años distintos')
	return
end if

// Asigna valores a structura 
sl_param.dw1 = "d_lista_prsp_partida_cnta_prsp"
sl_param.titulo = "Cuentas presupuestales"
sl_param.opcion = 9
sl_param.tipo = '1L'
sl_param.long1 = li_year1

OpenWithParm( w_rpt_listas, sl_param)
end event

type gb_1 from groupbox within w_pt774_compara_serv_art
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

type gb_2 from groupbox within w_pt774_compara_serv_art
integer x = 1326
integer y = 4
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

type gb_3 from groupbox within w_pt774_compara_serv_art
integer x = 2062
integer y = 4
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

