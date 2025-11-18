$PBExportHeader$w_cn040_abc_gxcfusion.srw
forward
global type w_cn040_abc_gxcfusion from w_abc_mastdet_smpl
end type
type st_1 from statictext within w_cn040_abc_gxcfusion
end type
end forward

global type w_cn040_abc_gxcfusion from w_abc_mastdet_smpl
integer width = 3095
integer height = 1620
string title = "Movimientos de Campos a fusionar (CN40)"
string menuname = "m_abc_master_smpl"
st_1 st_1
end type
global w_cn040_abc_gxcfusion w_cn040_abc_gxcfusion

type variables
Integer ii_dw_upd



end variables

on w_cn040_abc_gxcfusion.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_cn040_abc_gxcfusion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

event resize;// Override
end event

event ue_modify();call super::ue_modify;int li_protect 
li_protect = integer(dw_detail.Object.nro_fusion.Protect)

// Porteccion del numero de fusion
if li_protect = 0 then
	dw_detail.Object.nro_fusion.Protect = 1
end if 

end event

event ue_print();call super::ue_print;idw_1.print()
end event

event ue_update_pre();string  ls_tipo, ls_corr_corte_1
integer li_row, ln_contador

li_row = dw_master.GetRow()
if li_row > 0 then
	ls_tipo = string(dw_master.GetItemString(li_row,"tipo_fusion"))
	if isnull(ls_tipo) then
		dw_master.ii_update = 0
		MessageBox("Validación","Ingresa dato, si es Fusión o Apertura")
		dw_master.SetColumn("tipo_fusion")
		dw_master.SetFocus()
		return
	end if 
	ls_corr_corte_1 = string(dw_master.GetItemString(li_row,"corr_corte"))
	ln_contador = 0
	select count(*)
	  into :ln_contador
	  from campo_ciclo
	  where corr_corte = :ls_corr_corte_1 ;
	if ln_contador = 0 then
		dw_master.ii_update = 0
		MessageBox("Error","Correlativo de corte no existe en la tabla CAMPO_CICLO")
		dw_master.SetColumn("corr_corte")
		dw_master.SetFocus()
		return
	end if 
else
	return
end if 	


string  ls_corr_corte_2
integer li_rowd
li_rowd = dw_detail.GetRow()
if li_rowd > 0 then
	ls_corr_corte_2 = string(dw_detail.GetItemString(li_rowd,"corr_corte"))
	ln_contador = 0
	select count(*)
	  into :ln_contador
	  from campo_ciclo
	  where corr_corte = :ls_corr_corte_2 ;
	if ln_contador = 0 then
		dw_detail.ii_update = 0
		MessageBox("Error","Correlativo de corte no existe en la tabla CAMPO_CICLO")
		dw_detail.SetColumn("corr_corte")
		dw_detail.SetFocus()
		return
	end if 
else
	return
end if 	


end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cn040_abc_gxcfusion
integer x = 69
integer y = 220
integer width = 2907
integer height = 544
string dataobject = "d_gxc_fusion_separacion_tbl"
boolean vscrollbar = true
end type

event dw_master::clicked;call super::clicked;ii_dw_upd =1
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				 // columnas de lectrua de este dw
ii_dk[1] = 1             // colunmna de pase de parametros
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;// Validacion de ingreso de filas 
dw_master.Modify("nro_fusion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("ano.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("mes.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("corr_corte.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("tipo_fusion.Protect='1~tIf(IsRowNew(),0,1)'")

integer ln_numerador
select ult_nro
  into :ln_numerador
  from num_gxc_fusion_apertura
  where origen = :gs_origen ;
ln_numerador = ln_numerador + 1

// Ingreso de datos automáticos
string ls_flag_proceso
ls_flag_proceso = "N"
this.setitem(al_row,"nro_fusion",ln_numerador)
this.setitem(al_row,"cod_usr",gs_user)
this.setitem(al_row,"flag_proceso",ls_flag_proceso)

// Proteccion del campo llave
int li_protect
li_protect = integer(dw_master.Object.nro_fusion.Protect)
if li_protect = 0 then
	dw_master.Object.nro_fusion.Protect=1
end if

  update num_gxc_fusion_apertura
    set ult_nro = :ln_numerador
    where origen = :gs_origen ;


end event

event dw_master::ue_output(long al_row);call super::ue_output;this.event ue_retrieve_det(al_row)

end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])

end event

event dw_master::itemchanged;call super::itemchanged;string ls_corr_corte, ls_campo, ls_descripcion

accepttext()
choose case  dwo.name
	case 'corr_corte'
		ls_corr_corte = dw_master.object.corr_corte[row]	
		select cod_campo
		  into :ls_campo
		  from campo_ciclo
		  where corr_corte = :ls_corr_corte ;
		select nvl(desc_campo,'')
		  into :ls_descripcion
		  from campo
		  where cod_campo = :ls_campo ;
		dw_master.object.desc_campo [row] = ls_descripcion
end choose


end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cn040_abc_gxcfusion
integer x = 535
integer y = 832
integer width = 1979
integer height = 544
string dataobject = "d_gxc_fusion_separacion_det_tbl"
boolean vscrollbar = true
end type

event dw_detail::clicked;call super::clicked;ii_dw_upd = 2
end event

event dw_detail::constructor;call super::constructor;// Forma parte del PK
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

// Variable de pase de Parametros
ii_rk[1] = 1 	         // columnas que recibimos del master

end event

event dw_detail::itemchanged;call super::itemchanged;string ls_corr_corte, ls_campo, ls_descripcion

dw_detail.accepttext()
choose case  dwo.name
	case 'corr_corte'
		ls_corr_corte = dw_detail.object.corr_corte[row]	
		select cod_campo
		  into :ls_campo
		  from campo_ciclo
		  where corr_corte = :ls_corr_corte ;
		select nvl(desc_campo,'')
		  into :ls_descripcion
		  from campo
		  where cod_campo = :ls_campo ;
		dw_detail.object.desc_campo [row] = ls_descripcion
end choose

end event

event dw_detail::ue_insert_pre(long al_row);call super::ue_insert_pre;int li_protect 
li_protect = integer(dw_detail.object.nro_fusion.Protect)

// Proteccion del numero de fusion
if li_protect = 0 then
	dw_detail.Object.nro_fusion.Protect = 1
end if

// Validacion al ingresar un registro
dw_detail.Modify("corr_corte.Protect='1~tIf(IsRowNew(),0,1)'")

end event

type st_1 from statictext within w_cn040_abc_gxcfusion
integer x = 352
integer y = 60
integer width = 2341
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "MOVIMIENTO DE CAMPOS A FUSIONARSE O APERTURARSE"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

