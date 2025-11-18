$PBExportHeader$w_cam304_creditos_frm.srw
forward
global type w_cam304_creditos_frm from w_report_smpl
end type
end forward

global type w_cam304_creditos_frm from w_report_smpl
integer width = 2807
integer height = 1908
string title = ""
string menuname = "m_rpt_smpl"
long backcolor = 12632256
boolean toolbarvisible = false
end type
global w_cam304_creditos_frm w_cam304_creditos_frm

type variables

end variables

forward prototypes
public subroutine of_modify_dw (datawindow adw_data, string as_inifile)
end prototypes

public subroutine of_modify_dw (datawindow adw_data, string as_inifile);string 	ls_modify, ls_error
Long		ll_num_act, ll_i

if not FileExists(as_inifile) then return

ll_num_act = Long(ProfileString(as_inifile, "Total_lineas", 'Total', "0"))

for ll_i = 1 to ll_num_act
	ls_modify = ProfileString(as_inifile, "Modify", 'Linea' + string(ll_i), "")
	if ls_modify <> "" then
		ls_error = adw_data.Modify(ls_modify)
		if ls_error <> '' then
			MessageBox('Error en Modify datastore', ls_Error + ' ls_modify: ' + ls_modify)
		end if
	end if
next

end subroutine

on w_cam304_creditos_frm.create
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
end on

on w_cam304_creditos_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;istr_rep = message.powerobjectparm

idw_1 = dw_report
idw_1.Visible = False

this.Event ue_preview()
This.Event ue_retrieve()

end event

event ue_retrieve;call super::ue_retrieve;String 	ls_cad1, ls_cad2, ls_inifile, ls_razonsocial,  ls_direccion, ls_ruc, ls_email
Integer	li_opi
this.title = istr_rep.titulo
ls_inifile = istr_rep.inifile

dw_report.dataobject = istr_rep.dw1
dw_report.SetTransObject(sqlca)

CHOOSE CASE istr_rep.tipo 
		case '1S'
			dw_report.retrieve(istr_rep.string1)
		case else
			dw_report.retrieve()
END CHOOSE

dw_report.Visible = True
dw_report.object.datawindow.print.preview = 'Yes'
 	SELECT nombre, ruc, dir_calle into :ls_razonsocial, :gs_ruc, :ls_direccion from empresa;
	dw_report.Object.p_logo.filename = gs_logo
	dw_report.Object.t_empresa.text = ls_razonsocial
	dw_report.Object.t_ruc.text = ls_ruc
	dw_report.Object.t_direccion.text = ls_direccion
	select email into :ls_email from origen where cod_origen = :gs_origen;
	dw_report.Object.t_email.text = ls_email

dw_report.object.datawindow.print.Paper.Size = 1 //Letter	


if ls_inifile <> '' and Not isnull(ls_inifile) then
	of_modify_dw(dw_report, ls_inifile)
end if
end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()

end event

type dw_report from w_report_smpl`dw_report within w_cam304_creditos_frm
integer x = 0
integer y = 0
integer width = 2519
integer height = 1624
boolean hsplitscroll = true
end type

