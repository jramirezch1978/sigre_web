$PBExportHeader$w_cam380_packing_list_frm.srw
forward
global type w_cam380_packing_list_frm from w_report_smpl
end type
type rb_1 from radiobutton within w_cam380_packing_list_frm
end type
type rb_2 from radiobutton within w_cam380_packing_list_frm
end type
type rb_3 from radiobutton within w_cam380_packing_list_frm
end type
end forward

global type w_cam380_packing_list_frm from w_report_smpl
integer width = 2807
integer height = 1908
string title = ""
string menuname = "m_rpt_smpl"
long backcolor = 12632256
boolean toolbarvisible = false
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
end type
global w_cam380_packing_list_frm w_cam380_packing_list_frm

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

on w_cam380_packing_list_frm.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
end on

on w_cam380_packing_list_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
end on

event ue_open_pre;call super::ue_open_pre;istr_rep = message.powerobjectparm

idw_1 = dw_report
dw_report.dataobject = istr_rep.dw1
idw_1.Visible = False

this.Event ue_preview()
This.Event ue_retrieve()

end event

event ue_retrieve;call super::ue_retrieve;String 	ls_inifile

this.title = istr_rep.titulo
ls_inifile = istr_rep.inifile

dw_report.SetTransObject(sqlca)

CHOOSE CASE istr_rep.tipo 
		case '1S'
			dw_report.retrieve(istr_rep.string1)
		case else
			dw_report.retrieve()
END CHOOSE

dw_report.Visible = True
dw_report.object.datawindow.print.preview = 'Yes'
dw_report.object.datawindow.print.Paper.Size = 1 //Letter	
dw_report.object.datawindow.print.Orientation = 1


if ls_inifile <> '' and Not isnull(ls_inifile) then
	of_modify_dw(dw_report, ls_inifile)
end if
end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()

end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Calculo (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type dw_report from w_report_smpl`dw_report within w_cam380_packing_list_frm
integer x = 0
integer y = 132
integer width = 2519
integer height = 1492
boolean hsplitscroll = true
end type

type rb_1 from radiobutton within w_cam380_packing_list_frm
integer x = 123
integer y = 44
integer width = 590
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Normal"
boolean checked = true
end type

event clicked;dw_report.dataobject = istr_rep.dw1
parent.Event ue_preview()
parent.Event ue_retrieve()

end event

type rb_2 from radiobutton within w_cam380_packing_list_frm
integer x = 1056
integer y = 44
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "PF1"
end type

event clicked;dw_report.dataobject = 'd_rpt_packing_list_pf1_tbl'
parent.Event ue_preview()
parent.Event ue_retrieve()

end event

type rb_3 from radiobutton within w_cam380_packing_list_frm
integer x = 1659
integer y = 44
integer width = 562
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Export Information"
end type

event clicked;dw_report.dataobject = 'd_rpt_pl_export_inf_tbl'
parent.Event ue_preview()
parent.Event ue_retrieve()

end event

