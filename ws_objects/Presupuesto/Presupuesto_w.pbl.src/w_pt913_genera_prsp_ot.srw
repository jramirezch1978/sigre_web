$PBExportHeader$w_pt913_genera_prsp_ot.srw
$PBExportComments$Adiciona articulos proyectados al presupuesto de materiales
forward
global type w_pt913_genera_prsp_ot from w_abc
end type
type cbx_1 from checkbox within w_pt913_genera_prsp_ot
end type
type st_2 from statictext within w_pt913_genera_prsp_ot
end type
type hpb_1 from hprogressbar within w_pt913_genera_prsp_ot
end type
type cbx_revertir from checkbox within w_pt913_genera_prsp_ot
end type
type pb_1 from picturebutton within w_pt913_genera_prsp_ot
end type
type pb_2 from picturebutton within w_pt913_genera_prsp_ot
end type
type st_1 from statictext within w_pt913_genera_prsp_ot
end type
type st_6 from statictext within w_pt913_genera_prsp_ot
end type
type sle_year from editmask within w_pt913_genera_prsp_ot
end type
type cb_recuperar from commandbutton within w_pt913_genera_prsp_ot
end type
type sle_ot_adm from singlelineedit within w_pt913_genera_prsp_ot
end type
type st_3 from statictext within w_pt913_genera_prsp_ot
end type
type st_ot_adm from statictext within w_pt913_genera_prsp_ot
end type
type cb_selectall from commandbutton within w_pt913_genera_prsp_ot
end type
type cb_unselectall from commandbutton within w_pt913_genera_prsp_ot
end type
type cb_4 from commandbutton within w_pt913_genera_prsp_ot
end type
type dw_master from u_dw_abc within w_pt913_genera_prsp_ot
end type
end forward

global type w_pt913_genera_prsp_ot from w_abc
integer width = 2437
integer height = 1816
string title = "Generacion de Presupuesto (Orden Trabajo) (PT913)"
string menuname = "m_only_exit"
cbx_1 cbx_1
st_2 st_2
hpb_1 hpb_1
cbx_revertir cbx_revertir
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
global w_pt913_genera_prsp_ot w_pt913_genera_prsp_ot

forward prototypes
public function integer of_procesa_x_ot (integer ai_year, string as_nro_orden, string as_revertir)
end prototypes

public function integer of_procesa_x_ot (integer ai_year, string as_nro_orden, string as_revertir);String ls_mensaje

//create or replace procedure USP_PTO_GENERA_PTO_X_OT(
//       ani_year          in number,
//       asi_nro_orden     in orden_trabajo.nro_orden%TYPE,
//       asi_origen        in origen.cod_origen%TYPE,
//       asi_user          in usuario.cod_usr%TYPE, 
//       asi_modo          in char
//) is

DECLARE USP_PTO_GENERA_PTO_X_OT PROCEDURE FOR
	USP_PTO_GENERA_PTO_X_OT( :ai_year,
									 :as_nro_orden,
								    :gs_origen, 
							 	    :gs_user,
							 	    :as_revertir );

EXECUTE USP_PTO_GENERA_PTO_X_OT;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "USP_PTO_GENERA_PTO_X_OT: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

CLOSE USP_PTO_GENERA_PTO_X_OT;

return 1
end function

on w_pt913_genera_prsp_ot.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.cbx_1=create cbx_1
this.st_2=create st_2
this.hpb_1=create hpb_1
this.cbx_revertir=create cbx_revertir
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
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.hpb_1
this.Control[iCurrent+4]=this.cbx_revertir
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_6
this.Control[iCurrent+9]=this.sle_year
this.Control[iCurrent+10]=this.cb_recuperar
this.Control[iCurrent+11]=this.sle_ot_adm
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.st_ot_adm
this.Control[iCurrent+14]=this.cb_selectall
this.Control[iCurrent+15]=this.cb_unselectall
this.Control[iCurrent+16]=this.cb_4
this.Control[iCurrent+17]=this.dw_master
end on

on w_pt913_genera_prsp_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.st_2)
destroy(this.hpb_1)
destroy(this.cbx_revertir)
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
end event

event ue_open_pre;call super::ue_open_pre;sle_year.text = string(year(date(f_fecha_Actual())))
end event

type cbx_1 from checkbox within w_pt913_genera_prsp_ot
integer x = 695
integer y = 140
integer width = 599
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los OT_ADM"
end type

event clicked;if this.checked then
	sle_ot_adm.enabled = false
else
	sle_ot_adm.enabled = true
end if
end event

type st_2 from statictext within w_pt913_genera_prsp_ot
integer x = 1298
integer y = 404
integer width = 293
integer height = 64
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

type hpb_1 from hprogressbar within w_pt913_genera_prsp_ot
integer x = 9
integer y = 496
integer width = 1582
integer height = 64
unsignedinteger maxposition = 100
integer setstep = 10
end type

type cbx_revertir from checkbox within w_pt913_genera_prsp_ot
integer x = 1824
integer y = 140
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Revertir"
end type

event clicked;cb_recuperar.event clicked( )
end event

type pb_1 from picturebutton within w_pt913_genera_prsp_ot
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
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Long  	ll_i, ll_count, ll_j
string	ls_nro_doc, ls_tipo_doc, ls_mensaje, ls_ot_adm, &
			ls_opcion = '1', ls_revertir, ls_nro_orden
Integer 	li_year, li_return
str_parametros	lstr_param

dw_master.AcceptText()

li_year = Integer(sle_year.text)

if IsNull(li_year) or li_year = 0 then
	MessageBox('Aviso', 'Debe indicar un año')
	return
end if

if cbx_1.checked then
	ls_ot_adm = '%%'
else
	if sle_ot_adm.text = '' then
		MessageBox('Aviso', 'Debe especificar un OT_ADM',Information!)
		sle_ot_adm.SetFocus()
		return
	end if
	ls_ot_adm = trim(sle_ot_adm.text) + '%'
end if

if cbx_revertir.checked then
	ls_revertir = 'R'
else
	ls_Revertir = 'P'
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
if ls_revertir = 'P' then
	li_Return = MessageBox('Aviso', 'Desea visualizar los error antes de procesar las OTs', Information!, YesNo!, 2)
	
	if li_return = 1 then
		lstr_param.long1 = li_year
		lstr_param.string1 = ls_ot_adm
		
		OpenWithParm(w_pt505_errores_ots, lstr_param)
		
		if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return
		
		lstr_param = Message.PowerObjectParm
		
		if lstr_param.titulo = 'n' then return
	end if
end if

hpb_1.minposition = 0
hpb_1.maxposition = ll_count

if MessageBox('Aviso', 'Existen ' + string(ll_count) + ' registros marcados. Desea continuar ?', &
	Information!, Yesno!, 2 ) = 2 then return

ll_j = 0
for ll_i = 1 to idw_1.RowCount()
	if idw_1.object.flag[ll_i] = '1' then
		ll_j ++
		ls_nro_orden = idw_1.object.nro_doc[ll_i]
		parent.of_procesa_x_ot( li_year, ls_nro_orden, ls_revertir)		
		hpb_1.position = ll_j
		st_2.text = string(ll_j) + '/' + string(ll_count)
	end if
next

MessageBox('Aviso', 'Proceso ha sido ejecutado satisfactoriamente')

cb_recuperar.event clicked( )
end event

type pb_2 from picturebutton within w_pt913_genera_prsp_ot
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

type st_1 from statictext within w_pt913_genera_prsp_ot
integer x = 146
integer y = 16
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
string text = "Generacion de Presupuesto (Ordenes de Trabajo)"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_pt913_genera_prsp_ot
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

type sle_year from editmask within w_pt913_genera_prsp_ot
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

type cb_recuperar from commandbutton within w_pt913_genera_prsp_ot
integer x = 1358
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

if cbx_1.checked then
	ls_ot_adm = '%%'
else
	if sle_ot_adm.text = '' then
		MessageBox('Aviso', 'Debe especificar un OT_ADM',Information!)
		sle_ot_adm.SetFocus()
		return
	end if
	ls_ot_adm = trim(sle_ot_adm.text) + '%'
end if

if cbx_revertir.checked then
	dw_master.dataobject = 'd_list_ots_revertir'
else
	dw_master.dataobject = 'd_list_ots'
end if

dw_master.SetTransObject(SQLCA)
dw_master.Retrieve(li_year,ls_ot_adm)
end event

type sle_ot_adm from singlelineedit within w_pt913_genera_prsp_ot
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

//ls_sql = "SELECT DISTINCT A.OT_ADM AS CODIGO, " &
//		  + "A.DESCRIPCION AS DESCR_OT_ADM " &
//		  + "FROM OT_ADMINISTRACION A, " &
//		  + "ARTICULO_MOV_PROY AMP, " &
//		  + "OPERACIONES OP, " &
//		  + "ORDEN_TRABAJO OT " &
//		  + "WHERE AMP.NRO_DOC = OT.NRO_ORDEN " &
//		  + "AND OT.OT_ADM = A.OT_ADM " &
//		  + "AND OP.NRO_ORDEN = OT.NRO_ORDEN " &
//		  + "AND AMP.TIPO_DOC = (SELECT DOC_OT FROM LOGPARAM WHERE RECKEY ='1') " &
//		  + "AND (TO_CHAR(AMP.FEC_PROYECT, 'YYYY') = '" + ls_year + "' " &
//		  + "OR TO_CHAR(OP.FEC_INICIO_EST, 'YYYY') = '" + ls_year + "') " &
//		  + "AND NVL(AMP.FLAG_ESTADO, '0') = '3' " &
//		  + "AND AMP.tipo_mov = (select l.oper_cons_interno from logparam l where reckey = '1') " &
//   	  + "AND AMP.cencos is not null " &
//		  + "AND AMP.cnta_prsp is not null "

ls_sql = "SELECT DISTINCT A.OT_ADM AS CODIGO, " &
		  + "A.DESCRIPCION AS DESCR_OT_ADM " &
		  + "FROM OT_ADMINISTRACION A, " &
		  + "OT_ADM_USUARIO B " &
		  + "WHERE B.OT_ADM = A.OT_ADM " &
		  + "AND B.COD_USR = '" + gs_user + "' "
		  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text 		= ls_codigo
	st_ot_adm.text = ls_data
end if
end event

event modified;string ls_desc, ls_ot_adm

ls_ot_adm = this.text

select a.descripcion
	into :ls_desc
from 	ot_administracion a,
	 	ot_adm_usuario	   b
where a.ot_adm = b.ot_adm
  and b.cod_usr = :gs_user
  and a.ot_adm = :ls_ot_adm;
  
  
st_ot_adm.text = ls_desc
end event

type st_3 from statictext within w_pt913_genera_prsp_ot
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

type st_ot_adm from statictext within w_pt913_genera_prsp_ot
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

type cb_selectall from commandbutton within w_pt913_genera_prsp_ot
integer x = 50
integer y = 368
integer width = 398
integer height = 112
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

type cb_unselectall from commandbutton within w_pt913_genera_prsp_ot
integer x = 448
integer y = 368
integer width = 398
integer height = 112
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

type cb_4 from commandbutton within w_pt913_genera_prsp_ot
integer x = 846
integer y = 368
integer width = 398
integer height = 112
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

type dw_master from u_dw_abc within w_pt913_genera_prsp_ot
integer x = 9
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

