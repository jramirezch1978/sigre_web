$PBExportHeader$w_rh112_abc_quinta_categoria.srw
forward
global type w_rh112_abc_quinta_categoria from w_abc_master_smpl
end type
type uo_1 from u_cst_quick_search within w_rh112_abc_quinta_categoria
end type
end forward

global type w_rh112_abc_quinta_categoria from w_abc_master_smpl
integer width = 2473
integer height = 1684
string title = "(RH112) Movimiento de Quinta Categoría"
string menuname = "m_master_simple"
uo_1 uo_1
end type
global w_rh112_abc_quinta_categoria w_rh112_abc_quinta_categoria

type variables
String is_codigo
end variables

on w_rh112_abc_quinta_categoria.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
end on

on w_rh112_abc_quinta_categoria.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
end on

event ue_open_pre;// Override
THIS.EVENT POST ue_set_access()					// setear los niveles de acceso IEMC
THIS.EVENT POST ue_set_access_cb()				// setear los niveles de acceso IEMC
THIS.EVENT Post ue_open_pos()

im_1 = CREATE m_rButton      	// crear menu de boton derecho del mouse
idw_1 = dw_master             // asignar dw corriente
idw_1.SetTransObject(SQLCA)
idw_1.of_protect()         	// bloquear modificaciones al dw_master
ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master

// Inicio del Evento Open
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

uo_1.of_set_dw('d_maestro_lista_tbl')
uo_1.of_set_field('nombres')

uo_1.of_retrieve_lista(gs_origen)
uo_1.of_sort_lista()
uo_1.of_protect()
//Final del Evento Open	


end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh112_abc_quinta_categoria
integer x = 64
integer y = 772
integer width = 2295
integer height = 676
string dataobject = "d_dscto_quinta_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'  // tabular, grid, form (default)
ii_ck[1] = 1				// columnas de lectura de este dw
//ii_ck[2] = 2    			// Columnas de lectura de este dw

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.setitem(al_row,"cod_trabajador", is_codigo)

//Ingreso de Registros 
dw_master.Modify("fec_proceso.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("rem_proyectable.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("rem_imprecisa.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("rem_promedio.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("rem_retencion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("rem_gratif.Protect='1~tIf(IsRowNew(),0,1)'")

end event

type uo_1 from u_cst_quick_search within w_rh112_abc_quinta_categoria
integer x = 389
integer y = 60
integer width = 1646
integer height = 648
integer taborder = 10
boolean bringtotop = true
end type

on uo_1.destroy
call u_cst_quick_search::destroy
end on

event ue_retorno;call super::ue_retorno;dw_master.Retrieve(aa_id)
is_codigo=aa_id
end event

