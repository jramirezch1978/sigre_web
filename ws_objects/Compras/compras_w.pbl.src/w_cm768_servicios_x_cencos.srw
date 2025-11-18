$PBExportHeader$w_cm768_servicios_x_cencos.srw
$PBExportComments$Reporte de Servicios por Centro de Costos
forward
global type w_cm768_servicios_x_cencos from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_cm768_servicios_x_cencos
end type
type cb_3 from commandbutton within w_cm768_servicios_x_cencos
end type
type dw_1 from datawindow within w_cm768_servicios_x_cencos
end type
type cb_cencos from commandbutton within w_cm768_servicios_x_cencos
end type
type cb_n1 from commandbutton within w_cm768_servicios_x_cencos
end type
type cb_n2 from commandbutton within w_cm768_servicios_x_cencos
end type
type cb_n3 from commandbutton within w_cm768_servicios_x_cencos
end type
type gb_1 from groupbox within w_cm768_servicios_x_cencos
end type
end forward

global type w_cm768_servicios_x_cencos from w_report_smpl
integer width = 3177
integer height = 1404
string title = "Servicios por Centro de Costos (CM768)"
string menuname = "m_impresion"
uo_1 uo_1
cb_3 cb_3
dw_1 dw_1
cb_cencos cb_cencos
cb_n1 cb_n1
cb_n2 cb_n2
cb_n3 cb_n3
gb_1 gb_1
end type
global w_cm768_servicios_x_cencos w_cm768_servicios_x_cencos

type variables

end variables

on w_cm768_servicios_x_cencos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_1=create uo_1
this.cb_3=create cb_3
this.dw_1=create dw_1
this.cb_cencos=create cb_cencos
this.cb_n1=create cb_n1
this.cb_n2=create cb_n2
this.cb_n3=create cb_n3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.cb_cencos
this.Control[iCurrent+5]=this.cb_n1
this.Control[iCurrent+6]=this.cb_n2
this.Control[iCurrent+7]=this.cb_n3
this.Control[iCurrent+8]=this.gb_1
end on

on w_cm768_servicios_x_cencos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.dw_1)
destroy(this.cb_cencos)
destroy(this.cb_n1)
destroy(this.cb_n2)
destroy(this.cb_n3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_tipo, ls_grupo
Date ld_desde, ld_hasta
Long ll_count

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

ls_tipo = dw_1.object.flag_tipo[1]

//if li_ano = 0 or isnull(li_ano) then
//	messagebox("Aviso", "Debe de ingresar un año valido")
//	dw_1.SetFocus()
	//return
//end if


Choose Case ls_tipo
	Case 'C' //x cencos
		Select count(*) into :ll_count
		from tt_cencos;
		
		If ll_count <= 0 then
			MessageBox('Aviso','Debe seleccionar Cencos')
			Return
		end if		
	Case 'G' //x grupo cencos
		ls_grupo = dw_1.object.grupo[1]
		
		If Isnull(ls_grupo) or Len(trim(ls_grupo))=0 then
			MessageBox('Aviso','Debe seleccionar Grupo de Cencos')
			Return
		end if
		Delete from tt_cencos;
		Insert into tt_cencos(cencos)
		Select gd.cencos
		  from centro_costo_grupo g, centro_costo_grupo_det gd
		 where g.grupo = gd.grupo
		   and g.grupo = :ls_grupo;
	
		If sqlca.sqlcode = -1 then	
			messagebox("Aviso",string(sqlca.sqlcode)+ " " + &
							string(sqlca.sqlerrtext), StopSign!)
			RollBack ;
			Return
		end if
	Case 'N' //x niveles
		Delete from tt_cencos;
		Select count(*) into :ll_count
		from tt_cencos_niv3;
		
		If ll_count > 0 then
			Insert into tt_cencos(cencos)
			Select c.cencos
			  from centros_costo c, tt_cencos_niv3 t
			 where c.cod_n3 = t.cod_n3;			
		else
			Select count(*) into :ll_count
			from tt_cencos_niv2;
			
			If ll_count > 0 then
				Insert into tt_cencos(cencos)
				Select c.cencos
				  from centros_costo c, tt_cencos_niv2 t
				 where c.cod_n2 = t.cod_n2;			
			else
				Select count(*) into :ll_count
				from tt_cencos_niv1;
				If ll_count > 0 then
					Insert into tt_cencos(cencos)
					Select c.cencos
					  from centros_costo c, tt_cencos_niv1 t
					 where c.cod_n1 = t.cod_n1;			
				else
					MessageBox('Aviso','Debe seleccionar Niveles')
					Return
				end if				
			end if
			
		end if
	
		If sqlca.sqlcode = -1 then	
			messagebox("Aviso",string(sqlca.sqlcode)+ " " + &
							string(sqlca.sqlerrtext), StopSign!)
			RollBack ;
			Return
		end if

End choose
//Seleccion del Reporte
//If rb_dol.Checked then
//	dw_report.DataObject = 'd_rpt_ejec_pptal_campos_dol'
//elseif rb_sol.Checked then
//	dw_report.DataObject = 'd_rpt_ejec_pptal_campos_sol'
//elseif rb_dolsol.Checked then
//	dw_report.DataObject = 'd_rpt_ejec_pptal_campos'
//end if

dw_report.SetTransObject(sqlca)
dw_report.Retrieve(ld_desde, ld_hasta)
/*dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.Text = Upper(gs_user)
dw_report.object.t_empresa.Text = gs_empresa
*/
ib_preview = true
this.event ue_preview()

//Date ld_desde, ld_hasta
//
//ld_desde = uo_1.of_get_fecha1()
//ld_hasta = uo_1.of_get_fecha2()
//
//idw_1.Retrieve(ld_desde, ld_hasta)
//
dw_report.object.t_fecha.text 	= 'Del : ' & 
		+ STRING(ld_desde, "DD/MM/YYYY") + ' Al : ' &
		+ STRING(ld_hasta, "DD/MM/YYYY")		
dw_report.object.t_user.text 	  = gs_user
dw_report.Object.p_logo.filename = gs_logo

dw_report.Object.DataWindow.Print.Orientation = 1
end event

event ue_preview();call super::ue_preview;ib_preview = FALSE

end event

event ue_filter;call super::ue_filter;idw_1.GroupCalc()
end event

event ue_sort;call super::ue_sort;idw_1.GroupCalc()
end event

type dw_report from w_report_smpl`dw_report within w_cm768_servicios_x_cencos
integer x = 27
integer y = 504
integer width = 2505
integer height = 704
string dataobject = "d_rpt_servicios_x_cencos"
end type

type uo_1 from u_ingreso_rango_fechas within w_cm768_servicios_x_cencos
integer x = 27
integer y = 28
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_3 from commandbutton within w_cm768_servicios_x_cencos
integer x = 1568
integer y = 152
integer width = 329
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.Event ue_retrieve()
end event

type dw_1 from datawindow within w_cm768_servicios_x_cencos
integer x = 41
integer y = 172
integer width = 1481
integer height = 292
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_ext_cencos"
boolean border = false
boolean livescroll = true
end type

event constructor;SetTransObject(sqlca)
InsertRow(0)
end event

event itemchanged;dw_report.Reset()
choose case GetColumnName()
	case 'flag_tipo'
		If data = 'G' then//x grupo cencos
			cb_cencos.Enabled = false
			cb_n1.Enabled = false
			cb_n2.Enabled = false
			cb_n3.Enabled = false
		elseif data = 'C' then //x cencos
			Delete from tt_cencos;
			cb_cencos.Enabled = true
			cb_n1.Enabled = false
			cb_n2.Enabled = false
			cb_n3.Enabled = false
		elseif data = 'N' then //x Niveles
			cb_cencos.Enabled = false
			cb_n1.Enabled = true
			cb_n2.Enabled = true
			cb_n3.Enabled = true
		end if
end choose
end event

type cb_cencos from commandbutton within w_cm768_servicios_x_cencos
integer x = 576
integer y = 196
integer width = 325
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Selección..."
end type

event clicked;open(w_seleccion_cencos)
end event

type cb_n1 from commandbutton within w_cm768_servicios_x_cencos
integer x = 576
integer y = 372
integer width = 270
integer height = 76
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Nivel 1..."
end type

event clicked;open(w_seleccion_cencos_niv1)
end event

type cb_n2 from commandbutton within w_cm768_servicios_x_cencos
integer x = 846
integer y = 372
integer width = 270
integer height = 76
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Nivel 2..."
end type

event clicked;open(w_seleccion_cencos_niv2)
end event

type cb_n3 from commandbutton within w_cm768_servicios_x_cencos
integer x = 1115
integer y = 372
integer width = 270
integer height = 76
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Nivel 3..."
end type

event clicked;open(w_seleccion_cencos_niv3)
end event

type gb_1 from groupbox within w_cm768_servicios_x_cencos
integer x = 32
integer y = 120
integer width = 1513
integer height = 364
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
end type

