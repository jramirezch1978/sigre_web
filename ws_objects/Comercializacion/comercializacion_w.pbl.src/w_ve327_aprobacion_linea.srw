$PBExportHeader$w_ve327_aprobacion_linea.srw
forward
global type w_ve327_aprobacion_linea from w_abc_master_smpl
end type
type rb_grmp from radiobutton within w_ve327_aprobacion_linea
end type
type cb_recuperar from commandbutton within w_ve327_aprobacion_linea
end type
type rb_desaprobar from radiobutton within w_ve327_aprobacion_linea
end type
type rb_aprobar from radiobutton within w_ve327_aprobacion_linea
end type
type gb_1 from groupbox within w_ve327_aprobacion_linea
end type
type gb_2 from groupbox within w_ve327_aprobacion_linea
end type
end forward

global type w_ve327_aprobacion_linea from w_abc_master_smpl
integer width = 3872
integer height = 2660
string title = "[VE327] Aprobacion de lineas de credito"
string menuname = "m_salir"
rb_grmp rb_grmp
cb_recuperar cb_recuperar
rb_desaprobar rb_desaprobar
rb_aprobar rb_aprobar
gb_1 gb_1
gb_2 gb_2
end type
global w_ve327_aprobacion_linea w_ve327_aprobacion_linea

on w_ve327_aprobacion_linea.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.rb_grmp=create rb_grmp
this.cb_recuperar=create cb_recuperar
this.rb_desaprobar=create rb_desaprobar
this.rb_aprobar=create rb_aprobar
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_grmp
this.Control[iCurrent+2]=this.cb_recuperar
this.Control[iCurrent+3]=this.rb_desaprobar
this.Control[iCurrent+4]=this.rb_aprobar
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.gb_2
end on

on w_ve327_aprobacion_linea.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_grmp)
destroy(this.cb_recuperar)
destroy(this.rb_desaprobar)
destroy(this.rb_aprobar)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;//ii_lec_mst = 0  
end event

event ue_refresh;call super::ue_refresh;dw_master.retrieve()
end event

type dw_master from w_abc_master_smpl`dw_master within w_ve327_aprobacion_linea
integer y = 248
integer width = 3703
integer height = 1708
string dataobject = "d_abc_aprobar_linea_credito_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::buttonclicked;call super::buttonclicked;String	ls_nom_cliente, ls_cod_moneda, ls_proveedor, ls_mensaje, ls_motivo_baja
Decimal	ldc_importe
Integer	li_nro_item

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'b_aprobar'
		
		ls_proveedor	= this.object.proveedor 			[row]
		ls_nom_cliente = this.object.nom_cliente 			[row]
		ls_cod_moneda	= this.object.cod_moneda 			[row]
		ldc_importe		= Dec(this.object.importe			[row])
		li_nro_item		= Integer(this.object.nro_item 	[row])
		
		if MessageBox("Aviso", "Desea aprobar la linea de credito?" &
									+ "~r~nCliente: " + ls_nom_cliente &
									+ "~r~nImporte: " + trim(ls_cod_moneda) + " " + trim(string(ldc_importe, '###,##0.00')),&
									Information!, Yesno!, 1) = 2 then 
			return 0
		end if
									
		//Actualizo la aprobacion
		update PROVEEDOR_LINEA_CREDITO t 
			set t.usr_aprob_rech = :gs_user,
				 t.fec_aprob_rech = sysdate,
				 t.flag_estado		= '1'
		where t.proveedor = :ls_proveedor    
		  and t.nro_item  = :li_nro_item;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al momento de actualizar la tabla PROVEEDOR_LINEA_CREDITO. Mensaje: ' + ls_mensaje, StopSign!)
			return 0
		end if
		
		commit;
		
		parent.event ue_retrieve( )
	
	
	case 'b_rechazar'	
		
		ls_proveedor	= this.object.proveedor 			[row]
		ls_nom_cliente = this.object.nom_cliente 			[row]
		ls_cod_moneda	= this.object.cod_moneda 			[row]
		ldc_importe		= Dec(this.object.importe			[row])
		li_nro_item		= Integer(this.object.nro_item 	[row])
		
		if MessageBox("Aviso", "Desea RECHAZAR la linea de credito con estos datos?" &
									+ "~r~nCliente: " + ls_nom_cliente &
									+ "~r~nImporte: " + trim(ls_cod_moneda) + " " + trim(string(ldc_importe, '###,##0.00')),&
									Information!, Yesno!, 1) = 2 then 
			return 0
		end if
		
		//Tiene que ingresar un motivo de baja
		ls_motivo_baja = gnvo_util.of_get_Texto("Ingrese el motivo de Baja", "")
		
		if ISNull(ls_motivo_baja) or trim(ls_motivo_baja) = '' then
			MessageBox('Error', 'Debe ingresar un motivo de rechazo, de lo contrario no podrá continuar con la operacion...', StopSign!)
			return 0
		end if
		
		//Actualizo la aprobacion
		update PROVEEDOR_LINEA_CREDITO t 
			set t.usr_aprob_rech = :gs_user,
				 t.fec_aprob_rech = sysdate,
				 t.flag_estado		= '2',
				 t.motivo_rechazo = :ls_motivo_baja
		where t.proveedor = :ls_proveedor    
		  and t.nro_item  = :li_nro_item;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al momento de actualizar la tabla PROVEEDOR_LINEA_CREDITO. Mensaje: ' + ls_mensaje, StopSign!)
			return 0
		end if
		
		commit;
		
		parent.event ue_retrieve( )

END CHOOSE
end event

type rb_grmp from radiobutton within w_ve327_aprobacion_linea
integer x = 18
integer y = 60
integer width = 562
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Lineas de Credito"
boolean checked = true
end type

type cb_recuperar from commandbutton within w_ve327_aprobacion_linea
integer x = 1202
integer y = 40
integer width = 343
integer height = 156
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_refresh( )
setPointer(Arrow!)
end event

type rb_desaprobar from radiobutton within w_ve327_aprobacion_linea
integer x = 741
integer y = 132
integer width = 411
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desaprobar"
end type

type rb_aprobar from radiobutton within w_ve327_aprobacion_linea
integer x = 741
integer y = 60
integer width = 379
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Aprobar"
boolean checked = true
end type

type gb_1 from groupbox within w_ve327_aprobacion_linea
integer width = 686
integer height = 232
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo documento"
end type

type gb_2 from groupbox within w_ve327_aprobacion_linea
integer x = 713
integer width = 1051
integer height = 232
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
end type

