$PBExportHeader$w_ma710_rpt_orden_trabajo.srw
forward
global type w_ma710_rpt_orden_trabajo from w_rpt_list
end type
type rb_fecha from radiobutton within w_ma710_rpt_orden_trabajo
end type
type rb_labor from radiobutton within w_ma710_rpt_orden_trabajo
end type
type uo_1 from u_ingreso_rango_fechas within w_ma710_rpt_orden_trabajo
end type
type rb_maquina from radiobutton within w_ma710_rpt_orden_trabajo
end type
type rb_ejecutor from radiobutton within w_ma710_rpt_orden_trabajo
end type
type rb_proveedor from radiobutton within w_ma710_rpt_orden_trabajo
end type
type rb_cencos from radiobutton within w_ma710_rpt_orden_trabajo
end type
type gb_1 from groupbox within w_ma710_rpt_orden_trabajo
end type
end forward

global type w_ma710_rpt_orden_trabajo from w_rpt_list
integer width = 3433
integer height = 2008
string title = "Horas trabajadas por seccion (MA702)"
string menuname = "m_rpt_smpl"
rb_fecha rb_fecha
rb_labor rb_labor
uo_1 uo_1
rb_maquina rb_maquina
rb_ejecutor rb_ejecutor
rb_proveedor rb_proveedor
rb_cencos rb_cencos
gb_1 gb_1
end type
global w_ma710_rpt_orden_trabajo w_ma710_rpt_orden_trabajo

type variables
String is_opcion
end variables

on w_ma710_rpt_orden_trabajo.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.rb_fecha=create rb_fecha
this.rb_labor=create rb_labor
this.uo_1=create uo_1
this.rb_maquina=create rb_maquina
this.rb_ejecutor=create rb_ejecutor
this.rb_proveedor=create rb_proveedor
this.rb_cencos=create rb_cencos
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_fecha
this.Control[iCurrent+2]=this.rb_labor
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.rb_maquina
this.Control[iCurrent+5]=this.rb_ejecutor
this.Control[iCurrent+6]=this.rb_proveedor
this.Control[iCurrent+7]=this.rb_cencos
this.Control[iCurrent+8]=this.gb_1
end on

on w_ma710_rpt_orden_trabajo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_fecha)
destroy(this.rb_labor)
destroy(this.uo_1)
destroy(this.rb_maquina)
destroy(this.rb_ejecutor)
destroy(this.rb_proveedor)
destroy(this.rb_cencos)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False

end event

event resize;call super::resize;// Prueba
end event

type dw_report from w_rpt_list`dw_report within w_ma710_rpt_orden_trabajo
integer x = 50
integer y = 432
integer width = 3323
integer height = 1380
string dataobject = "d_rpt_pd_ot_det_tbl"
end type

type dw_1 from w_rpt_list`dw_1 within w_ma710_rpt_orden_trabajo
integer x = 46
integer y = 436
integer width = 1509
integer height = 988
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2

end event

type pb_1 from w_rpt_list`pb_1 within w_ma710_rpt_orden_trabajo
integer x = 1586
integer y = 624
end type

type pb_2 from w_rpt_list`pb_2 within w_ma710_rpt_orden_trabajo
integer x = 1582
integer y = 936
end type

type dw_2 from w_rpt_list`dw_2 within w_ma710_rpt_orden_trabajo
integer x = 1824
integer y = 452
integer width = 1509
integer height = 988
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2

end event

type cb_report from w_rpt_list`cb_report within w_ma710_rpt_orden_trabajo
integer x = 3090
integer y = 36
integer width = 288
integer textsize = -8
integer weight = 700
string text = "&Generar"
end type

event cb_report::clicked;Long i
Date ld_fini, ld_ffin
String ls_codigo, ls_texto

ld_fini = uo_1.of_get_fecha1()
ld_ffin = uo_1.of_get_fecha2()  

dw_1.visible = false
dw_2.visible = false
pb_1.visible = false
pb_2.visible = false

// Caso fecha
IF rb_fecha.checked = TRUE THEN
	delete from tt_cam_proveedor ;
	delete from tt_man_ejecutor ;
	delete from tt_cam_labores ;
	delete from tt_cam_maquina ;
	delete from tt_man_cencos ;

	idw_1.DataObject='d_rpt_pd_ot_det_tbl'
	idw_1.SetTransObject(sqlca)
	ls_texto = 'Del ' + STRING( ld_fini, 'dd/mm/yyyy') + ' al ' + STRING( ld_ffin, 'dd/mm/yyyy')
END IF 

// Caso codigo de labores
IF rb_labor.checked = TRUE THEN

	delete from tt_cam_labores;	

	FOR i = 1 to dw_2.rowcount()
		// Captura data llenar archivo temporal
	 	ls_codigo = dw_2.object.cod_labor[i]
	 	// Inserta datos en archivo temporal
	 	Insert into tt_cam_labores(cod_labor) values (:ls_codigo);

	 	IF sqlca.sqlcode = -1 THEN
		 	messagebox("Error al insertar registro",sqlca.sqlerrtext)
 	 	END IF

	NEXT	
	idw_1.DataObject='d_rpt_pd_ot_det_labor_tbl'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve(ld_fini, ld_ffin)
	ls_texto = 'Del ' + STRING( ld_fini, 'dd/mm/yyyy') + ' al ' + STRING( ld_ffin, 'dd/mm/yyyy')
END IF 

// Caso codigo de maquinas
IF rb_maquina.checked = TRUE THEN

	delete from tt_cam_maquina;	

	FOR i = 1 to dw_2.rowcount()
		// Captura data llenar archivo temporal
	 	ls_codigo = dw_2.object.cod_maquina[i]
	 	// Inserta datos en archivo temporal
	 	Insert into tt_cam_maquina(cod_maquina) values (:ls_codigo);

	 	IF sqlca.sqlcode = -1 THEN
		 	messagebox("Error al insertar registro",sqlca.sqlerrtext)
 	 	END IF

	NEXT	
	idw_1.DataObject='d_rpt_pd_ot_det_maquina_tbl'
	idw_1.SetTransObject(sqlca)
	ls_texto = 'Del ' + STRING( ld_fini, 'dd/mm/yyyy') + ' al ' + STRING( ld_ffin, 'dd/mm/yyyy')
END IF 

// Caso codigo de proveedores
IF rb_proveedor.checked = TRUE THEN

	delete from tt_cam_proveedor;	

	FOR i = 1 to dw_2.rowcount()
		// Captura data llenar archivo temporal
	 	ls_codigo = dw_2.object.proveedor[i]
	 	// Inserta datos en archivo temporal
	 	Insert into tt_cam_proveedor(proveedor) values (:ls_codigo);

	 	IF sqlca.sqlcode = -1 THEN
		 	messagebox("Error al insertar registro",sqlca.sqlerrtext)
 	 	END IF

	NEXT	
	idw_1.DataObject='d_rpt_pd_ot_det_proveedor_tbl'
	idw_1.SetTransObject(sqlca)
	ls_texto = 'Del ' + STRING( ld_fini, 'dd/mm/yyyy') + ' al ' + STRING( ld_ffin, 'dd/mm/yyyy')
END IF 

// Caso codigo de ejecutores
IF rb_ejecutor.checked = TRUE THEN

	delete from tt_cam_ejecutor;	

	FOR i = 1 to dw_2.rowcount()
		// Captura data llenar archivo temporal
	 	ls_codigo = dw_2.object.cod_ejecutor[i]
	 	// Inserta datos en archivo temporal
	 	Insert into tt_cam_ejecutor(cod_ejecutor) values (:ls_codigo);

	 	IF sqlca.sqlcode = -1 THEN
		 	messagebox("Error al insertar registro",sqlca.sqlerrtext)
 	 	END IF

	NEXT	
	idw_1.DataObject='d_rpt_pd_ot_det_ejecutor_tbl'
	idw_1.SetTransObject(sqlca)
	ls_texto = 'Del ' + STRING( ld_fini, 'dd/mm/yyyy') + ' al ' + STRING( ld_ffin, 'dd/mm/yyyy')
END IF 

// Caso codigo de centros de costo responsables de OT
IF rb_cencos.checked = TRUE THEN

	delete from tt_man_cencos;	

	FOR i = 1 to dw_2.rowcount()
		// Captura data llenar archivo temporal
	 	ls_codigo = dw_2.object.cencos[i]
	 	// Inserta datos en archivo temporal
	 	Insert into tt_cam_ejecutor(cencos) values (:ls_codigo);

	 	IF sqlca.sqlcode = -1 THEN
		 	messagebox("Error al insertar registro",sqlca.sqlerrtext)
 	 	END IF

	NEXT	
	idw_1.DataObject='d_rpt_pd_ot_det_cencos_tbl'
	idw_1.SetTransObject(sqlca)
	ls_texto = 'Del ' + STRING( ld_fini, 'dd/mm/yyyy') + ' al ' + STRING( ld_ffin, 'dd/mm/yyyy')
END IF 


idw_1.retrieve(ld_fini, ld_ffin)
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = ls_texto
//idw_1.Object.t_user.text = gs_user

idw_1.visible=true
parent.event ue_preview()

end event

type rb_fecha from radiobutton within w_ma710_rpt_orden_trabajo
integer x = 82
integer y = 92
integer width = 439
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Fecha"
end type

event clicked;idw_1 = dw_report
idw_1.Visible = False
pb_1.visible = false
pb_2.visible = false

dw_1.Visible = False
dw_2.Visible = False

end event

type rb_labor from radiobutton within w_ma710_rpt_orden_trabajo
integer x = 82
integer y = 172
integer width = 439
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
string text = "Por Labor"
end type

event clicked;idw_1 = dw_report
idw_1.Visible = False
pb_1.visible = true
pb_2.visible = true
// dw_1
dw_1.DataObject='d_list_labor_tbl'
dw_1.SetTransObject(sqlca)
dw_1.Retrieve()
dw_1.visible = true
// dw_2
dw_2.DataObject='d_list_labor_tbl'
dw_2.SetTransObject(sqlca)
//dw_2.retrieve()
dw_2.visible = true

end event

type uo_1 from u_ingreso_rango_fechas within w_ma710_rpt_orden_trabajo
integer x = 1463
integer y = 92
integer taborder = 20
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // Titulo de botones
of_set_fecha(today(), today()) // Datos por defecto
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type rb_maquina from radiobutton within w_ma710_rpt_orden_trabajo
integer x = 82
integer y = 240
integer width = 439
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
string text = "Por Maquina"
end type

event clicked;idw_1 = dw_report
idw_1.Visible = False
pb_1.visible = true
pb_2.visible = true
// dw_1
dw_1.DataObject='d_list_maquina_tbl'
dw_1.SetTransObject(sqlca)
dw_1.Retrieve()
dw_1.visible = true
// dw_2
dw_2.DataObject='d_list_maquina_tbl'
dw_2.SetTransObject(sqlca)
//dw_2.retrieve()
dw_2.visible = true

end event

type rb_ejecutor from radiobutton within w_ma710_rpt_orden_trabajo
integer x = 617
integer y = 172
integer width = 517
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
string text = "Por Ejecutor"
end type

event clicked;idw_1 = dw_report
idw_1.Visible = False
pb_1.visible = true
pb_2.visible = true
// dw_1
dw_1.DataObject='d_list_ejecutor_tbl'
dw_1.SetTransObject(sqlca)
dw_1.Retrieve()
dw_1.visible = true

// dw_2
dw_2.DataObject='d_list_ejecutor_tbl'
dw_2.SetTransObject(sqlca)
//dw_2.retrieve()
dw_2.visible = true

end event

type rb_proveedor from radiobutton within w_ma710_rpt_orden_trabajo
integer x = 617
integer y = 92
integer width = 517
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Por Proveedor"
borderstyle borderstyle = styleraised!
end type

event clicked;idw_1 = dw_report
idw_1.Visible = False
pb_1.visible = true
pb_2.visible = true
// dw_1
dw_1.DataObject='d_list_codrel_tbl'
dw_1.SetTransObject(sqlca)
dw_1.Retrieve()
dw_1.visible = true

// dw_2
dw_2.DataObject='d_list_codrel_tbl'
dw_2.SetTransObject(sqlca)
//dw_2.retrieve()
dw_2.visible = true

end event

type rb_cencos from radiobutton within w_ma710_rpt_orden_trabajo
integer x = 617
integer y = 240
integer width = 823
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Por Centro de costo responsable"
borderstyle borderstyle = styleraised!
end type

event clicked;idw_1 = dw_report
idw_1.Visible = False
pb_1.visible = true
pb_2.visible = true
// dw_1
dw_1.DataObject='d_list_cencos_tbl'
dw_1.SetTransObject(sqlca)
dw_1.Retrieve()
dw_1.visible = true

// dw_2
dw_1.DataObject='d_list_cencos_tbl'
dw_2.SetTransObject(sqlca)
//dw_2.retrieve()
dw_2.visible = true

end event

type gb_1 from groupbox within w_ma710_rpt_orden_trabajo
integer x = 59
integer y = 24
integer width = 2711
integer height = 316
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Opciones"
borderstyle borderstyle = styleraised!
end type

