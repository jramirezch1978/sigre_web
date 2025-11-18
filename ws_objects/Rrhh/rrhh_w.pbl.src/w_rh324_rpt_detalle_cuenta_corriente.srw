$PBExportHeader$w_rh324_rpt_detalle_cuenta_corriente.srw
forward
global type w_rh324_rpt_detalle_cuenta_corriente from w_report_smpl
end type
type cb_1 from commandbutton within w_rh324_rpt_detalle_cuenta_corriente
end type
type em_nombres from editmask within w_rh324_rpt_detalle_cuenta_corriente
end type
type cb_2 from commandbutton within w_rh324_rpt_detalle_cuenta_corriente
end type
type em_origen from editmask within w_rh324_rpt_detalle_cuenta_corriente
end type
type em_ttrab from editmask within w_rh324_rpt_detalle_cuenta_corriente
end type
type cb_3 from commandbutton within w_rh324_rpt_detalle_cuenta_corriente
end type
type cb_4 from commandbutton within w_rh324_rpt_detalle_cuenta_corriente
end type
type em_desc_origen from editmask within w_rh324_rpt_detalle_cuenta_corriente
end type
type em_desc_ttrab from editmask within w_rh324_rpt_detalle_cuenta_corriente
end type
type st_1 from statictext within w_rh324_rpt_detalle_cuenta_corriente
end type
type st_2 from statictext within w_rh324_rpt_detalle_cuenta_corriente
end type
type st_3 from statictext within w_rh324_rpt_detalle_cuenta_corriente
end type
type cbx_todos_trabajador from checkbox within w_rh324_rpt_detalle_cuenta_corriente
end type
type cbx_todos_origenes from checkbox within w_rh324_rpt_detalle_cuenta_corriente
end type
type cbx_todos_ttrab from checkbox within w_rh324_rpt_detalle_cuenta_corriente
end type
type sle_codigo from singlelineedit within w_rh324_rpt_detalle_cuenta_corriente
end type
type gb_2 from groupbox within w_rh324_rpt_detalle_cuenta_corriente
end type
end forward

global type w_rh324_rpt_detalle_cuenta_corriente from w_report_smpl
integer width = 3589
integer height = 1760
string title = "(RH324) Detalle de Cuenta Corriente por Trabajador"
string menuname = "m_impresion"
cb_1 cb_1
em_nombres em_nombres
cb_2 cb_2
em_origen em_origen
em_ttrab em_ttrab
cb_3 cb_3
cb_4 cb_4
em_desc_origen em_desc_origen
em_desc_ttrab em_desc_ttrab
st_1 st_1
st_2 st_2
st_3 st_3
cbx_todos_trabajador cbx_todos_trabajador
cbx_todos_origenes cbx_todos_origenes
cbx_todos_ttrab cbx_todos_ttrab
sle_codigo sle_codigo
gb_2 gb_2
end type
global w_rh324_rpt_detalle_cuenta_corriente w_rh324_rpt_detalle_cuenta_corriente

on w_rh324_rpt_detalle_cuenta_corriente.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_nombres=create em_nombres
this.cb_2=create cb_2
this.em_origen=create em_origen
this.em_ttrab=create em_ttrab
this.cb_3=create cb_3
this.cb_4=create cb_4
this.em_desc_origen=create em_desc_origen
this.em_desc_ttrab=create em_desc_ttrab
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.cbx_todos_trabajador=create cbx_todos_trabajador
this.cbx_todos_origenes=create cbx_todos_origenes
this.cbx_todos_ttrab=create cbx_todos_ttrab
this.sle_codigo=create sle_codigo
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_nombres
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.em_origen
this.Control[iCurrent+5]=this.em_ttrab
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.cb_4
this.Control[iCurrent+8]=this.em_desc_origen
this.Control[iCurrent+9]=this.em_desc_ttrab
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.cbx_todos_trabajador
this.Control[iCurrent+14]=this.cbx_todos_origenes
this.Control[iCurrent+15]=this.cbx_todos_ttrab
this.Control[iCurrent+16]=this.sle_codigo
this.Control[iCurrent+17]=this.gb_2
end on

on w_rh324_rpt_detalle_cuenta_corriente.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_nombres)
destroy(this.cb_2)
destroy(this.em_origen)
destroy(this.em_ttrab)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.em_desc_origen)
destroy(this.em_desc_ttrab)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cbx_todos_trabajador)
destroy(this.cbx_todos_origenes)
destroy(this.cbx_todos_ttrab)
destroy(this.sle_codigo)
destroy(this.gb_2)
end on

event ue_retrieve;String ls_codigo , ls_mensaje, ls_origen, ls_ttrab, ls_activo, ls_suspendido, ls_cancelado
Long   ll_count

ls_codigo = string(sle_codigo.text)
ls_origen = string(em_origen.text)
ls_ttrab	 = string(em_ttrab.text)

if cbx_todos_trabajador.checked then
	ls_codigo = '%'
else //verificar que codigo de trabajador existe
	if isnull(ls_codigo) or trim(ls_codigo) = '' then 
		MessageBox('Aviso','Debe seleccionar un trabajador', StopSign!)
		return
	end if
	select count(*) 
		into :ll_count 
	from maestro 
	where cod_trabajador = :ls_codigo ;
		
	if ll_count = 0 then
		Messagebox('Aviso','Codigo de Trabajador No Existe , Verifique!')
		Return
	end if
	
	ls_codigo = trim(ls_codigo) + '%'
end if	

if cbx_todos_origenes.checked then
	ls_origen = '%'
else //verificar que origen exista
	if isnull(ls_origen) or trim(ls_origen) = '' then 
		MessageBox('Aviso','Debe seleccionar un Origen')
		return
	else
		select count(*) into :ll_count from origen
		 where (cod_origen  = :ls_origen ) and 
		 		 (flag_estado = '1'		   )	;
		
		if ll_count = 0 then
			Messagebox('Aviso','Codigo de Origen No Existe , Verifique!')
			Return
		end if
	end if
	
	ls_origen = trim(ls_origen) + '%'
end if	

if cbx_todos_ttrab.checked then
	ls_ttrab = '%'
else //verificar que origen exista
	if isnull(ls_ttrab) or trim(ls_ttrab) = '' then 
		MessageBox('Aviso','Debe seleccionar un Tipo de Trabajador')
		return
	else
		select count(*) into :ll_count from tipo_trabajador 
		 where (tipo_trabajador = :ls_ttrab ) and 
		 		 (flag_estado     = '1'		   )	;
		
		if ll_count = 0 then
			Messagebox('Aviso','Codigo de Tipo de Trabajador No Existe , Verifique!')
			Return
		end if	
	end if
	
	ls_ttrab = trim(ls_ttrab) + '%'
end if	


//create or replace procedure usp_rh_rpt_detalle_cta_cte(
//       asi_codigo in maestro.cod_trabajador%TYPE,
//       asi_origen in origen.cod_origen%TYPE,
//       asi_ttrab  in tipo_trabajador.tipo_trabajador%TYPE 
//) is

// Procedimiento de reporte
DECLARE USP_RH_RPT_DETALLE_CTA_CTE PROCEDURE FOR 
	USP_RH_RPT_DETALLE_CTA_CTE( :ls_codigo, 
										 :ls_origen, 
										 :ls_ttrab) ;
EXECUTE USP_RH_RPT_DETALLE_CTA_CTE ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = SQLCA.SQLErrText
  	rollback ;
  	MessageBox("Error en procedure USP_RH_RPT_DETALLE_CTA_CTE", ls_mensaje)
	return
END IF

dw_report.retrieve()

CLOSE USP_RH_RPT_DETALLE_CTA_CTE;

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text 	= gs_empresa
dw_report.object.t_user.text 		= gs_user


end event

event ue_open_pre;call super::ue_open_pre;idw_1.Visible = true
end event

type dw_report from w_report_smpl`dw_report within w_rh324_rpt_detalle_cuenta_corriente
integer x = 14
integer y = 400
integer width = 3520
integer height = 1164
integer taborder = 40
string dataobject = "d_rpt_detalle_cuenta_corriente_tbl"
end type

type cb_1 from commandbutton within w_rh324_rpt_detalle_cuenta_corriente
integer x = 2638
integer y = 84
integer width = 402
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type em_nombres from editmask within w_rh324_rpt_detalle_cuenta_corriente
integer x = 887
integer y = 100
integer width = 1202
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh324_rpt_detalle_cuenta_corriente
integer x = 791
integer y = 100
integer width = 87
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_rpt_seleccion_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param )
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_codigo.text  = sl_param.field_ret[1]
	em_nombres.text = sl_param.field_ret[2]
END IF

end event

type em_origen from editmask within w_rh324_rpt_detalle_cuenta_corriente
integer x = 434
integer y = 184
integer width = 338
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_ttrab from editmask within w_rh324_rpt_detalle_cuenta_corriente
integer x = 434
integer y = 268
integer width = 338
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_3 from commandbutton within w_rh324_rpt_detalle_cuenta_corriente
integer x = 791
integer y = 184
integer width = 87
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_desc_origen.text = sl_param.field_ret[2]
END IF

end event

type cb_4 from commandbutton within w_rh324_rpt_detalle_cuenta_corriente
integer x = 791
integer y = 268
integer width = 87
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_tiptra_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_ttrab.text      = sl_param.field_ret[1]
	em_desc_ttrab.text = sl_param.field_ret[2]
END IF

end event

type em_desc_origen from editmask within w_rh324_rpt_detalle_cuenta_corriente
integer x = 887
integer y = 184
integer width = 1202
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_ttrab from editmask within w_rh324_rpt_detalle_cuenta_corriente
integer x = 887
integer y = 268
integer width = 1202
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_1 from statictext within w_rh324_rpt_detalle_cuenta_corriente
integer x = 41
integer y = 100
integer width = 384
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "C.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh324_rpt_detalle_cuenta_corriente
integer x = 41
integer y = 192
integer width = 384
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh324_rpt_detalle_cuenta_corriente
integer x = 41
integer y = 276
integer width = 384
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "T.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_todos_trabajador from checkbox within w_rh324_rpt_detalle_cuenta_corriente
integer x = 2162
integer y = 100
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Todos"
end type

event clicked;if this.checked then
	sle_codigo.enabled = false
else
	sle_codigo.enabled = true
end if
end event

type cbx_todos_origenes from checkbox within w_rh324_rpt_detalle_cuenta_corriente
integer x = 2162
integer y = 184
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Todos"
end type

event clicked;
if this.checked then
	em_origen.enabled = false
else
	em_origen.enabled = true
end if
end event

type cbx_todos_ttrab from checkbox within w_rh324_rpt_detalle_cuenta_corriente
integer x = 2162
integer y = 268
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Todos"
end type

event clicked;
if this.checked then
	em_ttrab.enabled = false
else
	em_ttrab.enabled = true
end if
end event

type sle_codigo from singlelineedit within w_rh324_rpt_detalle_cuenta_corriente
integer x = 434
integer y = 100
integer width = 343
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_rh324_rpt_detalle_cuenta_corriente
integer x = 9
integer width = 2560
integer height = 392
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Ingrese Datos"
borderstyle borderstyle = stylebox!
end type

