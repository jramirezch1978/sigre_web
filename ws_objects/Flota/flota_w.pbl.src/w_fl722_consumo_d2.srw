$PBExportHeader$w_fl722_consumo_d2.srw
forward
global type w_fl722_consumo_d2 from w_rpt
end type
type sle_descrip from singlelineedit within w_fl722_consumo_d2
end type
type sle_maquina from singlelineedit within w_fl722_consumo_d2
end type
type st_2 from statictext within w_fl722_consumo_d2
end type
type cbx_1 from checkbox within w_fl722_consumo_d2
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl722_consumo_d2
end type
type cb_1 from commandbutton within w_fl722_consumo_d2
end type
type dw_report from u_dw_rpt within w_fl722_consumo_d2
end type
end forward

global type w_fl722_consumo_d2 from w_rpt
integer width = 2994
integer height = 2752
string title = "Consumo de Petróleo D2 - General (FL722)"
string menuname = "m_rep_grf"
long backcolor = 67108864
event ue_copiar ( )
sle_descrip sle_descrip
sle_maquina sle_maquina
st_2 st_2
cbx_1 cbx_1
uo_fecha uo_fecha
cb_1 cb_1
dw_report dw_report
end type
global w_fl722_consumo_d2 w_fl722_consumo_d2

event ue_copiar();dw_report.ClipBoard("gr_1")
end event

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_retrieve;call super::ue_retrieve;integer 	li_ok
string 	ls_mensaje, ls_maquina
date 		ld_fecha1, ld_fecha2

SetPointer(HourGlass!)

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

if cbx_1.checked then
	ls_maquina = '%%'
else
	if trim(sle_maquina.text) = '' then
		MessageBox('Aviso', 'Debe especificar una Maquina')
		return
	end if
	
	ls_maquina = trim(sle_maquina.text) + '%'
end if

//create or replace procedure USP_FL_CONSUMO_D2(
//       adi_fecha1 in date,
//       adi_fecha2 in date
//) is

DECLARE USP_FL_CONSUMO_D2 PROCEDURE FOR
	USP_FL_CONSUMO_D2( :ld_fecha1,
							 :ld_fecha2,
							 :ls_maquina );

EXECUTE USP_FL_CONSUMO_D2;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_CONSUMO_D2: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_FL_CONSUMO_D2;

idw_1.SetTransObject(SQLCA)
idw_1.SetRedraw(False)
idw_1.Retrieve(ld_fecha1, ld_fecha2)
idw_1.SetRedraw(True)
idw_1.object.titulo2_t.text = 'PERIODO: ' + string(ld_fecha1, 'dd/mm/yyyy') &
	+ ' - ' + string(ld_fecha2, 'dd/mm/yyyy') 
idw_1.object.p_logo.filename = gs_logo
idw_1.object.usuario_t.text  = gs_user

if cbx_1.checked then
	idw_1.object.maquina_t.text = 'Sin indicar maquina específica'
else
	idw_1.object.maquina_t.text = trim(sle_maquina.text) + ' - ' + sle_descrip.text
end if

SetPointer(Arrow!)

end event

on w_fl722_consumo_d2.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.sle_descrip=create sle_descrip
this.sle_maquina=create sle_maquina
this.st_2=create st_2
this.cbx_1=create cbx_1
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_descrip
this.Control[iCurrent+2]=this.sle_maquina
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.uo_fecha
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.dw_report
end on

on w_fl722_consumo_d2.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_descrip)
destroy(this.sle_maquina)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.uo_fecha)
destroy(this.cb_1)
destroy(this.dw_report)
end on

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.object.usuario_t.text 	= 'Usuario: ' + gs_user
idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.Datawindow.Print.Orientation = 1


end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
 
end event

type sle_descrip from singlelineedit within w_fl722_consumo_d2
integer x = 1531
integer y = 148
integer width = 1390
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

type sle_maquina from singlelineedit within w_fl722_consumo_d2
event dobleclick pbm_lbuttondblclk
integer x = 1207
integer y = 148
integer width = 320
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT distinct m.COD_MAQUINA AS CODIGO_maquina, " &
		 + "m.DESC_MAQ AS DESCRIPCION_maquina " &
		 + "FROM maquina m, " &
		 + "fl_estruc_nave a " &
		 + "where a.cod_maquina = m.cod_maquina " &
		 + "and m.flag_estado = '1'" 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = this.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_maq 
	INTO :ls_desc
FROM maquina
where cod_maquina = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Máquina no existe')
	return
end if

sle_descrip.text = ls_desc

end event

type st_2 from statictext within w_fl722_consumo_d2
integer x = 773
integer y = 152
integer width = 421
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Maq / Equipos"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_fl722_consumo_d2
integer x = 41
integer y = 148
integer width = 731
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "No distinguir Maquina"
boolean checked = true
end type

event clicked;if this.checked then
	sle_maquina.enabled = false
else
	sle_maquina.enabled = true
end if
end event

type uo_fecha from u_ingreso_rango_fechas within w_fl722_consumo_d2
event destroy ( )
integer x = 37
integer y = 24
integer taborder = 40
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

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

type cb_1 from commandbutton within w_fl722_consumo_d2
integer x = 2528
integer y = 20
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;parent.event dynamic ue_retrieve()
end event

type dw_report from u_dw_rpt within w_fl722_consumo_d2
integer y = 264
integer width = 2528
integer height = 1464
integer taborder = 60
string dataobject = "d_rpt_consumo_d2_composite"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'  // tabular (default), form 
end event

