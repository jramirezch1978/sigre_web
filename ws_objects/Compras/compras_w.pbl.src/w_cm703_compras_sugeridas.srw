$PBExportHeader$w_cm703_compras_sugeridas.srw
forward
global type w_cm703_compras_sugeridas from w_rpt
end type
type rb_3 from radiobutton within w_cm703_compras_sugeridas
end type
type rb_2 from radiobutton within w_cm703_compras_sugeridas
end type
type rb_1 from radiobutton within w_cm703_compras_sugeridas
end type
type rb_res from radiobutton within w_cm703_compras_sugeridas
end type
type rb_det from radiobutton within w_cm703_compras_sugeridas
end type
type dw_report from u_dw_rpt within w_cm703_compras_sugeridas
end type
type cb_1 from commandbutton within w_cm703_compras_sugeridas
end type
type uo_fecha from u_ingreso_fecha within w_cm703_compras_sugeridas
end type
type gb_1 from groupbox within w_cm703_compras_sugeridas
end type
end forward

global type w_cm703_compras_sugeridas from w_rpt
integer x = 283
integer y = 248
integer width = 3150
integer height = 1384
string title = "Compras Sugeridas [CM703]"
string menuname = "m_impresion"
long backcolor = 79741120
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
rb_res rb_res
rb_det rb_det
dw_report dw_report
cb_1 cb_1
uo_fecha uo_fecha
gb_1 gb_1
end type
global w_cm703_compras_sugeridas w_cm703_compras_sugeridas

on w_cm703_compras_sugeridas.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.rb_res=create rb_res
this.rb_det=create rb_det
this.dw_report=create dw_report
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_3
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_res
this.Control[iCurrent+5]=this.rb_det
this.Control[iCurrent+6]=this.dw_report
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.uo_fecha
this.Control[iCurrent+9]=this.gb_1
end on

on w_cm703_compras_sugeridas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.rb_res)
destroy(this.rb_det)
destroy(this.dw_report)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;//idw_1.Visible = False
idw_1 = dw_report
ii_help = 101           // help topic

rb_det.checked = true
rb_det.triggerevent (clicked!)
end event

event ue_retrieve();call super::ue_retrieve;dw_report.Retrieve()
dw_report.Visible = True
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.text     = gs_user
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_codigo.text   = dw_report.dataobject

end event

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y


end event

event ue_print();call super::ue_print;dw_report.EVENT ue_print()
end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

type rb_3 from radiobutton within w_cm703_compras_sugeridas
integer x = 1161
integer y = 208
integer width = 357
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pendientes"
end type

type rb_2 from radiobutton within w_cm703_compras_sugeridas
integer x = 489
integer y = 208
integer width = 649
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Abiertos + Pendientes"
end type

type rb_1 from radiobutton within w_cm703_compras_sugeridas
integer x = 114
integer y = 208
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Abiertos"
boolean checked = true
end type

type rb_res from radiobutton within w_cm703_compras_sugeridas
integer x = 521
integer y = 44
integer width = 402
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
end type

event clicked;dw_report.dataObject = "d_rpt_compras_sugeridas_res"
dw_report.SetTransObject(sqlca)

dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.text     = gs_user
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_codigo.text   = dw_report.dataobject

end event

type rb_det from radiobutton within w_cm703_compras_sugeridas
integer x = 91
integer y = 44
integer width = 402
integer height = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
end type

event clicked;dw_report.dataObject = "d_rpt_compras_sugeridas_det_403"
dw_report.SetTransObject(sqlca)

dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.text     = gs_user
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_codigo.text   = dw_report.dataobject



end event

type dw_report from u_dw_rpt within w_cm703_compras_sugeridas
integer y = 316
integer width = 2999
integer height = 836
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_1 from commandbutton within w_cm703_compras_sugeridas
integer x = 2231
integer y = 48
integer width = 302
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;Date ld_fecha
string ls_est_amp, ls_msg

SetPointer( hourglass!)
ld_fecha = uo_fecha.of_get_fecha()

if rb_1.checked then
	ls_est_amp = '1'
elseif rb_2.checked then
	ls_est_amp = '2'
elseif rb_3.checked then
	ls_est_amp = '3'
else
	MessageBox('Aviso', 'Debe seleccionar alguna de las ' &
			+ 'opciones de los estados de los articulos ' &
			+ 'proyectados')
	return
end if

IF rb_det.checked = true then
	//create or replace procedure USP_CMP_SUGERIDAS_DET(
	//		 adi_fecha   in date ,
	//		 asi_origen  in origen.cod_origen%TYPE,
	//		 asi_est_amp in char               
	//) is	
	
	DECLARE USP_PROC_D PROCEDURE FOR 
    		USP_CMP_SUGERIDAS_DET( :ld_fecha, :gs_origen, :ls_est_amp);
	EXECUTE USP_PROC_D;
	
	IF SQLCA.SQLCODE = -1 THEN
		ls_msg = SQLCA.SQLErrText
		ROLLBACK;
		Messagebox( "Error USP_CMP_SUGERIDAS_DET", ls_msg)
		Return
	END IF
	
	CLOSE USP_PROC_D;
	
ELSEIF rb_res.checked = true then
	//create or replace procedure USP_CMP_SUGERIDAS_RES(
	//       adi_fecha    in date,
	//       asi_origen   in origen.cod_origen%TYPE,
	//       asi_est_amp  in char
	//) is	
	
	DECLARE USP_PROC_R PROCEDURE FOR 
    		USP_CMP_SUGERIDAS_RES( :ld_fecha, :gs_origen, :ls_est_amp);
	EXECUTE USP_PROC_R;
	IF SQLCA.SQLCODE = -1 THEN
		ls_msg = SQLCA.SQLErrText
		ROLLBACK;
		Messagebox( "Error USP_CMP_SUGERIDAS_RES", ls_msg)
		Return
	END IF
	CLOSE USP_PROC_R;
END IF

idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
ib_preview = true

Parent.event ue_retrieve()

dw_report.object.t_fecha.text = STRING(ld_fecha, "DD/MM/YYYY")

SetPointer(Arrow!)


end event

type uo_fecha from u_ingreso_fecha within w_cm703_compras_sugeridas
event destroy ( )
integer x = 955
integer y = 40
integer taborder = 30
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;string ls_inicio 
date ld_fec_ini, ld_Fec_fin
integer li_dia

of_set_label('Hasta:') //para setear la fecha inicial
of_set_fecha(today())
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1()  para leer las fechas

end event

type gb_1 from groupbox within w_cm703_compras_sugeridas
integer x = 96
integer y = 144
integer width = 1463
integer height = 164
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Estado de los Art. proyectados"
end type

