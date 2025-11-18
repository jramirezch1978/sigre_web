$PBExportHeader$w_ope905_balanza_prod_x_dia.srw
forward
global type w_ope905_balanza_prod_x_dia from w_prc
end type
type hpb_1 from hprogressbar within w_ope905_balanza_prod_x_dia
end type
type cb_1 from commandbutton within w_ope905_balanza_prod_x_dia
end type
type uo_1 from u_ingreso_fecha within w_ope905_balanza_prod_x_dia
end type
type gb_1 from groupbox within w_ope905_balanza_prod_x_dia
end type
end forward

global type w_ope905_balanza_prod_x_dia from w_prc
integer width = 1426
integer height = 492
string title = "Transferencia de Balanza (OPE905)"
string menuname = "m_salir"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
hpb_1 hpb_1
cb_1 cb_1
uo_1 uo_1
gb_1 gb_1
end type
global w_ope905_balanza_prod_x_dia w_ope905_balanza_prod_x_dia

type variables


end variables

forward prototypes
public subroutine wf_data_acces ()
end prototypes

public subroutine wf_data_acces ();String   	ls_tarjeta ,ls_producto,ls_fecha1, ls_fecha2,ls_hora, &
				ls_msj_err,ls_nada
Datetime 	ldt_fecha_hora 
Date			ld_fecha
Decimal  	ldc_peso 
Long        ll_bal,ll_count,ll_i
Boolean		lb_ret = true
transaction ltr_balanza
u_ds_base	lds_balanza
str_parametros lstr_rep
w_rpt_preview lw_1


ltr_balanza = create transaction

ld_fecha 	= uo_1.of_get_fecha( )
ls_fecha1	= string(ld_fecha, 'd/mm/yyyy')
ls_fecha2	= string(ld_fecha, 'dd/mm/yyyy')

// Profile balanza
ltr_balanza.DBMS = "ODBC"
ltr_balanza.AutoCommit = False
ltr_balanza.DBParm = "ConnectString='DSN=balanza;UID=;PWD='"

Connect  using ltr_balanza;

IF ltr_balanza.sqlcode <> 0 THEN
   MessageBox ("No Pude Conectar a la Base de Datos de Balanza", ltr_balanza.sqlerrtext)
	disConnect  using ltr_balanza;
	destroy ltr_balanza
	return
END IF

lds_balanza = create u_ds_base
lds_balanza.DataObject = 'd_datos_balanza_tbl'
lds_balanza.SetTransObject( ltr_balanza)
lds_balanza.retrieve( ls_fecha1, ls_fecha2 )

//Verifico cuantos registros tiene
ll_count = lds_balanza.rowcount( )

if ll_count = 0 then 
	Messagebox('Aviso','No se Encuentra Informacion para el día ' + ls_fecha1 + ',Verifique!')
	disConnect  using ltr_balanza;
	destroy lds_balanza
	destroy ltr_balanza
	return
end if	

// Ahora leo el datastore
for ll_i = 1 to ll_count 
	// Actualizo la barra de progreso
	hpb_1.Position = Integer(ll_i/ll_count*100)
	
	// Continua proceso
	
	ls_tarjeta  = Trim(lds_balanza.object.codtjt[ll_i])
	ls_producto = Trim(lds_balanza.object.codprd[ll_i])
	ldc_peso		= Dec(lds_balanza.object.Peso[ll_i])
	ll_bal		= Long(lds_balanza.object.numblz[ll_i])
	
	ldt_fecha_hora = Datetime(Date(lds_balanza.object.fecha[ll_i]), &
						 time(lds_balanza.object.hora[ll_i]))
	
	Insert Into tt_ope_psj_blz (codtjt,codprd,fecha,peso,codblz)
	Values (:ls_tarjeta,:ls_producto,:ldt_fecha_hora,:ldc_peso,:ll_bal ) 
	using sqlca ;
	
	IF SQLCA.SQLCode = -1 THEN 
		ls_msj_err = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al insertar en tt_ope_psj_blz', ls_msj_err)
		disConnect  using ltr_balanza;
		destroy lds_balanza
		destroy ltr_balanza
		return
	END IF
	
	commit;

next

//destruyo la transaccion y el datastore porque ya no los necesito
disConnect  using ltr_balanza;

destroy lds_balanza
destroy ltr_balanza


//ejecuta procedimiento de pesaje_balanza
DECLARE usp_ope_pesaje_balanza PROCEDURE FOR 
		usp_ope_pesaje_balanza(:ls_nada);
EXECUTE usp_ope_pesaje_balanza ;
	
IF SQLCA.SQLCode = -1 THEN
	ls_msj_err = SQLCA.SQLErrText
	ROLLBACK;
   MessageBox("Error en usp_ope_pesaje_balanza", ls_msj_err)
	return
END IF

CLOSE usp_ope_pesaje_balanza;

//Verifico si han habido errores
select count(*)
  into :ll_count
  from tt_error;

if ll_count > 0 then
	MessageBox('Aviso', 'Se han encontrado errores al momento de procesar los datos de la balanza')
	
	lstr_rep.dw1 = 'd_rpt_errores_tbl'
	lstr_rep.titulo = 'Errores al momento de pasar datos de balanza'
	
	OpenSheetWithParm(lw_1, lstr_rep, w_main, 0, Layered!)			
	return
end if

//ejecuta procedimeinto de asigancion de labores
DECLARE usp_ope_dist_trab_dstjo PROCEDURE FOR 
		usp_ope_dist_trab_dstjo(:ld_fecha,
										:gs_origen,
										:gs_user);
EXECUTE usp_ope_dist_trab_dstjo ;
	
IF SQLCA.SQLCode = -1 THEN
	ls_msj_err = SQLCA.SQLErrText
	ROLLBACK;
   MessageBox("Error en usp_ope_dist_trab_dstjo", ls_msj_err)
	return
END IF

CLOSE usp_ope_dist_trab_dstjo;

COMMIT;

MessageBox('Aviso', 'Datos Procesados Satisfactoriamente')




end subroutine

on w_ope905_balanza_prod_x_dia.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.hpb_1=create hpb_1
this.cb_1=create cb_1
this.uo_1=create uo_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_ope905_balanza_prod_x_dia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.hpb_1)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.gb_1)
end on

type hpb_1 from hprogressbar within w_ope905_balanza_prod_x_dia
integer y = 252
integer width = 1399
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 1
end type

type cb_1 from commandbutton within w_ope905_balanza_prod_x_dia
integer x = 887
integer y = 68
integer width = 347
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;SetPointer(HourGlass!)
wf_data_acces ()
SetPointer(Arrow!)
end event

type uo_1 from u_ingreso_fecha within w_ope905_balanza_prod_x_dia
integer x = 82
integer y = 96
integer taborder = 30
end type

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:') // para seatear el titulo del boton
of_set_fecha(today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type gb_1 from groupbox within w_ope905_balanza_prod_x_dia
integer width = 823
integer height = 240
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Fechas"
end type

