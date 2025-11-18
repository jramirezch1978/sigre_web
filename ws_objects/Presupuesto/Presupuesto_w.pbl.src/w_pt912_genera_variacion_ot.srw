$PBExportHeader$w_pt912_genera_variacion_ot.srw
$PBExportComments$Adiciona articulos proyectados al presupuesto de materiales
forward
global type w_pt912_genera_variacion_ot from w_abc
end type
type pb_1 from picturebutton within w_pt912_genera_variacion_ot
end type
type pb_2 from picturebutton within w_pt912_genera_variacion_ot
end type
type st_1 from statictext within w_pt912_genera_variacion_ot
end type
type st_6 from statictext within w_pt912_genera_variacion_ot
end type
type sle_year from editmask within w_pt912_genera_variacion_ot
end type
type cb_recuperar from commandbutton within w_pt912_genera_variacion_ot
end type
type sle_ot_adm from singlelineedit within w_pt912_genera_variacion_ot
end type
type st_3 from statictext within w_pt912_genera_variacion_ot
end type
type st_ot_adm from statictext within w_pt912_genera_variacion_ot
end type
type cb_selectall from commandbutton within w_pt912_genera_variacion_ot
end type
type cb_unselectall from commandbutton within w_pt912_genera_variacion_ot
end type
type cb_4 from commandbutton within w_pt912_genera_variacion_ot
end type
type dw_master from u_dw_abc within w_pt912_genera_variacion_ot
end type
end forward

global type w_pt912_genera_variacion_ot from w_abc
integer width = 2473
integer height = 1772
string title = "Genera Variacion Presup OT (PT912)"
string menuname = "m_only_exit"
pb_1 pb_1
pb_2 pb_2
st_1 st_1
st_6 st_6
sle_year sle_year
cb_recuperar cb_recuperar
sle_ot_adm sle_ot_adm
st_3 st_3
st_ot_adm st_ot_adm
cb_selectall cb_selectall
cb_unselectall cb_unselectall
cb_4 cb_4
dw_master dw_master
end type
global w_pt912_genera_variacion_ot w_pt912_genera_variacion_ot

forward prototypes
public function integer of_procesar_ots (integer ai_year, string as_tipo_var, string as_opcion)
end prototypes

public function integer of_procesar_ots (integer ai_year, string as_tipo_var, string as_opcion);string 	ls_mensaje
Integer	li_nada
//create or replace procedure USP_PTO_GEN_VAR_OT(
//       ani_year     in number,
//       asi_origen   in origen.cod_origen%TYPE,
//       asi_user     in usuario.cod_usr%TYPE,
//       ani_mes1     in number,
//       ani_mes2     in number,
//       asi_tipo_var in char,
//       asi_opcion   in char
//) is

DECLARE USP_PTO_GEN_VAR_OT PROCEDURE FOR
	USP_PTO_GEN_VAR_OT( :ai_year,
							  :gs_origen, 
							  :gs_user,
							  :li_nada,
							  :li_nada,
							  :as_tipo_var,
							  :as_opcion );

EXECUTE USP_PTO_GEN_VAR_OT;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "USP_PTO_GEN_VAR_OT: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

CLOSE USP_PTO_GEN_VAR_OT;

return 1
end function

on w_pt912_genera_variacion_ot.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_1=create st_1
this.st_6=create st_6
this.sle_year=create sle_year
this.cb_recuperar=create cb_recuperar
this.sle_ot_adm=create sle_ot_adm
this.st_3=create st_3
this.st_ot_adm=create st_ot_adm
this.cb_selectall=create cb_selectall
this.cb_unselectall=create cb_unselectall
this.cb_4=create cb_4
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.sle_year
this.Control[iCurrent+6]=this.cb_recuperar
this.Control[iCurrent+7]=this.sle_ot_adm
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_ot_adm
this.Control[iCurrent+10]=this.cb_selectall
this.Control[iCurrent+11]=this.cb_unselectall
this.Control[iCurrent+12]=this.cb_4
this.Control[iCurrent+13]=this.dw_master
end on

on w_pt912_genera_variacion_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_1)
destroy(this.st_6)
destroy(this.sle_year)
destroy(this.cb_recuperar)
destroy(this.sle_ot_adm)
destroy(this.st_3)
destroy(this.st_ot_adm)
destroy(this.cb_selectall)
destroy(this.cb_unselectall)
destroy(this.cb_4)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

st_1.height = newheight - st_1.y - 10
end event

type pb_1 from picturebutton within w_pt912_genera_variacion_ot
integer x = 1627
integer y = 376
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Long  	ll_i, ll_count
string	ls_nro_doc, ls_tipo_doc, ls_mensaje, ls_ot_adm, &
			ls_opcion = '1', ls_tipo_var
Integer 	li_year, li_nada, li_return
str_parametros	lstr_param

SetNull(li_nada)

li_year = Integer(sle_year.text)

if IsNull(li_year) or li_year = 0 then
	MessageBox('Aviso', 'Debe indicar un año')
	return
end if

ls_ot_adm = sle_ot_adm.text
if IsNull(ls_ot_adm) or ls_ot_adm = '' then
	MessageBox('Aviso', 'Debe indicar un OT ADM')
	return
end if

//Elimino la tabla temporal
delete tt_pto_selec_ots;
commit;

//ahora procedo a vaciar las OTs seleccionadas
idw_1 = dw_master
for ll_i = 1 to idw_1.RowCount()
	if idw_1.object.flag[ll_i] = '1' then
		ls_tipo_doc = idw_1.object.tipo_doc	[ll_i]
		ls_nro_doc 	= idw_1.object.nro_doc	[ll_i]
		
		insert into tt_pto_selec_ots(tipo_doc, nro_doc)
		values( :ls_tipo_doc, :ls_nro_doc);
		
		if SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return
		end if
		
		commit;
	end if
next

select count(*)
	into :ll_count
from tt_pto_selec_ots;

if ll_count = 0 then
	MessageBox('Aviso', 'No ha marcado ninguna OT para Generar Variación')
	return
end if

// Ahora procedo a mostrar el reporte de errores por OT
li_Return = MessageBox('Aviso', 'Desea visualizar los error antes de procesar las OTs', Information!, YesNo!, 2)

if li_Return = 1 then
	lstr_param.long1 = li_year
	lstr_param.string1 = ls_ot_adm
	
	OpenWithParm(w_pt505_errores_ots, lstr_param)
	
	if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return
	
	lstr_param = Message.PowerObjectParm
	
	if lstr_param.titulo = 'n' then return
end if

parent.of_procesar_ots( li_year, ls_tipo_var, ls_opcion)

// Verifico si existen registros para mostrar
select count(*)
	into :ll_count
from tt_pto_variaciones;

if ll_count = 0 then
	MessageBox('Aviso', 'No se ha procesado ningun registro, por favor verifique')
	return
end if

lstr_param.long1 = li_year

OpenSheetWithParm(w_pt504_prsp_var_ots, lstr_param, w_main, 7, Layered!)




end event

type pb_2 from picturebutton within w_pt912_genera_variacion_ot
integer x = 2002
integer y = 376
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(parent)
end event

type st_1 from statictext within w_pt912_genera_variacion_ot
integer width = 2277
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Generacion de Variaciones en Presupuesto (Ordenes de Trabajo)"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_pt912_genera_variacion_ot
integer x = 110
integer y = 148
integer width = 174
integer height = 64
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

type sle_year from editmask within w_pt912_genera_variacion_ot
integer x = 293
integer y = 132
integer width = 315
integer height = 96
integer taborder = 20
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

type cb_recuperar from commandbutton within w_pt912_genera_variacion_ot
integer x = 1262
integer y = 124
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Recuperar"
end type

event clicked;string 	ls_ot_adm
integer	li_year

li_year = integer(sle_year.text)

if IsNull(li_year) or li_year = 0 then
	Messagebox( "Error", "Ingrese año", exclamation!)
	sle_year.SetFocus()
	return
end if

ls_ot_adm = sle_ot_adm.text

if IsNull(ls_ot_adm) or ls_ot_adm = '' then
	Messagebox( "Error", "Ingrese año", exclamation!)
	sle_year.SetFocus()
	return
end if

dw_master.SetTransObject(SQLCA)
dw_master.Retrieve(li_year,ls_ot_adm)
end event

type sle_ot_adm from singlelineedit within w_pt912_genera_variacion_ot
event dblclick pbm_lbuttondblclk
integer x = 293
integer y = 240
integer width = 402
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dblclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_year

ls_year = sle_year.text

if ls_year = '' or IsNull(ls_year) then
	MessageBox('Aviso', 'Debe ingresar un año')
	return
end if

ls_sql = "SELECT DISTINCT A.OT_ADM AS CODIGO, " &
		  + "A.DESCRIPCION AS DESCR_OT_ADM " &
		  + "FROM OT_ADMINISTRACION A, " &
		  + "ARTICULO_MOV_PROY AMP, " &
		  + "OPERACIONES OP, " &
		  + "ORDEN_TRABAJO OT " &
		  + "WHERE AMP.NRO_DOC = OT.NRO_ORDEN " &
		  + "AND OT.OT_ADM = A.OT_ADM " &
		  + "AND OP.NRO_ORDEN = OT.NRO_ORDEN " &
		  + "AND AMP.TIPO_DOC = (SELECT DOC_OT FROM LOGPARAM WHERE RECKEY ='1') " &
		  + "AND (TO_CHAR(AMP.FEC_PROYECT, 'YYYY') = '" + ls_year + "' " &
		  + "OR TO_CHAR(OP.FEC_INICIO_EST, 'YYYY') = '" + ls_year + "') " &
		  + "AND NVL(AMP.FLAG_ESTADO, '0') = '3' " &
		  + "AND AMP.tipo_mov = (select l.oper_cons_interno from logparam l where reckey = '1') " &
   	  + "AND AMP.cencos is not null " &
		  + "AND AMP.cnta_prsp is not null "
		  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text 		= ls_codigo
	st_ot_adm.text = ls_data
end if

end event

type st_3 from statictext within w_pt912_genera_variacion_ot
integer x = 55
integer y = 252
integer width = 229
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ot Adm"
boolean focusrectangle = false
end type

type st_ot_adm from statictext within w_pt912_genera_variacion_ot
integer x = 727
integer y = 240
integer width = 1577
integer height = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_selectall from commandbutton within w_pt912_genera_variacion_ot
integer x = 50
integer y = 448
integer width = 375
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;long ll_i

for ll_i = 1 to dw_master.RowCount()
	dw_master.object.flag[ll_i] = '1'
next
end event

type cb_unselectall from commandbutton within w_pt912_genera_variacion_ot
integer x = 425
integer y = 448
integer width = 375
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "UnSelect All"
end type

event clicked;long ll_i

for ll_i = 1 to dw_master.RowCount()
	dw_master.object.flag[ll_i] = '0'
next
end event

type cb_4 from commandbutton within w_pt912_genera_variacion_ot
integer x = 800
integer y = 448
integer width = 375
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Invert Selection"
end type

event clicked;long ll_i

for ll_i = 1 to dw_master.RowCount()
	if dw_master.object.flag[ll_i] = '0' then
		dw_master.object.flag[ll_i] = '1'
	else
		dw_master.object.flag[ll_i] = '0'
	end if
next
end event

type dw_master from u_dw_abc within w_pt912_genera_variacion_ot
integer y = 564
integer width = 1979
integer height = 924
string dataobject = "d_list_ots"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

