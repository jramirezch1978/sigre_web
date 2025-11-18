$PBExportHeader$w_pt770_proy_prsp_produccion.srw
forward
global type w_pt770_proy_prsp_produccion from w_report_smpl
end type
type st_6 from statictext within w_pt770_proy_prsp_produccion
end type
type em_ano from editmask within w_pt770_proy_prsp_produccion
end type
type cb_leer from commandbutton within w_pt770_proy_prsp_produccion
end type
type rb_material from radiobutton within w_pt770_proy_prsp_produccion
end type
type rb_servicios from radiobutton within w_pt770_proy_prsp_produccion
end type
type rb_1 from radiobutton within w_pt770_proy_prsp_produccion
end type
type rb_2 from radiobutton within w_pt770_proy_prsp_produccion
end type
type rb_todos from radiobutton within w_pt770_proy_prsp_produccion
end type
type rb_monto from radiobutton within w_pt770_proy_prsp_produccion
end type
type rb_cantidad from radiobutton within w_pt770_proy_prsp_produccion
end type
type gb_1 from groupbox within w_pt770_proy_prsp_produccion
end type
type gb_2 from groupbox within w_pt770_proy_prsp_produccion
end type
type gb_3 from groupbox within w_pt770_proy_prsp_produccion
end type
end forward

global type w_pt770_proy_prsp_produccion from w_report_smpl
integer width = 2953
integer height = 3004
string title = "Reporte Proyectado Prsp Produccion (PT770)"
string menuname = "m_impresion"
long backcolor = 67108864
st_6 st_6
em_ano em_ano
cb_leer cb_leer
rb_material rb_material
rb_servicios rb_servicios
rb_1 rb_1
rb_2 rb_2
rb_todos rb_todos
rb_monto rb_monto
rb_cantidad rb_cantidad
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_pt770_proy_prsp_produccion w_pt770_proy_prsp_produccion

on w_pt770_proy_prsp_produccion.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_6=create st_6
this.em_ano=create em_ano
this.cb_leer=create cb_leer
this.rb_material=create rb_material
this.rb_servicios=create rb_servicios
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_todos=create rb_todos
this.rb_monto=create rb_monto
this.rb_cantidad=create rb_cantidad
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_6
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.cb_leer
this.Control[iCurrent+4]=this.rb_material
this.Control[iCurrent+5]=this.rb_servicios
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.rb_todos
this.Control[iCurrent+9]=this.rb_monto
this.Control[iCurrent+10]=this.rb_cantidad
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_3
end on

on w_pt770_proy_prsp_produccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_6)
destroy(this.em_ano)
destroy(this.cb_leer)
destroy(this.rb_material)
destroy(this.rb_servicios)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_todos)
destroy(this.rb_monto)
destroy(this.rb_cantidad)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;Integer 	li_year
String  	ls_mensaje, ls_cant_monto, ls_mat_serv

li_year = Integer(em_ano.text)

if li_year = 0 or IsNull(li_year) then
	MessageBox('Error', 'Debe Ingresar un año valido')
	return
end if

if rb_monto.checked then
	ls_cant_monto = 'm'
elseif rb_cantidad.checked then
	ls_cant_monto = 'c'
end if

if rb_material.checked then
	ls_mat_serv = '1'
elseif rb_servicios.checked then
	ls_mat_serv = '2'
elseif rb_todos.checked then
	ls_mat_serv = '3'
end if	
	

//create or replace procedure USP_PTO_RPT_PRSP_PROD(
//       ani_year         in number,
//       asi_cant_monto   in string,
//       asi_mat_serv     in out string        
//) is

DECLARE USP_PTO_RPT_PRSP_PROD PROCEDURE FOR 
	USP_PTO_RPT_PRSP_PROD (:li_year,
								  :ls_cant_monto,
								  :ls_mat_serv ); 
								  
EXECUTE USP_PTO_RPT_PRSP_PROD;

if sqlca.sqlcode = -1 then   // Fallo
	ls_mensaje = SQLCA.SQLErrText
	rollback ;
	Messagebox( "Error USP_PTO_RPT_PRSP_PROD", ls_mensaje, stopsign!)
	return
end if

CLOSE USP_PTO_RPT_PRSP_PROD;

idw_1.REtrieve( )
idw_1.Object.p_logo.filename 	= gs_logo
idw_1.Object.t_empresa.text 	= gs_empresa
idw_1.Object.t_objeto.text 	= this.classname( )
idw_1.Object.t_usuario.text 	= gs_user

end event

event ue_open_pre;call super::ue_open_pre;dw_report.Object.Datawindow.Print.Orientation = 1    // 0=default,1=Landscape, 2=Portrait
end event

type dw_report from w_report_smpl`dw_report within w_pt770_proy_prsp_produccion
integer x = 0
integer y = 156
integer width = 2528
integer height = 1380
string dataobject = "d_rpt_proy_prsp_prod_tbl"
end type

type st_6 from statictext within w_pt770_proy_prsp_produccion
integer y = 44
integer width = 160
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type em_ano from editmask within w_pt770_proy_prsp_produccion
integer x = 151
integer y = 28
integer width = 261
integer height = 96
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type cb_leer from commandbutton within w_pt770_proy_prsp_produccion
integer x = 2565
integer y = 20
integer width = 302
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;Parent.event ue_retrieve( )
end event

type rb_material from radiobutton within w_pt770_proy_prsp_produccion
integer x = 1001
integer y = 52
integer width = 270
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Material"
end type

type rb_servicios from radiobutton within w_pt770_proy_prsp_produccion
integer x = 1266
integer y = 52
integer width = 311
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Servicios"
end type

type rb_1 from radiobutton within w_pt770_proy_prsp_produccion
integer x = 1893
integer y = 52
integer width = 224
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos"
end type

event clicked;// Inserta todos los registros en tabla temporal
Integer 	li_year

li_year = Integer(em_ano.text)

if li_year = 0 or IsNull(li_year) then
	MessageBox('Error', 'Debe Ingresar un año valido')
	return
end if

Delete from TT_PTO_SEL_PROY_PRSP;

insert into TT_PTO_SEL_PROY_PRSP (ano, cencos, cod_art) 
	SELECT ano, cencos, cod_art
	FROM presup_produccion_und p
	WHERE p.ANO =  :li_year;

commit;
end event

type rb_2 from radiobutton within w_pt770_proy_prsp_produccion
integer x = 2121
integer y = 52
integer width = 334
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Selecciona"
end type

event clicked;Integer 	li_year

li_year = Integer(em_ano.text)

if li_year = 0 or IsNull(li_year) then
	MessageBox('Error', 'Debe Ingresar un año valido')
	return
end if

str_parametros sl_param

// Asigna valores a structura 
sl_param.dw1 = "d_list_presup_prod_tbl"	
sl_param.tipo = '1L'	
sl_param.long1 = li_year
sl_param.titulo = "Proyecciones de Produccion"
sl_param.opcion = 11

OpenWithParm( w_rpt_listas, sl_param)
end event

type rb_todos from radiobutton within w_pt770_proy_prsp_produccion
integer x = 1600
integer y = 52
integer width = 238
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

type rb_monto from radiobutton within w_pt770_proy_prsp_produccion
integer x = 466
integer y = 52
integer width = 197
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "US$"
boolean checked = true
end type

event clicked;if this.checked = true then
	rb_servicios.enabled = true
	rb_todos.enabled		= true
	//rb_material.checked	= true
end if
end event

type rb_cantidad from radiobutton within w_pt770_proy_prsp_produccion
integer x = 654
integer y = 52
integer width = 283
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Cantidad"
end type

event clicked;if this.checked = true then
	rb_servicios.enabled = false
	rb_todos.enabled		= false
	rb_material.checked	= true
end if
end event

type gb_1 from groupbox within w_pt770_proy_prsp_produccion
integer x = 1865
integer y = 12
integer width = 613
integer height = 112
integer taborder = 10
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Proy Producción"
end type

type gb_2 from groupbox within w_pt770_proy_prsp_produccion
integer x = 965
integer y = 12
integer width = 882
integer height = 112
integer taborder = 10
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Material / Servicios"
end type

type gb_3 from groupbox within w_pt770_proy_prsp_produccion
integer x = 430
integer y = 12
integer width = 517
integer height = 112
integer taborder = 10
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "US$ / Cantidad"
end type

