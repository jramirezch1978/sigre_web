$PBExportHeader$w_ope762_top_ten_old.srw
forward
global type w_ope762_top_ten_old from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_ope762_top_ten_old
end type
type cb_1 from commandbutton within w_ope762_top_ten_old
end type
type st_1 from statictext within w_ope762_top_ten_old
end type
type sle_producto from singlelineedit within w_ope762_top_ten_old
end type
type pb_1 from picturebutton within w_ope762_top_ten_old
end type
type st_nombre from statictext within w_ope762_top_ten_old
end type
type gb_1 from groupbox within w_ope762_top_ten_old
end type
end forward

global type w_ope762_top_ten_old from w_report_smpl
integer width = 3392
integer height = 1616
string title = "(OPE762) Ranking de Producion"
string menuname = "m_rpt_smpl"
long backcolor = 10789024
uo_1 uo_1
cb_1 cb_1
st_1 st_1
sle_producto sle_producto
pb_1 pb_1
st_nombre st_nombre
gb_1 gb_1
end type
global w_ope762_top_ten_old w_ope762_top_ten_old

on w_ope762_top_ten_old.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.uo_1=create uo_1
this.cb_1=create cb_1
this.st_1=create st_1
this.sle_producto=create sle_producto
this.pb_1=create pb_1
this.st_nombre=create st_nombre
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_producto
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.st_nombre
this.Control[iCurrent+7]=this.gb_1
end on

on w_ope762_top_ten_old.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.sle_producto)
destroy(this.pb_1)
destroy(this.st_nombre)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Visible = True

ib_preview = true
THIS.Event ue_preview()

end event

event ue_preview;call super::ue_preview;idw_1.Modify("datawindow.print.preview.zoom = " + String(100))
end event

type dw_report from w_report_smpl`dw_report within w_ope762_top_ten_old
integer x = 0
integer y = 352
integer width = 3346
integer height = 1056
string dataobject = "d_abc_grafico_part_x_destajo_grf"
end type

type uo_1 from u_ingreso_rango_fechas within w_ope762_top_ten_old
integer x = 137
integer y = 120
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(),today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_1 from commandbutton within w_ope762_top_ten_old
integer x = 2688
integer y = 72
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

event clicked;Date   ld_fecha_inicio,ld_fecha_final
String ls_cod_prod,ls_titulo,ls_nombre

ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()
ls_cod_prod		 = sle_producto.text
ls_nombre		 = st_nombre.text

if isnull(ls_cod_prod) or trim(ls_cod_prod) = '' then
	Messagebox('Aviso','Debe Ingresar Un Codigo de Producto ,Verifique!')
	RETURN
end if	

//ejecuta procedimeinto de asigancion de labores
DECLARE PB_USP_OPE_RANKING_DESTAJO PROCEDURE FOR USP_OPE_RANKING_DESTAJO
(:ld_fecha_inicio,:ld_fecha_final,:ls_cod_prod);
EXECUTE pb_USP_OPE_RANKING_DESTAJO ;
	
IF SQLCA.SQLCode = -1 THEN 
   MessageBox("SQL error", SQLCA.SQLErrText)

END IF

ls_titulo = 'Ranking de Producion de '+ls_nombre

dw_report.retrieve(ls_titulo)


//dw_report.object.p_logo.filename = gs_logo

end event

type st_1 from statictext within w_ope762_top_ten_old
integer x = 82
integer y = 240
integer width = 343
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
string text = "Producto :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_producto from singlelineedit within w_ope762_top_ten_old
integer x = 421
integer y = 232
integer width = 384
integer height = 84
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_ope762_top_ten_old
integer x = 823
integer y = 232
integer width = 91
integer height = 80
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "..."
boolean originalsize = true
string picturename = "C:\Source\BMP\file_open.bmp"
alignment htextalign = left!
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
	sle_producto.text = lstr_seleccionar.param1[1]
	st_nombre.text		= lstr_seleccionar.param2[1]
ELSE
	sle_producto.text = ''
	st_nombre.text		  = ''
END IF

end event

type st_nombre from statictext within w_ope762_top_ten_old
integer x = 951
integer y = 232
integer width = 1280
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 134217752
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_ope762_top_ten_old
integer x = 55
integer y = 16
integer width = 2231
integer height = 336
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

