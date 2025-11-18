$PBExportHeader$n_xls_formats.sru
forward
global type n_xls_formats from nonvisualobject
end type
end forward

global type n_xls_formats from nonvisualobject
end type
global n_xls_formats n_xls_formats

type variables
String			is_Keys[] 
String			is_Font_Keys[] 
String         is_Num_Format[] 


Blob  			iblob_Font[]
Blob 				iblob_xfs[]


Datastore      ids_System_Foramts
Int				ii_System_Format_cnt
end variables

forward prototypes
public function long of_format_exist (readonly string as_key)
public function integer of_font_exist (readonly string as_key)
public function long of_add (ref n_xls_format anvo_format)
public function integer of_num_format_exist (readonly string as_format)
end prototypes

public function long of_format_exist (readonly string as_key);Long  li,li_Count 
li_Count=UpperBound(is_Keys) 

For li=1 To li_Count 
	IF is_Keys[li]=as_Key Then
		Return li
	END IF
Next

Return -1 

end function

public function integer of_font_exist (readonly string as_key);Long  li,li_Count 
li_Count=UpperBound(is_Font_Keys) 

For li=1 To li_Count
	IF is_Font_Keys[li]=as_Key Then
		Return li
	END IF
Next

Return -1 

end function

public function long of_add (ref n_xls_format anvo_format);Long li_Index
Long li_KeyIndex
String ls_Key
Blob lb_data 
boolean lb_flag 

IF IsNull(anvo_format) OR Not IsValid(anvo_Format) Then
	Return li_Index
END IF


ls_Key=anvo_Format.OF_Get_Format_Key() 
li_KeyIndex=OF_Format_Exist(ls_Key)
IF li_KeyIndex>0 Then
   Return li_KeyIndex
END IF

li_KeyIndex=UpperBound(is_Keys)+1
is_Keys[li_KeyIndex]=ls_Key 

////字体

ls_Key=anvo_Format.OF_Get_Font_Key() 
li_Index=OF_Font_Exist(ls_Key)
IF li_Index<=0 Then
	li_Index= UpperBound(is_Font_Keys)+1
	is_Font_Keys[li_Index]=ls_Key 
	lb_data= anvo_Format.of_get_font() 
	iblob_font[li_Index]=lb_data
END IF
anvo_Format.ii_font_index= li_Index +5



//数据格式
IF anvo_Format.is_Num_Format<>"" AND Lower(anvo_Format.is_Num_Format)<>"general" and anvo_Format.ii_Num_Format = 0 Then
	li_Index=ids_System_Foramts.Find("Key='"+anvo_Format.is_Num_Format+"'",1,ii_System_Format_cnt)
	IF li_Index>0 Then
		 anvo_Format.ii_num_format = ids_System_Foramts.Object.Index[li_Index] - 1 
	ELSE
			li_Index=OF_num_Format_Exist(anvo_Format.is_Num_Format)
			IF li_Index<=0 Then
				li_Index=UpperBound(is_Num_Format)+1
				is_Num_Format[li_Index]=anvo_Format.is_Num_Format 
			END IF
			anvo_Format.ii_num_format = li_Index  +164 - 1 
	END IF 
END IF

//单元格式
lb_data= anvo_Format.of_get_xf("cell")
iblob_xfs[li_KeyIndex]=lb_data
Return li_KeyIndex
end function

public function integer of_num_format_exist (readonly string as_format);Long  li,li_Count 
li_Count=UpperBound(is_Num_Format) 

For li=1 To li_Count
	IF is_Num_Format[li]=as_format Then
		Return li
	END IF
Next

Return -1 

end function

on n_xls_formats.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_xls_formats.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;ids_System_Foramts=Create Datastore 
ids_System_Foramts.DataObject="d_dw2xls_systemFormat" 
ii_System_Format_cnt= ids_System_Foramts.RowCount() 
end event

event destructor;Destroy ids_System_Foramts
end event

