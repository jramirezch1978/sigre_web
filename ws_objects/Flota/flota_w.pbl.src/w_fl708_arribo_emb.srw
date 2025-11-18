$PBExportHeader$w_fl708_arribo_emb.srw
forward
global type w_fl708_arribo_emb from w_rpt
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl708_arribo_emb
end type
type dw_report from u_dw_rpt within w_fl708_arribo_emb
end type
type pb_recuperar from u_pb_std within w_fl708_arribo_emb
end type
end forward

global type w_fl708_arribo_emb from w_rpt
integer width = 2226
integer height = 1868
string title = "Embarcaciones Pendientes de Arribo (FL701)"
string menuname = "m_rep_grf"
long backcolor = 67108864
event ue_copiar ( )
uo_fecha uo_fecha
dw_report dw_report
pb_recuperar pb_recuperar
end type
global w_fl708_arribo_emb w_fl708_arribo_emb

event ue_copiar();dw_report.ClipBoard("gr_1")
end event

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_retrieve;call super::ue_retrieve;date ld_fecha1, ld_fecha2
ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

idw_1.Retrieve(ld_fecha1, ld_fecha2)


end event

on w_fl708_arribo_emb.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
this.pb_recuperar=create pb_recuperar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.dw_report
this.Control[iCurrent+3]=this.pb_recuperar
end on

on w_fl708_arribo_emb.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.dw_report)
destroy(this.pb_recuperar)
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

event ue_open_pre;call super::ue_open_pre;date ld_fecha1, ld_fecha2

idw_1 = dw_report
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()

idw_1.object.usuario_t.text 	= gs_user
idw_1.object.p_logo.filename 	= gs_logo

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( month( today() ) + 1 ,'00' ) &
	+ '/' + string( year( today() ), '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

uo_fecha.of_set_fecha( ld_fecha1, ld_fecha2 )


end event

type uo_fecha from u_ingreso_rango_fechas within w_fl708_arribo_emb
event destroy ( )
integer x = 73
integer y = 44
integer taborder = 50
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type dw_report from u_dw_rpt within w_fl708_arribo_emb
integer y = 172
integer width = 2167
integer height = 1464
integer taborder = 60
string dataobject = "d_rpt_arribos_emb_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type pb_recuperar from u_pb_std within w_fl708_arribo_emb
integer x = 1856
integer y = 24
integer width = 155
integer height = 132
integer textsize = -2
string text = "&r"
string picturename = "Retrieve!"
boolean map3dcolors = true
end type

event clicked;call super::clicked;parent.event dynamic ue_retrieve()
end event

