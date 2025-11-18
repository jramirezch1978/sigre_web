$PBExportHeader$w_cns_smpl.srw
$PBExportComments$Ventana base para crear consultas
forward
global type w_cns_smpl from w_cns
end type
type dw_cns from u_dw_cns within w_cns_smpl
end type
end forward

global type w_cns_smpl from w_cns
integer width = 1627
integer height = 1224
event ue_retrieve ( )
dw_cns dw_cns
end type
global w_cns_smpl w_cns_smpl

event ue_retrieve();idw_1.Visible = True

//idw_1.Retrieve(gs_empresa)
//idw_1.Object.p_logo.filename = gs_logo
end event

on w_cns_smpl.create
int iCurrent
call super::create
this.dw_cns=create dw_cns
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cns
end on

on w_cns_smpl.destroy
call super::destroy
destroy(this.dw_cns)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_cns
idw_1.SetTransObject(sqlca)
idw_1.Visible = False

//IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

//This.Event ue_retrieve()

// ii_help = 101           // help topic

end event

event resize;call super::resize;dw_cns.width = newwidth - dw_cns.x
dw_cns.height = newheight - dw_cns.y
end event

type dw_cns from u_dw_cns within w_cns_smpl
integer x = 41
integer y = 64
integer width = 1115
integer height = 764
end type

