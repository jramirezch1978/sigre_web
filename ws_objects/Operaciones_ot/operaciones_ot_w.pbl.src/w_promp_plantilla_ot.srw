$PBExportHeader$w_promp_plantilla_ot.srw
forward
global type w_promp_plantilla_ot from w_abc
end type
type p_1 from picture within w_promp_plantilla_ot
end type
type rb_ot from radiobutton within w_promp_plantilla_ot
end type
type rb_plant from radiobutton within w_promp_plantilla_ot
end type
type pb_2 from picturebutton within w_promp_plantilla_ot
end type
type rb_cxp from radiobutton within w_promp_plantilla_ot
end type
type gb_1 from groupbox within w_promp_plantilla_ot
end type
end forward

global type w_promp_plantilla_ot from w_abc
integer width = 2546
integer height = 532
string title = "Opciones avanzadas de Copiado de Plantillas"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 16777215
p_1 p_1
rb_ot rb_ot
rb_plant rb_plant
pb_2 pb_2
rb_cxp rb_cxp
gb_1 gb_1
end type
global w_promp_plantilla_ot w_promp_plantilla_ot

on w_promp_plantilla_ot.create
int iCurrent
call super::create
this.p_1=create p_1
this.rb_ot=create rb_ot
this.rb_plant=create rb_plant
this.pb_2=create pb_2
this.rb_cxp=create rb_cxp
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.rb_ot
this.Control[iCurrent+3]=this.rb_plant
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.rb_cxp
this.Control[iCurrent+6]=this.gb_1
end on

on w_promp_plantilla_ot.destroy
call super::destroy
destroy(this.p_1)
destroy(this.rb_ot)
destroy(this.rb_plant)
destroy(this.pb_2)
destroy(this.rb_cxp)
destroy(this.gb_1)
end on

type p_1 from picture within w_promp_plantilla_ot
integer x = 64
integer y = 76
integer width = 562
integer height = 304
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type rb_ot from radiobutton within w_promp_plantilla_ot
integer x = 677
integer y = 168
integer width = 1230
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Generar Plantilla de Orden de Trabajo Seleccionada"
end type

event clicked;//
//IF this.checked THEN
//	//datos de plantilla//
//	dw_ext.Reset()
//	dw_ext.InsertRow(0)
//	dw_ext.visible = TRUE
//	/**/
//ELSE
//	dw_ext.visible = FALSE
//
//END IF
end event

type rb_plant from radiobutton within w_promp_plantilla_ot
integer x = 677
integer y = 92
integer width = 1230
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Generar Copia de Plantilla Seleccionada"
end type

event clicked;//String ls_objeto, ls_insertar
//Long ll_row_master
//
//// Validando si tiene acceso a insertar una plantilla
//SELECT MAX(m.ls_flag) 
//  INTO :ls_insertar 
//  FROM 
//( SELECT NVL(flag_insertar,'0') as ls_flag
//    FROM usuario_obj 
//   WHERE cod_usr=:gs_user AND objeto=:is_objeto
// UNION  
//  SELECT nvl(g.flag_insertar,'0') as ls_flag
//    FROM GRP_OBJ g, USR_GRP u 
//   WHERE g.grupo=u.grupo and 
//         g.objeto=:is_objeto and 
//         u.cod_usr=:gs_user ) m ;
//		 
//// SELECT MAX(NVL(flag_insertar,'0'))
////   INTO :ls_insertar 
////   FROM usuario_obj 
////  WHERE cod_usr=:gs_user AND objeto=:is_objeto ;
////  
////IF ls_insertar = '0' THEN 
////	select MAX(nvl(g.flag_insertar,'0')) 
////	  INTO :ls_insertar 
////	  from GRP_OBJ g, USR_GRP u 
////	 where g.grupo=u.grupo and 
////			 g.objeto=:is_objeto and 
////			 u.cod_usr=:gs_user ) m ;		 
////END IF 
//
//IF ls_insertar='0' THEN 
//	MessageBox('Aviso','Usuario no tiene acceso a ingresar plantilla')
//	This.Checked = FALSE
//	rb_plant.checked = false
//	Return
//END IF ;
//
//// Validando si selecciono plantilla
//IF This.Checked THEN
//	ll_row_master = dw_master.getrow()
//	
//	IF ll_row_master = 0 THEN
//		Messagebox('Aviso','Debe Seleccionar Una plantilla para realizar su respectiva Copia')
//		This.Checked = FALSE
//		Return
//	END IF
//	dw_master.object.tipo_riego[dw_master.getrow()]='0'
//	dw_ext.visible=true
//	dw_ext.Reset()
//	dw_ext.InsertRow(0)
//	dw_ext.visible = TRUE
//ELSE
//	dw_ext.visible = FALSE
//END IF
end event

type pb_2 from picturebutton within w_promp_plantilla_ot
integer x = 2048
integer y = 88
integer width = 357
integer height = 312
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "c:\sigre\resources\Gif\aceptar6.gif"
alignment htextalign = left!
end type

event clicked;//Long   ll_row_master
//String ls_cod_plantilla,ls_new_plantilla,ls_desc_plantilla,ls_ot_adm
//
//IF rb_plant.checked THEN
//		dw_master.update()
//		dw_master.ii_update = 0
//	IF dw_master.ii_update = 1 OR dw_detail.ii_update = 1 OR dw_detdet.ii_update = 1 OR &
//	   dw_detdet_ingreso.ii_update = 1 THEN
//		Messagebox('Aviso','Tiene Actualizaciones Pendientes , Verifique!')
//		Return
//	END IF	
//	ll_row_master = dw_master.getrow()
//	IF ll_row_master = 0 THEN 
//		Messagebox('Aviso','Selecciona plantilla para copiar')
//		RETURN
//	END IF
//	ls_cod_plantilla = dw_master.object.cod_plantilla [ll_row_master]	
//	//PEDIR NOMBRE DE PLANTILLA A GENERAR
//	dw_ext.AcceptText()
//	ls_new_plantilla  = TRIM(dw_ext.object.cod_plantilla  [1])
//	ls_desc_plantilla = TRIM(dw_ext.object.desc_plantilla [1])
//	ls_ot_adm			= TRIM(dw_ext.object.ot_adm         [1])
//	
//	IF (ls_ot_adm = '') OR ISNULL(ls_ot_adm) THEN
//		Messagebox('Aviso','OT_ADM incorrecto')
//		RETURN
//	END IF
//	
//	dw_ext.visible=false
//	dw_ext.reset()
//
//	//genera plantilla
//	IF wf_genera_copia_plantilla( ls_new_plantilla, ls_desc_plantilla, ls_cod_plantilla, ls_ot_adm) = FALSE THEN
//		RETURN
//	END IF
//
//	
//ELSEIF rb_ot.checked THEN
//	// Asigna valores a structura 
//	Long ll_row
//	str_parametros sl_param
//
//	IF dw_master.ii_update = 1 OR dw_detail.ii_update = 1 OR dw_detdet.ii_update = 1 OR &
//	   dw_detdet_ingreso.ii_update = 1  THEN
//		Messagebox('Aviso','Tiene Actualizaciones Pendientes , Verifique!')
//		Return
//	END IF	
//
//	dw_ext.accepttext()
//	
//	ls_new_plantilla  = dw_ext.object.cod_plantilla  [1]
//	ls_desc_plantilla = dw_ext.object.desc_plantilla [1]
//	ls_ot_adm			= dw_ext.object.ot_adm         [1]
//		
//	dw_ext.visible=false
//	dw_ext.reset()
//	
//	sl_param.dw1     = 'd_abc_lista_orden_trabajo_x_usr_tbl'
//	sl_param.titulo  = 'Orden de Trabajo'
//	sl_param.tipo    = '1SQL'
//	sl_param.string1 = " WHERE (USUARIO = '" + gs_user + "') "&
//						  + "ORDER BY FEC_SOLICITUD DESC  "
//
//	sl_param.field_ret_i[1] = 1
//	sl_param.field_ret_i[2] = 2
//
//	OpenWithParm( w_lista, sl_param)
//
//	sl_param = Message.PowerObjectParm
//	IF sl_param.titulo <> 'n' THEN
//		wf_genera_plantilla_x_ot	(sl_param.field_ret[2],ls_new_plantilla,ls_desc_plantilla,ls_ot_adm)
//	END IF
//	
//ELSEIF rb_cxp.checked THEN
//
//	
//	IF dw_master.ii_update = 1 OR dw_detail.ii_update = 1 OR dw_detdet.ii_update = 1 OR &
//	   dw_detdet_ingreso.ii_update = 1 THEN
//		Messagebox('Aviso','Tiene Actualizaciones Pendientes , Verifique!')
//		Return
//	END IF	
//	
//	ll_row_master = dw_master.getrow()
//	IF ll_row_master = 0 THEN 
//		Messagebox('Aviso','Seleccione plantilla para copiar')
//		RETURN
//	END IF
//	ls_cod_plantilla = dw_master.object.cod_plantilla    [ll_row_master]	
//	ls_new_plantilla = dw_ext_plant.object.cod_plantilla [1]
//	
//	wf_ins_plant_x_plant(ls_cod_plantilla,ls_new_plantilla)
//	
//ELSE
//	Messagebox('Aviso','Debe seleccionar algun tipo de copia ,Verifique!')
//	Return
//END IF
end event

type rb_cxp from radiobutton within w_promp_plantilla_ot
integer x = 677
integer y = 248
integer width = 1230
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Adicionar operaciones hacia Plantillas"
end type

event clicked;//
//IF this.checked THEN
//	IF dw_master.Rowcount () = 0 THEN
//		Messagebox('Aviso','Debe Seleccionar Plantilla Hacia donde desea Adicionar Datos')
//		Return
//	END IF
//	
//	//datos de plantilla//
//	dw_ext_plant.Reset()
//	dw_ext_plant.InsertRow(0)
//	dw_ext_plant.visible = TRUE
//	/**/
//ELSE
//	dw_ext_plant.visible = FALSE
//END IF
end event

type gb_1 from groupbox within w_promp_plantilla_ot
integer width = 2523
integer height = 432
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Opciones de Copiado Avanzado"
end type

