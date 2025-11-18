$PBExportHeader$w_ve771_consolidado_vendedor.srw
forward
global type w_ve771_consolidado_vendedor from w_report_smpl
end type
type uo_fechas from u_ingreso_rango_fechas_v within w_ve771_consolidado_vendedor
end type
type cb_3 from commandbutton within w_ve771_consolidado_vendedor
end type
type cbx_vendedor from checkbox within w_ve771_consolidado_vendedor
end type
type cb_vendedor from commandbutton within w_ve771_consolidado_vendedor
end type
type rb_1 from radiobutton within w_ve771_consolidado_vendedor
end type
type rb_2 from radiobutton within w_ve771_consolidado_vendedor
end type
type cbx_ubigeo from checkbox within w_ve771_consolidado_vendedor
end type
type cb_ubigeo from commandbutton within w_ve771_consolidado_vendedor
end type
type gb_1 from groupbox within w_ve771_consolidado_vendedor
end type
type gb_2 from groupbox within w_ve771_consolidado_vendedor
end type
end forward

global type w_ve771_consolidado_vendedor from w_report_smpl
integer width = 3831
integer height = 1980
string title = "[VE771] Ventas consolidado por Vendedor"
string menuname = "m_impresion"
uo_fechas uo_fechas
cb_3 cb_3
cbx_vendedor cbx_vendedor
cb_vendedor cb_vendedor
rb_1 rb_1
rb_2 rb_2
cbx_ubigeo cbx_ubigeo
cb_ubigeo cb_ubigeo
gb_1 gb_1
gb_2 gb_2
end type
global w_ve771_consolidado_vendedor w_ve771_consolidado_vendedor

type variables
Integer ii_index
end variables

on w_ve771_consolidado_vendedor.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fechas=create uo_fechas
this.cb_3=create cb_3
this.cbx_vendedor=create cbx_vendedor
this.cb_vendedor=create cb_vendedor
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cbx_ubigeo=create cbx_ubigeo
this.cb_ubigeo=create cb_ubigeo
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.cbx_vendedor
this.Control[iCurrent+4]=this.cb_vendedor
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.cbx_ubigeo
this.Control[iCurrent+8]=this.cb_ubigeo
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
end on

on w_ve771_consolidado_vendedor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.cb_3)
destroy(this.cbx_vendedor)
destroy(this.cb_vendedor)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cbx_ubigeo)
destroy(this.cb_ubigeo)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;Date 		ld_desde, ld_hasta
Long		ll_count

try 
	ld_desde = uo_fechas.of_get_fecha1()
	ld_hasta = uo_fechas.of_get_fecha2()
	
	SetPointer( Hourglass!)
	
	//Filtrar Vendedor
	if cbx_vendedor.checked then
		
		delete TT_COMPROBANTES;
		if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_COMPROBANTES' ) then
			rollback;
			return 
		end if	
		
		Insert into TT_COMPROBANTES(vendedor)
		select distinct 
				 vw.vendedor
		  from vw_vta_reg_ventas_det vw
		 where trunc(vw.fecha_documento) between :ld_desde and :ld_hasta;
	
			
		if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_COMPROBANTES' ) then
			rollback;
			return 
		end if	
			
		commit;
	
	else
		select count(*)
			into :ll_count
		from TT_COMPROBANTES;
		
		if ll_count = 0 then 
			MessageBox('Error', 'Debe seleccionar un vendedor, por favor verifique!', StopSign!)
			return
		end if
	end if
	
	//Filtrar ubigeo
	if cbx_ubigeo.checked then
		
		delete TT_UBIGEO;
		if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_UBIGEO' ) then
			rollback;
			return 
		end if	
		
		Insert into TT_UBIGEO(ubigeo)
		select distinct 
			 u.ubigeo
		  from vw_vta_reg_ventas_det vw,
				 vale_mov              vm,
				 articulo_mov          am,
				 guia_Vale             gv,
				 guia                  g,
				 sunat_ubigeo          u
		 where vm.nro_vale           = am.nro_vale
			and gv.nro_vale           = vm.nro_Vale
			and g.nro_guia            = gv.nro_guia
			and g.ubigeo_dst          = u.ubigeo
			and am.cod_origen         = vw.org_am
			and am.nro_mov            = vw.nro_am
			and vm.flag_estado        <> '0'
			and am.flag_estado        <> '0'
			and vw.vendedor			  in (select vendedor from TT_COMPROBANTES)
			and trunc(vw.fecha_documento) between :ld_desde and :ld_hasta
		order by u.ubigeo;
	
			
		if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_UBIGEO' ) then
			rollback;
			return 
		end if	
			
		commit;
	
	else
		select count(*)
			into :ll_count
		from TT_UBIGEO;
		
		if ll_count = 0 then 
			MessageBox('Error', 'Debe seleccionar un UBIGEO, por favor verifique!', StopSign!)
			return
		end if
	end if
	
	
	//Indico el mejor Datawindow
	if rb_1.checked then
		dw_report.DataObject = 'd_rpt_resumen_vendedor_cmp'
	else
		dw_report.DataObject = 'd_rpt_venta_efectiva_vendedor_cmp'
	end if
	
	dw_report.setTransObject(SQLCA)
	
	dw_report.visible = true
	ib_preview=false
	this.event ue_preview()
	//dw_report.SetTransObject( sqlca)
	
	dw_report.retrieve(Ld_desde, ld_hasta )	
	//dw_report.Object.DataWindow.Print.Orientation = 1
	dw_report.object.t_titulo1.text 	= 'Del : ' + STRING(LD_DESDE, "DD/MM/YYYY") + ' Al : ' &
			+ STRING(LD_HASTA, "DD/MM/YYYY")		
	
	dw_report.object.t_user.text 		= gs_user
	dw_report.Object.p_logo.filename = gs_logo
	dw_report.Object.t_empresa.text 	= gs_empresa
	//dw_report.Object.t_objeto.text 	= 'VE771'	


catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Eventro Retrieve()')
	
finally
	SetPointer( Arrow!)
end try


end event

event ue_saveas_excel;call super::ue_saveas_excel;//Override
string 		ls_path, ls_file
int 			li_rc
Date 			ld_desde, ld_hasta
Long			ll_count
u_ds_base	lds_base

try 
	ld_desde = uo_fechas.of_get_fecha1()
	ld_hasta = uo_fechas.of_get_fecha2()
	lds_base	= create u_ds_base
	
	SetPointer( Hourglass!)
	
	//Filtrar Vendedor
	if cbx_vendedor.checked then
		
		delete TT_COMPROBANTES;
		if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_COMPROBANTES' ) then
			rollback;
			return 
		end if	
		
		Insert into TT_COMPROBANTES(vendedor)
		select distinct 
				 vw.vendedor
		  from vw_vta_reg_ventas_det vw
		 where trunc(vw.fecha_documento) between :ld_desde and :ld_hasta;
	
			
		if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_COMPROBANTES' ) then
			rollback;
			return 
		end if	
			
		commit;
	
	else
		select count(*)
			into :ll_count
		from TT_COMPROBANTES;
		
		if ll_count = 0 then 
			MessageBox('Error', 'Debe seleccionar un vendedor, por favor verifique!', StopSign!)
			return
		end if
	end if
	
	//Filtrar ubigeo
	if cbx_ubigeo.checked then
		
		delete TT_UBIGEO;
		if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_UBIGEO' ) then
			rollback;
			return 
		end if	
		
		Insert into TT_UBIGEO(ubigeo)
		select distinct 
			 u.ubigeo
		  from vw_vta_reg_ventas_det vw,
				 vale_mov              vm,
				 articulo_mov          am,
				 guia_Vale             gv,
				 guia                  g,
				 sunat_ubigeo          u
		 where vm.nro_vale           = am.nro_vale
			and gv.nro_vale           = vm.nro_Vale
			and g.nro_guia            = gv.nro_guia
			and g.ubigeo_dst          = u.ubigeo
			and am.cod_origen         = vw.org_am
			and am.nro_mov            = vw.nro_am
			and vm.flag_estado        <> '0'
			and am.flag_estado        <> '0'
			and vw.vendedor			  in (select vendedor from TT_COMPROBANTES)
			and trunc(vw.fecha_documento) between :ld_desde and :ld_hasta
		order by u.ubigeo;
	
			
		if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_UBIGEO' ) then
			rollback;
			return 
		end if	
			
		commit;
	
	else
		select count(*)
			into :ll_count
		from TT_UBIGEO;
		
		if ll_count = 0 then 
			MessageBox('Error', 'Debe seleccionar un UBIGEO, por favor verifique!', StopSign!)
			return
		end if
	end if
	
	
	//Indico el mejor Datawindow
	if rb_1.checked then
		lds_base.DataObject = 'd_rpt_resumen_vendedor_cmp'
	else
		lds_base.DataObject = 'd_rpt_venta_efectiva_vendedor_cmp'
	end if
	
	lds_base.setTransObject(SQLCA)
	
	lds_base.retrieve(Ld_desde, ld_hasta )	
	
	li_rc = GetFileSaveName ( "Select File", ls_path, ls_file, "XLS", &
   				"Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

	IF li_rc = 1 Then
		uf_save_ds_as_excel ( lds_base, ls_file )
	End If



catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Eventro Retrieve()')
	
finally
	destroy lds_base
	SetPointer( Arrow!)
end try





////Indico el mejor Datawindow
//if rb_1.checked then
//	dw_report.DataObject = 'd_rpt_resumen_vendedor_cmp'
//else
//	dw_report.DataObject = 'd_rpt_venta_efectiva_vendedor_cmp'
//end if
//
//dw_report.setTransObject(SQLCA)
end event

type dw_report from w_report_smpl`dw_report within w_ve771_consolidado_vendedor
integer x = 0
integer y = 276
integer width = 3259
integer height = 1036
string dataobject = "d_rpt_resumen_vendedor_cmp"
end type

type uo_fechas from u_ingreso_rango_fechas_v within w_ve771_consolidado_vendedor
event destroy ( )
integer x = 59
integer y = 44
integer height = 212
integer taborder = 50
boolean bringtotop = true
long backcolor = 67108864
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde

ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
uo_fechas.of_set_label("Desde","Hasta")
uo_fechas.of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
uo_fechas.of_set_rango_inicio(DATE('01/01/1000'))
uo_fechas.of_set_rango_fin(DATE('31/12/9999'))

end event

type cb_3 from commandbutton within w_ve771_consolidado_vendedor
integer x = 2807
integer y = 68
integer width = 393
integer height = 168
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve()


end event

type cbx_vendedor from checkbox within w_ve771_consolidado_vendedor
integer x = 795
integer y = 64
integer width = 539
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtrar x Vendedor"
boolean checked = true
end type

event clicked;if this.checked then
	cb_vendedor.enabled = false
else
	cb_vendedor.enabled = true
end if
end event

type cb_vendedor from commandbutton within w_ve771_consolidado_vendedor
integer x = 795
integer y = 136
integer width = 539
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Elegir vendedor(es)"
end type

event clicked;Long 		ll_count
Date 		ld_desde, ld_hasta
str_parametros lstr_param 

ld_desde = uo_fechas.of_get_fecha1()
ld_hasta = uo_fechas.of_get_fecha2()

delete TT_COMPROBANTES ;
commit;

lstr_param.dw1			= 'd_lista_vendedores_tbl'
lstr_param.titulo		= 'Listado de Vendedores'
lstr_param.opcion   	= 24
lstr_param.tipo		= '1D2D'
lstr_param.fecha1		= ld_desde
lstr_param.fecha2		= ld_hasta


OpenWithParm( w_abc_seleccion_lista_search, lstr_param)

end event

type rb_1 from radiobutton within w_ve771_consolidado_vendedor
integer x = 1934
integer y = 60
integer width = 722
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Total Ventas (Sin Devolución)"
boolean checked = true
end type

type rb_2 from radiobutton within w_ve771_consolidado_vendedor
integer x = 1934
integer y = 144
integer width = 832
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Ventas Efectivas (con devolución)"
end type

type cbx_ubigeo from checkbox within w_ve771_consolidado_vendedor
integer x = 1344
integer y = 60
integer width = 539
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtrar x Ubigeo"
boolean checked = true
end type

event clicked;if this.checked then
	cb_ubigeo.enabled = false
else
	cb_ubigeo.enabled = true
end if
end event

type cb_ubigeo from commandbutton within w_ve771_consolidado_vendedor
integer x = 1344
integer y = 136
integer width = 539
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Elegir Ubigeo(s)"
end type

event clicked;Long 		ll_count
Date 		ld_desde, ld_hasta
String 	ls_vendedor
str_parametros lstr_param 

ld_desde = uo_fechas.of_get_fecha1()
ld_hasta = uo_fechas.of_get_fecha2()


//Filtrar Placa - Chofer
if cbx_vendedor.checked then
	
	delete TT_COMPROBANTES;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_COMPROBANTES' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_COMPROBANTES(VENDEDOR)
	select distinct 
       vw.vendedor
  	from vw_vta_reg_ventas_det vw
 	where trunc(vw.fecha_documento) between :ld_desde and :ld_hasta;
		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_COMPROBANTES' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from TT_COMPROBANTES;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar a un VENDEDOR, por favor verifique!', StopSign!)
		return
	end if
end if


delete TT_UBIGEO ;

if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_UBIGEO' ) then
	rollback;
	return 
end if	
	
commit;

lstr_param.dw1			= 'd_lista_ubigeo_venta_tbl'
lstr_param.titulo		= 'Listado de Ubigeos'
lstr_param.opcion   	= 25
lstr_param.tipo		= '1D2D'
lstr_param.fecha1		= ld_desde
lstr_param.fecha2		= ld_hasta


OpenWithParm( w_abc_seleccion_lista_search, lstr_param)

end event

type gb_1 from groupbox within w_ve771_consolidado_vendedor
integer width = 745
integer height = 268
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "  Fechas  : "
end type

type gb_2 from groupbox within w_ve771_consolidado_vendedor
integer x = 763
integer width = 2999
integer height = 268
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

