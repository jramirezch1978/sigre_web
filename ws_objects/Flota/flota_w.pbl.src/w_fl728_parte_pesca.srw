$PBExportHeader$w_fl728_parte_pesca.srw
forward
global type w_fl728_parte_pesca from w_report_smpl
end type
type st_1 from statictext within w_fl728_parte_pesca
end type
type em_fecha2 from editmask within w_fl728_parte_pesca
end type
type em_fecha1 from editmask within w_fl728_parte_pesca
end type
type pb_reporte from picturebutton within w_fl728_parte_pesca
end type
type gb_1 from groupbox within w_fl728_parte_pesca
end type
end forward

global type w_fl728_parte_pesca from w_report_smpl
boolean visible = false
integer width = 2939
integer height = 2252
string title = "[FL728] Partes de Pesca"
string menuname = "m_impresion"
st_1 st_1
em_fecha2 em_fecha2
em_fecha1 em_fecha1
pb_reporte pb_reporte
gb_1 gb_1
end type
global w_fl728_parte_pesca w_fl728_parte_pesca

on w_fl728_parte_pesca.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_1=create st_1
this.em_fecha2=create em_fecha2
this.em_fecha1=create em_fecha1
this.pb_reporte=create pb_reporte
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_fecha2
this.Control[iCurrent+3]=this.em_fecha1
this.Control[iCurrent+4]=this.pb_reporte
this.Control[iCurrent+5]=this.gb_1
end on

on w_fl728_parte_pesca.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_fecha2)
destroy(this.em_fecha1)
destroy(this.pb_reporte)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

ib_preview = true
THIS.Event ue_preview()

em_Fecha1.text = '01/01/' + string(date(gnvo_app.of_fecha_actual( )), 'yyyy')
em_Fecha2.text = string(date(gnvo_app.of_fecha_actual( )), 'dd/mm/yyyy')
end event

event ue_retrieve;call super::ue_retrieve;Date   ld_fecha1,ld_fecha2

//rango de fechas
dw_report.Settransobject(sqlca)

ib_preview = true
event ue_preview( )

em_fecha1.getdata( ld_fecha1 )
em_fecha2.getdata( ld_fecha2 )

dw_report.Retrieve(ld_fecha1, ld_fecha2)
dw_report.object.datawindow.print.orientation = 1
dw_report.object.datawindow.print.paper.size = 8

dw_report.Object.p_logo.filename = gs_logo
dw_report.Object.t_user.text 	= gs_user
dw_report.Object.t_empresa.text 	= gs_empresa
dw_report.Object.t_ventana.text 	= this.ClassName()
dw_report.object.t_stitulo1.text = 'Desde ' + string(ld_fecha1, 'dd/mm/yyyy') + ' hasta ' + string(ld_fecha2, 'dd/mm/yyyy')

end event

type dw_report from w_report_smpl`dw_report within w_fl728_parte_pesca
integer x = 0
integer y = 248
integer width = 2921
integer height = 1656
string dataobject = "d_rpt_parte_diario_pesca_tbl"
end type

type st_1 from statictext within w_fl728_parte_pesca
integer x = 457
integer y = 68
integer width = 197
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "hasta"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_fecha2 from editmask within w_fl728_parte_pesca
integer x = 663
integer y = 72
integer width = 398
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type em_fecha1 from editmask within w_fl728_parte_pesca
integer x = 55
integer y = 72
integer width = 398
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type pb_reporte from picturebutton within w_fl728_parte_pesca
integer x = 1193
integer y = 40
integer width = 366
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\bmp\aceptar.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
ib_preview = false
parent.event ue_preview( )
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type gb_1 from groupbox within w_fl728_parte_pesca
integer width = 1669
integer height = 236
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
end type

