$PBExportHeader$w_rh009_param_cconcep.srw
forward
global type w_rh009_param_cconcep from w_abc_master
end type
end forward

global type w_rh009_param_cconcep from w_abc_master
integer width = 3419
integer height = 2068
string title = "(RH009) Grupos Para Cálculo de Planillas"
string menuname = "m_master_simple"
end type
global w_rh009_param_cconcep w_rh009_param_cconcep

on w_rh009_param_cconcep.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh009_param_cconcep.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;idw_1.Retrieve()
//ii_help = 101            // help topic
ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
ib_log = TRUE
//idw_query = dw_master
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master`dw_master within w_rh009_param_cconcep
integer x = 0
integer y = 0
integer width = 3383
integer height = 1812
string dataobject = "d_param_cconcep_ff"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
borderstyle borderstyle = StyleBox!
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::itemchanged;call super::itemchanged;string ls_grupo_calculo
integer li_count 

li_count = 0
ls_grupo_calculo = data

select count(*) 
	into :li_count
	from grupo_calculo gc 
	where gc.grupo_calculo = :ls_grupo_calculo;
	
if li_count <> 1 then 
	messagebox('Recursos Humanos', 'No se encontró grupo de cálculo')
	setnull(ls_grupo_calculo)
end if

dwo.primary[row]	= ls_grupo_calculo

return 2

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;long ll_reckey

select nvl(max(reckey),0) + 1 
   into :ll_reckey
   from rrhhparam_cconcep;

this.object.reckey[al_row] = ll_reckey

end event

