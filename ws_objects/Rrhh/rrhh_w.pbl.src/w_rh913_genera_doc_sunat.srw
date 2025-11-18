$PBExportHeader$w_rh913_genera_doc_sunat.srw
forward
global type w_rh913_genera_doc_sunat from w_prc
end type
type em_mes from editmask within w_rh913_genera_doc_sunat
end type
type st_1 from statictext within w_rh913_genera_doc_sunat
end type
type em_descripcion from editmask within w_rh913_genera_doc_sunat
end type
type cb_origen from commandbutton within w_rh913_genera_doc_sunat
end type
type em_origen from editmask within w_rh913_genera_doc_sunat
end type
type st_2 from statictext within w_rh913_genera_doc_sunat
end type
type st_4 from statictext within w_rh913_genera_doc_sunat
end type
type em_año from editmask within w_rh913_genera_doc_sunat
end type
type cb_1 from commandbutton within w_rh913_genera_doc_sunat
end type
type gb_1 from groupbox within w_rh913_genera_doc_sunat
end type
end forward

global type w_rh913_genera_doc_sunat from w_prc
integer width = 1801
integer height = 568
string title = "(RH493) Genera Documento para Impuestos"
string menuname = "m_only_exit"
em_mes em_mes
st_1 st_1
em_descripcion em_descripcion
cb_origen cb_origen
em_origen em_origen
st_2 st_2
st_4 st_4
em_año em_año
cb_1 cb_1
gb_1 gb_1
end type
global w_rh913_genera_doc_sunat w_rh913_genera_doc_sunat

on w_rh913_genera_doc_sunat.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.em_mes=create em_mes
this.st_1=create st_1
this.em_descripcion=create em_descripcion
this.cb_origen=create cb_origen
this.em_origen=create em_origen
this.st_2=create st_2
this.st_4=create st_4
this.em_año=create em_año
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_mes
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_descripcion
this.Control[iCurrent+4]=this.cb_origen
this.Control[iCurrent+5]=this.em_origen
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.em_año
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.gb_1
end on

on w_rh913_genera_doc_sunat.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_mes)
destroy(this.st_1)
destroy(this.em_descripcion)
destroy(this.cb_origen)
destroy(this.em_origen)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.em_año)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event open;call super::open;date ld_fecha

ld_fecha = date(f_fecha_actual())

em_año.text = string(ld_fecha, 'yyyy')
em_mes.text = string(ld_fecha, 'mm')
end event

type em_mes from editmask within w_rh913_genera_doc_sunat
integer x = 1047
integer y = 212
integer width = 229
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = right!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type st_1 from statictext within w_rh913_genera_doc_sunat
integer x = 722
integer y = 220
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Mes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_descripcion from editmask within w_rh913_genera_doc_sunat
integer x = 663
integer y = 108
integer width = 1042
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_origen from commandbutton within w_rh913_genera_doc_sunat
integer x = 576
integer y = 108
integer width = 87
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql
ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
		  + "nombre AS nombre_origen " &
		  + "FROM origen " &
		  + "WHERE FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_origen.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

type em_origen from editmask within w_rh913_genera_doc_sunat
integer x = 389
integer y = 108
integer width = 183
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_data, ls_null, ls_texto
SetNull(ls_null)

ls_texto = this.text

select nombre
	into :ls_data
from origen
where cod_origen = :ls_texto
  and flag_estado = '1';

if SQLCA.SQLCode = 100 then
	Messagebox('RRHH', "CODIGO DE ORIGEN NO EXISTE O NO ESTA ACTIVO", StopSign!)
	this.text = ls_null
	em_descripcion.text = ls_null
end if

em_descripcion.text = ls_data


end event

type st_2 from statictext within w_rh913_genera_doc_sunat
integer x = 64
integer y = 120
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_rh913_genera_doc_sunat
integer x = 64
integer y = 220
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_año from editmask within w_rh913_genera_doc_sunat
integer x = 389
integer y = 212
integer width = 311
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = right!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type cb_1 from commandbutton within w_rh913_genera_doc_sunat
integer x = 1326
integer y = 200
integer width = 370
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.SetMicroHelp('Procesando Adelanto de Quincena')

String 	ls_origen, ls_mensaje
integer	li_year, li_mes

ls_origen   = string(em_origen.text)
li_year 		= Integer(em_año.text)
li_mes 	   = Integer(em_mes.text) 
	
// Elimino El documento de Pago de quincena
//create or replace procedure usp_rh_gen_doc_pago_SUNAT(
//       asi_origen       in origen.cod_origen%Type       ,
//       ani_year         in number                       ,
//       ani_mes          in number                       ,
//       asi_cod_usr      in usuario.cod_usr%type          
//) is

DECLARE usp_rh_gen_doc_pago_SUNAT PROCEDURE FOR 
	usp_rh_gen_doc_pago_SUNAT(	:ls_origen,
										:li_year,
										:li_mes,
										:gs_user ) ;
EXECUTE usp_rh_gen_doc_pago_SUNAT ;

//busco errores
if sqlca.sqlcode = -1 then
	ls_mensaje = sqlca.sqlerrtext
  
  	Rollback ;
 	Messagebox('Error usp_rh_gen_doc_pago_SUNAT',ls_mensaje)
  	Return
end if

CLOSE usp_rh_gen_doc_pago_SUNAT ;


commit ;
Parent.SetMicroHelp('Proceso ha concluído Satisfactoriamente')

MessageBox('RRHH', 'Proceso de Generación de Impuestos para SUNAT realizado satisfactoriamente')


end event

type gb_1 from groupbox within w_rh913_genera_doc_sunat
integer width = 1742
integer height = 364
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Ingrese Datos"
end type

