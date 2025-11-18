$PBExportHeader$w_cam312_liquidacion_credito_frm.srw
forward
global type w_cam312_liquidacion_credito_frm from w_rpt
end type
type dw_report from u_dw_rpt within w_cam312_liquidacion_credito_frm
end type
end forward

global type w_cam312_liquidacion_credito_frm from w_rpt
integer x = 256
integer y = 348
integer width = 3314
integer height = 1792
string title = "Formato de orden de compra (CM311)"
string menuname = "m_rpt_smpl"
dw_report dw_report
end type
global w_cam312_liquidacion_credito_frm w_cam312_liquidacion_credito_frm

type variables
String 			is_cod_origen, is_nro_liq

end variables

on w_cam312_liquidacion_credito_frm.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_cam312_liquidacion_credito_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
This.Event ue_retrieve()
end event

event ue_retrieve;string 			ls_ruc, ls_nom_empresa, ls_empresa, ls_dua, ls_band, &
					ls_flag_agente_ret, ls_modify

istr_rep = message.powerobjectparm

is_nro_liq     = istr_rep.string1

select cod_empresa
  into :ls_empresa
  from genparam
 where reckey = '1';

Select nombre, ruc 
	into :ls_nom_empresa, :ls_ruc
from empresa
where cod_empresa = :ls_empresa;

if not ISNULL( ls_ruc ) then  ls_ruc = 'RUC:' + ls_ruc

dw_report.Retrieve(is_nro_liq)
idw_1 = dw_report
idw_1.ii_zoom_actual = 100
idw_1.modify('datawindow.print.preview.zoom = ' + String(idw_1.ii_zoom_actual))

idw_1.Visible = True
idw_1.Object.p_logo.filename  = gs_logo
idw_1.object.t_direccion.text = f_direccion_empresa(gs_origen)
idw_1.object.t_telefono.text  = f_telefono_empresa(gs_origen)
idw_1.object.t_email.text  	= f_email_empresa(gs_origen)
idw_1.object.t_ruc.text 		= ls_ruc
idw_1.object.t_empresa.text	= ls_nom_empresa
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

//this.windowstate = maximized!
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

type dw_report from u_dw_rpt within w_cam312_liquidacion_credito_frm
integer width = 3273
integer height = 1524
boolean bringtotop = true
string dataobject = "d_rpt_liquidacion_credito_cab"
boolean hscrollbar = true
boolean vscrollbar = true
end type

