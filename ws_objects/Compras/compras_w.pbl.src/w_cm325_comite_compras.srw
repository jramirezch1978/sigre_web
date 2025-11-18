$PBExportHeader$w_cm325_comite_compras.srw
forward
global type w_cm325_comite_compras from w_abc
end type
type rb_3 from radiobutton within w_cm325_comite_compras
end type
type rb_2 from radiobutton within w_cm325_comite_compras
end type
type rb_1 from radiobutton within w_cm325_comite_compras
end type
type cbx_1 from checkbox within w_cm325_comite_compras
end type
type cb_1 from commandbutton within w_cm325_comite_compras
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm325_comite_compras
end type
type st_3 from statictext within w_cm325_comite_compras
end type
type st_2 from statictext within w_cm325_comite_compras
end type
type st_1 from statictext within w_cm325_comite_compras
end type
type dw_3 from u_dw_abc within w_cm325_comite_compras
end type
type dw_2 from u_dw_abc within w_cm325_comite_compras
end type
type dw_1 from u_dw_abc within w_cm325_comite_compras
end type
type st_horizontal from statictext within w_cm325_comite_compras
end type
type st_both from statictext within w_cm325_comite_compras
end type
type st_vertical from statictext within w_cm325_comite_compras
end type
end forward

global type w_cm325_comite_compras from w_abc
integer width = 3355
integer height = 1944
string title = "Comite de Compras (CM325)"
string menuname = "m_save_exit"
event ue_flag_estado ( string as_estado )
event ue_reporte_ot ( )
event ue_filtrar_materiales ( )
event ue_reporte_aprobacion ( )
event ue_flag_todo ( string as_estado )
event ue_retrieve ( )
event ue_reporte_oper_sec ( )
event ue_validar_prsp ( string as_estado )
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
cbx_1 cbx_1
cb_1 cb_1
uo_fecha uo_fecha
st_3 st_3
st_2 st_2
st_1 st_1
dw_3 dw_3
dw_2 dw_2
dw_1 dw_1
st_horizontal st_horizontal
st_both st_both
st_vertical st_vertical
end type
global w_cm325_comite_compras w_cm325_comite_compras

type variables
Dragobject	idrg_TopLeft	//Reference to the Top Left control
Dragobject	idrg_TopRight	//Reference to the Top Right control
Dragobject	idrg_Bottom	//Reference to the Bottom  control
Boolean		ib_Debug=False	//Debug mode
Long		il_HiddenColor=0	//Bar hidden color to match the window background
Constant Integer	cii_BarThickness=20	//Bar Thickness
Constant Integer	cii_WindowBorder=15//Window border to be used on all sides
Constant Integer	cii_WindowTop = 81	//The virtual top of the window

string is_dw
end variables

forward prototypes
public subroutine of_resizebars ()
public subroutine of_resizepanels ()
public subroutine of_refreshbars ()
public subroutine of_compras_sug (string as_almacen)
public subroutine of_compras_sug ()
public subroutine of_ruptura_stock ()
public function boolean of_only_compras_sug (string as_almacen)
public subroutine of_compras_sug (string as_cod_art, string as_almacen, date ad_fecha)
public function boolean of_procesa_amp (string as_cod_origen, long al_nro_mov, string as_new_flag_estado, decimal ldc_ult_prec_comp, string as_cencos, string as_cnta_prsp, date ad_fecha, ref string as_old_flag_estado)
public function boolean of_graba_dw3 ()
public function boolean of_estado_amp (string as_origen, long al_nro_mov, string as_new_flag_estado, decimal adc_ult_prec_cmp, string as_cencos, string as_cnta_prsp, date ad_fecha, string as_flag_prsp)
end prototypes

event ue_flag_estado(string as_estado);string 	ls_nro_aprob, ls_oper_sec, ls_verifica_prsp
Long 		ll_row, ll_i, ll_find, ll_year
DateTime	ldt_fec_aprob

if cbx_1.checked then
	ls_verifica_prsp = '1'
else
	ls_verifica_prsp = '0'
end if

ll_year = Long(string(Date(Today()), 'yyyy'))

choose case is_dw
	case 'dw_1'
		if dw_1.il_row = 0 then
			MessageBox('Aviso', 'Debe Seleccionar registro en un OT_APROBACION')
			return
		end if
		
		ll_row = dw_1.il_row
		ls_nro_aprob = dw_1.object.nro_aprob[ll_row]
		// Aprobando la cabecera
		dw_1.object.flag_activacion[ll_row] = as_estado
		dw_1.object.usr_aprob 		[ll_row] = gs_user
		dw_1.object.fecha_aprob		[ll_row] = f_fecha_actual()
		dw_1.ii_update = 1
		
		// Aprobando todas las operaciones, solo las que estan pendientes
		dw_2.Retrieve(ls_nro_aprob)
		for ll_i = 1 to dw_2.RowCount()
			dw_2.object.flag_Estado[ll_i] = as_estado  //Aprobado
			dw_2.ii_update = 1
		next
		
		// Aprobando todos los articulos, solo las que estan pendientes
		dw_3.SetFilter('')
		dw_3.Filter()
		dw_3.Retrieve(ls_nro_aprob)
		ldt_fec_aprob = f_fecha_actual()
		
		for ll_i = 1 to dw_3.RowCount()
			if Long(String(Date(dw_3.object.fec_proyect[ll_i]), 'yyyy')) <= ll_year then
				dw_3.object.flag_verifica_prsp[ll_i] = ls_verifica_prsp
			end if
			
			dw_3.object.flag_Estado		[ll_i] = as_estado  //Aprobado
			dw_3.object.fec_proy_aprob	[ll_i] = ldt_fec_aprob
			dw_3.ii_update = 1
			
		next
		
	case 'dw_2'
		ll_row = dw_2.GetSelectedRow(0)
		ldt_fec_aprob = f_fecha_actual()
		
		if ll_row > 0 then
			ls_nro_aprob = dw_2.object.nro_aprob[ll_row]
			dw_3.SetFilter('')
			dw_3.Filter()
			dw_3.Retrieve(ls_nro_aprob)
			for ll_i = 1 to dw_3.RowCount()
				if Long(String(Date(dw_3.object.fec_proyect[ll_i]), 'yyyy')) <= ll_year then
					dw_3.object.flag_verifica_prsp[ll_i] = ls_verifica_prsp
				end if
			next
		end if
		
		Do While ll_row <> 0
			ls_oper_sec	 = dw_2.object.oper_sec [ll_row]
			
			//Aprobando la Operacion
			dw_2.object.flag_estado [ll_row] = as_estado
			dw_2.ii_update = 1
			
			//Aprobando los materiales
			ldt_fec_aprob = f_fecha_Actual()
			for ll_i = 1 to dw_3.RowCount()
				if ls_oper_sec = dw_3.object.oper_sec[ll_i] then
					dw_3.object.flag_Estado		[ll_i] = as_estado  //Aprobado
					dw_3.object.fec_proy_aprob	[ll_i] = ldt_fec_aprob
					dw_3.ii_update = 1
				end if
			next
			
			ll_row = dw_2.GetSelectedRow(ll_row)
		Loop
		
	case 'dw_3'
		ll_row = dw_3.GetSelectedRow(0)
		ldt_fec_aprob = f_fecha_actual()
		
		Do While ll_row <> 0
			
			dw_3.object.flag_estado		[ll_row] = as_estado
			dw_3.object.fec_proy_aprob	[ll_row] = ldt_fec_aprob
			dw_3.ii_update = 1
			
			ls_oper_sec	 = dw_3.object.oper_sec [ll_row]
			
			//Aprobando Operaciones
			if as_estado = '1' then
				ll_find = dw_2.Find("oper_sec = '" + ls_oper_sec + "'", 1, dw_2.RowCount())
				if ll_find > 0 then
					dw_2.object.flag_estado[ll_find] = as_estado
					dw_2.ii_update = 1
				end if
			end if
			
			ll_row = dw_3.GetSelectedRow(ll_row)
		Loop
			
	
end choose



end event

event ue_reporte_ot();string 			ls_nro_orden
str_parametros 	lstr_param

if is_dw = 'dw_2' then
	if dw_2.GetRow() = 0 then return
	ls_nro_orden = dw_2.object.nro_orden[dw_2.GetRow()]
	lstr_param.dw1		 = 'd_abc_datos_ot_frm'
	lstr_param.string1 = ls_nro_orden
	OpenWithParm(w_cns_datos_ot, lstr_param)
end if
end event

event ue_filtrar_materiales();string ls_oper_sec

if is_dw = 'dw_2' then
	if dw_2.GetRow() =  0 then return
	ls_oper_sec = dw_2.object.oper_sec[dw_2.GetRow()]
	dw_3.SetFilter("oper_sec = '" + ls_oper_sec + "'")
	dw_3.Filter()
end if
end event

event ue_flag_todo(string as_estado);string 	ls_nro_aprob, ls_oper_sec
Long 		ll_row, ll_i, ll_find
DateTime	ldt_fec_aprob

choose case is_dw
	case 'dw_2'
		for ll_i = 1 to dw_2.RowCount()
			dw_2.object.flag_estado		[ll_i] = as_estado
			dw_2.ii_update = 1
		next
		
	case 'dw_3'
		if as_estado = '1' then
			ldt_fec_aprob = f_fecha_Actual()
		else
			SetNull(ldt_fec_aprob)
		end if
		
		for ll_i = 1 to dw_3.RowCount()
			dw_3.object.flag_estado		[ll_i] = as_estado
			dw_3.object.fec_proy_aprob	[ll_i] = ldt_fec_aprob
			dw_3.ii_update = 1
		next
end choose

end event

event ue_retrieve();Date ld_Fecha1, ld_Fecha2
string ls_flag_activacion

ld_fecha1 = uo_Fecha.of_get_fecha1()
ld_fecha2 = uo_Fecha.of_get_fecha2()

if rb_1.checked then
	ls_flag_activacion = '1%'
elseif rb_2.checked then
	ls_flag_activacion = '6%'
else
	ls_flag_activacion = '%%'
end if

dw_1.Retrieve(ld_fecha1, ld_fecha2, ls_flag_activacion)

dw_2.Reset()
dw_2.ii_update = 0

dw_3.Reset()
dw_3.ii_update = 0

end event

event ue_reporte_oper_sec();string 			ls_oper_sec
str_parametros 	lstr_param

if is_dw = 'dw_2' then
	if dw_2.GetRow() = 0 then return
	ls_oper_sec = dw_2.object.oper_sec[dw_2.GetRow()]
	lstr_param.string1 = ls_oper_Sec
	lstr_param.dw1		 = 'd_abc_datos_oper_sec_frm'
	OpenWithParm(w_cns_datos_ot, lstr_param)
end if
end event

event ue_validar_prsp(string as_estado);string 	ls_nro_aprob
Long 		ll_row
choose case is_dw
	case 'dw_3'
		ll_row = dw_3.GetSelectedRow(0)
		
		Do While ll_row <> 0
			
			dw_3.object.flag_verifica_prsp[ll_row] = as_estado
			dw_3.ii_update = 1
			
			ll_row = dw_3.GetSelectedRow(ll_row)
		Loop
			
	
end choose

end event

public subroutine of_resizebars ();//Resize Bars according to Bars themselves, WindowBorder, and BarThickness.

st_vertical.Move (st_vertical.X, cii_WindowBorder + cii_WindowTop)
st_vertical.Resize (cii_Barthickness, 5 + st_horizontal.Y - (cii_WindowBorder + cii_WindowTop))

st_horizontal.Move (cii_WindowBorder, st_horizontal.Y)
st_horizontal.Resize (This.WorkSpaceWidth() - st_horizontal.X - cii_WindowBorder, cii_BarThickness)

st_both.Move(st_vertical.X, st_horizontal.Y)
st_both.Resize(cii_BarThickness, cii_BarThickness)

of_RefreshBars()

end subroutine

public subroutine of_resizepanels ();// Resize the panels according to the Vertical Line, Horizontal Line,
// BarThickness, and WindowBorder.

Long		ll_Width, ll_Height

// Validate the controls.
If Not IsValid(idrg_TopRight) or Not IsValid(idrg_TopRight) or &
	Not IsValid(idrg_Bottom) Then
	Return 
End If

ll_Width = This.WorkSpaceWidth()
ll_Height = This.WorkspaceHeight()

// Enforce a minimum window size
If ll_Width < idrg_TopRight.X + 150 Then
	ll_Width = idrg_TopRight.X + 150
End If

If ll_Height < idrg_Bottom.Y + 150 Then
	ll_Height = idrg_Bottom.Y + 150
End If

// TopLeft processing
idrg_TopLeft.Move(cii_WindowBorder, cii_WindowBorder + st_1.Y + st_1.height)
idrg_TopLeft.Resize(st_vertical.X - idrg_TopLeft.X, st_horizontal.Y - idrg_TopLeft.Y)
st_1.X = dw_1.x
st_1.width = dw_1.width

// TopRight Processing
idrg_TopRight.Move(st_vertical.X + cii_BarThickness, cii_WindowBorder + st_2.Y + st_2.height )
idrg_TopRight.Resize(ll_Width - (st_vertical.X + cii_BarThickness) - cii_WindowBorder, &
								st_horizontal.Y - idrg_TopRight.Y)

st_2.X 		= dw_2.x
st_2.width 	= dw_2.width
							
// Bottom Procesing
st_3.Y = st_horizontal.Y + cii_BarThickness

idrg_Bottom.Move(cii_WindowBorder, st_horizontal.Y + cii_BarThickness + st_3.height)
idrg_Bottom.Resize(ll_Width - (cii_WindowBorder * 2), &
							ll_Height - idrg_Bottom.Y - cii_WindowBorder)
st_3.X 		= dw_3.x
st_3.width 	= dw_3.width


end subroutine

public subroutine of_refreshbars ();// Refresh the size bars

// Force appropriate order
st_vertical.SetPosition(ToTop!)
st_horizontal.SetPosition(ToTop!)
st_both.SetPosition(ToTop!)

// Make sure the Width is not lost
st_vertical.Width = cii_BarThickness
st_horizontal.Height = cii_BarThickness
st_both.Resize (cii_BarThickness, cii_BarThickness)

end subroutine

public subroutine of_compras_sug (string as_almacen);date ld_fecha
string ls_est_amp, ls_msg
str_parametros lstr_param

ld_fecha = Date(f_fecha_actual())
ls_est_amp = '2'  //Los aprobados y los pendientes

//create or replace procedure USP_CMP_SUGERIDAS_DET_X_ALM(
//       adi_fecha         in date ,
//       asi_origen        in origen.cod_origen%TYPE,
//       asi_almacen       in almacen.almacen%TYPE,
//       asi_est_amp       in char
//) is	
	
DECLARE USP_CMP_SUGERIDAS_DET_X_ALM PROCEDURE FOR 
		USP_CMP_SUGERIDAS_DET_X_ALM( :ld_fecha, 
											  :gs_origen, 
											  :as_almacen,
											  :ls_est_amp );
EXECUTE USP_CMP_SUGERIDAS_DET_X_ALM;

IF SQLCA.SQLCODE = -1 THEN
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error USP_CMP_SUGERIDAS_DET_X_ALM", ls_msg)
	Return
END IF

CLOSE USP_CMP_SUGERIDAS_DET_X_ALM;

lstr_param.string1 	= as_almacen
lstr_param.fecha1		= ld_fecha

openSheetWithParm(w_cm509_compras_sug_x_alm_x_art, lstr_param, w_main, 0, Layered!)
end subroutine

public subroutine of_compras_sug ();date ld_fecha
string ls_est_amp, ls_msg
str_parametros lstr_param

ld_fecha = Date(f_fecha_actual())
ls_est_amp = '2'  //Los aprobados y los pendientes

//create or replace procedure USP_CMP_SUGERIDAS_DET(
//       adi_fecha   in date ,
//       asi_origen  in origen.cod_origen%TYPE,
//       asi_est_amp in char               
//) is	
	
DECLARE USP_CMP_SUGERIDAS_DET PROCEDURE FOR 
		USP_CMP_SUGERIDAS_DET( :ld_fecha, 
									  :gs_origen, 
									  :ls_est_amp );
EXECUTE USP_CMP_SUGERIDAS_DET;

IF SQLCA.SQLCODE = -1 THEN
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error USP_CMP_SUGERIDAS_DET", ls_msg)
	Return
END IF

CLOSE USP_CMP_SUGERIDAS_DET;

lstr_param.fecha1		= ld_fecha

openSheetWithParm(w_cm509_compras_sug_x_alm_x_art, lstr_param, w_main, 0, Layered!)
end subroutine

public subroutine of_ruptura_stock ();long 		ll_i, ll_row, ll_nro_mov_proy, ll_j
string	ls_almacen, ls_origen_mov_proy
u_ds_base ds_almacen, ds_stock

if is_dw <> 'dw_3' then return

ds_almacen = create u_ds_base
ds_almacen.DataObject = 'ds_almacen'

ds_stock = create u_ds_base
ds_stock.DataObject = 'ds_ruptura_stock'
ds_stock.SetTransObject(SQLCA)

//Primero lleno ds_almacen con todos los almacenes sin que se repitan
SetMicroHelp('Procesando Almacen')
for ll_i = 1 to dw_3.RowCount()
	ls_almacen = dw_3.object.almacen[ll_i]
	ll_row = ds_almacen.Find("almacen = '" + ls_almacen + "'", 1, ds_almacen.RowCount())
	if ll_row = 0 then
		ll_row = ds_almacen.InsertRow(0)
		ds_almacen.object.almacen[ll_row] = ls_almacen
	end if
next

// Despues por cada almacen debo ejecutar el proceso de las compras sugeridas
for ll_i = 1 to ds_almacen.RowCount()
	ls_almacen = ds_almacen.object.almacen[ll_i]
	SetMicroHelp('Verificando Compras Sugeridas Almacen ' + ls_almacen)
	
	if of_only_compras_sug(ls_almacen) = false then return
	
	ds_stock.Retrieve()
	
	for ll_j = 1 to dw_3.RowCount()
		SetMicroHelp('Procesando registro ' + string(ll_j))

		if dw_3.object.almacen[ll_j] = ls_almacen and &
				dw_3.object.flag_estado[ll_j] = '6' then
				
			ls_origen_mov_proy = dw_3.object.cod_origen	[ll_j]
			ll_nro_mov_proy	 = dw_3.object.nro_mov		[ll_j]
			
			ll_row = ds_stock.Find("nro_mov_proy = " + string(ll_nro_mov_proy) &
					+ " and origen_mov_proy = '" + ls_origen_mov_proy + "'", 1, &
					ds_stock.RowCount())
			
			if ll_row > 0 then
				dw_3.object.flag_estado[ll_j] = '1'
				dw_3.ii_update = 1
			end if
		end if
	next
	
next

destroy ds_almacen
destroy ds_stock
end subroutine

public function boolean of_only_compras_sug (string as_almacen);date ld_fecha
string ls_est_amp, ls_msg
str_parametros lstr_param

ld_fecha = Date(f_fecha_actual())
ls_est_amp = '2'  //Los aprobados y los pendientes

//create or replace procedure USP_CMP_SUGERIDAS_DET_X_ALM(
//       adi_fecha         in date ,
//       asi_origen        in origen.cod_origen%TYPE,
//       asi_almacen       in almacen.almacen%TYPE,
//       asi_est_amp       in char
//) is	
	
DECLARE USP_CMP_SUGERIDAS_DET_X_ALM PROCEDURE FOR 
		USP_CMP_SUGERIDAS_DET_X_ALM( :ld_fecha, 
											  :gs_origen, 
											  :as_almacen,
											  :ls_est_amp );
EXECUTE USP_CMP_SUGERIDAS_DET_X_ALM;

IF SQLCA.SQLCODE = -1 THEN
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error USP_CMP_SUGERIDAS_DET_X_ALM", ls_msg)
	Return false
END IF

CLOSE USP_CMP_SUGERIDAS_DET_X_ALM;

return true


end function

public subroutine of_compras_sug (string as_cod_art, string as_almacen, date ad_fecha);string ls_est_amp, ls_msg
str_parametros lstr_param

ls_est_amp = '2'  //Los aprobados y los pendientes

//create or replace procedure USP_CMP_SUG_DET_X_ALM_X_ART(
//       adi_fecha         in date ,
//       asi_origen        in origen.cod_origen%TYPE,
//       asi_almacen       in almacen.almacen%TYPE,
//       asi_cod_art       in articulo.cod_art%TYPE,
//       asi_est_amp       in char
//) is	
	
DECLARE USP_CMP_SUG_DET_X_ALM_X_ART PROCEDURE FOR 
		USP_CMP_SUG_DET_X_ALM_X_ART( :ad_fecha, 
											  :gs_origen, 
											  :as_almacen,
											  :as_cod_art,
											  :ls_est_amp );
EXECUTE USP_CMP_SUG_DET_X_ALM_X_ART;

IF SQLCA.SQLCODE = -1 THEN
	ls_msg = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error USP_CMP_SUG_DET_X_ALM_X_ART", ls_msg)
	Return
END IF

CLOSE USP_CMP_SUG_DET_X_ALM_X_ART;

lstr_param.string1 	= as_almacen
lstr_param.string2 	= as_cod_art
lstr_param.fecha1		= ad_fecha

openSheetWithParm(w_cm509_compras_sug_x_alm_x_art, lstr_param, w_main, 0, Layered!)
end subroutine

public function boolean of_procesa_amp (string as_cod_origen, long al_nro_mov, string as_new_flag_estado, decimal ldc_ult_prec_comp, string as_cencos, string as_cnta_prsp, date ad_fecha, ref string as_old_flag_estado);string 	ls_mensaje
integer	li_ok
//create or replace procedure USP_CMP_ESTADO_AMP(
//       asi_cod_origen       in  articulo_mov_proy.cod_origen%TYPE,
//       ani_nro_mov          in  articulo_mov_proy.nro_mov%TYPE,
//       asi_new_flag_estado  in  articulo_mov_proy.flag_estado%TYPE,
//       ani_ult_prec_cmp     in  articulo_almacen.costo_ult_compra%TYPE,
//       asi_cencos           in  articulo_mov_proy.cencos%TYPE,
//       asi_cnta_prsp        in  articulo_mov_proy.cnta_prsp%TYPE,
//       adi_fecha            in  articulo_mov_proy.fec_proyect%TYPE,
//       aso_old_flag_estado  out articulo_mov_proy.flag_estado%TYPE,
//       aio_ok               out number,
//       aso_mensaje          out string
//) is

DECLARE USP_CMP_ESTADO_AMP PROCEDURE FOR
	USP_CMP_ESTADO_AMP( :as_cod_origen,
							  :al_nro_mov,
							  :as_new_flag_estado,
							  :ldc_ult_prec_comp,
							  :as_Cencos,
							  :as_cnta_prsp
							  :ad_fecha);

EXECUTE USP_CMP_ESTADO_AMP;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_CMP_ESTADO_AMP:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

FETCH USP_CMP_ESTADO_AMP into :as_old_flag_estado, :li_ok, :ls_mensaje;

CLOSE USP_CMP_ESTADO_AMP;

if li_ok <> 1 then
	MessageBox('Aviso', ls_mensaje)
	return false
end if

return true
end function

public function boolean of_graba_dw3 ();Long 		ll_i, ll_nro_mov, ll_rowCount, ll_year
string 	ls_estado_old, ls_estado_new, ls_origen, ls_cencos, &
			ls_cnta_prsp, ls_nro_aprob, ls_verifica_prsp
Decimal	ldc_ult_prec_cmp
Date		ld_fecha

if dw_3.ii_update = 0 then return true

ll_rowCount = dw_3.RowCount()

for ll_i = 1 to ll_RowCount
	SetMicroHelp('Procesando ' + string(ll_i/ll_RowCount * 100, '###,##0.000'))
	
	ls_verifica_prsp 	= dw_3.object.flag_verifica_prsp[ll_i]
	ls_estado_old 		= dw_3.GetItemString(ll_i, 'flag_estado', Primary!, TRUE)
	ls_estado_new 		= dw_3.GetItemString(ll_i, 'flag_estado', Primary!, FALSE)
	
	
	if ls_estado_old <> ls_estado_new then
		
		ls_origen 	= dw_3.object.cod_origen[ll_i]
		ll_nro_mov	= dw_3.object.nro_mov	[ll_i]
		ldc_ult_prec_cmp = Dec(dw_3.object.costo_ult_compra[ll_i])
		ls_cencos	= dw_3.object.cencos		[ll_i]
		ls_cnta_prsp= dw_3.object.cnta_prsp	[ll_i] 
		ld_fecha		= Date(dw_3.object.fec_proyect[ll_i])
		
		if this.of_estado_amp( ls_origen, ll_nro_mov, ls_estado_new, &
				ldc_ult_prec_cmp, ls_cencos, ls_cnta_prsp, ld_fecha, &
				ls_verifica_prsp) = false then
			
			dw_3.object.flag_estado[ll_i]= ls_estado_old
			
		end if
	end if
next

dw_3.ii_update = 0

if cbx_1.checked then
	ls_verifica_prsp = '1'
else
	ls_verifica_prsp = '0'
end if

ls_nro_aprob = dw_1.object.nro_aprob[dw_1.GetRow()]

dw_3.SetFilter('')
dw_3.Filter()
dw_3.Retrieve(ls_nro_aprob)

ll_year = Long(string(Date(Today()), 'yyyy'))
for ll_i = 1 to dw_3.RowCount()
	if Long(String(Date(dw_3.object.fec_proyect[ll_i]), 'yyyy')) <= ll_year then
		dw_3.object.flag_verifica_prsp[ll_i] = ls_verifica_prsp
	end if
next

return true
end function

public function boolean of_estado_amp (string as_origen, long al_nro_mov, string as_new_flag_estado, decimal adc_ult_prec_cmp, string as_cencos, string as_cnta_prsp, date ad_fecha, string as_flag_prsp);string 	ls_mensaje, ls_old_flag_estado
Integer	li_ok

/*
	as_flag_prsp = 1  --> Verifica presupuesto
	as_flag_prsp = 0  --> No verifica presupuesto
*/

//create or replace procedure USP_CMP_ESTADO_AMP(
//       asi_cod_origen       in  articulo_mov_proy.cod_origen%TYPE,
//       ani_nro_mov          in  articulo_mov_proy.nro_mov%TYPE,
//       asi_new_flag_estado  in  articulo_mov_proy.flag_estado%TYPE,
//       ani_ult_prec_cmp     in  articulo_almacen.costo_ult_compra%TYPE,
//       asi_cencos           in  articulo_mov_proy.cencos%TYPE,
//       asi_cnta_prsp        in  articulo_mov_proy.cnta_prsp%TYPE,
//       adi_fecha            in  articulo_mov_proy.fec_proyect%TYPE,
//       asi_flag_prsp        in  articulo_mov_proy.flag_estado%TYPE,
//       aio_ok               out number,
//       aso_mensaje          out string
//) is

DECLARE USP_CMP_ESTADO_AMP PROCEDURE FOR
	USP_CMP_ESTADO_AMP( :as_origen,
							  :al_nro_mov,
							  :as_new_flag_estado,
							  :adc_ult_prec_cmp,
							  :as_cencos,
							  :as_cnta_prsp,
							  :ad_fecha,
							  :as_flag_prsp);

EXECUTE USP_CMP_ESTADO_AMP;

IF SQLCA.sqlcode <> 0 THEN
	ls_mensaje = "PROCEDURE USP_CMP_ESTADO_AMP:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

FETCH USP_CMP_ESTADO_AMP INTO :li_ok, :ls_mensaje;

CLOSE USP_CMP_ESTADO_AMP;

if li_ok <> 1 then
	MessageBox('Aviso USP_CMP_ESTADO_AMP', ls_mensaje)
	return false
end if

return true
end function

on w_cm325_comite_compras.create
int iCurrent
call super::create
if this.MenuName = "m_save_exit" then this.MenuID = create m_save_exit
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cbx_1=create cbx_1
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_3=create dw_3
this.dw_2=create dw_2
this.dw_1=create dw_1
this.st_horizontal=create st_horizontal
this.st_both=create st_both
this.st_vertical=create st_vertical
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_3
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.uo_fecha
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.dw_3
this.Control[iCurrent+11]=this.dw_2
this.Control[iCurrent+12]=this.dw_1
this.Control[iCurrent+13]=this.st_horizontal
this.Control[iCurrent+14]=this.st_both
this.Control[iCurrent+15]=this.st_vertical
end on

on w_cm325_comite_compras.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cbx_1)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.st_horizontal)
destroy(this.st_both)
destroy(this.st_vertical)
end on

event ue_open_pre;call super::ue_open_pre;// Set the TopLeft, TopRight, and Bottom Controls
idrg_TopLeft 	= dw_1
idrg_TopRight 	= dw_2
idrg_Bottom 	= dw_3

//Change the back color so they cannot be seen.
If Not ib_debug Then 
	st_vertical.BackColor 	= This.BackColor
	st_both.backcolor 		= This.BackColor
	st_horizontal.BackColor = This.BackColor
	il_HiddenColor 			= This.BackColor
End If

// Call the resize functions
of_ResizeBars()
of_ResizePanels()

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)

//dw_1.Retrieve()


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_1.ii_update = 1 OR dw_2.ii_update = 1 OR dw_3.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_1.ii_update = 0
		dw_2.ii_update = 0
		dw_3.ii_update = 0
	END IF
END IF

end event

event ue_update;call super::ue_update;Boolean lb_ok = TRUE

dw_1.AcceptText()
dw_2.AcceptText()
dw_3.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF dw_1.ii_update = 1 THEN
	IF dw_1.Update() = -1 then		// Grabacion del detalle
		lb_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion ","Se ha procedido al rollback, OT_APROBACION",exclamation!)
	END IF
END IF

IF	dw_2.ii_update = 1 AND lb_ok = TRUE THEN
	IF dw_2.Update() = -1 then		// Grabacion del Master
		lb_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion","Se ha procedido al rollback, OT_APROBACION_OPER",exclamation!)
	END IF
END IF

if dw_3.ii_update = 1 and lb_ok = TRUE then
	if of_graba_dw3() = false then 
			lb_ok = FALSE
			Rollback ;
			messagebox("Error en Grabacion","Se ha procedido al rollback, OT_APROBACION_AMP",exclamation!)
	end if		
end if

IF lb_ok THEN
	COMMIT using SQLCA;
	dw_1.ii_update = 0
	dw_2.ii_update = 0
	dw_3.ii_update = 0
END IF

end event

event ue_update_pre;call super::ue_update_pre;dw_1.of_set_flag_replicacion()
dw_2.of_set_flag_replicacion()
dw_3.of_set_flag_replicacion()
end event

type rb_3 from radiobutton within w_cm325_comite_compras
integer x = 2757
integer y = 20
integer width = 379
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

type rb_2 from radiobutton within w_cm325_comite_compras
integer x = 2414
integer y = 20
integer width = 379
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pendientes"
boolean checked = true
end type

type rb_1 from radiobutton within w_cm325_comite_compras
integer x = 2062
integer y = 20
integer width = 379
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Aprobados"
end type

type cbx_1 from checkbox within w_cm325_comite_compras
integer x = 1641
integer y = 8
integer width = 389
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Valida Prsp"
boolean checked = true
end type

type cb_1 from commandbutton within w_cm325_comite_compras
integer x = 1321
integer y = 4
integer width = 306
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;Parent.Event dynamic ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_cm325_comite_compras
integer x = 41
integer y = 4
integer taborder = 40
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;string ls_desde

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton

end event

type st_3 from statictext within w_cm325_comite_compras
integer y = 1096
integer width = 2885
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12639424
string text = "INSUMOS/MATERIALES REQUERIDOS"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm325_comite_compras
integer x = 1440
integer y = 128
integer width = 1440
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12639424
string text = "OPERACIONES"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cm325_comite_compras
integer y = 128
integer width = 1403
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12639424
string text = "APROBACIONES"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_3 from u_dw_abc within w_cm325_comite_compras
integer y = 1168
integer width = 2885
integer height = 480
integer taborder = 30
string dataobject = "d_abc_ot_aprobacion_amp"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
end event

event rbuttondown;//Ancestor Script
if row = 0 then return
m_rbutton_cm 	lm_1

//this.SelectRow(0, false)
//this.SelectRow(row,true)
//this.SetRow(row)
//this.il_Row = row
//this.event ue_output(row)

is_dw = 'dw_3'

lm_1 = CREATE m_rbutton_cm 
lm_1.m_-.visible 						= true
lm_1.m_comprassugeridas.visible 	= true
lm_1.m_rupturastock.visible 		= true

lm_1.m_-0.visible 				= true
lm_1.m_aprobartodo.visible 	= true
lm_1.m_cerrartodo.visible 		= true
lm_1.m_planificartodo.visible = true
lm_1.m_novalidarprsp.visible 	= true

lm_1.PopMenu(w_main.PointerX(), w_main.PointerY())

destroy lm_1


end event

event doubleclicked;call super::doubleclicked;string 	ls_codigo, ls_almacen
Date		ld_fecha

choose case lower(dwo.name)
		
	case "cod_art"
		ls_codigo  = this.object.cod_art[row]
		ls_almacen = this.object.almacen[row]
		ld_fecha	  = Date(this.object.fec_proyect[row])
		
		parent.function dynamic of_compras_sug(ls_codigo, ls_almacen, ld_Fecha)
		
	case "almacen"
		ls_almacen = this.object.almacen[row]
		
		parent.function dynamic of_compras_sug(ls_almacen)
		
end choose
end event

event itemerror;call super::itemerror;return 1
end event

type dw_2 from u_dw_abc within w_cm325_comite_compras
integer x = 1440
integer y = 200
integer width = 1440
integer height = 852
integer taborder = 20
string dataobject = "d_abc_ot_aprobacion_oper"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw


ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
end event

event rbuttondown;//Ancestor Script
if row = 0 then return
m_rbutton_cm 	lm_1

//this.SelectRow(0, false)
//this.SelectRow(row,true)
//this.SetRow(row)
//this.il_Row = row
//this.event ue_output(row)

is_dw = 'dw_2'

lm_1 = CREATE m_rbutton_cm 
lm_1.m_-.visible = true
lm_1.m_datosdeot.visible = true
lm_1.m_filtrarmaterial.visible = true

lm_1.m_-0.visible = true
lm_1.m_aprobartodo.visible = true
lm_1.m_cerrartodo.visible = true
lm_1.m_planificartodo.visible = true

lm_1.PopMenu(w_main.PointerX(), w_main.PointerY())

destroy lm_1


end event

event doubleclicked;call super::doubleclicked;choose case lower(dwo.name)
		
	case "nro_orden"
		is_dw = 'dw_2'
		parent.event dynamic ue_reporte_ot()
		
	case "oper_sec"
		is_dw = 'dw_2'
		parent.event dynamic ue_reporte_oper_sec()
		
end choose
end event

type dw_1 from u_dw_abc within w_cm325_comite_compras
integer y = 200
integer width = 1403
integer height = 852
string dataobject = "d_abc_ot_aprobaciones"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event ue_output;call super::ue_output;string 	ls_nro_Aprob, ls_verifica_prsp
Long 		ll_i, ll_year
Date 		ld_fecha
if al_row <= 0 then return

parent.event dynamic ue_update_request()

if cbx_1.checked then
	ls_verifica_prsp = '1'
else
	ls_verifica_prsp = '0'
end if

ls_nro_aprob = this.object.nro_aprob[al_row]

dw_2.Retrieve(ls_nro_aprob)

dw_3.SetFilter('')
dw_3.Filter()
dw_3.Retrieve(ls_nro_aprob)

ll_year = Long(string(Date(Today()), 'yyyy'))
for ll_i = 1 to dw_3.RowCount()
	if Long(String(Date(dw_3.object.fec_proyect[ll_i]), 'yyyy')) <= ll_year then
		dw_3.object.flag_verifica_prsp[ll_i] = ls_verifica_prsp
	end if
next


end event

event rbuttondown;//Ancestor Script
if row = 0 then return
m_rbutton_cm 	lm_1

this.SelectRow(0, false)
this.SelectRow(row,true)
this.SetRow(row)
this.il_Row = row
this.event ue_output(row)

is_dw = 'dw_1'

lm_1 = CREATE m_rbutton_cm 
lm_1.PopMenu(w_main.PointerX(), w_main.PointerY())

destroy lm_1


end event

type st_horizontal from statictext within w_cm325_comite_compras
event mousemove pbm_mousemove
event mouseup pbm_lbuttonup
event mousedown pbm_lbuttondown
integer x = 55
integer y = 924
integer width = 745
integer height = 32
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string pointer = "SizeNS!"
long textcolor = 33554432
long backcolor = 16776960
boolean focusrectangle = false
end type

event mousemove;Integer	li_prevposition

If KeyDown(keyLeftButton!) Then
	// Store the previous position.
	li_prevposition = This.Y

	// Refresh the Bar attributes.	
	This.Y = Parent.PointerY()
	
	// Perform redraws when appropriate.
	If Not IsValid(idrg_topleft) or Not IsValid(idrg_topright) Then Return
	If li_prevposition < idrg_topleft.y + idrg_topleft.height Then 
		idrg_topleft.setredraw(true)
		idrg_topright.setredraw(true)
	End If
	If Not IsValid(idrg_bottom) Then Return
	If li_prevposition > idrg_bottom.y Then idrg_bottom.setredraw(true)
End If

end event

event mouseup;// Hide the bar
If Not ib_Debug Then This.BackColor = il_HiddenColor

// Call the resize functions
of_ResizeBars()
of_ResizePanels()

end event

event mousedown;This.SetPosition(ToTop!)
If Not ib_debug Then This.BackColor = 0  // Show Bar in Black while being moved.

end event

type st_both from statictext within w_cm325_comite_compras
event mousemove pbm_mousemove
event mouseup pbm_lbuttonup
event mousedown pbm_lbuttondown
integer x = 841
integer y = 924
integer width = 41
integer height = 48
string dragicon = "Exclamation!"
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string pointer = "SizeNESW!"
long textcolor = 16711680
long backcolor = 16711680
long bordercolor = 16711680
boolean focusrectangle = false
end type

event mousemove;//Check for move in progess
If KeyDown(keyLeftButton!) Then
	st_horizontal.Trigger Event mousemove(flags, xpos, ypos)
	st_vertical.Trigger Event mousemove(flags, xpos, ypos)
	
	// Stretch the Vertical line
	st_vertical.Resize(cii_BarThickness, 5 + st_horizontal.Y - (cii_WindowBorder + cii_WindowTop))
End If







end event

event mouseup;st_vertical.Trigger Event mouseup(flags, xpos, ypos)
st_horizontal.Trigger Event mouseup(flags, xpos, ypos)


end event

event mousedown;This.SetPosition(ToTop!)
If Not ib_debug Then
	// Show Bar2 in Black while being moved.
	st_vertical.BackColor = 0
	st_horizontal.BackColor = 0
End If

end event

type st_vertical from statictext within w_cm325_comite_compras
event mousemove pbm_mousemove
event mouseup pbm_lbuttonup
event mousedown pbm_lbuttondown
integer x = 1413
integer y = 316
integer width = 27
integer height = 540
string dragicon = "Exclamation!"
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string pointer = "SizeWE!"
long textcolor = 255
long backcolor = 255
long bordercolor = 276856960
boolean focusrectangle = false
end type

event mousemove;Integer	li_prevposition

If KeyDown(keyLeftButton!) Then
	// Store the previous position.
	li_prevposition = This.X

	// Refresh the Bar attributes.
	This.X = Parent.PointerX()
	
	// Perform redraws when appropriate.
	If Not IsValid(idrg_topright) or Not IsValid(idrg_topleft) Then Return
	If li_prevposition > idrg_topright.x Then idrg_topright.setredraw(true)
	If li_prevposition < idrg_topleft.x + idrg_topleft.width Then idrg_topleft.setredraw(true)
End If

end event

event mouseup;// Hide the bar
If Not ib_Debug Then This.BackColor = il_HiddenColor

// Call the resize functions
of_ResizeBars()
of_ResizePanels()

end event

event mousedown;This.SetPosition(ToTop!)
If Not ib_debug Then This.BackColor = 0  // Show Bar in Black while being moved.

end event

