$PBExportHeader$w_ope305_lista_trabaj.srw
forward
global type w_ope305_lista_trabaj from w_rpt_list
end type
end forward

global type w_ope305_lista_trabaj from w_rpt_list
integer width = 3442
integer height = 1652
string title = "Lista de trabajdores por labor"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 67108864
end type
global w_ope305_lista_trabaj w_ope305_lista_trabaj

type variables
sg_parametros_est is_param
end variables

on w_ope305_lista_trabaj.create
call super::create
end on

on w_ope305_lista_trabaj.destroy
call super::destroy
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(400,400) 	
end event

type dw_report from w_rpt_list`dw_report within w_ope305_lista_trabaj
boolean visible = false
integer x = 14
integer y = 20
integer width = 55
integer height = 48
boolean enabled = false
end type

type dw_1 from w_rpt_list`dw_1 within w_ope305_lista_trabaj
integer x = 14
integer y = 204
integer width = 1573
integer height = 1348
string dataobject = "d_lista_trabajador_x_labor_pd_tbl"
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;// Asigna parametro
IF NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	is_param = MESSAGE.POWEROBJECTPARM	
END IF

dw_1.SetTransObject(sqlca)
dw_1.retrieve(is_param.string1, is_param.string2, is_param.string3, is_param.long1)
dw_2.SetTransObject(sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2

end event

type pb_1 from w_rpt_list`pb_1 within w_ope305_lista_trabaj
integer x = 1623
integer y = 668
end type

type pb_2 from w_rpt_list`pb_2 within w_ope305_lista_trabaj
integer x = 1623
integer y = 936
end type

type dw_2 from w_rpt_list`dw_2 within w_ope305_lista_trabaj
integer x = 1819
integer y = 204
integer width = 1573
integer height = 1340
string dataobject = "d_lista_trabajador_x_labor_pd_tbl"
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2

end event

type cb_report from w_rpt_list`cb_report within w_ope305_lista_trabaj
integer x = 2825
integer y = 48
string text = "Traslada datos"
end type

event cb_report::clicked;call super::clicked;integer ll_inicio
string  ls_cod_trabajador, ls_nombre, ls_cod_labor, ls_cod_ejecutor
Long ll_row, ll_item
Decimal{2} ldc_gan_fija 
Date ld_fecha
u_dw_abc ldw_master

ldw_master = is_param.dw_m
ld_fecha = is_param.date1
ls_cod_labor = is_param.string1
ls_cod_ejecutor = is_param.string2

FOR ll_inicio = 1 to dw_2.rowcount()
  	 ls_cod_trabajador = dw_2.object.cod_trabajador[ll_inicio]
	 ll_row = ldw_master.event ue_insert()
	 
	 if ll_row > 0 then
		 IF ldw_master.Rowcount()  > 1 THEN
			 ll_item = ldw_master.object.nro_item	[ldw_master.Rowcount() - 1] + 1
		 ELSE
			 ll_item = 1
		 END IF
		 
		 SELECT p.nom_proveedor 
			INTO :ls_nombre
			FROM proveedor p 
		  WHERE p.proveedor=:ls_cod_trabajador ;
		  
		 SELECT usf_ope_costo_hora_personal(:ls_cod_trabajador, :ls_cod_labor, 
					:ls_cod_ejecutor, :ld_fecha)
		  INTO :ldc_gan_fija
		  FROM dual ;
	
	
		IF Isnull(ldc_gan_fija) THEN ldc_gan_fija = 0.00
		
		// Configura datos  
		 ldw_master.object.no_parte         [ll_row] = is_param.string3
		 ldw_master.object.nro_item         [ll_row] = is_param.long1
		 ldw_master.object.cod_trabajador   [ll_row] = ls_cod_trabajador
		 ldw_master.object.nom_trabajador   [ll_row] = ls_nombre
		 ldw_master.object.nro_horas		   [ll_row] = 8
		 ldw_master.object.costo_horas	   [ll_row] = ldc_gan_fija
		 ldw_master.object.observacion	   [ll_row] = 'Procesado'
		 ldw_master.object.factor			   [ll_row] = 1
		 ldw_master.object.flag_replicacion [ll_row] = '1'
	 end if
NEXT

Close( parent)

end event

