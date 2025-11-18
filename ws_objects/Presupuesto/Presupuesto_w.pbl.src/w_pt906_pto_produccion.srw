$PBExportHeader$w_pt906_pto_produccion.srw
forward
global type w_pt906_pto_produccion from w_abc
end type
type cbx_1 from checkbox within w_pt906_pto_produccion
end type
type st_3 from statictext within w_pt906_pto_produccion
end type
type st_2 from statictext within w_pt906_pto_produccion
end type
type ddlb_cmp_directa from dropdownlistbox within w_pt906_pto_produccion
end type
type ddlb_cntrl_prsp from dropdownlistbox within w_pt906_pto_produccion
end type
type cb_4 from commandbutton within w_pt906_pto_produccion
end type
type cb_unselectall from commandbutton within w_pt906_pto_produccion
end type
type cb_selectall from commandbutton within w_pt906_pto_produccion
end type
type cb_leer from commandbutton within w_pt906_pto_produccion
end type
type pb_1 from picturebutton within w_pt906_pto_produccion
end type
type pb_2 from picturebutton within w_pt906_pto_produccion
end type
type st_1 from statictext within w_pt906_pto_produccion
end type
type st_6 from statictext within w_pt906_pto_produccion
end type
type em_ano from editmask within w_pt906_pto_produccion
end type
type cbx_revertir from checkbox within w_pt906_pto_produccion
end type
type dw_master from u_dw_abc within w_pt906_pto_produccion
end type
end forward

global type w_pt906_pto_produccion from w_abc
integer width = 3154
integer height = 2248
string title = "Generacion de Presupuesto de Produccion (PT906)"
string menuname = "m_only_exit"
cbx_1 cbx_1
st_3 st_3
st_2 st_2
ddlb_cmp_directa ddlb_cmp_directa
ddlb_cntrl_prsp ddlb_cntrl_prsp
cb_4 cb_4
cb_unselectall cb_unselectall
cb_selectall cb_selectall
cb_leer cb_leer
pb_1 pb_1
pb_2 pb_2
st_1 st_1
st_6 st_6
em_ano em_ano
cbx_revertir cbx_revertir
dw_master dw_master
end type
global w_pt906_pto_produccion w_pt906_pto_produccion

on w_pt906_pto_produccion.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.cbx_1=create cbx_1
this.st_3=create st_3
this.st_2=create st_2
this.ddlb_cmp_directa=create ddlb_cmp_directa
this.ddlb_cntrl_prsp=create ddlb_cntrl_prsp
this.cb_4=create cb_4
this.cb_unselectall=create cb_unselectall
this.cb_selectall=create cb_selectall
this.cb_leer=create cb_leer
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_1=create st_1
this.st_6=create st_6
this.em_ano=create em_ano
this.cbx_revertir=create cbx_revertir
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.ddlb_cmp_directa
this.Control[iCurrent+5]=this.ddlb_cntrl_prsp
this.Control[iCurrent+6]=this.cb_4
this.Control[iCurrent+7]=this.cb_unselectall
this.Control[iCurrent+8]=this.cb_selectall
this.Control[iCurrent+9]=this.cb_leer
this.Control[iCurrent+10]=this.pb_1
this.Control[iCurrent+11]=this.pb_2
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.st_6
this.Control[iCurrent+14]=this.em_ano
this.Control[iCurrent+15]=this.cbx_revertir
this.Control[iCurrent+16]=this.dw_master
end on

on w_pt906_pto_produccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.ddlb_cmp_directa)
destroy(this.ddlb_cntrl_prsp)
destroy(this.cb_4)
destroy(this.cb_unselectall)
destroy(this.cb_selectall)
destroy(this.cb_leer)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_1)
destroy(this.st_6)
destroy(this.em_ano)
destroy(this.cbx_revertir)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

st_1.width  = newwidth  - st_1.x - 10

end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

end event

type cbx_1 from checkbox within w_pt906_pto_produccion
integer x = 1870
integer y = 292
integer width = 507
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Segun Plantilla"
end type

type st_3 from statictext within w_pt906_pto_produccion
integer x = 1870
integer y = 104
integer width = 507
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Compra Directa"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt906_pto_produccion
integer x = 1170
integer y = 108
integer width = 681
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Control Prsp"
boolean focusrectangle = false
end type

type ddlb_cmp_directa from dropdownlistbox within w_pt906_pto_produccion
integer x = 1870
integer y = 188
integer width = 507
integer height = 400
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"0 - Mov de Almacen","1 - OC / OS Directo","2 - Ambos"}
borderstyle borderstyle = stylelowered!
end type

type ddlb_cntrl_prsp from dropdownlistbox within w_pt906_pto_produccion
integer x = 1170
integer y = 188
integer width = 681
integer height = 400
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"0 - No Control","1 - Acumulado Anual","2 - Acumulado a la fecha","3 - Mensual","4 - Trimetre Acumulado","5 - Trimestre Centrado"}
borderstyle borderstyle = stylelowered!
end type

type cb_4 from commandbutton within w_pt906_pto_produccion
integer x = 773
integer y = 248
integer width = 384
integer height = 88
integer taborder = 50
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
	if dw_master.object.flag_estado[ll_i] = '0' then
		dw_master.object.flag_estado[ll_i] = '1'
	else
		dw_master.object.flag_estado[ll_i] = '0'
	end if
next
end event

type cb_unselectall from commandbutton within w_pt906_pto_produccion
integer x = 384
integer y = 248
integer width = 384
integer height = 88
integer taborder = 40
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
	dw_master.object.flag_estado[ll_i] = '0'
next
end event

type cb_selectall from commandbutton within w_pt906_pto_produccion
integer y = 248
integer width = 384
integer height = 88
integer taborder = 30
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
	dw_master.object.flag_estado[ll_i] = '1'
next
end event

type cb_leer from commandbutton within w_pt906_pto_produccion
integer x = 891
integer y = 112
integer width = 256
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Leer"
end type

event clicked;integer li_year
string ls_estado

li_year  = integer (em_ano.text)

if li_year = 0 or IsNull(li_year) then
	MessageBox('Aviso', 'Debe indicar un año')
	return
end if

if cbx_revertir.checked = true then
	ls_estado = '2'
else
	ls_estado = '1'
end if

dw_master.Retrieve(li_year, ls_estado)
end event

type pb_1 from picturebutton within w_pt906_pto_produccion
integer x = 2386
integer y = 132
integer width = 315
integer height = 180
integer taborder = 30
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

event clicked;Long 		ll_year, ll_row
String 	ls_modo, ls_cencos, ls_cod_Art, ls_mensaje, &
			ls_cntrl_prsp, ls_cmp_directa, ls_flag_xdefecto

if dw_master.RowCount() = 0 then
	MessageBox('Aviso', 'No existe registros, por favor verifique')
	return
end if

if cbx_revertir.checked = true then
	ls_modo = 'R'
else
	ls_modo = 'G'
end if

if cbx_1.checked = true then
	ls_flag_xdefecto = '1'
else
	ls_flag_xdefecto = '0'
end if

ls_cntrl_prsp = left(ddlb_cntrl_prsp.text,1)
ls_cmp_directa = left(ddlb_cmp_directa.text,1)

if ls_modo = 'G' and ls_cntrl_prsp = '' then
	MessageBox('Aviso', 'Debe elegir un tipo de Control Presupuestal')
	Return
end if

if ls_modo = 'G' and (ls_cmp_directa = '' and ls_flag_xdefecto = '0') then
	MessageBox('Aviso', 'Debe elegir un tipo de Compra Directa')
	Return
end if

if ISNULL( em_ano.text) OR TRIM(em_ano.text) = '' THEN
	Messagebox( "Error", "Ingrese año", exclamation!)
	em_ano.SetFocus()
	return
end if

//Elimino todos los registros de la tabla temporal
delete TT_PTO_SEL_PROY_PRSP;
commit;

for ll_row = 1 to dw_master.RowCount( )
	if dw_master.object.flag_estado[ll_row] = '1' then
		ll_year 		= Long(dw_master.object.ano[ll_row])
		ls_cencos	= dw_master.object.cencos	[ll_row]
		ls_cod_Art	= dw_master.object.cod_Art	[ll_row]
		
		insert into TT_PTO_SEL_PROY_PRSP(ano, cencos, cod_art)
		values(:ll_year, :ls_Cencos, :ls_cod_Art);
		
		if SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error en insercion de registro', ls_mensaje)
			return
		end if
	end if
next
commit;

//Procedo a ejecutar el procedimiento
SetPointer(hourglass!)

//create or replace procedure USP_PTO_GEN_PRSP_PROD(
//       asi_user             in usuario.cod_usr%TYPE,
//       asi_origen           in origen.cod_origen%TYPE,
//       asi_modo             in VARCHAR2,
//       asi_cntrl_prsp       IN VARCHAR2,
//       asi_cmp_directa      IN VARCHAR2,
//       asi_flag_defecto     IN VARCHAR2
//) is

DECLARE USP_PTO_GEN_PRSP_PROD PROCEDURE FOR 
	USP_PTO_GEN_PRSP_PROD (:gs_user, 
								  :gs_origen, 
								  :ls_modo,
								  :ls_cntrl_prsp,
								  :ls_cmp_directa,
								  :ls_flag_xdefecto);
								  
EXECUTE USP_PTO_GEN_PRSP_PROD;

if sqlca.sqlcode = -1 then   // Fallo
	ls_mensaje = SQLCA.SQLErrText
	rollback ;
	Messagebox( "Error USP_PTO_GEN_PRSP_PROD", ls_mensaje, stopsign!)
	return
end if

CLOSE USP_PTO_GEN_PRSP_PROD;

MessageBox( 'Mensaje', "Proceso Ejecutado Satisfactoriamente" )
cb_leer.triggerEvent(clicked!)

SetPointer(Arrow!)

end event

type pb_2 from picturebutton within w_pt906_pto_produccion
integer x = 2711
integer y = 132
integer width = 315
integer height = 180
integer taborder = 40
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

type st_1 from statictext within w_pt906_pto_produccion
integer width = 1413
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
string text = "Generacion de presupuesto Produccion"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_pt906_pto_produccion
integer x = 9
integer y = 140
integer width = 178
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

type em_ano from editmask within w_pt906_pto_produccion
integer x = 215
integer y = 124
integer width = 315
integer height = 96
integer taborder = 10
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

event modified;dw_master.Reset()
end event

type cbx_revertir from checkbox within w_pt906_pto_produccion
integer x = 549
integer y = 132
integer width = 329
integer height = 80
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Revertir "
end type

event clicked;dw_master.Reset()
end event

type dw_master from u_dw_abc within w_pt906_pto_produccion
integer y = 380
integer width = 2199
integer height = 1488
integer taborder = 50
string dataobject = "d_list_presup_prod_plant_prsp"
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
is_dwform = 'tabular'	// tabular, form (default)
end event

