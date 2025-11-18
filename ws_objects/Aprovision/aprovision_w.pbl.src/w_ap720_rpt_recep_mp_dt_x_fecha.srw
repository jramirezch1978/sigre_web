$PBExportHeader$w_ap720_rpt_recep_mp_dt_x_fecha.srw
$PBExportComments$Record de pesca de embarcaciones
forward
global type w_ap720_rpt_recep_mp_dt_x_fecha from w_rpt_pop
end type
end forward

global type w_ap720_rpt_recep_mp_dt_x_fecha from w_rpt_pop
end type
global w_ap720_rpt_recep_mp_dt_x_fecha w_ap720_rpt_recep_mp_dt_x_fecha

forward prototypes
public function long of_retrieve (string as_arg1)
public function long of_retrieve (string as_arg1, string as_arg2)
end prototypes

public function long of_retrieve (string as_arg1);//
Long	ll_row

ll_row = idw_1.Retrieve(Date(as_arg1))

Return ll_row
end function

public function long of_retrieve (string as_arg1, string as_arg2);//
Long	ll_row

ll_row = idw_1.Retrieve(Date(as_arg1), as_arg2)

Return ll_row

end function

on w_ap720_rpt_recep_mp_dt_x_fecha.create
call super::create
end on

on w_ap720_rpt_recep_mp_dt_x_fecha.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;Long		ll_row, ll_total
String	ls_rc, ls_modify
Integer	li_rc
Menu		lm_1, lm_menu

lm_1   = THIS.MenuID
idw_1  = dw_report
istr_1 = Message.PowerObjectParm					// lectura de parametros

idw_1.DataObject = istr_1.DataObject    		// asignar datawindow
THIS.title  = istr_1.title							// asignar titulo de la ventana
THIS.width  = istr_1.width							// asignar ancho y altura de ventana
THIS.height = istr_1.height

idw_1.SetTransObject(SQLCA)

//THIS.Event ue_preview()

IF IsValid(istr_1.dw) THEN
	IF istr_1.flag_share THEN
		istr_1.dw.ShareData(idw_1)
	ELSE
		ll_total = istr_1.dw.RowCount()
		istr_1.dw.RowsCopy(1, ll_total, Primary!, idw_1, 1, Primary!)
	END IF
ELSE
	ll_row = of_retrieve(istr_1.arg[1], istr_1.arg[2])
end if

IF istr_1.nextcol <> '' THEN
	li_rc = of_get_next_str(istr_1.nextcol)
	ls_modify = is_column + ".Pointer = '" + "\source\cur\taladro.cur'"
	ls_rc = idw_1.Modify( ls_modify )
END IF

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user

// ii_help = 101           // help topic


end event

type dw_report from w_rpt_pop`dw_report within w_ap720_rpt_recep_mp_dt_x_fecha
end type

