$PBExportHeader$w_sig765_proyeccion_vs_real_azucar.srw
forward
global type w_sig765_proyeccion_vs_real_azucar from w_cns_grf
end type
type dw_detalle from u_dw_cns within w_sig765_proyeccion_vs_real_azucar
end type
type cb_proceso from commandbutton within w_sig765_proyeccion_vs_real_azucar
end type
type sle_ano from singlelineedit within w_sig765_proyeccion_vs_real_azucar
end type
type st_1 from statictext within w_sig765_proyeccion_vs_real_azucar
end type
end forward

global type w_sig765_proyeccion_vs_real_azucar from w_cns_grf
integer width = 2048
integer height = 2360
string title = "Produccion Planeada vs Real"
boolean minbox = false
event ue_proceso ( )
dw_detalle dw_detalle
cb_proceso cb_proceso
sle_ano sle_ano
st_1 st_1
end type
global w_sig765_proyeccion_vs_real_azucar w_sig765_proyeccion_vs_real_azucar

forward prototypes
public function integer of_get_parametros (ref string as_clase, ref string as_oper_ing_prod)
end prototypes

event ue_proceso();Date 	 	ld_fecha_ini, ld_fecha_fin
String 	ls_tipo, ls_texto, ls_ano, ls_mov_tipo, ls_clase
String	ls_find, ls_mes
Long		ll_rc, ll_tproyect,ll_tcana,ll_tazucar,ll_row
Long		ll_rcana, ll_razucar, ll_rproy
Integer	li_x
Datastore	lds_proyectado, lds_cana, lds_azucar

dw_detalle.Reset()
ls_ano = sle_ano.text
ld_fecha_ini = Date('01/01/'+ls_ano)
ld_fecha_fin = Date('31/12/'+ls_ano)
ls_tipo = 'T'

ll_rc = of_get_parametros(ls_clase, ls_mov_tipo)

// Datastore Resumen Proyectado
lds_proyectado = CREATE Datastore
lds_proyectado.Dataobject = 'd_cana_azucar_proy_tbl'
ll_rc = lds_proyectado.SetTransObject(SQLCA)
// Datastore Resumen Pesadas
lds_cana = CREATE Datastore
lds_cana.Dataobject = 'd_cana_tbl'
ll_rc = lds_cana.SetTransObject(SQLCA)
// Datastore Resumen Azucar Producida
lds_azucar = CREATE Datastore
lds_azucar.Dataobject = 'd_azucar_prod_tbl'
ll_rc = lds_azucar.SetTransObject(SQLCA)

// Procedure de Proyeccion
DECLARE pb_usp_prog_cosecha PROCEDURE FOR USP_PROG_COSECHA  
        ( :ld_fecha_ini,:ld_fecha_fin,:ls_tipo ) ;
Execute pb_usp_prog_cosecha;

IF sqlca.sqlcode = -1 THEN
	THIS.SetMicroHelp("Store procedure <<<usp_prog_cosecha>>> no funciona!!!")
	MessageBox('Falló Store Procedure', 'Vuelva a intentarlo' + '~n~rusp_prog_cosecha') 
Else
	THIS.SetMicroHelp("Store procedure ok")
   // carga dw_detalle
	ll_tproyect = lds_proyectado.Retrieve()
	ll_tcana = lds_cana.Retrieve(ld_fecha_ini, ld_fecha_fin)
	ll_tazucar = lds_azucar.Retrieve(ls_clase,ls_mov_tipo,ld_fecha_ini,ld_fecha_fin)
	// Consolidar Datos
	FOR li_x = 1 TO 12
		ll_row = dw_detalle.InsertRow(0)
		ls_mes = String(li_x)    //lds_proyectado.GetItemString(li_x,'mes')
			ll_rc = dw_detalle.SetItem(ll_row,'mes',ls_mes)
		// Leer Proyectado
		ls_find = "mes = '" + ls_mes + "'"
		ll_rproy = lds_proyectado.Find(ls_find, 1, ll_tproyect)
		IF ll_rproy > 0 THEN 
			ll_rc = dw_detalle.SetItem(ll_row,'cana_proy',lds_proyectado.GetItemDecimal(ll_rproy,'cana'))
			ll_rc = dw_detalle.SetItem(ll_row,'azucar_proy',lds_proyectado.GetItemDecimal(ll_rproy,'azucar'))
		END IF	
		// Leer Caña Real
		ls_find = "mes = '" + ls_mes + "'"
		ll_rcana = lds_cana.Find(ls_find, 1, ll_tcana)
		IF ll_rcana > 0 THEN ll_rc = dw_detalle.SetItem(ll_row,'cana_real',lds_cana.GetItemDecimal(ll_rcana,'cana'))
		// Leer Azucar Real
		ll_razucar = lds_azucar.Find(ls_find, 1, ll_tazucar)
		IF ll_razucar > 0 THEN ll_rc = dw_detalle.SetItem(ll_row,'azucar_real',lds_azucar.GetItemDecimal(ll_razucar,'azucar'))
	NEXT
End If





end event

public function integer of_get_parametros (ref string as_clase, ref string as_oper_ing_prod);Long		ll_rc = 0
String	ls_clase


SELECT CLASE_PROD_TERM
  INTO :as_clase
  FROM SIGPARAM
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer SIGPARAM')
	lL_rc = -1
END IF

SELECT OPER_ING_PROD
  INTO :as_oper_ing_prod
  FROM LOGPARAM
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -2
END IF

RETURN ll_rc

end function

on w_sig765_proyeccion_vs_real_azucar.create
int iCurrent
call super::create
this.dw_detalle=create dw_detalle
this.cb_proceso=create cb_proceso
this.sle_ano=create sle_ano
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detalle
this.Control[iCurrent+2]=this.cb_proceso
this.Control[iCurrent+3]=this.sle_ano
this.Control[iCurrent+4]=this.st_1
end on

on w_sig765_proyeccion_vs_real_azucar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detalle)
destroy(this.cb_proceso)
destroy(this.sle_ano)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;//dw_master.SetTransObject(SQLCA)
//dw_detalle.SetTransObject(SQLCA)

sle_ano.Text = String(Year(Today()))
end event

type st_etiqueta from w_cns_grf`st_etiqueta within w_sig765_proyeccion_vs_real_azucar
integer x = 946
integer y = 256
end type

type dw_master from w_cns_grf`dw_master within w_sig765_proyeccion_vs_real_azucar
integer x = 14
integer y = 72
integer width = 1970
integer height = 1144
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1 
end event

type dw_detalle from u_dw_cns within w_sig765_proyeccion_vs_real_azucar
integer x = 14
integer y = 1268
integer width = 1979
integer height = 860
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cana_azucar_proy_real_tbl"
end type

event constructor;call super::constructor;ii_ck[1] = 1   
end event

type cb_proceso from commandbutton within w_sig765_proyeccion_vs_real_azucar
integer x = 526
integer width = 334
integer height = 56
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;PARENT.EVENT ue_proceso()
end event

type sle_ano from singlelineedit within w_sig765_proyeccion_vs_real_azucar
integer x = 165
integer y = 4
integer width = 210
integer height = 60
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_sig765_proyeccion_vs_real_azucar
integer x = 9
integer y = 4
integer width = 165
integer height = 56
boolean bringtotop = true
integer textsize = -8
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

