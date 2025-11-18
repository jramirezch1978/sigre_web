$PBExportHeader$w_fi349_conciliacion_no_registrado.srw
forward
global type w_fi349_conciliacion_no_registrado from w_abc
end type
type cb_cancel from commandbutton within w_fi349_conciliacion_no_registrado
end type
type cb_aceptar from commandbutton within w_fi349_conciliacion_no_registrado
end type
type dw_master from u_dw_abc within w_fi349_conciliacion_no_registrado
end type
end forward

global type w_fi349_conciliacion_no_registrado from w_abc
integer width = 2194
integer height = 1016
string title = "Conciliacion de Documentos No Registrado (FI349)"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_cancel cb_cancel
cb_aceptar cb_aceptar
dw_master dw_master
end type
global w_fi349_conciliacion_no_registrado w_fi349_conciliacion_no_registrado

type variables
str_parametros is_param 
end variables

forward prototypes
public subroutine wf_generacion_item ()
end prototypes

public subroutine wf_generacion_item ();Long   ll_item,ll_ano,ll_mes
String ls_ctabco


//
ls_ctabco = dw_master.object.cod_ctabco [1] 
ll_ano    = dw_master.object.ano 		 [1] 
ll_mes    = dw_master.object.mes 		 [1]

select max(item) into :ll_item
  from fin_datos_concil
 where (cod_ctabco = :ls_ctabco) and
 		 (ano			 = :ll_ano	 ) and
		 (mes			 = :ll_mes	 ) ;
		 
if Isnull(ll_item) or ll_item = 0 then 
	ll_item = 1
else
	ll_item = ll_item + 1
end if
		 


dw_master.object.item [1] = ll_item


end subroutine

on w_fi349_conciliacion_no_registrado.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_aceptar=create cb_aceptar
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_aceptar
this.Control[iCurrent+3]=this.dw_master
end on

on w_fi349_conciliacion_no_registrado.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_aceptar)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;
dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente

ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones



//envia parametro
is_param = message.powerobjectparm

//se dispara insert
Triggerevent('ue_insert')
end event

event ue_insert;call super::ue_insert;Long  ll_row



ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

type cb_cancel from commandbutton within w_fi349_conciliacion_no_registrado
integer x = 1733
integer y = 812
integer width = 402
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;Close(Parent)
end event

type cb_aceptar from commandbutton within w_fi349_conciliacion_no_registrado
integer x = 1321
integer y = 812
integer width = 402
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;Boolean lbo_ok = TRUE

dw_master.accepttext( )

dw_master.of_create_log( )

IF dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	//generacion de item
	wf_generacion_item()
	IF dw_master.Update() = -1 THEN	// Grabación de Cabecera de  Asiento
		lbo_ok = FALSE
		Messagebox('Error de Grabación','Se Procedio al Rollback ',exclamation!)
	END IF
END IF	

IF lbo_ok THEN
	lbo_ok = dw_master.of_save_log( )
end if

IF lbo_ok THEN
	Commit ;
	dw_master.ii_update = 0
	Close(Parent)
ELSE
	Rollback ;
END IF
end event

type dw_master from u_dw_abc within w_fi349_conciliacion_no_registrado
integer width = 2171
integer height = 780
string dataobject = "d_abc_concil_mov_no_reg_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2	
ii_ck[3] = 3	
ii_ck[4] = 4

idw_mst = dw_master

end event

event itemchanged;call super::itemchanged;Int 	 li_count = 0
String ls_descripcion = ''

Accepttext()

CHOOSE CASE dwo.name
	CASE 'fecha_doc'
		this.object.tasa_cambio [row] = gnvo_app.of_tasa_cambio( date(data) )

				
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;String 	ls_moneda
Date		ld_hoy

Select cod_moneda
	into :ls_moneda
from banco_cnta
where COD_CTABCO = :is_param.string1;

ld_hoy = Date(gnvo_app.of_fecha_actual())

This.Object.cod_ctabco 	[al_row] = is_param.string1
This.Object.desc_cnta 	[al_row] = is_param.string2
This.Object.ano		  	[al_row] = is_param.longa [1]
This.Object.mes		  	[al_row] = is_param.longa [2]
This.Object.cod_usr	  	[al_row] = gs_user

This.Object.cod_moneda	[al_row] = ls_moneda
This.Object.fecha_doc  	[al_row] = ld_hoy
this.object.tasa_cambio	[al_row] = gnvo_app.of_tasa_cambio(ld_hoy)
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "tipo_doc"
		ls_sql = "select tipo_doc as tipo_doc, " &
				 + "desc_tipo_doc as desc_tipo_doc " &
				 + "from doc_tipo t " &
				 + "where t.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.tipo_doc	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
end choose
end event

