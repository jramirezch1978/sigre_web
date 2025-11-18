$PBExportHeader$w_cam374_rpt_reg43.srw
forward
global type w_cam374_rpt_reg43 from w_rpt
end type
type ddlb_modulo from dropdownlistbox within w_cam374_rpt_reg43
end type
type dw_report from datawindow within w_cam374_rpt_reg43
end type
type cb_1 from commandbutton within w_cam374_rpt_reg43
end type
type uo_fecha from u_ingreso_rango_fechas within w_cam374_rpt_reg43
end type
end forward

global type w_cam374_rpt_reg43 from w_rpt
integer x = 256
integer y = 348
integer width = 3314
integer height = 1792
string title = "[CAM374] RG-43 Informe Compendio Productores 2010"
string menuname = "m_rpt_smpl"
ddlb_modulo ddlb_modulo
dw_report dw_report
cb_1 cb_1
uo_fecha uo_fecha
end type
global w_cam374_rpt_reg43 w_cam374_rpt_reg43

type variables
String 			is_cod_origen, is_nro_liq

end variables

on w_cam374_rpt_reg43.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.ddlb_modulo=create ddlb_modulo
this.dw_report=create dw_report
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_modulo
this.Control[iCurrent+2]=this.dw_report
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.uo_fecha
end on

on w_cam374_rpt_reg43.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_modulo)
destroy(this.dw_report)
destroy(this.cb_1)
destroy(this.uo_fecha)
end on

event ue_open_pre;call super::ue_open_pre;dw_report.SetTransObject(sqlca)
this.Event ue_preview()

end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

//this.windowstate = maximized!
end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hojas de Excel (*.XLS),*.XLS" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type ddlb_modulo from dropdownlistbox within w_cam374_rpt_reg43
integer x = 1371
integer y = 32
integer width = 480
integer height = 376
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"AF","CB","FV","QM"}
borderstyle borderstyle = stylelowered!
end type

type dw_report from datawindow within w_cam374_rpt_reg43
integer x = 73
integer y = 204
integer width = 3145
integer height = 1348
integer taborder = 60
string title = "none"
string dataobject = "d_rpt_sic_rg45_crt"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cam374_rpt_reg43
integer x = 2043
integer y = 36
integer width = 393
integer height = 88
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Filtrar "
end type

event clicked;date   ld_fecha_ini, ld_fecha_fin
String ls_cod

ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))
ls_cod 			= ddlb_modulo.text

dw_report.SetTransObject(SQLCA)
dw_report.Retrieve(ld_fecha_ini, ld_fecha_fin, ls_cod)

end event

type uo_fecha from u_ingreso_rango_fechas within w_cam374_rpt_reg43
integer y = 32
integer taborder = 50
end type

event constructor;call super::constructor;date ld_fecini, ld_fecfin
string ls_fecha


ld_fecini = Date('01/'+string(Today(),'mm/yyyy') )

if string(Today(), 'mm' ) <> '12' then
	ld_fecfin = RelativeDate(Date('01/' + string( Integer( string(Today(),'mm') ) + 1 ) &
		+ '/' + string( Today(), 'yyyy')), -1)
else
	ld_fecfin = RelativeDate(Date('01/' + '01' + '/' + string( Integer( string(Today(), 'yyyy') ) +1 ) ), -1)

end if

of_set_label('Desde:','Hasta:') 				// para setear el titulo del boton
of_set_fecha( ld_fecini, ld_fecfin)			// para setear la fecha
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

