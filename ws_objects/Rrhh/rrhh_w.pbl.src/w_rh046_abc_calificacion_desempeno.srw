$PBExportHeader$w_rh046_abc_calificacion_desempeno.srw
forward
global type w_rh046_abc_calificacion_desempeno from w_abc_mastdet_smpl
end type
end forward

global type w_rh046_abc_calificacion_desempeno from w_abc_mastdet_smpl
integer width = 2862
integer height = 1988
string title = "(RH046) Calificaciones por Actitudes"
string menuname = "m_master_simple"
end type
global w_rh046_abc_calificacion_desempeno w_rh046_abc_calificacion_desempeno

type variables
Integer ii_dw_upd

end variables

on w_rh046_abc_calificacion_desempeno.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh046_abc_calificacion_desempeno.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

event ue_print;call super::ue_print;idw_1.print()
end event

event ue_modify;call super::ue_modify;int li_protect 

li_protect = integer(dw_master.Object.condes.Protect)
If li_protect = 0 Then
	dw_master.Object.condes.Protect = 1
End if 

li_protect = integer(dw_detail.Object.condes.Protect)
If li_protect = 0 Then
	dw_detail.Object.condes.Protect = 1
End if 
li_protect = integer(dw_detail.Object.calif_concepto.Protect)
If li_protect = 0 Then
	dw_detail.Object.calif_concepto.Protect = 1
End if 


	

end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;decimal ldc_porcentaje
integer li_row 

li_row = dw_detail.GetRow()

If li_row > 0 Then 
	ldc_porcentaje = dw_detail.GetItemDecimal(li_row,"porcentaje")
	If isnull(ldc_porcentaje) or ldc_porcentaje = 0.000 then
  		dw_detail.ii_update = 0
		Messagebox("Sistema de Validacion","Ingrese Porcentaje de Calificación por Desempeño")
		dw_detail.SetColumn("porcentaje")
		dw_detail.SetFocus()
		return
	End If
End if	

dw_master.of_set_flag_replicacion( )
dw_detail.of_set_flag_replicacion( )
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_rh046_abc_calificacion_desempeno
integer x = 343
integer y = 20
integer width = 1989
integer height = 556
string dataobject = "d_av_tipo_eval_desempeno_tbl"
boolean vscrollbar = true
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

event dw_master::ue_insert_pre;call super::ue_insert_pre;//Validacion de ingreso de filas 
dw_master.Modify("condes.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("descripcion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_estado.Protect='1~tIf(IsRowNew(),0,1)'")

end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_rh046_abc_calificacion_desempeno
integer x = 41
integer y = 608
integer width = 2747
integer height = 1156
string dataobject = "d_av_calificacion_desempeno_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;//Forma parte del pK
ii_ck[1] = 1				// columnas de lectrua de este dw

//Variable de pase de Parametros
ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::clicked;call super::clicked;ii_dw_upd = 2

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.setitem(al_row,"cod_usr",gs_user)

int li_protect 

li_protect = integer(dw_detail.object.condes.Protect)
If li_protect = 0 Then
	dw_detail.Object.condes.Protect = 1
End if

//Validacion al ingresar un registro
dw_detail.Modify("condes.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("calif_concepto.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("porcentaje.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("flag_estado.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("cod_usr.Protect='1~tIf(IsRowNew(),0,1)'")

end event

event dw_detail::buttonclicked;call super::buttonclicked;openwithparm(w_rsp_descripcion,string(row))
dw_detail.ii_update = 1
end event

