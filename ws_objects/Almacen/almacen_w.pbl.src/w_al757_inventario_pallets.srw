$PBExportHeader$w_al757_inventario_pallets.srw
forward
global type w_al757_inventario_pallets from w_report_smpl
end type
type cb_1 from commandbutton within w_al757_inventario_pallets
end type
type sle_almacen from singlelineedit within w_al757_inventario_pallets
end type
type sle_descrip from singlelineedit within w_al757_inventario_pallets
end type
type st_1 from statictext within w_al757_inventario_pallets
end type
type dp_fecha from datepicker within w_al757_inventario_pallets
end type
type st_3 from statictext within w_al757_inventario_pallets
end type
type cbx_1 from checkbox within w_al757_inventario_pallets
end type
type cb_ajustar from commandbutton within w_al757_inventario_pallets
end type
end forward

global type w_al757_inventario_pallets from w_report_smpl
integer width = 3877
integer height = 3100
string title = "[AL757] Reprote de Inventarios por pallets y por posicion"
string menuname = "m_impresion"
long backcolor = 79741120
event ue_generar_ajuste ( )
cb_1 cb_1
sle_almacen sle_almacen
sle_descrip sle_descrip
st_1 st_1
dp_fecha dp_fecha
st_3 st_3
cbx_1 cbx_1
cb_ajustar cb_ajustar
end type
global w_al757_inventario_pallets w_al757_inventario_pallets

type variables
n_cst_wait	invo_Wait
end variables

event ue_generar_ajuste();string  	ls_mensaje,ls_sql, ls_almacen
Date		ld_fecha
integer li_ok

try 
	SetPointer (HourGlass!)

	invo_wait = create n_cst_wait
	
	if trim(sle_almacen.text) = '' then
		MessageBox('Error', 'Debe especificar un almacen, por favor corrija!', StopSign!)
		sle_almacen.setFocus()
		return
	end if
	
	ls_almacen 	= sle_almacen.text
	ld_fecha 	= Date(dp_fecha.value)
	
	invo_wait.of_mensaje("Ejecutando procedimiento pkg_almacen.sp_ajuste_inventario_pallets()")

	//pkg_almacen.sp_ajuste_inventario_pallets(asi_almacen => :asi_almacen,
	//													    adi_fecha => :adi_fecha,
	//													    asi_usuario => :asi_usuario);

	
	DECLARE sp_ajuste_inventario_pallets PROCEDURE FOR
		pkg_almacen.sp_ajuste_inventario_pallets( :ls_almacen,
																:ld_fecha,
																:gs_user);
	
	EXECUTE sp_ajuste_inventario_pallets;
	
	IF SQLCA.sqlcode = -1 THEN
		ls_mensaje = "Error al ejecutar PROCEDURE pkg_almacen.sp_ajuste_inventario_pallets():" &
				  + SQLCA.SQLErrText
		Rollback;
		MessageBox('Aviso', ls_mensaje, StopSign!)
		Return
	END IF
	
	commit;
	
	CLOSE sp_ajuste_inventario_pallets;
	
	MessageBox('Aviso', 'Proceso ha sido efectuado satisfactoriamente', Information!)
	
	return

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Error al procesar el evento us_generar_ajuste()")

finally
	
	invo_wait.of_close()
	destroy invo_wait
	
	SetPointer (Arrow!)
end try

end event

on w_al757_inventario_pallets.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_1=create st_1
this.dp_fecha=create dp_fecha
this.st_3=create st_3
this.cbx_1=create cbx_1
this.cb_ajustar=create cb_ajustar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_almacen
this.Control[iCurrent+3]=this.sle_descrip
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.dp_fecha
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.cb_ajustar
end on

on w_al757_inventario_pallets.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_1)
destroy(this.dp_fecha)
destroy(this.st_3)
destroy(this.cbx_1)
destroy(this.cb_ajustar)
end on

event ue_retrieve;call super::ue_retrieve;string	ls_almacen
Date		ld_Fec_conteo

if cbx_1.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		MessageBox('Error', 'Debe ingresar un almacen, por favor verifique!', StopSign!)
		sle_almacen.setFocus()
		return
	end if
	
	ls_almacen = trim(sle_almacen.text) + '%'
end if

ld_fec_conteo = Date(dp_fecha.value)

dw_report.object.datawindow.Print.Orientation = 1

dw_report.Retrieve(ls_almacen, ld_fec_conteo)

if dw_report.RowCount() > 0 then
	cb_ajustar.enabled = true
else
	cb_ajustar.enabled = false
end if

dw_report.Object.p_logo.filename = gs_logo
end event

event ue_open_pre;call super::ue_open_pre;ib_preview = true

event ue_preview()
end event

type dw_report from w_report_smpl`dw_report within w_al757_inventario_pallets
integer x = 0
integer y = 216
integer width = 3195
integer height = 1544
integer taborder = 10
string dataobject = "d_rpt_inventario_pallets_posicion_tbl"
end type

type cb_1 from commandbutton within w_al757_inventario_pallets
integer x = 2181
integer y = 28
integer width = 526
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Visualizar"
end type

event clicked;SetPointer(HourGlass!)
Parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type sle_almacen from singlelineedit within w_al757_inventario_pallets
event dobleclick pbm_lbuttondblclk
integer x = 384
integer y = 20
integer width = 224
integer height = 88
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT distinct a.almacen AS CODIGO_almacen, " &
	  	 + "a.DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen a, " &
		 + "inventario_pallets ic " &
		 + "where ic.almacen = a.almacen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen, por favor verifique!', StopSign!)
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe, por favor verifique!', StopSign!)
	return
end if

sle_descrip.text = ls_desc


end event

type sle_descrip from singlelineedit within w_al757_inventario_pallets
integer x = 613
integer y = 20
integer width = 1554
integer height = 88
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_al757_inventario_pallets
integer x = 27
integer y = 36
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "Almacen: "
alignment alignment = right!
boolean focusrectangle = false
end type

type dp_fecha from datepicker within w_al757_inventario_pallets
integer x = 1719
integer y = 116
integer width = 439
integer height = 88
integer taborder = 90
boolean bringtotop = true
boolean allowedit = true
boolean dropdownright = true
string customformat = "dd/mm/yyyy"
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2021-01-02"), Time("03:50:24.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type st_3 from statictext within w_al757_inventario_pallets
integer x = 1307
integer y = 128
integer width = 379
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Fecha Conteo:"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_al757_inventario_pallets
integer x = 384
integer y = 124
integer width = 759
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
string text = "Todos los Almacenes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type cb_ajustar from commandbutton within w_al757_inventario_pallets
integer x = 2715
integer y = 28
integer width = 526
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean enabled = false
string text = "&Generar Ajuste"
end type

event clicked;SetPointer(HourGlass!)
Parent.event dynamic ue_generar_ajuste()
SetPointer(Arrow!)
end event

