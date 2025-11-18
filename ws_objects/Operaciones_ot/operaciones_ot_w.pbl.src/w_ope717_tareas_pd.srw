$PBExportHeader$w_ope717_tareas_pd.srw
forward
global type w_ope717_tareas_pd from w_rpt_list
end type
type uo_1 from u_ingreso_rango_fechas within w_ope717_tareas_pd
end type
type dw_text from datawindow within w_ope717_tareas_pd
end type
type pb_3 from picturebutton within w_ope717_tareas_pd
end type
type st_campo from statictext within w_ope717_tareas_pd
end type
type gb_1 from groupbox within w_ope717_tareas_pd
end type
end forward

global type w_ope717_tareas_pd from w_rpt_list
integer width = 3305
integer height = 1984
string title = "Costo estimado de tareas (ope717)"
string menuname = "m_rpt_smpl"
uo_1 uo_1
dw_text dw_text
pb_3 pb_3
st_campo st_campo
gb_1 gb_1
end type
global w_ope717_tareas_pd w_ope717_tareas_pd

type variables
String is_col
//Integer		ii_grf_val_index = 4
end variables

on w_ope717_tareas_pd.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.uo_1=create uo_1
this.dw_text=create dw_text
this.pb_3=create pb_3
this.st_campo=create st_campo
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.dw_text
this.Control[iCurrent+3]=this.pb_3
this.Control[iCurrent+4]=this.st_campo
this.Control[iCurrent+5]=this.gb_1
end on

on w_ope717_tareas_pd.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.dw_text)
destroy(this.pb_3)
destroy(this.st_campo)
destroy(this.gb_1)
end on

event ue_retrieve();call super::ue_retrieve;Date ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

DECLARE pb_usp_ope_labores_x_proveedor PROCEDURE FOR usp_ope_labores_x_proveedor
        ( :ld_fec_ini, :ld_fec_fin ) ;
Execute pb_usp_ope_labores_x_proveedor ;

dw_report.retrieve(ld_fec_ini, ld_fec_fin)
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_texto.text = 'Del ' + string(ld_fec_ini,'dd/mm/yyyy') + ' al ' + string(ld_fec_fin,'dd/mm/yyyy')
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_rpt_list`dw_report within w_ope717_tareas_pd
boolean visible = false
integer x = 87
integer y = 436
integer width = 3154
string dataobject = "d_rpt_tareaje_x_proveedor_tbl"
end type

type dw_1 from w_rpt_list`dw_1 within w_ope717_tareas_pd
integer x = 64
integer y = 336
integer width = 1307
integer height = 1476
string dataobject = "d_lista_labor_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;idw_1 = dw_report
idw_1.Visible = False

dw_1.SetTransObject(sqlca)
dw_1.retrieve()
dw_2.SetTransObject(sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2
end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	
	st_campo.text = "Orden: " + is_col
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF
end event

type pb_1 from w_rpt_list`pb_1 within w_ope717_tareas_pd
integer x = 1403
integer y = 724
end type

type pb_2 from w_rpt_list`pb_2 within w_ope717_tareas_pd
integer x = 1403
integer y = 1048
end type

type dw_2 from w_rpt_list`dw_2 within w_ope717_tareas_pd
integer x = 1577
integer y = 336
integer width = 1307
integer height = 1480
string dataobject = "d_lista_labor_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2
end event

type cb_report from w_rpt_list`cb_report within w_ope717_tareas_pd
integer x = 2953
integer y = 92
integer width = 293
string text = "Generar"
end type

event cb_report::clicked;call super::clicked;string  ls_codigo
integer i

idw_1.Visible = True
dw_1.visible = False
dw_2.visible = False
pb_1.visible = False
pb_2.visible = False
gb_1.visible = False
dw_text.visible = false
st_campo.visible = false

delete from tt_cam_labores ;
	
for i = 1 to dw_2.rowcount()
  	 ls_codigo      = dw_2.object.cod_labor[i]
	 
	 insert into tt_cam_labores(cod_labor)
	 values (:ls_codigo) ;
	 
	 if sqlca.sqlcode = -1 then
		 MessageBox("Error al Insertar Registro",sqlca.sqlerrtext)
	end if
next

parent.event ue_preview()
dw_report.SetTransObject(sqlca)
dw_report.visible=true

parent.event ue_retrieve()

end event

type uo_1 from u_ingreso_rango_fechas within w_ope717_tareas_pd
integer x = 82
integer y = 100
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_text from datawindow within w_ope717_tareas_pd
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 73
integer y = 212
integer width = 1285
integer height = 92
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_enter;dw_1.triggerevent(doubleclicked!)
return 1
end event

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if
ll_row = dw_text.Getrow()
end event

event constructor;Long ll_reg
ll_reg = this.insertrow(0)
end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)

end event

type pb_3 from picturebutton within w_ope717_tareas_pd
integer x = 3026
integer y = 252
integer width = 146
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\retroceder.bmp"
end type

event clicked;idw_1.Visible = False
gb_1.visible = true
pb_1.visible = true
pb_2.visible = true
dw_1.visible = true
dw_2.visible = true
dw_text.visible = true
st_campo.visible = true

end event

type st_campo from statictext within w_ope717_tareas_pd
integer x = 1413
integer y = 228
integer width = 1019
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "*"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_ope717_tareas_pd
integer x = 32
integer y = 20
integer width = 2889
integer height = 1812
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seleccione"
end type

