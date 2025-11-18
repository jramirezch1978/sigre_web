$PBExportHeader$w_asi707_asistencia_ht580.srw
forward
global type w_asi707_asistencia_ht580 from w_rpt
end type
type st_2 from statictext within w_asi707_asistencia_ht580
end type
type sle_origen from singlelineedit within w_asi707_asistencia_ht580
end type
type st_1 from statictext within w_asi707_asistencia_ht580
end type
type rb_formato3 from radiobutton within w_asi707_asistencia_ht580
end type
type rb_formato2 from radiobutton within w_asi707_asistencia_ht580
end type
type rb_formato1 from radiobutton within w_asi707_asistencia_ht580
end type
type uo_1 from u_ingreso_rango_fechas within w_asi707_asistencia_ht580
end type
type pb_1 from picturebutton within w_asi707_asistencia_ht580
end type
type dw_report from u_dw_rpt within w_asi707_asistencia_ht580
end type
type gb_4 from groupbox within w_asi707_asistencia_ht580
end type
end forward

global type w_asi707_asistencia_ht580 from w_rpt
integer width = 4128
integer height = 2568
string title = "[ASI707] Asistencia HT580"
string menuname = "m_reporte"
st_2 st_2
sle_origen sle_origen
st_1 st_1
rb_formato3 rb_formato3
rb_formato2 rb_formato2
rb_formato1 rb_formato1
uo_1 uo_1
pb_1 pb_1
dw_report dw_report
gb_4 gb_4
end type
global w_asi707_asistencia_ht580 w_asi707_asistencia_ht580

on w_asi707_asistencia_ht580.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_2=create st_2
this.sle_origen=create sle_origen
this.st_1=create st_1
this.rb_formato3=create rb_formato3
this.rb_formato2=create rb_formato2
this.rb_formato1=create rb_formato1
this.uo_1=create uo_1
this.pb_1=create pb_1
this.dw_report=create dw_report
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_origen
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rb_formato3
this.Control[iCurrent+5]=this.rb_formato2
this.Control[iCurrent+6]=this.rb_formato1
this.Control[iCurrent+7]=this.uo_1
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.dw_report
this.Control[iCurrent+10]=this.gb_4
end on

on w_asi707_asistencia_ht580.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.sle_origen)
destroy(this.st_1)
destroy(this.rb_formato3)
destroy(this.rb_formato2)
destroy(this.rb_formato1)
destroy(this.uo_1)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.gb_4)
end on

event ue_open_pre;//Overrride

sle_origen.text = gs_origen
idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)
idw_1.ii_zoom_actual = 100

ib_preview = false
THIS.Event ue_preview()



 ii_help = 101           // help topic
end event

event ue_retrieve;String 	ls_area,ls_origen,ls_seccion,ls_ttrab,ls_cod_trabajador, ls_msj_err
Long   	ll_count
Date	ld_fecha_inicio,ld_fecha_final	

ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()
ls_origen 		= sle_origen.text
	
if rb_formato1.checked then
	
	idw_1.DataObject = 'd_rpt_asistencia_ht580_tbl'
	idw_1.SetTransObject(SQLCA)
	idw_1.Retrieve(ld_fecha_inicio,ld_fecha_final, ls_origen)
	idw_1.object.Datawindow.Print.Orientation = 2
	idw_1.object.t_empresa.text = gs_empresa
	
	ib_preview = false
	event ue_preview()
	
elseif rb_formato3.checked then
	
	idw_1.DataObject = 'd_rpt_datos_lectoras_crt'
	idw_1.SetTransObject(SQLCA)
	
	idw_1.Retrieve(ld_fecha_inicio,ld_fecha_final, ls_origen)
	idw_1.object.t_empresa.text = gs_empresa
	
elseif rb_formato2.checked then
	
//	DECLARE USP_ASISTENCIA_HT580 PROCEDURE FOR 
//				USP_ASISTENCIA_HT580(:ld_fecha_inicio,
//									 :ld_fecha_final);
//	EXECUTE USP_ASISTENCIA_HT580 ;
	
//	IF SQLCA.SQLCode = -1 THEN 
//		ls_msj_err = SQLCA.SQLErrText
//		Rollback ;
//		MessageBox('SQL error en USP_ASISTENCIA_HT580', ls_msj_err)
//		return
//	END IF
//	Commit ;
//	CLOSE USP_ASISTENCIA_HT580 ;

	idw_1.DataObject = 'd_rpt_asistencia_ht580_f2_tbl'
	idw_1.SetTransObject(SQLCA)
	idw_1.Retrieve(ld_fecha_inicio, ld_fecha_final, ls_origen)
	idw_1.object.Datawindow.Print.Orientation = 1
	
	try 
		/*statementBlock*/
		/*
		idw_1.object.t_ruc.text = gnvo_app.of_get_parametro( "RUC_EMPRESA", "20160272784")
		idw_1.object.t_direccion.text = gnvo_app.of_get_parametro( "DIRECCION_EMPRESA", "AV. A N°4041 Mz. F-1 ZONA INDUSTRIAL - PAITA PAITA PIURA ")
		idw_1.object.t_telefono.text = gnvo_app.of_get_parametro( "FONO_EMPRESA", "Telf: 073-211400")
		idw_1.object.t_empresa.text = gnvo_app.of_get_parametro( "NOMBRE_EMPRESA", "ARMADORES Y CONGELADORES DEL PACIFICO S.A.")
		*/
		
		idw_1.object.t_ruc.text 		= gnvo_app.empresa.is_ruc
		idw_1.object.t_direccion.text = gnvo_app.empresa.is_direccion 
		idw_1.object.t_telefono.text 	= gnvo_app.empresa.is_telefono
		idw_1.object.t_empresa.text 	= gnvo_app.empresa.is_nom_empresa
		
	catch ( Exception ex )
		gnvo_app.of_catch_exception( ex, "")
	end try
	
	ib_preview = false
	event ue_preview()

	
end if

idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text = gs_user


this.SetRedraw(true)

end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_preview;call super::ue_preview;
IF ib_preview THEN
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

type st_2 from statictext within w_asi707_asistencia_ht580
integer x = 526
integer y = 52
integer width = 489
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Rango de Fechas:"
boolean focusrectangle = false
end type

type sle_origen from singlelineedit within w_asi707_asistencia_ht580
integer x = 288
integer y = 36
integer width = 187
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_asi707_asistencia_ht580
integer x = 82
integer y = 56
integer width = 224
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Origen:"
boolean focusrectangle = false
end type

type rb_formato3 from radiobutton within w_asi707_asistencia_ht580
integer x = 750
integer y = 156
integer width = 338
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Crosstab"
end type

type rb_formato2 from radiobutton within w_asi707_asistencia_ht580
integer x = 407
integer y = 156
integer width = 338
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato 2"
end type

type rb_formato1 from radiobutton within w_asi707_asistencia_ht580
integer x = 64
integer y = 156
integer width = 338
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato 1"
boolean checked = true
end type

type uo_1 from u_ingreso_rango_fechas within w_asi707_asistencia_ht580
integer x = 960
integer y = 40
integer taborder = 20
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type pb_1 from picturebutton within w_asi707_asistencia_ht580
integer x = 2779
integer y = 44
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type dw_report from u_dw_rpt within w_asi707_asistencia_ht580
integer y = 272
integer width = 3730
integer height = 1384
string dataobject = "d_rpt_asistencia_ht580_tbl"
end type

type gb_4 from groupbox within w_asi707_asistencia_ht580
integer width = 3150
integer height = 256
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Datos"
end type

