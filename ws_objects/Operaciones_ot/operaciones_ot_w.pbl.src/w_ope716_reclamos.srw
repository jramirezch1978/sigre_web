$PBExportHeader$w_ope716_reclamos.srw
forward
global type w_ope716_reclamos from w_rpt
end type
type cbx_2 from checkbox within w_ope716_reclamos
end type
type cbx_1 from checkbox within w_ope716_reclamos
end type
type cb_1 from commandbutton within w_ope716_reclamos
end type
type dw_1 from datawindow within w_ope716_reclamos
end type
type dw_report from u_dw_rpt within w_ope716_reclamos
end type
end forward

global type w_ope716_reclamos from w_rpt
integer width = 3003
integer height = 1652
string title = "Reporte de Reclamos ( OPE716)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
cbx_2 cbx_2
cbx_1 cbx_1
cb_1 cb_1
dw_1 dw_1
dw_report dw_report
end type
global w_ope716_reclamos w_ope716_reclamos

on w_ope716_reclamos.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.cb_1=create cb_1
this.dw_1=create dw_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_2
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.dw_report
end on

on w_ope716_reclamos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

ib_preview = FALSE
THIS.Event ue_preview()


end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

type cbx_2 from checkbox within w_ope716_reclamos
integer x = 2062
integer y = 124
integer width = 736
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los Centros de Costo"
end type

type cbx_1 from checkbox within w_ope716_reclamos
integer x = 2062
integer y = 40
integer width = 736
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Todos Los Clientes"
end type

type cb_1 from commandbutton within w_ope716_reclamos
integer x = 2514
integer y = 300
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_fecha_inicio,ls_fecha_final,ls_cliente,ls_cencos

dw_1.Accepttext()

ls_fecha_inicio = String(dw_1.object.fecha_ini [1],'yyyymmdd')
ls_fecha_final  = String(dw_1.object.fecha_fin [1],'yyyymmdd')
ls_cliente		 = dw_1.object.cliente [1]
ls_cencos		 = dw_1.object.cencos  [1]	


IF cbx_1.Checked THEN
	ls_cliente = '%'
ELSE
	IF Isnull(ls_cliente) OR Trim(ls_cliente) = '' THEN
		Messagebox('Aviso','Debe Ingresar Un Cliente ,Verifique!')
		Return
	ELSE
		ls_cliente = ls_cliente+'%'
	END IF
END IF

IF cbx_2.Checked THEN
	ls_cencos = '%'
ELSE	
	IF Isnull(ls_cencos) OR Trim(ls_cencos) = '' THEN
		Messagebox('Aviso','Debe Ingresar Un Centro de Costo ,Verifique!')
		Return
	ELSE
		ls_cencos = ls_cencos+'%'
	END IF
END IF




dw_report.Retrieve(ls_fecha_inicio,ls_fecha_final,ls_cencos,ls_cliente)
end event

type dw_1 from datawindow within w_ope716_reclamos
integer x = 37
integer y = 36
integer width = 1934
integer height = 364
integer taborder = 10
string title = "none"
string dataobject = "d_ext_rpt_reclamos_tbl"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Long   ll_count
String ls_desc

Accepttext()
choose case dwo.name
		 case 'cencos'
				select count(*) into :ll_count from centros_costo where (cencos = :data );
				
				if ll_count > 0 then
					select desc_cencos into :ls_desc from centros_costo where (cencos = :data);
					
					This.object.desc_cencos [row] = ls_desc
				else
					SetNull(ls_desc)
					This.object.cencos 		[row] = ls_desc
					This.object.desc_cencos [row] = ls_desc
				end if
				
		 case 'cliente'	
				select count(*) into :ll_count from proveedor where (proveedor = :data );
				
				if ll_count > 0 then
					select nom_proveedor into :ls_desc from proveedor where (proveedor = :data);
					
					This.object.desc_cliente [row] = ls_desc
					
				else
					SetNull(ls_desc)
					This.object.cliente 		 [row] = ls_desc
					This.object.desc_cliente [row] = ls_desc
				end if
				
end choose

end event

event constructor;InsertRow(0)
end event

event itemerror;Return 1
end event

event doubleclicked;Datawindow ldw
str_seleccionar lstr_seleccionar


CHOOSE CASE dwo.name
		 CASE 'fecha_ini','fecha_fin'
			   ldw = this
			   f_call_calendar(ldw,dwo.name,dwo.coltype,row)
		 CASE 'cencos'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT VW_OPE_CENCOS_CAL_RECLAMO.CENCOS AS CENCOS,'&
		      										 +'VW_OPE_CENCOS_CAL_RECLAMO.DESC_CENCOS AS DESCRIPCION '&     	
					 		   						 +'FROM VW_OPE_CENCOS_CAL_RECLAMO ' 
				/*lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS 	  AS CENCOS,'&
		      										 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&     	
					 		   						 +'FROM CENTROS_COSTO ' */
														  
				OpenWithParm(w_seleccionar,lstr_seleccionar)	
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
				IF lstr_seleccionar.s_action = "aceptar" THEN
						Setitem(row,'cencos',lstr_seleccionar.param1[1])
						Setitem(row,'desc_cencos',lstr_seleccionar.param2[1])
				END IF
			
			
		 CASE 'cliente'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT VW_OPE_CLIENTE_CAL_RECLAMO.PROVEEDOR AS CODIGO,'&
		      										 +'VW_OPE_CLIENTE_CAL_RECLAMO.NOM_PROVEEDOR AS NOMBRE '&     	
					 		   						 +'FROM VW_OPE_CLIENTE_CAL_RECLAMO ' 
				
			/*	lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO,'&
												 		 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE,'&
														 +'PROVEEDOR.TIPO_PROVEEDOR AS TIPO '&
														 +'FROM PROVEEDOR '*/

				OpenWithParm(w_seleccionar,lstr_seleccionar)	
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cliente',lstr_seleccionar.param1[1])
					Setitem(row,'desc_cliente',lstr_seleccionar.param2[1])
				END IF

END CHOOSE			


end event

type dw_report from u_dw_rpt within w_ope716_reclamos
integer x = 18
integer y = 428
integer width = 2907
integer height = 1076
string dataobject = "d_rpt_reclamos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

