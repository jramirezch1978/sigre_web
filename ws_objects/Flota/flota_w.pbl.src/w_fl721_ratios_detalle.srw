$PBExportHeader$w_fl721_ratios_detalle.srw
forward
global type w_fl721_ratios_detalle from w_rpt
end type
type ddlb_1 from dropdownlistbox within w_fl721_ratios_detalle
end type
type cbx_1 from checkbox within w_fl721_ratios_detalle
end type
type st_nomb_nave from statictext within w_fl721_ratios_detalle
end type
type st_1 from statictext within w_fl721_ratios_detalle
end type
type sle_nave from singlelineedit within w_fl721_ratios_detalle
end type
type st_3 from statictext within w_fl721_ratios_detalle
end type
type em_frecuencia from editmask within w_fl721_ratios_detalle
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl721_ratios_detalle
end type
type cb_1 from commandbutton within w_fl721_ratios_detalle
end type
type dw_report from u_dw_rpt within w_fl721_ratios_detalle
end type
end forward

global type w_fl721_ratios_detalle from w_rpt
integer width = 3547
integer height = 2392
string title = "Ratio de Petróleo Diesel 2 - detalle (FL721)"
string menuname = "m_rep_grf"
long backcolor = 67108864
event ue_copiar ( )
ddlb_1 ddlb_1
cbx_1 cbx_1
st_nomb_nave st_nomb_nave
st_1 st_1
sle_nave sle_nave
st_3 st_3
em_frecuencia em_frecuencia
uo_fecha uo_fecha
cb_1 cb_1
dw_report dw_report
end type
global w_fl721_ratios_detalle w_fl721_ratios_detalle

event ue_copiar();dw_report.ClipBoard("gr_1")
end event

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_retrieve;call super::ue_retrieve;integer 	li_ok, li_frecuencia
string 	ls_mensaje, ls_nave, ls_opcion
date 		ld_fecha1, ld_fecha2

SetPointer(HourGlass!)

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()
if cbx_1.checked then
	ls_nave = '%%'
else
	ls_nave 	 = sle_nave.text
end if

li_frecuencia = Integer(em_frecuencia.text)
ls_opcion = left(ddlb_1.text,1)

if ls_opcion = '' then 
	SetPointer(Arrow!)
	MessageBox('Aviso', 'Debe Seleccionar un indicador')
	return
end if

if ls_opcion = 'a' then
	//create or replace procedure USP_FL_RATIO_D2_X_TM(
	//       asi_nave         in tg_naves.nave%TYPE,
	//       adi_fecha1       in date,
	//       adi_fecha2       in date,
	//       ani_frecuencia   in number
	//) is
	
	DECLARE USP_FL_RATIO_D2_X_TM PROCEDURE FOR
		USP_FL_RATIO_D2_X_TM( :ls_nave, 
									 :ld_fecha1,
									 :ld_fecha2,
									 :li_frecuencia);
	
	EXECUTE USP_FL_RATIO_D2_X_TM;
	
	IF SQLCA.sqlcode = -1 THEN
		ls_mensaje = "PROCEDURE USP_FL_RATIO_D2_X_TM: " + SQLCA.SQLErrText
		Rollback ;
		MessageBox('SQL error', ls_mensaje, StopSign!)	
		return
	END IF
	
	CLOSE USP_FL_RATIO_D2_X_TM;
	
	idw_1.object.t_1.text = 'Ratio de Petróleo D2 ' + '~r~n' + 'US$/TM'
	//idw_1.object.dw_2.object.gr_1.Title = 'RATIO DE PETROLEO D2 US$/TM'
	
elseif ls_opcion = 'b' then
	//	create or replace procedure USP_FL_RATIO_MAT_X_TM(
	//       asi_nave         in tg_naves.nave%TYPE,
	//       adi_fecha1       in date,
	//       adi_fecha2       in date,
	//       ani_frecuencia   in number
	//	) is
	DECLARE USP_FL_RATIO_MAT_X_TM PROCEDURE FOR
		USP_FL_RATIO_MAT_X_TM( :ls_nave, 
									 :ld_fecha1,
									 :ld_fecha2,
									 :li_frecuencia);
	
	EXECUTE USP_FL_RATIO_MAT_X_TM;
	
	IF SQLCA.sqlcode = -1 THEN
		ls_mensaje = "PROCEDURE USP_FL_RATIO_MAT_X_TM: " + SQLCA.SQLErrText
		Rollback ;
		MessageBox('SQL error', ls_mensaje, StopSign!)	
		return
	END IF
	
	CLOSE USP_FL_RATIO_MAT_X_TM;
	
	idw_1.object.t_1.text = 'Ratio de Materiales' + '~r~n' + 'US$/TM'
	
elseif ls_opcion = 'c' then
	//create or replace procedure USP_FL_RATIO_SERV_X_TM(
	//       asi_nave         in tg_naves.nave%TYPE,
	//       adi_fecha1       in date,
	//       adi_fecha2       in date,
	//       ani_frecuencia   in number
	//) is
	DECLARE USP_FL_RATIO_SERV_X_TM PROCEDURE FOR
		USP_FL_RATIO_SERV_X_TM( :ls_nave, 
									 :ld_fecha1,
									 :ld_fecha2,
									 :li_frecuencia);
	
	EXECUTE USP_FL_RATIO_SERV_X_TM;
	
	IF SQLCA.sqlcode = -1 THEN
		ls_mensaje = "PROCEDURE USP_FL_RATIO_SERV_X_TM: " + SQLCA.SQLErrText
		Rollback ;
		MessageBox('SQL error', ls_mensaje, StopSign!)	
		return
	END IF
	
	CLOSE USP_FL_RATIO_MAT_X_TM;
	
	idw_1.object.t_1.text = 'Ratio de Servicios' + '~r~n' + 'US$/TM'
	
end if

idw_1.Retrieve()
if cbx_1.checked then
	idw_1.object.titulo2_t.text = 'Todas las Naves Propias'
else
	idw_1.object.titulo2_t.text = sle_nave.text + ' - ' + st_nomb_nave.text
end if

idw_1.object.p_logo.filename = gs_logo
idw_1.object.usuario_t.text  = gs_user


SetPointer(Arrow!)

end event

on w_fl721_ratios_detalle.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.ddlb_1=create ddlb_1
this.cbx_1=create cbx_1
this.st_nomb_nave=create st_nomb_nave
this.st_1=create st_1
this.sle_nave=create sle_nave
this.st_3=create st_3
this.em_frecuencia=create em_frecuencia
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.st_nomb_nave
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_nave
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.em_frecuencia
this.Control[iCurrent+8]=this.uo_fecha
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.dw_report
end on

on w_fl721_ratios_detalle.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_1)
destroy(this.cbx_1)
destroy(this.st_nomb_nave)
destroy(this.st_1)
destroy(this.sle_nave)
destroy(this.st_3)
destroy(this.em_frecuencia)
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

type ddlb_1 from dropdownlistbox within w_fl721_ratios_detalle
integer x = 1970
integer y = 28
integer width = 878
integer height = 408
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"a.- Petroleo D2 ","b.- Materiales","c.- Servicios"}
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_fl721_ratios_detalle
integer x = 1970
integer y = 136
integer width = 507
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todas las naves"
end type

event clicked;if this.checked then
	sle_nave.enabled = false
else
	sle_nave.enabled = true
end if
end event

type st_nomb_nave from statictext within w_fl721_ratios_detalle
integer x = 818
integer y = 136
integer width = 1143
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_1 from statictext within w_fl721_ratios_detalle
integer x = 59
integer y = 148
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Codigo de Nave:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nave from singlelineedit within w_fl721_ratios_detalle
event ue_dblclick pbm_lbuttondblclk
event ue_desp_naves ( )
event ue_keydwn pbm_keydown
integer x = 507
integer y = 136
integer width = 293
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event ue_desp_naves()
end event

event ue_desp_naves();// Este evento despliega la pantalla w_seleccionar

string ls_codigo, ls_data, ls_sql
integer li_i
str_seleccionar lstr_seleccionar

ls_sql = "SELECT NAVE AS CODIGO, " &
		 + "NOMB_NAVE AS DESCRIPCION, " &
		 + "FLAG_TIPO_FLOTA AS TIPO_FLOTA " &
       + "FROM TG_NAVES " &
		 + "WHERE FLAG_TIPO_FLOTA = 'P'"
				 
lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S'

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
END IF	

IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_codigo = lstr_seleccionar.param1[1]
	ls_data   = lstr_seleccionar.param2[1]
ELSE		
	Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE NAVE", StopSign!)
	return
end if
		
st_nomb_nave.text = ls_data		
this.text	 		= ls_codigo
parent.event ue_retrieve()
end event

event ue_keydwn;if Key = KeyF2! then
	this.event ue_desp_naves()	
end if
end event

event modified;string ls_codigo, ls_data

ls_codigo = trim(this.text)

select nomb_nave
	into :ls_data
from tg_naves
where nave = :ls_codigo;

st_nomb_nave.text = ls_data

parent.event dynamic ue_retrieve()
end event

type st_3 from statictext within w_fl721_ratios_detalle
integer x = 1339
integer y = 28
integer width = 297
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Frecuencia:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_frecuencia from editmask within w_fl721_ratios_detalle
integer x = 1655
integer y = 28
integer width = 306
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "7"
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
end type

type uo_fecha from u_ingreso_rango_fechas within w_fl721_ratios_detalle
event destroy ( )
integer x = 37
integer y = 28
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

type cb_1 from commandbutton within w_fl721_ratios_detalle
integer x = 2510
integer y = 120
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

type dw_report from u_dw_rpt within w_fl721_ratios_detalle
integer y = 244
integer width = 2167
integer height = 1664
integer taborder = 60
string dataobject = "d_rpt_ratio_d2_x_tm_comp_det"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'  // tabular (default), form 
end event

