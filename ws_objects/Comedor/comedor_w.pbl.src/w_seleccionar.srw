$PBExportHeader$w_seleccionar.srw
forward
global type w_seleccionar from window
end type
type cb_listo from commandbutton within w_seleccionar
end type
type dw_new from uo_datawindow within w_seleccionar
end type
type st_2 from statictext within w_seleccionar
end type
type st_1 from statictext within w_seleccionar
end type
type cbx_1 from checkbox within w_seleccionar
end type
type st_3 from statictext within w_seleccionar
end type
type cb_cancelar from commandbutton within w_seleccionar
end type
type cb_detener from commandbutton within w_seleccionar
end type
type cb_iniciar from commandbutton within w_seleccionar
end type
type sle_descripcion from singlelineedit within w_seleccionar
end type
type ddlb_seleccion from dropdownlistbox within w_seleccionar
end type
type mle_1 from multilineedit within w_seleccionar
end type
end forward

global type w_seleccionar from window
integer x = 645
integer y = 272
integer width = 2176
integer height = 1336
boolean titlebar = true
string title = "Seleccionar"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
boolean center = true
event ue_aceptar ( )
event ue_busqueda ( )
event ue_cancel ( )
event ue_close ( )
event ue_detener ( )
cb_listo cb_listo
dw_new dw_new
st_2 st_2
st_1 st_1
cbx_1 cbx_1
st_3 st_3
cb_cancelar cb_cancelar
cb_detener cb_detener
cb_iniciar cb_iniciar
sle_descripcion sle_descripcion
ddlb_seleccion ddlb_seleccion
mle_1 mle_1
end type
global w_seleccionar w_seleccionar

type variables
Boolean         ib_cancelboton
str_seleccionar istr_seleccionar
integer 		    ii_sort




end variables

forward prototypes
public subroutine wf_add_item_ddlb (datawindow a_dw)
public function string wf_condicion_sql (string as_cadena)
public function integer wf_requerido ()
public function string of_new_sql ()
public subroutine of_add_item_ddlb ()
end prototypes

event ue_aceptar();Integer  li_i,li_j=0, li_col_count
String   ls_tipo_campo,ls_tipo_column[]
str_seleccionar lstr_seleccionar

ib_cancelboton     = FALSE

ls_tipo_column[1]  = ''
ls_tipo_column[2]  = ''
ls_tipo_column[3]  = ''
ls_tipo_column[4]  = ''
ls_tipo_column[5]  = ''
ls_tipo_column[6]  = ''
ls_tipo_column[7]  = ''
ls_tipo_column[8]  = ''
ls_tipo_column[9]  = ''
ls_tipo_column[10] = ''
ls_tipo_column[11] = ''
ls_tipo_column[12] = ''

li_col_count = Integer(dw_new.Object.DataWindow.Column.Count)

if li_col_count = 0 then
	MessageBox('Aviso', 'El Datawindow no tiene columnas')
	return
end if

FOR li_i = 1 TO li_col_count
	 ls_tipo_campo = dw_new.Describe("#" + string(li_i) + ".Coltype")
	 ls_tipo_column[li_i] = Mid(ls_tipo_campo,1,3)  
    IF ls_tipo_column[li_i] = 'num' THEN
		 ls_tipo_column[li_i] = 'dec'
	 END IF
NEXT

FOR li_i = 1 TO dw_new.RowCount()
	IF dw_new.IsSelected(li_i)  THEN 
		
	   li_j ++
		
      IF ls_tipo_column[1] = 'cha' THEN
         lstr_seleccionar.param1		[li_j] = dw_new.GetItemString(li_i , 1)   
      ELSEIF ls_tipo_column[1] = 'dat' THEN
         lstr_seleccionar.paramdt1	[li_j] = dw_new.GetItemDateTime(li_i , 1)
			lstr_seleccionar.param1		[li_j] = string(dw_new.GetItemDateTime(li_i , 1),'dd/mm/yyyy')
		ELSEIF ls_tipo_column[1] = 'dec' THEN
         lstr_seleccionar.paramdc1	[li_j] = dw_new.GetItemDecimal(li_i , 1)		
			lstr_seleccionar.param1		[li_j] = string(dw_new.GetItemDecimal(li_i , 1))
	   END IF
         
      IF ls_tipo_column[2] = 'cha' THEN
         lstr_seleccionar.param2		[li_j] = dw_new.GetItemString(li_i , 2)   
      ELSEIF ls_tipo_column[2] = 'dat' THEN
         lstr_seleccionar.paramdt2	[li_j] = dw_new.GetItemDateTime(li_i , 2)
			lstr_seleccionar.param2		[li_j] = string(dw_new.GetItemDateTime(li_i , 2),'dd/mm/yyyy')
		ELSEIF ls_tipo_column[2] = 'dec' THEN
         lstr_seleccionar.paramdc2	[li_j] = dw_new.GetItemDecimal(li_i , 2)		
			lstr_seleccionar.param2		[li_j] = string(dw_new.GetItemDecimal(li_i , 2))
	   END IF

      IF ls_tipo_column[3] = 'cha' THEN
         lstr_seleccionar.param3		[li_j] = dw_new.GetItemString(li_i , 3)   
      ELSEIF ls_tipo_column[3] = 'dat' THEN
         lstr_seleccionar.paramdt3	[li_j] = dw_new.GetItemDateTime(li_i , 3)
			lstr_seleccionar.param3		[li_j] = string(dw_new.GetItemDateTime(li_i , 3),'dd/mm/yyyy')
		ELSEIF ls_tipo_column[3] = 'dec' THEN
         lstr_seleccionar.paramdc3	[li_j] = dw_new.GetItemDecimal(li_i , 3)		
			lstr_seleccionar.param3		[li_j] = string(dw_new.GetItemDecimal(li_i , 3))
	   END IF
           
      IF ls_tipo_column[4] = 'cha' THEN
         lstr_seleccionar.param4		[li_j] = dw_new.GetItemString(li_i , 4)   
      ELSEIF ls_tipo_column[4] = 'dat' THEN
         lstr_seleccionar.paramdt4	[li_j] = dw_new.GetItemDateTime(li_i , 4)
			lstr_seleccionar.param4		[li_j] = string(dw_new.GetItemDateTime(li_i , 4),'dd/mm/yyyy')
		ELSEIF ls_tipo_column[4] = 'dec' THEN
         lstr_seleccionar.paramdc4	[li_j] = dw_new.GetItemDecimal(li_i , 4)		
			lstr_seleccionar.param4		[li_j] = string(dw_new.GetItemDecimal(li_i , 4))
	   END IF
     
      IF ls_tipo_column[5] = 'cha' THEN
         lstr_seleccionar.param5		[li_j] = dw_new.GetItemString(li_i , 5)   
      ELSEIF ls_tipo_column[5] = 'dat' THEN
         lstr_seleccionar.paramdt5	[li_j] = dw_new.GetItemDateTime(li_i , 5)
			lstr_seleccionar.param5		[li_j] = string(dw_new.GetItemDateTime(li_i , 5),'dd/mm/yyyy')
		ELSEIF ls_tipo_column[5] = 'dec' THEN
         lstr_seleccionar.paramdc5	[li_j] = dw_new.GetItemDecimal(li_i , 5)		
			lstr_seleccionar.param5		[li_j] = string(dw_new.GetItemDecimal(li_i , 5))
	   END IF
          
       IF ls_tipo_column[6] = 'cha' THEN
         lstr_seleccionar.param6		[li_j] = dw_new.GetItemString(li_i , 6)   
      ELSEIF ls_tipo_column[6] = 'dat' THEN
         lstr_seleccionar.paramdt6	[li_j] = dw_new.GetItemDateTime(li_i , 6)
			lstr_seleccionar.param6		[li_j] = string(dw_new.GetItemDateTime(li_i , 6),'dd/mm/yyyy')
		ELSEIF ls_tipo_column[6] = 'dec' THEN
         lstr_seleccionar.paramdc6	[li_j] = dw_new.GetItemDecimal(li_i , 6)		
			lstr_seleccionar.param6		[li_j] = string(dw_new.GetItemDecimal(li_i , 6))
	   END IF

       IF ls_tipo_column[7] = 'cha' THEN
         lstr_seleccionar.param7		[li_j] = dw_new.GetItemString(li_i , 7)   
      ELSEIF ls_tipo_column[7] = 'dat' THEN
         lstr_seleccionar.paramdt7	[li_j] = dw_new.GetItemDateTime(li_i , 7)
			lstr_seleccionar.param7		[li_j] = string(dw_new.GetItemDateTime(li_i , 7),'dd/mm/yyyy')
		ELSEIF ls_tipo_column[7] = 'dec' THEN
         lstr_seleccionar.paramdc7	[li_j] = dw_new.GetItemDecimal(li_i , 7)		
			lstr_seleccionar.param7		[li_j] = string(dw_new.GetItemDecimal(li_i , 7))
	   END IF

       IF ls_tipo_column[8] = 'cha' THEN
         lstr_seleccionar.param8		[li_j] = dw_new.GetItemString(li_i , 8)   
      ELSEIF ls_tipo_column[8] = 'dat' THEN
         lstr_seleccionar.paramdt8	[li_j] = dw_new.GetItemDateTime(li_i , 8)
			lstr_seleccionar.param8		[li_j] = string(dw_new.GetItemDateTime(li_i , 8),'dd/mm/yyyy')
		ELSEIF ls_tipo_column[8] = 'dec' THEN
         lstr_seleccionar.paramdc8	[li_j] = dw_new.GetItemDecimal(li_i , 8)		
			lstr_seleccionar.param8		[li_j] = string(dw_new.GetItemDecimal(li_i , 8))
	   END IF

       IF ls_tipo_column[9] = 'cha' THEN
         lstr_seleccionar.param9		[li_j] = dw_new.GetItemString(li_i , 9)   
      ELSEIF ls_tipo_column[9] = 'dat' THEN
         lstr_seleccionar.paramdt9	[li_j] = dw_new.GetItemDateTime(li_i , 9)
			lstr_seleccionar.param9		[li_j] = string(dw_new.GetItemDateTime(li_i , 9),'dd/mm/yyyy')
		ELSEIF ls_tipo_column[9] = 'dec' THEN
         lstr_seleccionar.paramdc9	[li_j] = dw_new.GetItemDecimal(li_i , 9)		
			lstr_seleccionar.param9		[li_j] = string(dw_new.GetItemDecimal(li_i , 9))
	   END IF

       IF ls_tipo_column[10] = 'cha' THEN
         lstr_seleccionar.param10	[li_j] = dw_new.GetItemString(li_i , 10)   
      ELSEIF ls_tipo_column[10] = 'dat' THEN
         lstr_seleccionar.paramdt10	[li_j] = dw_new.GetItemDateTime(li_i , 10)
			lstr_seleccionar.param10	[li_j] = string(dw_new.GetItemDateTime(li_i , 10),'dd/mm/yyyy')
		ELSEIF ls_tipo_column[10] = 'dec' THEN
         lstr_seleccionar.paramdc10	[li_j] = dw_new.GetItemDecimal(li_i , 10)		
			lstr_seleccionar.param10	[li_j] = string(dw_new.GetItemDecimal(li_i , 10))
	   END IF
		
       IF ls_tipo_column[11] = 'cha' THEN
         lstr_seleccionar.param11	[li_j] = dw_new.GetItemString(li_i , 11)   
      ELSEIF ls_tipo_column[11] = 'dat' THEN
         lstr_seleccionar.paramdt11	[li_j] = dw_new.GetItemDateTime(li_i , 11)
			lstr_seleccionar.param11	[li_j] = string(dw_new.GetItemDateTime(li_i , 11),'dd/mm/yyyy')
		ELSEIF ls_tipo_column[11] = 'dec' THEN
         lstr_seleccionar.paramdc11	[li_j] = dw_new.GetItemDecimal(li_i , 11)		
			lstr_seleccionar.param11	[li_j] = string(dw_new.GetItemDecimal(li_i , 11))
	   END IF
		
       IF ls_tipo_column[12] = 'cha' THEN
         lstr_seleccionar.param12	[li_j] = dw_new.GetItemString(li_i , 12)   
      ELSEIF ls_tipo_column[12] = 'dat' THEN
         lstr_seleccionar.paramdt12	[li_j] = dw_new.GetItemDateTime(li_i , 12)
			lstr_seleccionar.param12	[li_j] = string(dw_new.GetItemDateTime(li_i , 12),'dd/mm/yyyy')
		ELSEIF ls_tipo_column[12] = 'dec' THEN
         lstr_seleccionar.paramdc12	[li_j] = dw_new.GetItemDecimal(li_i , 12)		
			lstr_seleccionar.param12	[li_j] = string(dw_new.GetItemDecimal(li_i , 12))
	   END IF
		
	END IF      
NEXT


lstr_seleccionar.s_action = 'aceptar'
CloseWithReturn(this,lstr_seleccionar)

end event

event ue_busqueda();Integer ll_i, li_return
String  ls_sql_old, ls_sql_new

if IsValid(cb_listo) and not IsNull(cb_listo) then
	cb_listo.Enabled 	= FALSE
end if

cb_detener.Enabled 	= TRUE
cb_detener.Cancel 	= TRUE

cb_cancelar.Enabled 	= FALSE
cb_cancelar.cancel 	= FALSE

ll_i = wf_requerido()
IF ll_i = -1 THEN
	ddlb_seleccion.SetFocus()
	Return
END IF

ls_sql_old   = dw_new.GetSQLSelect()
ls_sql_new   = this.of_new_sql()

dw_new.SetSQLSelect(ls_sql_new)


IF cbx_1.checked THEN	
	dw_new.Object.DataWindow.Retrieve.AsNeeded='Yes'
ELSE
	dw_new.Object.DataWindow.Retrieve.AsNeeded='No'
END IF

mle_1.text = ls_sql_new
dw_new.SetTransObject(sqlca)
li_return = dw_new.Retrieve( )

if li_return = -1 then
	MessageBox(this.ClassName(), 'NO SE PUDO EJECUTAR CORRECTAMENTE LA SENTENCIA SQL: ' + ls_sql_new, StopSign!)
end if

dw_new.SetSQLSelect(ls_sql_old)
dw_new.setfocus()


end event

event ue_cancel();cb_detener.TriggerEvent(clicked!)

str_seleccionar lstr_seleccionar
ib_cancelboton     = FALSE

lstr_seleccionar.s_action = 'cancel'
Closewithreturn (This,lstr_seleccionar )

end event

event ue_close();str_seleccionar lstr_seleccionar

ib_cancelboton     = FALSE

lstr_seleccionar.s_action = 'cancel'
message.powerobjectparm = lstr_seleccionar
Closewithreturn ( This , lstr_seleccionar )

end event

event ue_detener();ib_cancelboton     	= FALSE
dw_new.SetFocus()

cb_detener.cancel 	= FALSE
cb_cancelar.enabled	= TRUE
cb_cancelar.cancel	= TRUE
cb_listo.enabled		= TRUE


end event

public subroutine wf_add_item_ddlb (datawindow a_dw);//****************************************************************************************//
// Funcion que inserta los itens al ddlb_seleccion                                        //   
//****************************************************************************************//
Integer i
String  ls_expresion, ls_campo

FOR i = 1 TO Integer(a_dw.Object.DataWindow.Column.Count)
	 a_dw.SetTabOrder(i,0)
	 ls_expresion = "#" + string(i) + ".Name"
	  MessageBox('', ls_expresion)
	 ls_campo =  a_dw.Describe( ls_expresion )
	 ddlb_seleccion.InsertItem (ls_campo, i )
	 ls_expresion = "#" + string(i) + ".Text = '" + ls_campo + "'"
	 MessageBox('', ls_expresion)
	 a_dw.Modify( ls_expresion )
NEXT

IF ISNULL(istr_seleccionar.s_column) OR TRIM(istr_seleccionar.s_column) = '' THEN
   ls_expresion = "#" + string(1) + ".Name" 
ELSE
	ls_expresion = "#" +istr_seleccionar.s_column+ ".Name" 
END IF
ls_campo = a_dw.Describe( ls_expresion )  

ddlb_seleccion.Text = ls_campo

end subroutine

public function string wf_condicion_sql (string as_cadena);//****************************************************************************************//
// Permite Crear el Criterio de Filtro dentro del Where
//****************************************************************************************//
String  ls_sql, ls_descripcion, ls_cadena, ls_where, ls_order_by
Integer ll_pos, ll_pos_two, ll_found, ll_order_by
Boolean lb_where

ls_sql      = UPPER(dw_new.GetSQLSelect())
ll_found    = Pos(ls_sql,'WHERE',1) 

IF ll_found > 0 THEN 
   lb_where = false
ELSE
   lb_where = true
END IF	

ls_where 	= ls_sql
ls_cadena   = UPPER(as_cadena)
ll_pos      = Pos(ls_sql,' AS ' + ls_cadena, 1) 
if ll_pos = 0 then
	MessageBox('Aviso', 'No se encontro: ' + ls_cadena + ' en sentencia sql: ' + ls_sql, Exclamation!)
	return ls_sql
end if

ls_where    = Mid(ls_where, 1, ll_pos)
ll_pos_two  = Pos(ls_where, ',', 1)
if ll_pos_two > 0 then
	ls_where = Mid(ls_where, ll_pos_two )
end if

DO WHILE ll_pos_two > 0
	ll_pos_two = Pos( ls_where, ',', 1 )
	IF ll_pos_two > 0 THEN 
	   ls_where = Mid( ls_where, ll_pos_two + 1 )
	ELSE
		ll_pos_two = 0
	END IF	
LOOP

// Extraigo la parte select de la setencia si lo hubiera
ll_pos_two = Pos( ls_where, 'SELECT' , 1 ) 

IF ll_pos_two > 0 THEN 
	ls_where = Mid(ls_where, 7)
END IF
ls_where = trim(ls_where)

// Extraigo la parte distinct de la setencia si lo hubiera
ll_pos_two = Pos( ls_where, 'DISTINCT' , 1 ) 

IF ll_pos_two > 0 THEN 
	ls_where = Mid(ls_where, 9)
END IF

ll_pos 	= Pos(ls_where,' AS ',1) 
if ll_pos > 0 then
	ls_where = Mid(ls_where, 1, ll_pos)
end if

IF ISNULL(sle_descripcion.text) OR  TRIM(sle_descripcion.text) = '' THEN 
	ls_descripcion = "'"+'%'+"'"
ELSE 
   ls_descripcion = "'"+TRIM(sle_descripcion.text)+'%'+"'"
END IF

ls_where = ls_where + ' LIKE ' + ls_descripcion

// Busco si han puesto la clausula Order by en la sentencia SQL
ll_order_by	= Pos(ls_sql,'ORDER BY',1) 

if ll_order_by > 0 then
	ls_order_by = Mid( ls_sql, ll_order_by )
else
	ls_order_by = ''
end if

IF lb_where THEN
   ls_cadena = ' WHERE ( '+ ls_where +' ) ' + ls_order_by   
ELSE
	ls_cadena = ' AND ( ' + ls_where + ' ) ' + ls_order_by
END IF

Return ls_cadena
end function

public function integer wf_requerido ();//***************************************************************************//
// Permite Validar una Busqueda.                                             // 
//***************************************************************************//

String   ls_buscar

ls_buscar  = ddlb_seleccion.text

IF IsNull(ls_buscar) OR ls_buscar = "" THEN
  	messagebox("Error","Ingrese dato en opción buscar por...")
	RETURN -1
END IF

RETURN 0
end function

public function string of_new_sql ();//****************************************************************************************//
// Permite Crear el Criterio de Filtro dentro del Where
//****************************************************************************************//
String  	ls_sql, ls_descripcion, ls_cadena, ls_where, ls_order_by, ls_new_sql, &
			ls_old_where
Integer 	ll_pos, ll_pos_two, ll_found
boolean	lb_where

ls_sql      = upper(dw_new.GetSQLSelect())

// Primero extraigo la sentencia where de la sentencia SQL
ll_pos = Pos( UPPER(ls_sql), 'WHERE', 1 ) 

if ll_pos > 0 then
	lb_where = TRUE
else
	lb_where = FALSE
end if


ls_where 	= ls_sql
ls_cadena   = UPPER(ddlb_seleccion.text)
ll_pos      = Pos(ls_sql,' AS ' + ls_cadena, 1) 
if ll_pos = 0 then
	MessageBox('Aviso', 'No se encontro: ' + ls_cadena + ' en sentencia sql: ' + ls_sql, Exclamation!)
	return ls_sql
end if

ls_where    = Mid(ls_where, 1, ll_pos)
ll_pos_two  = Pos(ls_where, ',', 1)
if ll_pos_two > 0 then
	ls_where = Mid(ls_where, ll_pos_two )
end if


DO WHILE ll_pos_two > 0
	ll_pos_two = Pos( ls_where, ',', 1 )
	IF ll_pos_two > 0 THEN 
	   ls_where = Mid( ls_where, ll_pos_two + 1 )
	ELSE
		ll_pos_two = 0
	END IF	
LOOP

// Extraigo la parte select de la setencia si lo hubiera
ll_pos_two = Pos( ls_where, 'SELECT' , 1 ) 

IF ll_pos_two > 0 THEN 
	ls_where = Mid(ls_where, 7)
END IF
ls_where = trim(ls_where)

// Extraigo la parte distinct de la setencia si lo hubiera
ll_pos_two = Pos( ls_where, 'DISTINCT' , 1 ) 

IF ll_pos_two > 0 THEN 
	ls_where = Mid(ls_where, 9)
END IF

ll_pos 	= Pos(ls_where,' AS ',1) 
if ll_pos > 0 then
	ls_where = Mid(ls_where, 1, ll_pos)
end if

IF ISNULL(sle_descripcion.text) OR  TRIM(sle_descripcion.text) = '' THEN 
	ls_descripcion = "'"+'%'+"'"
ELSE 
   ls_descripcion = "'"+TRIM(sle_descripcion.text)+'%'+"'"
END IF

ls_where = ls_where + ' LIKE ' + ls_descripcion

// Busco si han puesto la clausula Order by en la sentencia SQL
ll_pos	= Pos(ls_sql,'ORDER BY',1) 

if ll_pos > 0 then
	ls_order_by = Mid( ls_sql, ll_pos )
else
	ls_order_by = ''
end if

// Ahor tengo que armar la nueva sentencia SQL
ls_new_sql = dw_new.GetSQLSelect()

ll_pos = Pos(UPPER(ls_new_sql), 'ORDER BY', 1)
if ll_pos > 0 then
	ls_new_sql = Trim(Mid(ls_new_sql, 1, ll_pos - 1))
end if

IF lb_where = FALSE THEN
   ls_new_sql = ls_new_sql + ' WHERE ( '+ ls_where +' ) ' + ls_order_by   
ELSE
	ls_new_sql = ls_new_sql + ' AND ( ' + ls_where + ' ) ' + ls_order_by
END IF

Return ls_new_sql
end function

public subroutine of_add_item_ddlb ();string 	ls_sql, ls_columna, ls_expresion, ls_mensaje, ls_campo
Long		ll_pos1, ll_pos2, ll_i, ll_pos3
boolean	lb_from
long 		ll_start_pos=1
string 	ls_old_str ='~t', ls_new_str = ' '

ls_sql      = upper(dw_new.GetSQLSelect())

// Find the first occurrence of old_str.
ll_start_pos = Pos(ls_sql, ls_old_str, ll_start_pos)
// Only enter the loop if you find old_str.
DO WHILE ll_start_pos > 0
    // Replace old_str with new_str.
    ls_sql = Replace(ls_sql, ll_start_pos, 1, ls_new_str)
    // Find the next occurrence of old_str.
    ll_start_pos = Pos(ls_sql, ls_old_str, ll_start_pos + 1)
LOOP

ll_pos1 = Pos(ls_sql,' FROM ', 1)

if ll_pos1 = 0 then
	MessageBox('Aviso', 'No se la palabra reservada FROM en la setencia SQL')
	return
end if

ll_pos1 = Pos(ls_sql,' AS ', 1)

if ll_pos1 = 0 then
	MessageBox('Aviso', 'No se la palabra reservada AS en la setencia SQL')
	return
end if

ll_i = 1
do while ll_pos1 <> 0
	lb_from = false
	
	ll_pos1 += 4
	ll_pos2 = Pos(ls_sql,',', ll_pos1)
	if ll_pos2 = 0 then
		ll_pos2 = Pos(ls_sql,' FROM ', ll_pos1)
		if ll_pos2 = 0 then exit
		lb_from = true
	end if
	ls_columna = Mid(ls_sql, ll_pos1 , ll_pos2 - ll_pos1)
	
	// Evaluo si dentro de la columna se metio la palabra
	// resevada FROM
	ll_pos3 = Pos(ls_columna, ' FROM ', 1)
	
	if ll_pos3 > 0 then
		ls_columna = trim(Mid(ls_columna, 1, ll_pos3))
		ll_pos2 = ll_pos3
		lb_from = true
	end if
	
	ddlb_seleccion.InsertItem (lower(ls_columna), ll_i )
	ls_expresion = "#" + string(ll_i) + ".Name"
 	ls_campo =  dw_new.Describe( ls_expresion )
	
 	ls_expresion = ls_campo + "_t.Text = '" + lower(ls_columna) + "'"
	ls_mensaje = dw_new.Modify( ls_expresion )
	
	IF ls_mensaje <> "" THEN
   	MessageBox("Status", "Modify to Text Color " &
            + "of yes_or_no Failed " + ls_mensaje)
        RETURN
	END IF
	
	if string(ll_i) = istr_seleccionar.s_column then
		ddlb_seleccion.Text = lower(ls_columna)
	end if
	
	ll_pos2 ++
	ll_pos1 = Pos(ls_sql,' AS ', ll_pos2 )
	ll_i ++
	
	if lb_from then exit
loop


end subroutine

event open;//**************************************************************************************//
//Codigo Ejemplo: Copiar en el Evento Examinar														 //	
//**************************************************************************************//
//
//str_seleccionar lstr_seleccionar



//string ls_codigo
//integer li_i


//lstr_seleccionar.s_column = '2'- Indica el campo selecionado en la lista 
//                                            Despegable : ddlb_selecion
//lstr_seleccionar.s_sql       = 'SELECT INEN.ADM_TABLA.COD_TABLA AS CODIGO, 
//                                       INEN.ADM_TABLA.DES_TABLA AS DESCRIPCION 
//                                FROM   INEN.ADM_TABLA'	
//lstr_seleccionar.s_seleccion = 'M'  // M --> Selección multiple
//												  // S --> Selección Simple
//
//OpenWithParm(w_seleccionar,lstr_seleccionar)
//IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//IF lstr_seleccionar.s_action = "aceptar" THEN
//	FOR  li_i=1 TO UpperBound(lstr_seleccionar.param1)
//    ...
//		ls_codigo = lstr_seleccionar.param1[li_i]
//		messagebox('Retorno de w_seleccionar',ls_codigo)
//    ...
//    codigo para cada item seleccionado, se utiliza hasta lstr_seleccionar.param1
//    ...
//	NEXT
//END IF
//**************************************************************************************//



String 	ls_report_type, ls_style, ls_sql_syntax, ls_dw_err, &
			ls_dw_syntax, ls_type_font
Long		ll_long

IF IsValid(message.powerobjectparm) AND &
	ClassName(message.powerobjectparm) = 'str_seleccionar' THEN
	
	istr_seleccionar = message.powerobjectparm
	
ELSE
	messagebox('Aviso','Parámetros mal pasados')
	this.triggerevent("ue_cancel")
	Return
END IF

mle_1.text 	= istr_seleccionar.s_sql
ll_long		= len(istr_seleccionar.s_sql)

if istr_seleccionar.s_column = '' or IsNull(istr_seleccionar.s_column) then
	istr_seleccionar.s_column = '1'
end if

ls_report_type  = "grid"
ls_type_font    = "Arial"
ls_style = 'style(type=' + ls_report_type + ')' + &
	        'Text(background.mode=0 background.color=12632256 color=0  border=6 ' +&
	        'font.face = "' + ls_type_font + '"  font.height = -8  font.weight = 400 font.family = 2 ' + &
	        'font.pitch=2 ) ' + &
	        'Column(background.mode=0 background.color=1073741824 color=0 border=0 ' +&
           'font.face = "' + ls_type_font + '"  font.height = -8  font.weight = 400 font.family = 2 ' + &
	        'font.pitch = 2 ) ' 
			  
ls_sql_syntax = mle_1.text
ls_dw_err     = ""
ls_dw_syntax  = SyntaxFromSQL(sqlca, ls_sql_syntax, ls_style, ls_dw_err)

IF len(trim(ls_dw_err)) > 0 THEN
	messagebox('Error en SyntaxFromSQL',ls_dw_err,StopSign!)
	istr_seleccionar.s_action = 'cancel'
	Closewithreturn (This,istr_seleccionar )
	return
END IF

dw_new.Create(ls_dw_syntax, ls_dw_err)

dw_new.SetTransObject(sqlca)

//FOR ll_i = 1 TO Integer(dw_new.Object.DataWindow.Column.Count)
//	 dw_new.SetTabOrder(ll_i,0)
//	 ls_expresion = "#" + string(ll_i) + ".Text = '" + ls_campo + "'"
//	 dw_new.Modify( ls_expresion )
//NEXT

dw_new.Object.DataWindow.Selected.Mouse='No'
dw_new.Object.DataWindow.Retrieve.AsNeeded='Yes'
dw_new.Object.DataWindow.Grid.ColumnMove = "No"
dw_new.Object.DataWindow.Header.Height = 66

//wf_add_item_ddlb(dw_new)
of_add_item_ddlb()

sle_descripcion.SetFocus()
cb_listo.enabled = false


end event

on w_seleccionar.create
this.cb_listo=create cb_listo
this.dw_new=create dw_new
this.st_2=create st_2
this.st_1=create st_1
this.cbx_1=create cbx_1
this.st_3=create st_3
this.cb_cancelar=create cb_cancelar
this.cb_detener=create cb_detener
this.cb_iniciar=create cb_iniciar
this.sle_descripcion=create sle_descripcion
this.ddlb_seleccion=create ddlb_seleccion
this.mle_1=create mle_1
this.Control[]={this.cb_listo,&
this.dw_new,&
this.st_2,&
this.st_1,&
this.cbx_1,&
this.st_3,&
this.cb_cancelar,&
this.cb_detener,&
this.cb_iniciar,&
this.sle_descripcion,&
this.ddlb_seleccion,&
this.mle_1}
end on

on w_seleccionar.destroy
destroy(this.cb_listo)
destroy(this.dw_new)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cbx_1)
destroy(this.st_3)
destroy(this.cb_cancelar)
destroy(this.cb_detener)
destroy(this.cb_iniciar)
destroy(this.sle_descripcion)
destroy(this.ddlb_seleccion)
destroy(this.mle_1)
end on

type cb_listo from commandbutton within w_seleccionar
integer x = 1733
integer y = 24
integer width = 389
integer height = 88
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Aceptar"
end type

event clicked;parent.event dynamic ue_aceptar()
end event

type dw_new from uo_datawindow within w_seleccionar
event ue_keydwn pbm_dwnkey
integer x = 14
integer y = 424
integer width = 2098
integer height = 816
integer taborder = 70
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_keydwn;if key = KeyEnter! then
	IF cb_listo.enabled = true AND dw_new.rowcount() > 0 THEN
		cb_listo.triggerevent('clicked')
	END IF
end if
end event

event clicked;call super::clicked;IF dwo.TYPE = 'text' THEN
   uf_ordena(String(dwo.name))	
	if this.RowCount() > 0 then
		this.SetRow(1)
		this.SelectRow(0, false)
		this.SelectRow(1, true)
	end if
END IF
 

end event

event dberror;call super::dberror;RETURN 1
end event

event doubleclicked;call super::doubleclicked;Integer li_pos
String  ls_column, ls_name

ls_column = THIS.GetObjectAtPointer()
li_pos = pos(upper(ls_column),'~t')
ls_name = mid(ls_column, 1, li_pos - 1)

IF Lower(Right(ls_name, 2)) = '_t' THEN
	RETURN
END IF

IF cb_listo.enabled = true AND this.rowcount() > 0 THEN
	cb_listo.triggerevent('clicked')
END IF

end event

event rowfocuschanged;call super::rowfocuschanged;IF ISNULL(istr_seleccionar.s_seleccion) THEN  istr_seleccionar.s_seleccion = 'S'

uf_seleccion(dw_new,istr_seleccionar.s_seleccion)

end event

event retrieveend;call super::retrieveend;setpointer( arrow! )
st_3.text = 'Total de Reg. : '+string(rowcount)
IF ib_cancelboton THEN 	ib_cancelboton = FALSE

parent.event ue_detener()
end event

event retrievestart;call super::retrievestart;setpointer( Hourglass! )
ib_cancelboton = true

end event

event retrieverow;call super::retrieverow;
dw_new.ScrollNextRow( )
IF ib_cancelboton = FALSE THEN RETURN 1


end event

type st_2 from statictext within w_seleccionar
integer x = 14
integer y = 144
integer width = 279
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Descripción"
boolean focusrectangle = false
end type

type st_1 from statictext within w_seleccionar
integer x = 14
integer y = 44
integer width = 247
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Busca Por"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_seleccionar
integer x = 306
integer y = 236
integer width = 635
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mostrar solo lo necesario"
boolean righttoleft = true
end type

event clicked;if dw_new.rowcount() > 0 then
	Parent.triggerEvent( 'ue_detener' )
end if
end event

type st_3 from statictext within w_seleccionar
integer x = 41
integer y = 340
integer width = 585
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean focusrectangle = false
end type

type cb_cancelar from commandbutton within w_seleccionar
integer x = 1737
integer y = 312
integer width = 389
integer height = 88
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;Parent.triggerEvent( 'ue_cancel' )
end event

type cb_detener from commandbutton within w_seleccionar
integer x = 1737
integer y = 216
integer width = 389
integer height = 88
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Detener"
end type

event clicked;Parent.triggerEvent( 'ue_detener' )
end event

type cb_iniciar from commandbutton within w_seleccionar
integer x = 1737
integer y = 120
integer width = 389
integer height = 88
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Buscar"
end type

event clicked;Parent.triggerEvent( 'ue_busqueda' )
end event

type sle_descripcion from singlelineedit within w_seleccionar
event ue_key_down pbm_keydown
integer x = 302
integer y = 132
integer width = 1381
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event ue_key_down;IF KeyDown(KeyTab!) OR KeyDown(KeyEnter!) then
	Parent.triggerEvent( 'ue_busqueda' )
	IF dw_new.rowcount()>0 THEN
		dw_new.SelectRow( 1, True)
	END IF
end if
end event

type ddlb_seleccion from dropdownlistbox within w_seleccionar
integer x = 306
integer y = 36
integer width = 1381
integer height = 320
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean allowedit = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;String ls_campo



ls_campo = ddlb_seleccion.text(index)

If LEN(ls_campo) > 0 Then
	cb_iniciar.Enabled = TRUE
Else
	cb_iniciar.Enabled = FALSE
End if	
	
end event

type mle_1 from multilineedit within w_seleccionar
integer x = 5
integer y = 1300
integer width = 2107
integer height = 668
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

