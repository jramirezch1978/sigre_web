$PBExportHeader$w_fi359_cntas_pagar_conciliar_provision.srw
forward
global type w_fi359_cntas_pagar_conciliar_provision from w_abc
end type
type cb_1 from commandbutton within w_fi359_cntas_pagar_conciliar_provision
end type
type uo_1 from u_ingreso_rango_fechas within w_fi359_cntas_pagar_conciliar_provision
end type
type dw_master from u_dw_abc within w_fi359_cntas_pagar_conciliar_provision
end type
end forward

global type w_fi359_cntas_pagar_conciliar_provision from w_abc
integer width = 4283
integer height = 1640
string title = "Conciliacion Facturacion (FI359)"
string menuname = "m_proceso_anula_elim"
cb_1 cb_1
uo_1 uo_1
dw_master dw_master
end type
global w_fi359_cntas_pagar_conciliar_provision w_fi359_cntas_pagar_conciliar_provision

on w_fi359_cntas_pagar_conciliar_provision.create
int iCurrent
call super::create
if this.MenuName = "m_proceso_anula_elim" then this.MenuID = create m_proceso_anula_elim
this.cb_1=create cb_1
this.uo_1=create uo_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.dw_master
end on

on w_fi359_cntas_pagar_conciliar_provision.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente


of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

event ue_update_pre;call super::ue_update_pre;Long   ll_inicio
String ls_cod_relacion,ls_tipo_doc,ls_nro_doc,ls_msj_err


ib_update_check = TRUE

For ll_inicio = 1 TO dw_master.rowcount()
	 ls_cod_relacion = dw_master.object.cod_relacion [ll_inicio]
	 ls_tipo_doc	  = dw_master.object.tipo_doc		 [ll_inicio]
	 ls_nro_doc		  = dw_master.object.nro_doc		 [ll_inicio]
	
    update cntas_pagar
	    set flag_cntr_almacen = '1'  // REGUALRIZACION DE FACTURACION
	  where (cod_relacion = :ls_cod_relacion ) and
	  		  (tipo_doc 	 = :ls_tipo_doc	  ) and
			  (nro_doc 		 = :ls_nro_doc		  ) ;
			  
	 IF SQLCA.SQLCode = -1 THEN 
       ls_msj_err = SQLCA.SQLErrText
		 ROLLBACK ;
		 Messagebox('Aviso',ls_msj_err)
		 ib_update_check = FALSE
	 END IF


	 
Next	

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


IF lbo_ok THEN
	COMMIT using SQLCA;
	Messagebox('Aviso','Grabacion Satifactoria')
END IF

end event

type cb_1 from commandbutton within w_fi359_cntas_pagar_conciliar_provision
integer x = 1381
integer y = 60
integer width = 402
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_fecha_inicial,ls_fecha_final

ls_fecha_inicial = String(uo_1.of_get_fecha1(),'yyyymmdd')
ls_fecha_final	  = String(uo_1.of_get_fecha2(),'yyyymmdd')


dw_master.retrieve(ls_fecha_inicial,ls_fecha_final)
end event

type uo_1 from u_ingreso_rango_fechas within w_fi359_cntas_pagar_conciliar_provision
integer x = 41
integer y = 60
integer taborder = 30
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

type dw_master from u_dw_abc within w_fi359_cntas_pagar_conciliar_provision
integer x = 23
integer y = 180
integer width = 4197
integer height = 1264
string dataobject = "d_abc_control_almacen_cpagar_tbl"
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;Accepttext()
end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)



ii_ck[1] = 1				// columnas de lectrua de este dw


idw_mst = dw_master

end event

event retrieverow;call super::retrieverow;String ls_cod_relacion,ls_tipo_doc,ls_nro_doc,ls_nro_ref
Long   ll_flag_count


ll_flag_count	 = 0
ls_cod_relacion = this.object.cod_relacion [row]
ls_tipo_doc 	 = this.object.tipo_doc		 [row]
ls_nro_doc		 = this.object.nro_doc		 [row]
ls_nro_ref		 = this.object.nro_ref		 [row]


DECLARE PB_USP_FIN_VER_FACT_OC PROCEDURE FOR USP_FIN_VER_FACT_OC 
(:ls_nro_ref,:ls_cod_relacion,:ls_tipo_doc,:ls_nro_doc);
EXECUTE PB_USP_FIN_VER_FACT_OC ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF

FETCH PB_USP_FIN_VER_FACT_OC INTO :ll_flag_count  ;
CLOSE PB_USP_FIN_VER_FACT_OC ;

if ll_flag_count > 0 then
	this.object.flag [row] = '1'
end if
end event

