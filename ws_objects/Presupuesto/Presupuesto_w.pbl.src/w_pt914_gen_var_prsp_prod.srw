$PBExportHeader$w_pt914_gen_var_prsp_prod.srw
forward
global type w_pt914_gen_var_prsp_prod from w_abc
end type
type cb_4 from commandbutton within w_pt914_gen_var_prsp_prod
end type
type cb_unselectall from commandbutton within w_pt914_gen_var_prsp_prod
end type
type cb_selectall from commandbutton within w_pt914_gen_var_prsp_prod
end type
type cb_leer from commandbutton within w_pt914_gen_var_prsp_prod
end type
type pb_1 from picturebutton within w_pt914_gen_var_prsp_prod
end type
type pb_2 from picturebutton within w_pt914_gen_var_prsp_prod
end type
type st_1 from statictext within w_pt914_gen_var_prsp_prod
end type
type st_6 from statictext within w_pt914_gen_var_prsp_prod
end type
type em_ano from editmask within w_pt914_gen_var_prsp_prod
end type
type dw_master from u_dw_abc within w_pt914_gen_var_prsp_prod
end type
end forward

global type w_pt914_gen_var_prsp_prod from w_abc
integer width = 2953
integer height = 2420
string title = "Generacion de Variacion de Prsp Prod (PT914)"
string menuname = "m_only_exit"
cb_4 cb_4
cb_unselectall cb_unselectall
cb_selectall cb_selectall
cb_leer cb_leer
pb_1 pb_1
pb_2 pb_2
st_1 st_1
st_6 st_6
em_ano em_ano
dw_master dw_master
end type
global w_pt914_gen_var_prsp_prod w_pt914_gen_var_prsp_prod

on w_pt914_gen_var_prsp_prod.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.cb_4=create cb_4
this.cb_unselectall=create cb_unselectall
this.cb_selectall=create cb_selectall
this.cb_leer=create cb_leer
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_1=create st_1
this.st_6=create st_6
this.em_ano=create em_ano
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_4
this.Control[iCurrent+2]=this.cb_unselectall
this.Control[iCurrent+3]=this.cb_selectall
this.Control[iCurrent+4]=this.cb_leer
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_6
this.Control[iCurrent+9]=this.em_ano
this.Control[iCurrent+10]=this.dw_master
end on

on w_pt914_gen_var_prsp_prod.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_4)
destroy(this.cb_unselectall)
destroy(this.cb_selectall)
destroy(this.cb_leer)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_1)
destroy(this.st_6)
destroy(this.em_ano)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

st_1.width  = newwidth  - st_1.x - 10

end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

end event

type cb_4 from commandbutton within w_pt914_gen_var_prsp_prod
integer x = 773
integer y = 260
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

type cb_unselectall from commandbutton within w_pt914_gen_var_prsp_prod
integer x = 384
integer y = 260
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

type cb_selectall from commandbutton within w_pt914_gen_var_prsp_prod
integer y = 260
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

type cb_leer from commandbutton within w_pt914_gen_var_prsp_prod
integer x = 891
integer y = 124
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

li_year  = integer (em_ano.text)

if li_year = 0 or IsNull(li_year) then
	MessageBox('Aviso', 'Debe indicar un año')
	return
end if

dw_master.Retrieve(li_year)
end event

type pb_1 from picturebutton within w_pt914_gen_var_prsp_prod
integer x = 1207
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

event clicked;Long 		ll_row, ll_count, ll_year
String 	ls_cencos, ls_cod_Art, ls_mensaje, ls_tipo_var, &
			ls_opcion
Integer	li_nada			
str_parametros lstr_param

SetNull(li_nada)
if dw_master.RowCount() = 0 then
	MessageBox('Aviso', 'No existe registros, por favor verifique')
	return
end if

if ISNULL( em_ano.text) OR TRIM(em_ano.text) = '' THEN
	Messagebox( "Error", "Ingrese año", exclamation!)
	em_ano.SetFocus()
	return
end if

//Elimino todos los registros de la tabla temporal
delete TT_PTO_SEL_PROY_PRSP;
commit;

dw_master.accepttext( )

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

//Verifico que haya seleccionado aunque sea un registro
select count(*)
	into :ll_count
from TT_PTO_SEL_PROY_PRSP;

if ll_count = 0 then
	MessageBox('Aviso', 'No ha seleccionado ningun registro')
	return
end if

//Procedo a ejecutar el procedimiento
ll_year = Long(em_ano.text)
ls_opcion = '1'  //Solo visualizar
SetPointer(hourglass!)

//create or replace procedure USP_PTO_GEN_VAR_PRSP_PROD(
//       ani_year     in number,
//       asi_origen   in origen.cod_origen%TYPE,
//       asi_user     in usuario.cod_usr%TYPE,
//       ani_mes1      in number,
//       ani_mes2      in number,
//       asi_tipo_var in char,
//       asi_opcion   in char
//) is

DECLARE USP_PTO_GEN_VAR_PRSP_PROD PROCEDURE FOR
	USP_PTO_GEN_VAR_PRSP_PROD( :ll_year,
							  			:gs_origen, 
							  			:gs_user,
										:li_nada,
										:li_nada,
							  			:ls_tipo_var,
							  			:ls_opcion );

EXECUTE USP_PTO_GEN_VAR_PRSP_PROD;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PTO_GEN_VAR_PRSP_PROD: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_PTO_GEN_VAR_PRSP_PROD;

// Verifico si existen registros para mostrar
select count(*)
	into :ll_count
from tt_pto_variaciones;

if ll_count = 0 then
	MessageBox('Aviso', 'No se ha procesado ningun registro, por favor verifique')
	return
end if

lstr_param.long1 = ll_year

OpenSheetWithParm(w_pt506_var_prsp_prod, lstr_param, w_main, 7, Layered!)

end event

type pb_2 from picturebutton within w_pt914_gen_var_prsp_prod
integer x = 1582
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

type st_1 from statictext within w_pt914_gen_var_prsp_prod
integer width = 2565
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
string text = "GENERACION DE VARIACIONES A PARTIR DEL PLAN DE PRODUCCION"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_pt914_gen_var_prsp_prod
integer x = 9
integer y = 152
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

type em_ano from editmask within w_pt914_gen_var_prsp_prod
integer x = 215
integer y = 136
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

type dw_master from u_dw_abc within w_pt914_gen_var_prsp_prod
integer y = 404
integer width = 1957
integer height = 1164
integer taborder = 50
string dataobject = "d_list_prsp_prod_ejec"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
is_dwform = 'tabular'	// tabular, form (default)
end event

