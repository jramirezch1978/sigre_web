$PBExportHeader$w_al506_consignacion.srw
forward
global type w_al506_consignacion from w_report_smpl
end type
type st_1 from statictext within w_al506_consignacion
end type
type cb_1 from commandbutton within w_al506_consignacion
end type
type sle_alm from singlelineedit within w_al506_consignacion
end type
type cb_alm from commandbutton within w_al506_consignacion
end type
type st_desc_alm from statictext within w_al506_consignacion
end type
end forward

global type w_al506_consignacion from w_report_smpl
integer width = 2775
integer height = 1728
string title = "Articulos En Consignacion [AL506]"
string menuname = "m_impresion"
long backcolor = 67108864
st_1 st_1
cb_1 cb_1
sle_alm sle_alm
cb_alm cb_alm
st_desc_alm st_desc_alm
end type
global w_al506_consignacion w_al506_consignacion

type variables

end variables

on w_al506_consignacion.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_alm=create sle_alm
this.cb_alm=create cb_alm
this.st_desc_alm=create st_desc_alm
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_alm
this.Control[iCurrent+4]=this.cb_alm
this.Control[iCurrent+5]=this.st_desc_alm
end on

on w_al506_consignacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_alm)
destroy(this.cb_alm)
destroy(this.st_desc_alm)
end on

event ue_retrieve;call super::ue_retrieve;String ls_almacen, ls_cod_alm, ls_mensaje

// Tengo que actualizar la cantidad liquidada de los ingresos con todas las salidas
// Que se le hicieron con respecto a ese ingreso
update articulo_consignacion a
  set a.cantidad_liquidada = (select NVL(sum(ac.cantidad),0)
										 from articulo_consignacion   ac,
												art_consignacion_enlace ace
										where ace.nro_mov_sal = ac.nro_mov
										  and ac.flag_estado = '1'  
										  and ace.nro_mov_ing = a.nro_mov)
where a.tipo_mov in (select tipo_mov from articulo_mov_tipo amt
							 where amt.factor_sldo_consig = 1) 
  and a.flag_estado = '1';

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
end if

COMMIT;

ls_cod_alm = sle_alm.text

idw_1.Object.Datawindow.Print.Orientation = 1
idw_1.Retrieve(ls_cod_alm)
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text = gs_user
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_objeto.text = 'AL506'
idw_1.object.t_titulo.text   = 'Almacen: ' + st_desc_alm.text

end event

type dw_report from w_report_smpl`dw_report within w_al506_consignacion
integer x = 0
integer y = 120
integer width = 2693
integer height = 1376
string dataobject = "d_cns_articulo_consignacion"
end type

type st_1 from statictext within w_al506_consignacion
integer x = 50
integer y = 28
integer width = 343
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Almacen:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_al506_consignacion
integer x = 2030
integer y = 24
integer width = 338
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;Parent.Event ue_retrieve()
end event

type sle_alm from singlelineedit within w_al506_consignacion
integer x = 393
integer y = 24
integer width = 325
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event losefocus;// Verifica que el almacen exista
String ls_alm
Long ll_count

ls_alm = sle_alm.text

if TRIM( ls_alm ) <> '' then
	Select count(*) into :ll_count from almacen where almacen = :ls_alm;
	if ll_count = 0 then
		Messagebox( "Error", "Codigo de almacen no existe")
		sle_alm.text = ''
		sle_alm.SetFocus()
		return 
	end if
end if
end event

event modified;//// Verifica que el almacen exista
//String ls_alm
//Long ll_count
//
//ls_alm = sle_alm.text
//
//Select count(*) into :ll_count from almacen where almacen = :ls_alm;
//if ll_count = 0 then
//	Messagebox( "Error", "Codigo de almacen no existe")
//	return
//end if
end event

type cb_alm from commandbutton within w_al506_consignacion
integer x = 727
integer y = 24
integer width = 87
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string ls_sql, ls_almacen, ls_data
boolean lb_ret

ls_sql = "SELECT ALMACEN AS CODIGO_ALMACEN, " &
		  + "DESC_ALMACEN AS DESCRIPCION_ALMACEN " &
		  + "FROM ALMACEN " 
			 
lb_ret = f_lista(ls_sql, ls_almacen, &
			ls_data, '1')
	
if ls_almacen <> '' then
	sle_alm.text		= ls_almacen
	st_desc_alm.text 	= ls_data
end if

end event

type st_desc_alm from statictext within w_al506_consignacion
integer x = 823
integer y = 24
integer width = 1161
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
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

