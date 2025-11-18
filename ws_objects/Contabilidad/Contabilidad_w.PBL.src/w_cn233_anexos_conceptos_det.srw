$PBExportHeader$w_cn233_anexos_conceptos_det.srw
forward
global type w_cn233_anexos_conceptos_det from w_abc_master
end type
end forward

global type w_cn233_anexos_conceptos_det from w_abc_master
integer width = 2217
integer height = 1096
string title = "[CN233] Detalle Asientos"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
end type
global w_cn233_anexos_conceptos_det w_cn233_anexos_conceptos_det

on w_cn233_anexos_conceptos_det.create
call super::create
end on

on w_cn233_anexos_conceptos_det.destroy
call super::destroy
end on

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("tipo_nota.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("tipo_nota")
END IF

end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

event open;//Override
THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()
	
if isvalid(message.powerobjectparm) then
	
	str_parametros lstr_parametros
	
	long ll_ano, ll_mes, ll_libro, ll_asiento
	string ls_origen
	
	lstr_parametros = message.powerobjectparm
	
	ls_origen = lstr_parametros.string1
	ll_ano    = long(lstr_parametros.string2)
	ll_mes	 = long(lstr_parametros.string3)
	ll_libro	 = long(lstr_parametros.string4)
	ll_asiento = long(lstr_parametros.string5)
	
	dw_master.retrieve( ls_origen, ll_ano, ll_mes, ll_libro, ll_asiento )
	
end if
end event

event ue_set_access;//Override
end event

type dw_master from w_abc_master`dw_master within w_cn233_anexos_conceptos_det
integer x = 37
integer y = 32
integer width = 2121
integer height = 932
string dataobject = "d_abc_detalle_cuentas_concepto"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

