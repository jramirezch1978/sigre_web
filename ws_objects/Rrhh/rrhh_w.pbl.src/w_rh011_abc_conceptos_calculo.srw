$PBExportHeader$w_rh011_abc_conceptos_calculo.srw
forward
global type w_rh011_abc_conceptos_calculo from w_abc_mastdet_smpl
end type
type uo_search from n_cst_search within w_rh011_abc_conceptos_calculo
end type
end forward

global type w_rh011_abc_conceptos_calculo from w_abc_mastdet_smpl
integer width = 2706
integer height = 1900
string title = "(RH011) Grupos de Conceptos de Calculo"
string menuname = "m_master_simple"
uo_search uo_search
end type
global w_rh011_abc_conceptos_calculo w_rh011_abc_conceptos_calculo

type variables
Integer ii_dw_upd
end variables

on w_rh011_abc_conceptos_calculo.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search
end on

on w_rh011_abc_conceptos_calculo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_search)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)


end event

event ue_print;call super::ue_print;idw_1.print()
end event

event ue_modify;call super::ue_modify;// Porteccion del grupo de cálculo

int li_protect 
li_protect = integer(dw_master.Object.grupo_calculo.Protect)
If li_protect = 0 Then
	dw_master.Object.grupo_calculo.Protect = 1
End if 

li_protect = integer(dw_detail.Object.grupo_calculo.Protect)
If li_protect = 0 Then
	dw_detail.Object.grupo_calculo.Protect = 1
End if 

	

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
end event

event resize;call super::resize;uo_search.width 	= newWidth - uo_Search.x - 10
uo_search.event ue_resize(sizetype, newwidth, newheight)
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_rh011_abc_conceptos_calculo
integer x = 0
integer y = 84
integer width = 2542
integer height = 852
string dataobject = "d_grupo_calculo_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1            //colunmna de pase de parametros

ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::clicked;call super::clicked;ii_dw_upd =1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;// Validacion de ingreso de filas 
dw_master.Modify("grupo_calculo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("concepto_gen.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("desc_grupo.Protect='1~tIf(IsRowNew(),0,1)'")



end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_rh011_abc_conceptos_calculo
integer x = 0
integer y = 952
integer width = 2139
integer height = 656
string dataobject = "d_grupo_calculo_det_tbl"
end type

event dw_detail::constructor;call super::constructor;//Forma parte del pK
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
//Variable de pase de Parametros
ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::clicked;call super::clicked;ii_dw_upd = 2
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;int li_protect 
li_protect = integer(dw_detail.object.grupo_calculo.Protect)

// Proteccion del grupo del calculo
If li_protect = 0 Then
	dw_detail.Object.grupo_calculo.Protect = 1
End if

// Validacion al ingresar un registro
dw_detail.Modify("grupo_calculo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("concepto_calc.Protect='1~tIf(IsRowNew(),0,1)'")

end event

event dw_detail::itemchanged;call super::itemchanged;string ls_codigo, ls_descripcion

accepttext()
choose case dwo.name 
	case 'concepto_calc'
		ls_codigo = dw_detail.object.concepto_calc[row]	
		Select desc_concep
		  into :ls_descripcion
		  from concepto
		  where concep = :ls_codigo ;
		dw_detail.object.concepto_desc_concep [row] = ls_descripcion
end choose

end event

type uo_search from n_cst_search within w_rh011_abc_conceptos_calculo
integer taborder = 30
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

