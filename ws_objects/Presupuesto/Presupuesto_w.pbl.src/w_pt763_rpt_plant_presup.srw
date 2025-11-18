$PBExportHeader$w_pt763_rpt_plant_presup.srw
forward
global type w_pt763_rpt_plant_presup from w_report_smpl
end type
end forward

global type w_pt763_rpt_plant_presup from w_report_smpl
integer width = 2811
integer height = 1940
string title = ""
string menuname = "m_impresion"
end type
global w_pt763_rpt_plant_presup w_pt763_rpt_plant_presup

type variables

end variables

on w_pt763_rpt_plant_presup.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_pt763_rpt_plant_presup.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;str_parametros lstr_param

if IsNull(Message.Powerobjectparm) or Not IsValid(Message.PowerObjectParm) then return

if Message.PowerObjectparm.classname() <> 'str_parametros' then return

idw_1 = dw_report
lstr_param = message.powerobjectparm

idw_1.SetTransObject(SQLCA)
idw_1.Retrieve(lstr_param.string1)

THIS.Event ue_preview()
idw_1.Visible = TRUE
idw_1.object.t_usuario.text = gs_user
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.p_logo.filename= gs_logo
idw_1.object.datawindow.print.orientation = 1
end event

event ue_retrieve();call super::ue_retrieve;String ls_cad1, ls_cad2

this.title = istr_rep.titulo
dw_report.dataobject = istr_rep.dw1
dw_report.SetTransObject(sqlca)

CHOOSE CASE istr_rep.tipo 
		case '1S'
			dw_report.retrieve(istr_rep.string1)
		case '1L'
			dw_report.retrieve(istr_rep.long1)
		case '1L1A'			
			dw_report.retrieve(istr_rep.long1, istr_rep.field_ret)
		case '1L1S'
			dw_report.retrieve(istr_rep.long1, istr_rep.string1)
		case '2S'
			dw_report.retrieve(istr_rep.string1, istr_rep.string2)
		case '3S'
			dw_report.retrieve(istr_rep.string1, istr_rep.string2, istr_rep.string3)
		case else
			dw_report.retrieve()
	END CHOOSE
//ls_cad1 = istr_rep.string1
//ls_Cad2 = istr_rep.string2


//dw_report.Retrieve(ls_Cad1, ls_cad2 )
dw_report.Visible = True

//idw_1.Object.p_logo.filename = gs_logo
end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()

end event

type dw_report from w_report_smpl`dw_report within w_pt763_rpt_plant_presup
integer width = 1893
integer height = 1552
string dataobject = "d_rpt_formato_plantilla"
end type

