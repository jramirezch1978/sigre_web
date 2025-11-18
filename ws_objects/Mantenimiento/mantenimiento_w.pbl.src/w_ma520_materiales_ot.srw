$PBExportHeader$w_ma520_materiales_ot.srw
forward
global type w_ma520_materiales_ot from w_report_smpl
end type
type st_1 from statictext within w_ma520_materiales_ot
end type
type sle_ot from singlelineedit within w_ma520_materiales_ot
end type
type cb_procesar from commandbutton within w_ma520_materiales_ot
end type
type pb_1 from picturebutton within w_ma520_materiales_ot
end type
end forward

global type w_ma520_materiales_ot from w_report_smpl
integer width = 1984
integer height = 1128
string title = "Consulta de Articulos Faltantes por OT"
string menuname = "m_cns"
long backcolor = 12632256
st_1 st_1
sle_ot sle_ot
cb_procesar cb_procesar
pb_1 pb_1
end type
global w_ma520_materiales_ot w_ma520_materiales_ot

type variables
String	is_doc
end variables

forward prototypes
public function long of_get_param (ref string as_doc)
end prototypes

public function long of_get_param (ref string as_doc);Long	ll_rc = 0

SELECT DOC_OT
  INTO :as_doc
  FROM PROD_PARAM
 WHERE RECKEY = '1'  ;
	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer Prod_Param')
	ll_rc = -1
END IF

RETURN ll_rc
end function

on w_ma520_materiales_ot.create
int iCurrent
call super::create
if this.MenuName = "m_cns" then this.MenuID = create m_cns
this.st_1=create st_1
this.sle_ot=create sle_ot
this.cb_procesar=create cb_procesar
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_ot
this.Control[iCurrent+3]=this.cb_procesar
this.Control[iCurrent+4]=this.pb_1
end on

on w_ma520_materiales_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_ot)
destroy(this.cb_procesar)
destroy(this.pb_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_report.Object.Datawindow.Print.Orientation = 1

// lectura de parametros
of_get_param(is_doc)


end event

type dw_report from w_report_smpl`dw_report within w_ma520_materiales_ot
integer x = 14
integer y = 152
integer width = 1897
integer height = 768
string dataobject = "d_articulo_mov_proy_ot"
end type

type st_1 from statictext within w_ma520_materiales_ot
integer x = 32
integer y = 36
integer width = 425
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro de Orden :"
boolean focusrectangle = false
end type

type sle_ot from singlelineedit within w_ma520_materiales_ot
integer x = 471
integer y = 36
integer width = 507
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type cb_procesar from commandbutton within w_ma520_materiales_ot
integer x = 1170
integer y = 36
integer width = 402
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Datastore	lds_mov
Long			ll_rc, ll_mov, ll_x, ll_row
String		ls_articulo
Date			ld_fecha
Decimal		ldc_saldo_fisico, ldc_cantidad

idw_1.Visible = TRUE
idw_1.Reset()

// lectura de movimientos de la OT
lds_mov = Create Datastore
lds_mov.DataObject = 'd_articulo_mov_proy_ot'
ll_rc = lds_mov.SetTransObject(SQLCA)
ll_mov = lds_mov.Retrieve(is_doc, sle_ot.Text,gs_empresa,gs_user)
IF ll_mov < 1 THEN GOTO SALIDA


FOR ll_x = 1 TO ll_mov
	
	ls_articulo = lds_mov.GetItemString(ll_x, 'cod_art')
	ld_fecha    = Date(lds_mov.GetItemDateTime(ll_x, 'fec_proyect'))
	
	SELECT SLDO_TOTAL
		INTO 	:ldc_saldo_fisico
		FROM ARTICULO
		WHERE COD_ART = :ls_articulo ;
	
	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox(SQLCA.SQLErrText, 'No se pudo leer Articulos')
		ll_rc = -1
		GOTO SALIDA
	END IF

	SELECT sum( ("ARTICULO_MOV_PROY"."CANT_PROYECT" - "ARTICULO_MOV_PROY"."CANT_PROCESADA") * "ARTICULO_MOV_TIPO"."FACTOR_SLDO_TOTAL")  
   	INTO :ldc_cantidad  
   	FROM "ARTICULO_MOV_PROY",   
    	     "ARTICULO_MOV_TIPO"  
  	WHERE ( "ARTICULO_MOV_TIPO"."TIPO_MOV" = "ARTICULO_MOV_PROY"."TIPO_MOV" ) and  
         ( ( "ARTICULO_MOV_PROY"."COD_ART" = :ls_articulo ) AND  
         ( "ARTICULO_MOV_PROY"."FEC_PROYECT" <= :ld_fecha ) AND  
         ( "ARTICULO_MOV_PROY"."CANT_PROYECT" > "ARTICULO_MOV_PROY"."CANT_PROCESADA" ) AND  
         ( "ARTICULO_MOV_PROY"."FLAG_ESTADO" in ( '1', '3' ) ) )   ;

	IF SQLCA.SQLCODE <> 0 THEN
		MessageBox(SQLCA.SQLErrText, 'No se pudo leer Movimientos Proyectados')
		ll_rc = -1
		GOTO SALIDA
	END IF
	
	IF (ldc_saldo_fisico + ldc_cantidad) < 0 THEN
		ll_rc  = lds_mov.RowsCopy(ll_x, ll_x, Primary!, dw_report, 9999999, Primary!)
	END IF
NEXT


SALIDA:
Destroy lds_mov

end event

type pb_1 from picturebutton within w_ma520_materiales_ot
integer x = 1056
integer y = 36
integer width = 101
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Search!"
alignment htextalign = left!
end type

event clicked;String ls_ot_adm
str_seleccionar lstr_seleccionar



lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql ='SELECT ORDEN_TRABAJO.NRO_ORDEN AS NRO_ORDEN,'& 
								      +'ORDEN_TRABAJO.FEC_INICIO AS FECHA_INICIO,'&
										+'ORDEN_TRABAJO.CENCOS_RSP AS CENCOS_RESP '&
								      +'FROM ORDEN_TRABAJO '&

 

										  
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
   sle_ot.text = lstr_seleccionar.param1[1]
END IF
end event

