$PBExportHeader$w_rpt_preview.srw
forward
global type w_rpt_preview from w_report_smpl
end type
end forward

global type w_rpt_preview from w_report_smpl
integer width = 2807
integer height = 1908
string menuname = "m_impresion"
boolean toolbarvisible = false
end type
global w_rpt_preview w_rpt_preview

type variables
str_parametros istr_rep
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

on w_rpt_preview.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_rpt_preview.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;istr_rep = message.powerobjectparm

idw_1 = dw_report
idw_1.Visible = False

this.Event ue_preview()
This.Event ue_retrieve()

end event

event ue_retrieve;call super::ue_retrieve;String 	ls_cad1, ls_cad2, ls_inifile
Integer	li_opi
this.title = istr_rep.titulo
ls_inifile = istr_rep.inifile

dw_report.dataobject = istr_rep.dw1
dw_report.SetTransObject(sqlca)

CHOOSE CASE istr_rep.tipo 
		case '1S'
			dw_report.retrieve(istr_rep.string1)
		case '1S2S'
			dw_report.retrieve(istr_rep.string1, istr_rep.string2)
		case '1S2S3S'
			dw_report.retrieve(istr_rep.string1, istr_rep.string2, istr_rep.string3)
		case else
			dw_report.retrieve()
END CHOOSE

dw_report.Visible = True
dw_report.object.datawindow.print.preview = 'Yes'
dw_report.object.datawindow.print.Paper.Size = 1 //Letter

if ls_inifile <> '' and Not isnull(ls_inifile) then
	of_modify_dw(dw_report, ls_inifile)
end if

try
	dw_report.Object.p_logo.filename = gnvo_app.is_logo
	dw_report.Object.t_empresa.text 	= gnvo_app.invo_empresa.is_desc_empresa
	dw_report.Object.t_ruc.text		= gnvo_app.invo_empresa.is_ruc
catch (throwable ex)
	//MessageBox('Error', ex.getMessage())
end try
end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()

end event

type p_pie from w_report_smpl`p_pie within w_rpt_preview
end type

type ole_skin from w_report_smpl`ole_skin within w_rpt_preview
end type

type uo_h from w_report_smpl`uo_h within w_rpt_preview
end type

type st_box from w_report_smpl`st_box within w_rpt_preview
end type

type phl_logonps from w_report_smpl`phl_logonps within w_rpt_preview
end type

type p_mundi from w_report_smpl`p_mundi within w_rpt_preview
end type

type p_logo from w_report_smpl`p_logo within w_rpt_preview
end type

type uo_filter from w_report_smpl`uo_filter within w_rpt_preview
end type

type st_filtro from w_report_smpl`st_filtro within w_rpt_preview
end type

type dw_report from w_report_smpl`dw_report within w_rpt_preview
integer x = 512
integer y = 292
integer width = 2519
integer height = 1624
boolean hsplitscroll = true
end type

