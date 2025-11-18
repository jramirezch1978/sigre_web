$PBExportHeader$w_sg060_obj_usu.srw
forward
global type w_sg060_obj_usu from w_abc_mastdet_smpl
end type
type st_1 from statictext within w_sg060_obj_usu
end type
type st_2 from statictext within w_sg060_obj_usu
end type
type cbx_prefijar from checkbox within w_sg060_obj_usu
end type
type cbx_ins from checkbox within w_sg060_obj_usu
end type
type cbx_eli from checkbox within w_sg060_obj_usu
end type
type cbx_mod from checkbox within w_sg060_obj_usu
end type
type cbx_con from checkbox within w_sg060_obj_usu
end type
type cbx_anu from checkbox within w_sg060_obj_usu
end type
type cbx_can from checkbox within w_sg060_obj_usu
end type
type dw_usu_obj from u_dw_abc within w_sg060_obj_usu
end type
type dw_usu_obj_neto from datawindow within w_sg060_obj_usu
end type
type ddlb_1 from dropdownlistbox within w_sg060_obj_usu
end type
type gb_1 from groupbox within w_sg060_obj_usu
end type
end forward

global type w_sg060_obj_usu from w_abc_mastdet_smpl
integer width = 3881
integer height = 2660
string title = "Mantenimiento de Usuarios por Objetos  (SG060)"
string menuname = "m_abc_mastdet_smpl"
long backcolor = 67108864
st_1 st_1
st_2 st_2
cbx_prefijar cbx_prefijar
cbx_ins cbx_ins
cbx_eli cbx_eli
cbx_mod cbx_mod
cbx_con cbx_con
cbx_anu cbx_anu
cbx_can cbx_can
dw_usu_obj dw_usu_obj
dw_usu_obj_neto dw_usu_obj_neto
ddlb_1 ddlb_1
gb_1 gb_1
end type
global w_sg060_obj_usu w_sg060_obj_usu

event resize;// Override
end event

on w_sg060_obj_usu.create
int iCurrent
call super::create
if this.MenuName = "m_abc_mastdet_smpl" then this.MenuID = create m_abc_mastdet_smpl
this.st_1=create st_1
this.st_2=create st_2
this.cbx_prefijar=create cbx_prefijar
this.cbx_ins=create cbx_ins
this.cbx_eli=create cbx_eli
this.cbx_mod=create cbx_mod
this.cbx_con=create cbx_con
this.cbx_anu=create cbx_anu
this.cbx_can=create cbx_can
this.dw_usu_obj=create dw_usu_obj
this.dw_usu_obj_neto=create dw_usu_obj_neto
this.ddlb_1=create ddlb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cbx_prefijar
this.Control[iCurrent+4]=this.cbx_ins
this.Control[iCurrent+5]=this.cbx_eli
this.Control[iCurrent+6]=this.cbx_mod
this.Control[iCurrent+7]=this.cbx_con
this.Control[iCurrent+8]=this.cbx_anu
this.Control[iCurrent+9]=this.cbx_can
this.Control[iCurrent+10]=this.dw_usu_obj
this.Control[iCurrent+11]=this.dw_usu_obj_neto
this.Control[iCurrent+12]=this.ddlb_1
this.Control[iCurrent+13]=this.gb_1
end on

on w_sg060_obj_usu.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cbx_prefijar)
destroy(this.cbx_ins)
destroy(this.cbx_eli)
destroy(this.cbx_mod)
destroy(this.cbx_con)
destroy(this.cbx_anu)
destroy(this.cbx_can)
destroy(this.dw_usu_obj)
destroy(this.dw_usu_obj_neto)
destroy(this.ddlb_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar(this)
dw_usu_obj.SetTransObject(SQLCA)
dw_usu_obj_neto.SetTransObject(SQLCA)
dw_detail.retrieve()

end event

event ue_insert;call super::ue_insert;IF idw_1 = dw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
END IF
end event

event ue_update;call super::ue_update;boolean lbo_ok
string  ls_msg
lbo_ok = true
IF	dw_usu_obj.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_usu_obj.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF
IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_usu_obj.ii_update = 0
END IF

end event

event ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1 OR dw_usu_obj.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_sg060_obj_usu
integer x = 14
integer y = 96
integer width = 2711
integer height = 840
string dataobject = "d_objeto_sis"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
ii_dk[1] = 1 	
end event

event dw_master::clicked;call super::clicked;// Actualiza detalle
dw_usu_obj.retrieve( dw_master.object.objeto[dw_master.getrow()])
dw_usu_obj_neto.retrieve( dw_master.object.objeto[dw_master.getrow()])
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;Parent.EVENT ue_update_request()
f_select_current_row(this)
dw_usu_obj.retrieve( dw_master.object.objeto[dw_master.getrow()])
dw_usu_obj_neto.retrieve( dw_master.object.objeto[dw_master.getrow()])

end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_sg060_obj_usu
integer y = 1044
integer width = 1746
integer height = 1288
string dataobject = "d_usuario_ori"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1	
ii_rk[1] = 1 	
end event

event dw_detail::doubleclicked;call super::doubleclicked;if row > 0 then
	// vefificación de no existencia previa
	string ls_cod_usr,ls_expresion
	ls_cod_usr = this.object.cod_usr[row]
   long ll_nbr, ll_foundrow
   ll_nbr = dw_usu_obj.RowCount()
	ls_expresion = "cod_usr = '"+ ls_cod_usr +"'"
//	messagebox('ls_expresion',ls_expresion)
	
   ll_foundrow = dw_usu_obj.Find( &
        "cod_usr = '" + ls_cod_usr + "'", 1, ll_nbr)
	
	if ll_foundrow > 0 then 
		MessageBox("Usuario existe", "El usuario ya está registrado")
      return 0
	end if
	if ll_foundrow < 0 then 
		MessageBox("Error ", "Existió algún error")
      return 0
	end if
		
	
   long ll_reg
   ll_reg = dw_usu_obj.insertrow(0)
   dw_usu_obj.setitem( ll_reg, 'objeto',  dw_master.object.objeto[dw_master.getrow()])
   dw_usu_obj.setitem( ll_reg, 'cod_usr', this.object.cod_usr[row])
   If cbx_prefijar.checked = true then 
   	if cbx_ins.checked = true then 
         dw_usu_obj.setitem( ll_reg, 'flag_insertar', '1')
   	end if 
   	if cbx_eli.checked = true then 
         dw_usu_obj.setitem( ll_reg, 'flag_eliminar', '1')
   	end if 
	   if cbx_mod.checked = true then 
         dw_usu_obj.setitem( ll_reg, 'flag_modificar', '1')
   	end if 
	   if cbx_con.checked = true then 
         dw_usu_obj.setitem( ll_reg, 'flag_consultar', '1')
   	end if 
	   if cbx_anu.checked = true then 
         dw_usu_obj.setitem( ll_reg, 'flag_anular', '1')
   	end if 
	   if cbx_can.checked = true then 
         dw_usu_obj.setitem( ll_reg, 'flag_cancelar', '1')
   	end if 
   end if
end if
dw_usu_obj.ii_update=1
end event

type st_1 from statictext within w_sg060_obj_usu
integer x = 9
integer y = 968
integer width = 430
integer height = 76
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Usuarios:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_sg060_obj_usu
integer x = 9
integer y = 12
integer width = 571
integer height = 76
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Objetos:"
boolean focusrectangle = false
end type

type cbx_prefijar from checkbox within w_sg060_obj_usu
integer x = 2770
integer y = 192
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Prefijar"
end type

event clicked;If cbx_prefijar.checked = true then 
	cbx_ins.enabled = true
	cbx_eli.enabled = true
	cbx_mod.enabled = true
	cbx_con.enabled = true
	cbx_anu.enabled = true
	cbx_can.enabled = true
else
   cbx_ins.enabled = false
	cbx_eli.enabled = false
	cbx_mod.enabled = false
	cbx_con.enabled = false
	cbx_anu.enabled = false
	cbx_can.enabled = false
end if
end event

type cbx_ins from checkbox within w_sg060_obj_usu
integer x = 2871
integer y = 272
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Insertar"
end type

type cbx_eli from checkbox within w_sg060_obj_usu
integer x = 2871
integer y = 344
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Eliminar"
end type

type cbx_mod from checkbox within w_sg060_obj_usu
integer x = 2871
integer y = 416
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Modificar"
end type

type cbx_con from checkbox within w_sg060_obj_usu
integer x = 2871
integer y = 488
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Consultar"
end type

type cbx_anu from checkbox within w_sg060_obj_usu
integer x = 2871
integer y = 560
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Anular"
end type

type cbx_can from checkbox within w_sg060_obj_usu
integer x = 2871
integer y = 632
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Cancelar"
end type

type dw_usu_obj from u_dw_abc within w_sg060_obj_usu
integer x = 1769
integer y = 1632
integer width = 2025
integer height = 704
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_usr_obj_tbl"
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event itemchanged;call super::itemchanged;ii_update = 1
end event

event doubleclicked;call super::doubleclicked;if row > 0 then 
   ii_update = 1
   this.deleterow(row)
end if 
end event

type dw_usu_obj_neto from datawindow within w_sg060_obj_usu
integer x = 1769
integer y = 944
integer width = 2025
integer height = 680
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_obj_acceso_neto_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_rol
ls_rol = trim(this.object.grp_obj_grupo[row])
OpenSheet (w_sg020_grupo, w_main, 0, Original!)

long ll_found
ll_found = w_sg020_grupo.dw_master.Find("grupo = '" + ls_rol + "'", &
        1, w_sg020_grupo.dw_master.RowCount())
w_sg020_grupo.dw_master.selectrow(0, false)
w_sg020_grupo.dw_master.selectrow(ll_found, true)
w_sg020_grupo.dw_master.ScrollToRow(ll_found)


end event

type ddlb_1 from dropdownlistbox within w_sg060_obj_usu
integer x = 3177
integer y = 12
integer width = 480
integer height = 400
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"CN","LM","SC","SP","*"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;string ls_origen, ls_temp
ls_origen = this.Text(index)
if ls_origen = '*' then
	// limpiar filtros
   SetNull(ls_temp)
   dw_detail.SetFilter(ls_temp)
   dw_detail.Filter( )
   dw_usu_obj_neto.SetFilter(ls_temp)
   dw_usu_obj_neto.Filter( )
   dw_usu_obj.SetFilter(ls_temp)
   dw_usu_obj.Filter( )
else
	// actualizar filtros
	ls_temp = "origen_alt = '" + ls_origen + "'"
   dw_detail.SetFilter(ls_temp)
   dw_detail.Filter( )
	ls_temp = "usuario_origen_alt = '" + ls_origen + "'"
   dw_usu_obj_neto.SetFilter(ls_temp)
   dw_usu_obj_neto.Filter( )
	ls_temp = "usuario_origen_alt = '" + ls_origen + "'"
   dw_usu_obj.SetFilter(ls_temp)
   dw_usu_obj.Filter( )
end if
end event

type gb_1 from groupbox within w_sg060_obj_usu
integer x = 2743
integer y = 124
integer width = 773
integer height = 808
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

