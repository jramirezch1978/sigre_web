$PBExportHeader$w_fl917_anular_asiento_adm.srw
forward
global type w_fl917_anular_asiento_adm from w_abc_master_smpl
end type
type cb_1 from commandbutton within w_fl917_anular_asiento_adm
end type
type em_ano from editmask within w_fl917_anular_asiento_adm
end type
type em_mes from editmask within w_fl917_anular_asiento_adm
end type
type st_3 from statictext within w_fl917_anular_asiento_adm
end type
type st_2 from statictext within w_fl917_anular_asiento_adm
end type
type hpb_1 from hprogressbar within w_fl917_anular_asiento_adm
end type
type cb_2 from commandbutton within w_fl917_anular_asiento_adm
end type
end forward

global type w_fl917_anular_asiento_adm from w_abc_master_smpl
integer width = 3237
integer height = 1980
string title = "Anular Asientos de Incentivo de Administ. (FL917)"
string menuname = "m_smpl"
event ue_retrieve ( )
event ue_procesar ( )
cb_1 cb_1
em_ano em_ano
em_mes em_mes
st_3 st_3
st_2 st_2
hpb_1 hpb_1
cb_2 cb_2
end type
global w_fl917_anular_asiento_adm w_fl917_anular_asiento_adm

forward prototypes
public function boolean of_procesar (long al_year, long al_mes, string as_trabajador, string as_tipo_doc, string as_nro_doc, string as_org_asiento, long al_nro_libro, long al_nro_asiento)
end prototypes

event ue_retrieve();integer 	li_mes, li_ano
string 	ls_mensaje

this.event ue_update_Request()

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

SetPointer(HourGlass!)
idw_1.Retrieve(li_ano, li_mes)
idw_1.Visible = True
idw_1.ii_update = 0

SetPointer(Arrow!)
end event

event ue_procesar();Long 		ll_i, ll_count, ll_row, ll_year, ll_mes, &
			ll_nro_libro, ll_nro_asiento
String	ls_trabajador, ls_tipo_doc, ls_nro_doc, ls_org_asiento

if dw_master.ii_update = 1 then
	MessageBox('Aviso', 'No puede procesar mientras existan cambiso pendientes por grabar')
	return
end if

if dw_master.RowCount() = 0 then
	MessageBox('Aviso', 'No hay ningun registro para procesar')
	return	
end if

IF f_row_Processing( dw_master, "tabular") <> true then	
	return
END IF

ll_count = 0
for ll_row = 1 to dw_master.RowCount()
	if dw_master.object.flag [ll_row] = '1' then ll_count ++
next

hpb_1.maxposition = ll_count
hpb_1.minposition = 0
hpb_1.position		= 0
hpb_1.visible 		= true

ll_i = 0
for ll_row = 1 to dw_master.RowCount()
	if dw_master.object.flag [ll_row] = '1' then 
		ll_i ++
		hpb_1.position = ll_i
		
		ls_trabajador 	= dw_master.object.cod_relacion[ll_row]
		ls_tipo_doc		= dw_master.object.tipo_doc	 [ll_row]
		ls_nro_doc		= dw_master.object.nro_doc		 [ll_row]
		ls_org_asiento	= dw_master.object.org_asiento	 [ll_row]
		ll_year			= Long(dw_master.object.ano_asiento	 [ll_row])
		ll_mes			= Long(dw_master.object.mes_asiento	 [ll_row])
		ll_nro_libro	= Long(dw_master.object.libro_asiento	 [ll_row])
		ll_nro_asiento	= Long(dw_master.object.nro_asiento	 [ll_row])		
		
		
		if of_procesar(ll_year, ll_mes, ls_trabajador, ls_tipo_doc, ls_nro_doc, ls_org_asiento, ll_nro_libro, ll_nro_asiento) = false then
			Exit
		end if
		
	end if
next
hpb_1.visible 		= false
this.event ue_retrieve()
end event

public function boolean of_procesar (long al_year, long al_mes, string as_trabajador, string as_tipo_doc, string as_nro_doc, string as_org_asiento, long al_nro_libro, long al_nro_asiento);string ls_mensaje

//create or replace procedure USP_FL_ANULAR_ASIENTO(
//       ani_year             in number,
//       ani_mes              in number,
//       asi_trabajador       in cntas_pagar.cod_relacion%TYPE,
//       asi_tipo_doc         in cntas_pagar.tipo_doc%TYPE,
//       asi_nro_doc          in cntas_pagar.nro_doc%TYPE,
//       asi_origen           in origen.cod_origen%TYPE,
//       ani_libro            in cntbl_asiento_det.nro_libro%TYPE,
//       ani_nro_asiento      in cntbl_asiento_det.nro_asiento%TYPE
//) is

DECLARE USP_FL_ANULAR_ASIENTO PROCEDURE FOR
	USP_FL_ANULAR_ASIENTO( :al_year, 
									  :al_mes, 
									  :as_trabajador,
									  :as_tipo_doc,
									  :as_nro_doc,
									  :as_org_asiento,
									  :al_nro_libro,
									  :al_nro_asiento);

EXECUTE USP_FL_ANULAR_ASIENTO;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_ANULAR_ASIENTO: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

CLOSE USP_FL_ANULAR_ASIENTO;

SetMicrohelp ('Se ha procesado satisfactoriamente al trabajador ' + as_trabajador)
return true
end function

on w_fl917_anular_asiento_adm.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.cb_1=create cb_1
this.em_ano=create em_ano
this.em_mes=create em_mes
this.st_3=create st_3
this.st_2=create st_2
this.hpb_1=create hpb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.em_mes
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.hpb_1
this.Control[iCurrent+7]=this.cb_2
end on

on w_fl917_anular_asiento_adm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.hpb_1)
destroy(this.cb_2)
end on

event resize;call super::resize;hpb_1.width  = newwidth  - hpb_1.x - 10
end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0
em_ano.text = string( f_fecha_Actual(), 'yyyy' )
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = TRUE

dw_master.of_set_flag_replicacion ()

//Verificación de Data en Cabecera de Documento
IF f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
END IF
end event

event ue_insert;//Ancestor Script Overriding
end event

type dw_master from w_abc_master_smpl`dw_master within w_fl917_anular_asiento_adm
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 224
integer width = 2693
integer height = 1112
string dataobject = "d_abc_anular_asiento_adm_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_parametros sl_param

choose case lower(as_columna)
		
	case "confin"
		
		sl_param.tipo			= ''
		sl_param.opcion		= 1
		sl_param.titulo 		= 'Selección de Concepto Financiero'
		sl_param.dw_master	= 'd_lista_grupo_financiero_grd'     //Filtrado para cierto grupo
		sl_param.dw1			= 'd_lista_concepto_financiero_grd'
		sl_param.dw_m			=  This
				
		OpenWithParm( w_abc_seleccion_md, sl_param)
		
		IF not isvalid(message.PowerObjectParm) or IsNull(Message.PowerObjectParm) THEN return
		sl_param = message.PowerObjectParm			
		
		IF sl_param.titulo = 's' THEN 
			this.object.confin [al_row] = sl_param.field_ret[1]
			this.ii_update = 1
		end if		

end choose
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0

	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;String ls_null
Long ll_count

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "confin"
		
		select count(*)
			into :ll_count
		from concepto_financiero
		where confin = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CONCEPTO FINANCIERO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.confin	[row] = ls_null
			return 1
		end if

end choose
end event

type cb_1 from commandbutton within w_fl917_anular_asiento_adm
integer x = 1797
integer y = 28
integer width = 393
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;parent.event dynamic ue_retrieve()
end event

type em_ano from editmask within w_fl917_anular_asiento_adm
integer x = 251
integer y = 28
integer width = 366
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
end type

type em_mes from editmask within w_fl917_anular_asiento_adm
integer x = 846
integer y = 24
integer width = 370
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean spin = true
end type

type st_3 from statictext within w_fl917_anular_asiento_adm
integer x = 78
integer y = 44
integer width = 137
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fl917_anular_asiento_adm
integer x = 635
integer y = 44
integer width = 174
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Mes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type hpb_1 from hprogressbar within w_fl917_anular_asiento_adm
boolean visible = false
integer y = 148
integer width = 2679
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type cb_2 from commandbutton within w_fl917_anular_asiento_adm
integer x = 2190
integer y = 28
integer width = 393
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;Parent.event dynamic ue_procesar()
end event

