$PBExportHeader$w_ope763_productividad_x_actividad.srw
forward
global type w_ope763_productividad_x_actividad from w_report_smpl
end type
type cb_1 from commandbutton within w_ope763_productividad_x_actividad
end type
type uo_1 from u_ingreso_fecha within w_ope763_productividad_x_actividad
end type
type cb_2 from commandbutton within w_ope763_productividad_x_actividad
end type
type st_1 from statictext within w_ope763_productividad_x_actividad
end type
type sle_producto from singlelineedit within w_ope763_productividad_x_actividad
end type
type sle_desc_producto from singlelineedit within w_ope763_productividad_x_actividad
end type
type cbx_1 from checkbox within w_ope763_productividad_x_actividad
end type
type gb_1 from groupbox within w_ope763_productividad_x_actividad
end type
end forward

global type w_ope763_productividad_x_actividad from w_report_smpl
integer width = 3214
integer height = 1948
string title = "(OPE763) Productividad por Actividad"
string menuname = "m_rpt_smpl"
long backcolor = 10789024
cb_1 cb_1
uo_1 uo_1
cb_2 cb_2
st_1 st_1
sle_producto sle_producto
sle_desc_producto sle_desc_producto
cbx_1 cbx_1
gb_1 gb_1
end type
global w_ope763_productividad_x_actividad w_ope763_productividad_x_actividad

on w_ope763_productividad_x_actividad.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_1=create cb_1
this.uo_1=create uo_1
this.cb_2=create cb_2
this.st_1=create st_1
this.sle_producto=create sle_producto
this.sle_desc_producto=create sle_desc_producto
this.cbx_1=create cbx_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_producto
this.Control[iCurrent+6]=this.sle_desc_producto
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.gb_1
end on

on w_ope763_productividad_x_actividad.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.sle_producto)
destroy(this.sle_desc_producto)
destroy(this.cbx_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Visible = True

ib_preview = false
THIS.Event ue_preview()

end event

event ue_preview;call super::ue_preview;idw_1.Modify("datawindow.print.preview.zoom = " + String(100))
end event

type dw_report from w_report_smpl`dw_report within w_ope763_productividad_x_actividad
integer x = 27
integer y = 456
integer width = 3109
integer height = 1284
string dataobject = "d_rpt_productividad_x_pers_dest_tbl"
end type

type cb_1 from commandbutton within w_ope763_productividad_x_actividad
integer x = 2770
integer y = 24
integer width = 384
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Date   ld_fecha
String ls_prod


ld_fecha  = uo_1.of_get_fecha()
ls_prod	 = sle_producto.text

if cbx_1.checked then
	ls_prod = '%'
	sle_producto.text = ''
	sle_desc_producto.text = ''
else
	if isnull(ls_prod) or trim(ls_prod) = '' then
		Messagebox('Aviso','Debe Colocar Algun Producto a Visualizar')
		Return

	end if
end if	



//ejecuta procedimeinto de asigancion de labores
DECLARE PB_usp_ope_destajo_efectividad PROCEDURE FOR usp_ope_destajo_efectividad
(:ld_fecha);
EXECUTE pb_usp_ope_destajo_efectividad ;
	
IF SQLCA.SQLCode = -1 THEN 
   MessageBox("SQL error", SQLCA.SQLErrText)

END IF

dw_report.retrieve(ld_fecha,ls_prod)


dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_user.text = gs_user
dw_report.object.t_empresa.text = gs_empresa

end event

type uo_1 from u_ingreso_fecha within w_ope763_productividad_x_actividad
event destroy ( )
integer x = 55
integer y = 144
integer taborder = 60
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:') // para seatear el titulo del boton
 of_set_fecha(today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final

end event

type cb_2 from commandbutton within w_ope763_productividad_x_actividad
integer x = 987
integer y = 232
integer width = 110
integer height = 96
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;Str_seleccionar lstr_seleccionar
Datawindow		 ldw	
				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT PRODUCTO_PESAJE.CODPRD AS CODIGO,'&
		      				 +'PRODUCTO_PESAJE.DESCRIPCION AS DESCRIPCION '&
			   				 +'FROM PRODUCTO_PESAJE '&


				
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_producto.text      = lstr_seleccionar.param1[1]
	sle_desc_producto.text = lstr_seleccionar.param2[1]
ELSE
	sle_producto.text      = ''
	sle_desc_producto.text = ''
END IF

end event

type st_1 from statictext within w_ope763_productividad_x_actividad
integer x = 82
integer y = 264
integer width = 343
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
string text = "Producto :"
boolean focusrectangle = false
end type

type sle_producto from singlelineedit within w_ope763_productividad_x_actividad
integer x = 357
integer y = 240
integer width = 603
integer height = 96
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type sle_desc_producto from singlelineedit within w_ope763_productividad_x_actividad
integer x = 1125
integer y = 240
integer width = 1289
integer height = 96
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 65535
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_ope763_productividad_x_actividad
integer x = 1152
integer y = 120
integer width = 741
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
string text = "Todos Los Productos"
end type

type gb_1 from groupbox within w_ope763_productividad_x_actividad
integer x = 27
integer y = 24
integer width = 2441
integer height = 360
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Datos"
end type

