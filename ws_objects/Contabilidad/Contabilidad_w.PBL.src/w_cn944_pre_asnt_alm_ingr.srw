$PBExportHeader$w_cn944_pre_asnt_alm_ingr.srw
forward
global type w_cn944_pre_asnt_alm_ingr from w_prc
end type
type cbx_1 from checkbox within w_cn944_pre_asnt_alm_ingr
end type
type st_7 from statictext within w_cn944_pre_asnt_alm_ingr
end type
type dw_origen from datawindow within w_cn944_pre_asnt_alm_ingr
end type
type sle_libro from singlelineedit within w_cn944_pre_asnt_alm_ingr
end type
type st_6 from statictext within w_cn944_pre_asnt_alm_ingr
end type
type ddlb_tipo_alm from dropdownlistbox within w_cn944_pre_asnt_alm_ingr
end type
type st_5 from statictext within w_cn944_pre_asnt_alm_ingr
end type
type sle_mes from singlelineedit within w_cn944_pre_asnt_alm_ingr
end type
type sle_ano from singlelineedit within w_cn944_pre_asnt_alm_ingr
end type
type cb_cancelar from commandbutton within w_cn944_pre_asnt_alm_ingr
end type
type cb_generar from commandbutton within w_cn944_pre_asnt_alm_ingr
end type
type st_4 from statictext within w_cn944_pre_asnt_alm_ingr
end type
type st_2 from statictext within w_cn944_pre_asnt_alm_ingr
end type
type st_1 from statictext within w_cn944_pre_asnt_alm_ingr
end type
type gb_1 from groupbox within w_cn944_pre_asnt_alm_ingr
end type
end forward

global type w_cn944_pre_asnt_alm_ingr from w_prc
integer width = 1646
integer height = 1184
string title = "[CN944] Generación de Pre-Asientos de Almacenes"
string menuname = "m_prc"
boolean maxbox = false
boolean resizable = false
boolean center = true
cbx_1 cbx_1
st_7 st_7
dw_origen dw_origen
sle_libro sle_libro
st_6 st_6
ddlb_tipo_alm ddlb_tipo_alm
st_5 st_5
sle_mes sle_mes
sle_ano sle_ano
cb_cancelar cb_cancelar
cb_generar cb_generar
st_4 st_4
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_cn944_pre_asnt_alm_ingr w_cn944_pre_asnt_alm_ingr

on w_cn944_pre_asnt_alm_ingr.create
int iCurrent
call super::create
if this.MenuName = "m_prc" then this.MenuID = create m_prc
this.cbx_1=create cbx_1
this.st_7=create st_7
this.dw_origen=create dw_origen
this.sle_libro=create sle_libro
this.st_6=create st_6
this.ddlb_tipo_alm=create ddlb_tipo_alm
this.st_5=create st_5
this.sle_mes=create sle_mes
this.sle_ano=create sle_ano
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_4=create st_4
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.st_7
this.Control[iCurrent+3]=this.dw_origen
this.Control[iCurrent+4]=this.sle_libro
this.Control[iCurrent+5]=this.st_6
this.Control[iCurrent+6]=this.ddlb_tipo_alm
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.sle_mes
this.Control[iCurrent+9]=this.sle_ano
this.Control[iCurrent+10]=this.cb_cancelar
this.Control[iCurrent+11]=this.cb_generar
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.gb_1
end on

on w_cn944_pre_asnt_alm_ingr.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.st_7)
destroy(this.dw_origen)
destroy(this.sle_libro)
destroy(this.st_6)
destroy(this.ddlb_tipo_alm)
destroy(this.st_5)
destroy(this.sle_mes)
destroy(this.sle_ano)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;call super::open;String ls_ano, ls_mes, ls_nro_libro
Long ll_nro_libro
// Proceso CANI
ls_ano = string( gnvo_app.of_fecha_actual(), 'yyyy' )
ls_mes = string( gnvo_app.of_fecha_actual(), 'mm' )

sle_ano.text = ls_ano
sle_mes.text = ls_mes

dw_origen.SetTransObject(SQLCA)
dw_origen.Retrieve()

dw_origen.InsertRow(0)
dw_origen.object.origen[1] = gs_origen


end event

type cbx_1 from checkbox within w_cn944_pre_asnt_alm_ingr
integer x = 457
integer y = 512
integer width = 366
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Elegir Mes"
boolean checked = true
boolean lefttext = true
end type

event clicked;if this.checked then
	sle_mes.enabled = true
else
	sle_mes.enabled = false
end if
end event

type st_7 from statictext within w_cn944_pre_asnt_alm_ingr
integer x = 457
integer y = 312
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_origen from datawindow within w_cn944_pre_asnt_alm_ingr
integer x = 841
integer y = 304
integer width = 256
integer height = 80
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_origen_ff"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type sle_libro from singlelineedit within w_cn944_pre_asnt_alm_ingr
event ue_dobleclick pbm_lbuttondblclk
integer x = 841
integer y = 712
integer width = 192
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT trim(to_char(nro_libro)) AS CODIGO, " &
		 + "desc_libro AS DESCRIPCION " &
		 + "FROM cntbl_libro " &
		 + "ORDER BY nro_libro " 

//ls_sql = "SELECT d.tipo_doc AS CODIGO, " &
//		 + "d.desc_tipo_doc AS DESCRIPCION " &
//		 + "FROM doc_tipo d " 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data,'1') 

if ls_codigo <> '' then
	this.text   = ls_codigo
// sle_1.text	= ls_data
end if



end event

type st_6 from statictext within w_cn944_pre_asnt_alm_ingr
integer x = 457
integer y = 620
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Almacen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_tipo_alm from dropdownlistbox within w_cn944_pre_asnt_alm_ingr
integer x = 841
integer y = 604
integer width = 430
integer height = 328
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"Materiales                                  M","Sub Productos                           S","Materia Prima                             P","Prod. Terminado                        T"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;string ls_tipo_alm, ls_desc_libro
Integer li_count, li_nro_libro



try 
	ls_tipo_alm 	= Right(trim(ddlb_Tipo_alm.text),1)
	
	if ls_tipo_alm = 'M' then
		li_nro_libro = Integer(gnvo_app.of_get_parametro( "LIBRO_ALM_MAT", "16"))
		ls_desc_libro = 'MOVIMIENTOS DE ALMACEN MATERIALES'
	elseif ls_tipo_alm = 'P' then
		li_nro_libro = Integer(gnvo_app.of_get_parametro( "LIBRO_ALM_MP", "19"))
		ls_desc_libro = 'MOVIMIENTOS DE ALMACEN DE MATERIA PRIMA'
	elseif ls_tipo_alm = 'T' then
		li_nro_libro = Integer(gnvo_app.of_get_parametro( "LIBRO_ALM_PPTT", "23"))
		ls_desc_libro = 'MOVIMIENTOS PRODUCTOS TERMINADOS'
	elseif ls_tipo_alm = 'S' then
		li_nro_libro = Integer(gnvo_app.of_get_parametro( "LIBRO_ALM_SUB_PRODUCTOS", "24"))
		ls_desc_libro = 'MOVIMIENTOS DE SUB PRODUCTOS'
	end if
	
	select count(*)
	  into :li_count
	from cntbl_libro cl
	where cl.nro_libro = :li_nro_libro;
	
	if li_count = 0 then
		insert into cntbl_libro(
			nro_libro, desc_libro, num_provisional)
		values(
			:li_nro_libro, :ls_desc_libro, 1);
	end if
	
	sle_libro.text = string(li_nro_libro)
	
catch ( Exception ex )
	MessageBox('Exception', 'Ha ocurrido una expception: ' + ex.getMessage(), StopSign!)
end try
end event

type st_5 from statictext within w_cn944_pre_asnt_alm_ingr
integer x = 256
integer y = 112
integer width = 1134
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "de ALMACENES"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_cn944_pre_asnt_alm_ingr
integer x = 841
integer y = 508
integer width = 192
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_ano from singlelineedit within w_cn944_pre_asnt_alm_ingr
integer x = 841
integer y = 404
integer width = 192
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_cn944_pre_asnt_alm_ingr
integer x = 882
integer y = 884
integer width = 302
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;close(parent)
end event

type cb_generar from commandbutton within w_cn944_pre_asnt_alm_ingr
integer x = 521
integer y = 884
integer width = 302
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Long		ll_year, ll_mes, ll_nro_libro
string  	ls_msj, ls_tipo_alm, ls_origen
dateTime	ldt_inicio, ldt_fin
Decimal	ldc_dias

ll_year 			= Long(sle_ano.text)
ll_nro_libro 	= Long(sle_libro.text)
ls_tipo_alm 	= Right(trim(ddlb_Tipo_alm.text),1)
ls_origen 		= dw_origen.object.origen[1]


if cbx_1.checked then
	ll_mes 			= Long(sle_mes.text)
else
	ll_mes 			= -1
end if

// Generacion de asientos contables de almacen de materiales
/*
	CREATE OR REPLACE PROCEDURE usp_cnt_asiento_almacen(
			 ani_year           in number,
			 ani_mes            in number,
			 asi_origen         in origen.cod_origen%TYPE,
			 asi_usuario        in usuario.cod_usr%TYPE,
			 asi_tipo_alm       in almacen.flag_tipo_almacen%TYPE,
			 ani_nro_libro      in cntbl_libro.nro_libro%TYPE
	) IS
*/

ldt_inicio = gnvo_app.of_fecha_actual()

DECLARE usp_cnt_asiento_almacen PROCEDURE FOR 
	usp_cnt_asiento_almacen ( 	:ll_year, 
								 		:ll_mes, 
								 		:ls_origen, 
								 		:gs_user, 
								 		:ls_tipo_alm, 
								 		:ll_nro_libro ) ;
								 
EXECUTE usp_cnt_asiento_almacen  ;

IF sqlca.sqlcode = -1 THEN
	ls_msj = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error usp_cnt_asiento_almacen', ls_msj, StopSign! )
	return
END IF

Close usp_cnt_asiento_almacen;

ldt_fin = gnvo_app.of_fecha_actual()

select :ldt_fin - :ldt_inicio
	into :ldc_dias
from dual;

MessageBox ('Atención', "Proceso de generación de Asientos de Almacen concluido satisfactoriamente " + string(round(ldc_dias * 24 * 60,2)) + " minutos")

		

end event

type st_4 from statictext within w_cn944_pre_asnt_alm_ingr
integer x = 457
integer y = 720
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Libro contable :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn944_pre_asnt_alm_ingr
integer x = 457
integer y = 412
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn944_pre_asnt_alm_ingr
integer x = 256
integer y = 16
integer width = 1134
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generación de pre asientos"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn944_pre_asnt_alm_ingr
integer x = 187
integer y = 232
integer width = 1248
integer height = 576
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos Generales"
end type

