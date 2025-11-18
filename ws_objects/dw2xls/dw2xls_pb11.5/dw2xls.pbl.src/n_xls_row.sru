$PBExportHeader$n_xls_row.sru
forward
global type n_xls_row from nonvisualobject
end type
end forward

shared variables

end variables

global type n_xls_row from nonvisualobject
end type
global n_xls_row n_xls_row

type variables
n_xls_cell        invo_Cells[]    //保存当前行的全部列
UINT 					ii_Row
UINT					ii_MaxCol
PUBLIC 				n_xls_WorkSheet     invo_WorkSheet 

end variables

forward prototypes
public subroutine of_setrow (unsignedinteger ai_row)
public subroutine of_priorcell_wraptext (integer ai_endcol)
public subroutine of_set_row (unsignedinteger ai_row, boolean ab_border)
end prototypes

public subroutine of_setrow (unsignedinteger ai_row);uInt li ,lj 

ii_Row=ai_Row
lj=UpperBound(invo_Cells)+1 
For li=lj To ii_MaxCol
	invo_Cells[li]=Create  n_xls_Cell
	invo_Cells[li].Row=ai_Row
	invo_Cells[li].Col=li  
	invo_Cells[li].invo_WorkSheet = invo_WorkSheet
Next 
end subroutine

public subroutine of_priorcell_wraptext (integer ai_endcol);/*----------------------------------
  判断是否有单元的结束列为 ai_EndCol 
--------------------------------------------*/
Int li 

IF ai_EndCol> ii_MaxCol OR ai_EndCol<=1 Then
	Return 
END IF
ai_EndCol= ai_EndCol -1 
For li=ai_EndCol To 1 Step -1 
	 IF IsValid(invo_Cells[li]) Then
		 IF Not Invo_Cells[li].ib_Empty Then
				 IF invo_Cells[li].Col=ai_EndCol or invo_Cells[li].EndCol=ai_EndCol Then
					  invo_Cells[li].invo_format.ii_text_wrap=1 
					  Return 
				  ELSE
					  Return 
				  END IF
			END IF
	 END IF
Next

Return

	
		
			

end subroutine

public subroutine of_set_row (unsignedinteger ai_row, boolean ab_border);/*-----------------------------------------------------------
   在设置行的同时,同时设置该行全部单元的边框属性
--------------------------------------------------------------*/


uInt li ,lj 


ii_Row=ai_Row
lj=UpperBound(invo_Cells)+1 
For li=lj To ii_MaxCol
	invo_Cells[li]=Create  n_xls_Cell
	invo_Cells[li].Row=ai_Row
	invo_Cells[li].Col=li  
	invo_Cells[li].invo_WorkSheet = invo_WorkSheet
	
	IF ab_Border Then 
		invo_Cells[li].invo_Format.ii_left=1
		invo_Cells[li].invo_Format.ii_Right=1
		invo_Cells[li].invo_Format.ii_top=1
		invo_Cells[li].invo_Format.ii_bottom=1
		
	END IF
	
Next 
end subroutine

on n_xls_row.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_xls_row.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

