$PBExportHeader$w_pr710_parte_piso.srw
forward
global type w_pr710_parte_piso from w_report_smpl
end type
type uo_rango from u_ingreso_rango_fechas within w_pr710_parte_piso
end type
type st_1 from statictext within w_pr710_parte_piso
end type
type cbx_harina from checkbox within w_pr710_parte_piso
end type
type cbx_conservas from checkbox within w_pr710_parte_piso
end type
type cbx_congelados from checkbox within w_pr710_parte_piso
end type
type gb_1 from groupbox within w_pr710_parte_piso
end type
type rb_todos from radiobutton within w_pr710_parte_piso
end type
type rb_activos from radiobutton within w_pr710_parte_piso
end type
type rb_anulados from radiobutton within w_pr710_parte_piso
end type
type em_nro_parte from singlelineedit within w_pr710_parte_piso
end type
type sle_desc_formato from singlelineedit within w_pr710_parte_piso
end type
type gb_2 from groupbox within w_pr710_parte_piso
end type
end forward

global type w_pr710_parte_piso from w_report_smpl
integer width = 4361
integer height = 2800
string title = "Parte de Piso(PR710) "
string menuname = "m_reporte"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_query_retrieve ( )
event ue_retrieve_list ( )
uo_rango uo_rango
st_1 st_1
cbx_harina cbx_harina
cbx_conservas cbx_conservas
cbx_congelados cbx_congelados
gb_1 gb_1
rb_todos rb_todos
rb_activos rb_activos
rb_anulados rb_anulados
em_nro_parte em_nro_parte
sle_desc_formato sle_desc_formato
gb_2 gb_2
end type
global w_pr710_parte_piso w_pr710_parte_piso

type variables

end variables

event ue_query_retrieve();this.event ue_retrieve()
end event

event ue_retrieve_list();long ll_cuenta
string ls_fecha_ini, ls_fecha_fin, ls_tipo, ls_estado, ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_mensaje

ls_fecha_ini = trim(string(uo_rango.of_get_fecha1(), 'dd/mm/yyyy'))
ls_fecha_fin = trim(string(uo_rango.of_get_fecha2(), 'dd/mm/yyyy'))

if rb_todos.checked = true then
	ls_estado = '2'
end if
if rb_activos.checked = true then
	ls_estado = '1'
end if
if rb_anulados.checked = true then
	ls_estado = '0'
end if
ls_tipo = ''
if cbx_harina.checked = true then
	ls_tipo = ls_tipo + 'PH'
end if
if cbx_conservas.checked = true then
	ls_tipo = ls_tipo + 'PC'
end if
if cbx_congelados.checked = true then
	ls_tipo = ls_tipo + 'PG'
end if

declare usp_parte_cons procedure for
	usp_pr_parte_piso_consulta(:ls_fecha_ini, :ls_fecha_fin, :ls_estado, :ls_tipo);

execute usp_parte_cons;
fetch usp_parte_cons into :ls_mensaje, :ll_cuenta;
close usp_parte_cons;

if ll_cuenta <= 0 then
	if Sqlca.sqlcode = -1 then
		messagebox(this.title, "Error al cargar usp_pr_parte_piso_consulta")
		return
	else
		messagebox(this.title, ls_mensaje)
		return
	end if
end if
ls_sql = "select nro_parte as numero, desc_parte as descripcion, fecha_parte as fecha, tipo_parte as linea from tt_pr_parte_piso_consulta"
f_lista_4ret(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, '1')
if isnull(ls_return1) or trim(ls_return1) = '' then
	return
else
	em_nro_parte.text = ls_return1
	this.event ue_retrieve()
end if
end event

on w_pr710_parte_piso.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_rango=create uo_rango
this.st_1=create st_1
this.cbx_harina=create cbx_harina
this.cbx_conservas=create cbx_conservas
this.cbx_congelados=create cbx_congelados
this.gb_1=create gb_1
this.rb_todos=create rb_todos
this.rb_activos=create rb_activos
this.rb_anulados=create rb_anulados
this.em_nro_parte=create em_nro_parte
this.sle_desc_formato=create sle_desc_formato
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_rango
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cbx_harina
this.Control[iCurrent+4]=this.cbx_conservas
this.Control[iCurrent+5]=this.cbx_congelados
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.rb_todos
this.Control[iCurrent+8]=this.rb_activos
this.Control[iCurrent+9]=this.rb_anulados
this.Control[iCurrent+10]=this.em_nro_parte
this.Control[iCurrent+11]=this.sle_desc_formato
this.Control[iCurrent+12]=this.gb_2
end on

on w_pr710_parte_piso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_rango)
destroy(this.st_1)
destroy(this.cbx_harina)
destroy(this.cbx_conservas)
destroy(this.cbx_congelados)
destroy(this.gb_1)
destroy(this.rb_todos)
destroy(this.rb_activos)
destroy(this.rb_anulados)
destroy(this.em_nro_parte)
destroy(this.sle_desc_formato)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_nro_parte, ls_date, ls_title
long 		ll_cuenta

ls_nro_parte = trim(em_nro_parte.text)

dw_report.reset()

dw_report.retrieve(ls_nro_parte)

 select upper(fma.descripcion)
   into :ls_title
   from tg_parte_piso_det ppd, tg_fmt_med_act fma
  where ppd.formato   = fma.formato(+)
    and ppd.nro_parte = :ls_nro_parte;

if sqlca.sqlcode = 100 then ls_title = 'PARTE DE PISO'

select   to_char(sysdate, 'dd/mm/yyyy') 
	into  :ls_date
	from  dual;
	
ls_title = ls_title + ' Nº ' + ls_nro_parte

dw_report.object.t_title.text 	= ls_title
dw_report.object.t_date.text 		= 'Fecha de impresión: ' + ls_date
dw_report.object.t_user.text 		= 'Impreso por: ' + gs_user
dw_report.object.t_empresa.text 	= gs_empresa
dw_report.object.p_logo.filename = gs_logo

end event

type dw_report from w_report_smpl`dw_report within w_pr710_parte_piso
integer x = 0
integer y = 264
integer width = 3369
integer height = 888
string dataobject = "d_pr_parte_piso_rep_cst"
end type

type uo_rango from u_ingreso_rango_fechas within w_pr710_parte_piso
integer x = 23
integer y = 92
integer taborder = 40
boolean bringtotop = true
end type

on uo_rango.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(relativedate(today(),-30), today()) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

type st_1 from statictext within w_pr710_parte_piso
integer x = 2217
integer y = 40
integer width = 713
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
string text = "Número de parte a mostrar"
boolean focusrectangle = false
end type

type cbx_harina from checkbox within w_pr710_parte_piso
integer x = 1737
integer y = 48
integer width = 247
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
string text = "Harina"
boolean checked = true
end type

type cbx_conservas from checkbox within w_pr710_parte_piso
integer x = 1737
integer y = 100
integer width = 357
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
string text = "Conservas"
boolean checked = true
end type

type cbx_congelados from checkbox within w_pr710_parte_piso
integer x = 1737
integer y = 152
integer width = 357
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
string text = "Congelados"
boolean checked = true
end type

type gb_1 from groupbox within w_pr710_parte_piso
integer y = 4
integer width = 2135
integer height = 236
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Criterio de búsqueda"
end type

type rb_todos from radiobutton within w_pr710_parte_piso
integer x = 1326
integer y = 48
integer width = 247
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

type rb_activos from radiobutton within w_pr710_parte_piso
integer x = 1326
integer y = 100
integer width = 297
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Activos"
end type

type rb_anulados from radiobutton within w_pr710_parte_piso
integer x = 1326
integer y = 152
integer width = 297
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Anulados"
end type

type em_nro_parte from singlelineedit within w_pr710_parte_piso
event dobleclick pbm_lbuttondblclk
integer x = 2345
integer y = 132
integer width = 416
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT T.NRO_PARTE AS CODIGO, "& 
		  + "F.DESCRIPCION AS DESCRIPCION "&
		  + "FROM TG_PARTE_PISO T, TG_FMT_MED_ACT F "&
		  + "WHERE F.FORMATO = T.FORMATO AND T.FLAG_ESTADO = '1'"
		  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	sle_desc_formato.text = ls_data
end if
end event

event modified;String 	ls_nro_parte, ls_desc

ls_nro_parte = this.text
if ls_nro_parte = '' or IsNull(ls_nro_parte) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Parte')
	return
end if

SELECT F.DESCRIPCION INTO :ls_desc
  FROM TG_PARTE_PISO T, TG_FMT_MED_ACT F
 WHERE F.FORMATO = T.FORMATO 
       AND T.NRO_PARTE = :ls_nro_parte;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Parte no existe')
	return
end if

sle_desc_formato.text = ls_desc

end event

type sle_desc_formato from singlelineedit within w_pr710_parte_piso
integer x = 2793
integer y = 128
integer width = 1230
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_pr710_parte_piso
integer x = 2272
integer y = 76
integer width = 1783
integer height = 156
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
end type

