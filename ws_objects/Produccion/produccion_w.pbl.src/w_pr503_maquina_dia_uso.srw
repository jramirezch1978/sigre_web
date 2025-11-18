$PBExportHeader$w_pr503_maquina_dia_uso.srw
forward
global type w_pr503_maquina_dia_uso from w_pr500_base
end type
type em_maquina from singlelineedit within w_pr503_maquina_dia_uso
end type
type sle_desc_maquina from singlelineedit within w_pr503_maquina_dia_uso
end type
type gb_2 from groupbox within w_pr503_maquina_dia_uso
end type
type gb_1 from groupbox within w_pr503_maquina_dia_uso
end type
end forward

global type w_pr503_maquina_dia_uso from w_pr500_base
integer width = 3086
integer height = 1476
string title = "Eficiencia por Equipo(PR503)"
windowstate windowstate = normal!
em_maquina em_maquina
sle_desc_maquina sle_desc_maquina
gb_2 gb_2
gb_1 gb_1
end type
global w_pr503_maquina_dia_uso w_pr503_maquina_dia_uso

type variables
string is_date
end variables

forward prototypes
public subroutine of_title ()
end prototypes

public subroutine of_title ();string ls_fecha1, ls_fecha2, ls_periodo,ls_title
ls_fecha1 = trim(string(uo_fecha.of_get_fecha1(), 'dd/mm/yyyy'))
ls_fecha2 = trim(string(uo_fecha.of_get_fecha2(), 'dd/mm/yyyy'))
ls_title = trim(is_title_original)

if ls_fecha1 = ls_fecha2 then
	ls_periodo = 'para el día ' + ls_fecha1
else
	ls_periodo = 'para el periodo entre ' + ls_fecha1 + ' y ' + ls_fecha2
end if

idw_1.object.t_title.text = trim(upper(ls_title)) +' '+ trim(upper(ls_periodo) + ' ~r PARA EL EQUIPO: '+ is_title1)
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = 'Impreso por: '+ trim(gs_user)
idw_1.Object.t_date.text = 'Impreso el: ' + is_date
end subroutine

on w_pr503_maquina_dia_uso.create
int iCurrent
call super::create
this.em_maquina=create em_maquina
this.sle_desc_maquina=create sle_desc_maquina
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_maquina
this.Control[iCurrent+2]=this.sle_desc_maquina
this.Control[iCurrent+3]=this.gb_2
this.Control[iCurrent+4]=this.gb_1
end on

on w_pr503_maquina_dia_uso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_maquina)
destroy(this.sle_desc_maquina)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;long ll_cuenta
string ls_cod_maquina, ls_fecha1, ls_fecha2
date ld_fecha1, ld_fecha2
st_procesando.visible = true
idw_1.visible = false
idw_1.reset()
of_get_code(1,8,ls_cod_maquina)
ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()
ls_fecha1 = string(ld_fecha1, 'dd/mm/yyyy')
ls_fecha2 = string(ld_fecha2, 'dd/mm/yyyy')
declare usp_uso_dia procedure for 
	usp_tg_tiempo_uso_diario(:ls_cod_maquina, :ls_fecha1, :ls_fecha2);
execute usp_uso_dia;
fetch usp_uso_dia into :ll_cuenta, :is_title1, :is_date;
close usp_uso_dia;
idw_1.Retrieve()
of_title()
idw_1.visible = true
st_procesando.visible = false
end event

event ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()
idw_1.Visible = False
is_title_original = trim(idw_1.object.t_title.text)
end event

event ue_retrieve_list;call super::ue_retrieve_list;long ll_cuenta
string ls_sql, ls_return1, ls_return2, ls_fecha_ini, ls_fecha_fin
date ld_fecha_ini, ld_fecha_fin
ld_fecha_ini = uo_fecha.of_get_fecha1( )
ld_fecha_fin = uo_fecha.of_get_fecha2( )
ls_fecha_ini = string(ld_fecha_ini, 'dd/mm/yyyy')
ls_fecha_fin = string(ld_fecha_fin, 'dd/mm/yyyy')

declare usp_maquina procedure for 
	usp_pr_maquinas_incidencias(:ls_fecha_ini, :ls_fecha_fin);
execute usp_maquina;
fetch usp_maquina into :ll_cuenta;

if ll_cuenta >= 1 then
	ls_sql = 'select cod_maquina as codigo, desc_maq as descripcion from tt_pr_maquina_incidencia'
	f_lista(ls_sql, ls_return1, ls_return2, '2')
	if not isnull(ls_return1) and trim(ls_return1) <> '' then
		sle_code.text = trim(ls_return1)
		this.event ue_retrieve()
	end if
else
	messagebox(this.title,'No se han encontrado máquinas para ese periodo de tiempo, elija un periodo de tiempo más amplio',stopsign!)
end if
close usp_maquina;
end event

event ue_query_retrieve;date ld_fecha_ini, ld_fecha_fin
string ls_cod_maquina, ls_fecha_ini, ls_fecha_fin
long ll_cuenta

if trim (em_maquina.text) = '' then
	messagebox(this.title,'Debe ingresar o seleccionar '+ lower(trim(em_maquina.text)) ,stopsign!)
	return
else
	st_procesando.visible = true
	of_get_code(1,8,ls_cod_maquina)
	ld_fecha_ini = uo_fecha.of_get_fecha1( )
	ld_fecha_fin = uo_fecha.of_get_fecha2( )
	ls_fecha_ini = string(ld_fecha_ini, 'dd/mm/yyyy')
	ls_fecha_fin = string(ld_fecha_fin, 'dd/mm/yyyy')
	declare usp_busca_maquina procedure for 
		usp_tg_busca_maquina_tuso(:ls_cod_maquina, :ls_fecha_ini, :ls_fecha_fin);
	execute usp_busca_maquina;
	fetch usp_busca_maquina into :ll_cuenta;
	close usp_busca_maquina;
	if ll_cuenta >= 1 then
		this.event ue_retrieve()
	else
		messagebox(this.title,'No se ha encontrado ' + lower(trim(em_maquina.text)) ,stopsign!)
		st_procesando.visible = false
		return
	end if
end if
end event

type dw_report from w_pr500_base`dw_report within w_pr503_maquina_dia_uso
integer x = 9
integer y = 276
integer width = 2985
integer height = 988
string dataobject = "d_pr_maquina_hora_uso_cst"
end type

type uo_fecha from w_pr500_base`uo_fecha within w_pr503_maquina_dia_uso
integer x = 64
integer y = 76
end type

type st_confirm from w_pr500_base`st_confirm within w_pr503_maquina_dia_uso
end type

type st_etiqueta from w_pr500_base`st_etiqueta within w_pr503_maquina_dia_uso
integer x = 105
integer y = 12
end type

type sle_code from w_pr500_base`sle_code within w_pr503_maquina_dia_uso
boolean visible = false
integer x = 1975
integer y = 76
end type

type st_code from w_pr500_base`st_code within w_pr503_maquina_dia_uso
boolean visible = false
integer x = 1403
integer y = 360
integer width = 544
integer weight = 700
long textcolor = 8388608
string text = "Código de máquina"
alignment alignment = left!
end type

type st_procesando from w_pr500_base`st_procesando within w_pr503_maquina_dia_uso
integer x = 1408
integer y = 192
integer width = 1577
long textcolor = 0
long backcolor = 134217731
end type

type em_maquina from singlelineedit within w_pr503_maquina_dia_uso
event dobleclick pbm_lbuttondblclk
integer x = 1417
integer y = 80
integer width = 416
integer height = 72
integer taborder = 70
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

ls_sql = "select m.cod_maquina as Codigo, "& 
		  + "m.desc_maq as Descripción "&
		  + "from maquina m "&
		  + "where m.flag_estado = '1' AND m.FLAG_ESTADO = '1'"
		  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	sle_desc_maquina.text = ls_data
end if
end event

event modified;String 	ls_nro_maquina, ls_desc

ls_nro_maquina = this.text
if ls_nro_maquina = '' or IsNull(ls_nro_maquina) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Parte')
	return
end if

SELECT desc_maq INTO :ls_desc
  FROM maquina
 WHERE cod_maquina = :ls_nro_maquina;
 
 
IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Parte no existe')
	return
end if

sle_desc_maquina.text = ls_desc

end event

type sle_desc_maquina from singlelineedit within w_pr503_maquina_dia_uso
integer x = 1847
integer y = 84
integer width = 1088
integer height = 72
integer taborder = 90
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

type gb_2 from groupbox within w_pr503_maquina_dia_uso
integer x = 1394
integer y = 12
integer width = 1600
integer height = 180
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Código de máquina"
end type

type gb_1 from groupbox within w_pr503_maquina_dia_uso
integer x = 27
integer y = 12
integer width = 1362
integer height = 180
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Rango de Fechas"
end type

