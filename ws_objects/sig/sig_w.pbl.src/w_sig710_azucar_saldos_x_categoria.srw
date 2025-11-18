$PBExportHeader$w_sig710_azucar_saldos_x_categoria.srw
forward
global type w_sig710_azucar_saldos_x_categoria from w_report_smpl
end type
type rb_prod_term from radiobutton within w_sig710_azucar_saldos_x_categoria
end type
type rb_sub_prod from radiobutton within w_sig710_azucar_saldos_x_categoria
end type
type cb_lectura from commandbutton within w_sig710_azucar_saldos_x_categoria
end type
type gb_1 from groupbox within w_sig710_azucar_saldos_x_categoria
end type
end forward

global type w_sig710_azucar_saldos_x_categoria from w_report_smpl
integer width = 2638
integer height = 1328
string title = "Saldos de Prod Terminado (SIG710)"
string menuname = "m_rpt_simple"
rb_prod_term rb_prod_term
rb_sub_prod rb_sub_prod
cb_lectura cb_lectura
gb_1 gb_1
end type
global w_sig710_azucar_saldos_x_categoria w_sig710_azucar_saldos_x_categoria

type variables
String	is_clase_prod_term, is_clase_sub_prod
end variables

forward prototypes
public function integer of_get_parametros (ref string as_clase_prod_term, ref string as_clase_sub_prod)
end prototypes

public function integer of_get_parametros (ref string as_clase_prod_term, ref string as_clase_sub_prod);Long		ll_rc = 0
String	ls_clase


SELECT CLASE_PROD_TERM, CLASE_SUB_PROD
  INTO :as_clase_prod_term, :as_clase_sub_prod
  FROM SIGPARAM
 WHERE RECKEY = '1' ;
	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer parametros del SIG')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_sig710_azucar_saldos_x_categoria.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.rb_prod_term=create rb_prod_term
this.rb_sub_prod=create rb_sub_prod
this.cb_lectura=create cb_lectura
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_prod_term
this.Control[iCurrent+2]=this.rb_sub_prod
this.Control[iCurrent+3]=this.cb_lectura
this.Control[iCurrent+4]=this.gb_1
end on

on w_sig710_azucar_saldos_x_categoria.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_prod_term)
destroy(this.rb_sub_prod)
destroy(this.cb_lectura)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;Long	ll_rc

//This.Event ue_retrieve()

ll_rc = of_get_parametros(is_clase_prod_term, is_clase_sub_prod)
end event

event ue_retrieve;call super::ue_retrieve;String	ls_clase, ls_titulo
Long		ll_rc


IF rb_prod_term.checked THEN
	ls_clase = is_clase_prod_term
	ls_titulo = 'SALDOS DE PRODUCTOS TERMINADOS'
ELSE
	ls_clase = is_clase_sub_prod
	ls_titulo = 'SALDOS DE SUB PRODUCTOS'
END IF

idw_1.Retrieve(ls_clase)
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_titulo.text = ls_titulo
idw_1.object.t_texto.text = 'Al ' + string(today(),'dd/mm/yyyy hh:mm:ss')


end event

type dw_report from w_report_smpl`dw_report within w_sig710_azucar_saldos_x_categoria
integer x = 27
integer y = 204
integer width = 2569
integer height = 932
string dataobject = "d_rpt_saldo_articulo_x_clase_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "sldo_total" 
		lstr_1.DataObject = 'd_articulo_saldos_almacen_tbl'
		lstr_1.Width = 2500
		lstr_1.Height= 1300
		lstr_1.Arg[1] = GetItemString(row,'cod_art')
		lstr_1.Title = 'Saldos por Almacen'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
	CASE "sldo_disponible" 
		lstr_1.DataObject = 'd_articulo_saldo_disp_almacen_tbl'
		lstr_1.Width = 2500
		lstr_1.Height= 1300
		lstr_1.Arg[1] = GetItemString(row,'cod_art')
		lstr_1.Title = 'Saldo Disponible por Almacen'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)			
	CASE "sldo_por_llegar"
		lstr_1.DataObject = 'd_articulo_mov_proy_ov_pendiente'
		lstr_1.Width = 3220
		lstr_1.Height= 1300
		lstr_1.Arg[1] = GetItemString(row,'cod_art')
		lstr_1.Title = 'Solicitudes Pendientes'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
	CASE "sldo_solicitado"
		lstr_1.DataObject = 'd_articulo_mov_proy_ov_pendiente'
		lstr_1.Width = 3220
		lstr_1.Height= 1300
		lstr_1.Arg[1] = GetItemString(row,'cod_art')
		lstr_1.Title = 'Solicitudes Pendientes'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)		
END CHOOSE

end event

type rb_prod_term from radiobutton within w_sig710_azucar_saldos_x_categoria
integer x = 69
integer y = 100
integer width = 613
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
string text = "Porducto Terminado"
end type

type rb_sub_prod from radiobutton within w_sig710_azucar_saldos_x_categoria
integer x = 654
integer y = 100
integer width = 402
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
string text = "Sub Producto"
end type

type cb_lectura from commandbutton within w_sig710_azucar_saldos_x_categoria
integer x = 1266
integer y = 60
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;Parent.Event ue_retrieve()
end event

type gb_1 from groupbox within w_sig710_azucar_saldos_x_categoria
integer x = 27
integer y = 24
integer width = 1152
integer height = 168
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Seleccione"
end type

