$PBExportHeader$w_ma008_tipo_mantto.srw
forward
global type w_ma008_tipo_mantto from w_abc_master
end type
type dw_lista from u_dw_list_tbl within w_ma008_tipo_mantto
end type
end forward

global type w_ma008_tipo_mantto from w_abc_master
integer width = 3296
integer height = 1212
string title = "Tipos de mantenimientos de maquinarias (MA008)"
string menuname = "m_abc_mastdet_smpl"
dw_lista dw_lista
end type
global w_ma008_tipo_mantto w_ma008_tipo_mantto

on w_ma008_tipo_mantto.create
int iCurrent
call super::create
if this.MenuName = "m_abc_mastdet_smpl" then this.MenuID = create m_abc_mastdet_smpl
this.dw_lista=create dw_lista
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
end on

on w_ma008_tipo_mantto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_master             // asignar dw corriente
idw_1.SetTransObject(SQLCA)
idw_1.of_protect()         	// bloquear modificaciones al dw_master

dw_master.Retrieve()
dw_master.of_protect()
of_position_window(0,0) 
//Help
ii_help = 10

//ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
end event

event ue_modify;call super::ue_modify;//dw_master.of_protect() 
end event

event ue_dw_share;call super::ue_dw_share;dw_lista.of_share_lista(dw_master)
end event

event ue_update_pre();call super::ue_update_pre;

//--VERIFICACION Y ASIGNACION DE TIPO DE MAQUINA
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

end event

type dw_master from w_abc_master`dw_master within w_ma008_tipo_mantto
integer y = 700
integer width = 3246
integer height = 304
string dataobject = "d_abc_tipo_manten_ff"
end type

event dw_master::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event dw_master::constructor;call super::constructor;//ii_cn = 1          	// numero de la columna, que juega como key.(default = 1)

// ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple

// ii_dk[1] = 1 	

ii_ck[1]=1
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

type dw_lista from u_dw_list_tbl within w_ma008_tipo_mantto
integer x = 9
integer y = 8
integer width = 3246
integer height = 684
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_tipo_manten_tbl"
end type

event ue_output;call super::ue_output;// personalizar en herencia
 
dw_master.ScrollToRow(al_row)
dw_master.il_row = al_row

end event

event constructor;call super::constructor;ii_ck[1]=1
end event

