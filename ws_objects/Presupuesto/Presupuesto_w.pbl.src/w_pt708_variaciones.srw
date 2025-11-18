$PBExportHeader$w_pt708_variaciones.srw
$PBExportComments$Control presupuestario por centro de costo
forward
global type w_pt708_variaciones from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_pt708_variaciones
end type
type ddlb_variacion from dropdownlistbox within w_pt708_variaciones
end type
type cb_10 from commandbutton within w_pt708_variaciones
end type
type rb_1 from radiobutton within w_pt708_variaciones
end type
type rb_2 from radiobutton within w_pt708_variaciones
end type
type rb_3 from radiobutton within w_pt708_variaciones
end type
type rb_4 from radiobutton within w_pt708_variaciones
end type
type gb_1 from groupbox within w_pt708_variaciones
end type
type gb_2 from groupbox within w_pt708_variaciones
end type
type gb_3 from groupbox within w_pt708_variaciones
end type
type gb_4 from groupbox within w_pt708_variaciones
end type
end forward

global type w_pt708_variaciones from w_report_smpl
integer width = 3991
integer height = 2136
string title = "Variaciones (PT708)"
string menuname = "m_impresion"
long backcolor = 67108864
uo_fecha uo_fecha
ddlb_variacion ddlb_variacion
cb_10 cb_10
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_pt708_variaciones w_pt708_variaciones

on w_pt708_variaciones.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fecha=create uo_fecha
this.ddlb_variacion=create ddlb_variacion
this.cb_10=create cb_10
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.ddlb_variacion
this.Control[iCurrent+3]=this.cb_10
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.rb_3
this.Control[iCurrent+7]=this.rb_4
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_3
this.Control[iCurrent+11]=this.gb_4
end on

on w_pt708_variaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.ddlb_variacion)
destroy(this.cb_10)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;//ii_help = 514       				// help topic

uo_fecha.event ue_output()
end event

event ue_retrieve;call super::ue_retrieve;String ls_tipo
Date ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_fecha.of_get_fecha1()
ld_fec_fin = uo_fecha.of_get_fecha2()

ls_tipo = LEFT( ddlb_variacion.text,1)   // Solo toma un caracter.
if ls_tipo = '' then
	messagebox( "Atencion", "Indique tipo de variacion")
	ddlb_variacion.Setfocus()
	return
end if

CHOOSE CASE ls_tipo   // tipo variacion
	CASE 'A'
		dw_report.dataobject = 'd_rpt_variacion_ampliacion'
	CASE 'R'
		dw_report.dataobject = 'd_rpt_variacion_reduccion'
	CASE 'T'
		dw_report.dataobject = 'd_rpt_variacion_transferencia'
END CHOOSE
dw_report.SetTransObject(sqlca)


ib_preview = false
this.Event ue_preview()

dw_report.retrieve(ld_fec_ini, ld_fec_fin)
dw_report.object.t_user.text = gs_user
dw_report.object.t_titulo.text = "Del :" + STRING( ld_fec_ini, 'DD/MM/YYYY') + &
      ' Al: ' + STRING( ld_fec_fin, 'DD/MM/YYYY')
dw_report.object.p_logo.filename = gs_logo

end event

type dw_report from w_report_smpl`dw_report within w_pt708_variaciones
integer x = 0
integer y = 212
integer height = 560
end type

type uo_fecha from u_ingreso_rango_fechas within w_pt708_variaciones
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

type ddlb_variacion from dropdownlistbox within w_pt708_variaciones
integer x = 1339
integer y = 72
integer width = 503
integer height = 432
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
string item[] = {"Ampliacion","Reduccion","Transferencia"}
borderstyle borderstyle = stylelowered!
end type

type cb_10 from commandbutton within w_pt708_variaciones
integer x = 3342
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
string text = "Aceptar"
end type

event clicked;parent.event ue_retrieve()

end event

type rb_1 from radiobutton within w_pt708_variaciones
integer x = 1883
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
Date		ld_fecha1, ld_fecha2
Integer 	li_year1, li_year2
string	ls_mensaje


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
	WHERE p.ANO =  :li_year1 ;

if sqlca.sqlcode = -1 then
	ls_mensaje = sqlca.sqlerrtext
	rollback;
	MessageBox('Aviso', ls_mensaje)
else
	Commit;	
end if


end event

type rb_2 from radiobutton within w_pt708_variaciones
integer x = 2190
integer y = 84
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
sl_param.dw1 = "d_sel_presup_partida_cencos_ano_all"	
sl_param.tipo = '1L1S'	
sl_param.long1 = li_year1
sl_param.string1 = '%%'
sl_param.titulo = "Centros de costo"
sl_param.opcion = 8

OpenWithParm( w_rpt_listas, sl_param)
end event

type rb_3 from radiobutton within w_pt708_variaciones
integer x = 2615
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
Date		ld_fecha1, ld_fecha2
Integer 	li_year1, li_year2
string	ls_mensaje


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
FROM PRESUPUESTO_PARTIDA            
WHERE ANO =  :li_year1 ;

if sqlca.sqlcode = -1 then
	ls_mensaje = sqlca.sqlerrtext
	rollback;
	MessageBox('Aviso', ls_mensaje)
else
	Commit;	
end if
end event

type rb_4 from radiobutton within w_pt708_variaciones
integer x = 2907
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
sl_param.dw1 = "d_sel_presupuesto_partida_cnta_pres_ano"
sl_param.titulo = "Cuentas presupuestales"
sl_param.opcion = 9
sl_param.tipo = '1L'
sl_param.long1 = li_year1


OpenWithParm( w_rpt_listas, sl_param)
end event

type gb_1 from groupbox within w_pt708_variaciones
integer width = 1317
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

type gb_2 from groupbox within w_pt708_variaciones
integer x = 1321
integer width = 539
integer height = 188
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Variacion"
end type

type gb_3 from groupbox within w_pt708_variaciones
integer x = 1861
integer width = 736
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
string text = "C.Costo"
end type

type gb_4 from groupbox within w_pt708_variaciones
integer x = 2597
integer width = 727
integer height = 188
integer taborder = 80
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

