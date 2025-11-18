$PBExportHeader$n_dwr_psr.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_dwr_psr from nonvisualobject
end type
type st_dwlookup from structure within n_dwr_psr
end type
end forward

type st_dwlookup from structure
	string		dwo_name
	string		dwo_id
end type

shared variables
long ii_recsize
string is_tempdir = ""
long ii_tempid
boolean ib_debug_keep_temp = false
end variables

global type n_dwr_psr from nonvisualobject
end type
global n_dwr_psr n_dwr_psr

type variables
private string is_file = ""
private olestorage ipo_storage
private st_dwlookup ipo_dwlookup[]
private boolean ib_temporary = false
public string band_detail = "1"
public string band_header = "2"
public string band_footer = "3"
public string band_summary = "4"
public string band_groupheader = "5"
public string band_grouptrailer = "6"
end variables

forward prototypes
public function integer of_close ()
private function long of_copystream (olestorage apo_src_root_storage,string as_src_stream_name,olestorage apo_tgt_root_storage,string as_tgt_stream_name)
private function integer of_copystream (olestream apo_src_stream,olestream apo_tgt_stream)
public function integer of_createfromdw (powerobject apo_dw)
public subroutine of_debug_keep_temp (boolean ab_debug_keep_temp)
private function string of_finddwoid (string as_dwoname)
public function string of_gettempfilename (string as_prefix,string as_suffix)
private function integer of_makestorage (olestorage apo_root_storage,string as_dir)
public function integer of_nested2ds (string as_nested_id,string as_dataobject,string as_parent_band,long al_parent_row,string as_dddw_column_id[],ref datastore ads_nested)
public function integer of_nested2psr (string as_nested_id,string as_nested_instance_id,string as_parent_band,long al_parent_row,string as_dddw_column_id[],string as_psr_name)
public function integer of_openfile (string as_file)
private function olestream of_openstream (olestorage apo_storage,string as_name,stgreadmode apo_mode)
private function olestorage of_opensubstorage (string as_name,olestorage apo_parentstorage,stgreadmode apo_mode)
private function integer of_parsedwlookup ()
public function integer of_parsepath (string as_path,ref string as_out_dir,ref string as_out_file)
private function blob of_readstream (olestorage apo_root_storage,string as_stream)
private function integer of_setdwlookuprecsize ()
end prototypes

public function integer of_close ();integer li_ret = -1

if isvalid(ipo_storage) then
	li_ret = ipo_storage.close()
	setnull(ipo_storage)

	if ib_temporary then
		filedelete(is_file)
	end if

	is_file = ""
end if

return li_ret
end function

private function long of_copystream (olestorage apo_src_root_storage,string as_src_stream_name,olestorage apo_tgt_root_storage,string as_tgt_stream_name);olestorage lpo_src_storage
olestorage lpo_tgt_storage
olestream lpo_src_stream
olestream lpo_tgt_stream
long li_ret
string ls_src_dir = ""
string ls_src_file
string ls_tgt_dir = ""
string ls_tgt_file

setnull(lpo_src_stream)
setnull(lpo_tgt_stream)
of_parsepath(as_src_stream_name,ls_src_dir,ls_src_file)

if ls_src_dir = "" then
	lpo_src_storage = apo_src_root_storage
else
	lpo_src_storage = of_opensubstorage(ls_src_dir,apo_src_root_storage,stgread!)
end if

of_parsepath(as_tgt_stream_name,ls_tgt_dir,ls_tgt_file)

if ls_tgt_dir = "" then
	lpo_tgt_storage = apo_tgt_root_storage
else
	lpo_tgt_storage = of_opensubstorage(ls_tgt_dir,apo_tgt_root_storage,stgreadwrite!)
end if

if ((isnull(lpo_src_storage)) or (isnull(lpo_tgt_storage))) then
else
	lpo_src_stream = of_openstream(lpo_src_storage,ls_src_file,stgread!)

	if isnull(lpo_src_stream) then
	else
		lpo_tgt_stream = of_openstream(lpo_tgt_storage,ls_tgt_file,stgwrite!)

		if isnull(lpo_tgt_stream) then
		else
			li_ret = of_copystream(lpo_src_stream,lpo_tgt_stream)

			if li_ret <> 0 then
			else
				lpo_src_stream.close()
				lpo_tgt_stream.close()

				if ls_src_dir <> "" then
					lpo_src_storage.close()
				end if

				if ls_tgt_dir <> "" then
					lpo_tgt_storage.close()
				end if

				return 1
			end if

		end if

	end if

end if

if ls_src_dir <> "" then
	lpo_src_storage.close()
end if

if ls_tgt_dir <> "" then
	lpo_tgt_storage.close()
end if

if not isnull(lpo_src_stream) then
	lpo_src_stream.close()
end if

if not isnull(lpo_tgt_stream) then
	lpo_tgt_stream.close()
end if

return -1
end function

private function integer of_copystream (olestream apo_src_stream,olestream apo_tgt_stream);long li_ret
long li_streamsize
long li_chunksize = 30000
blob lb_temp

if apo_src_stream.length(li_streamsize) <> 0 then
	return -1
end if

do while li_streamsize > 0
	li_ret = apo_src_stream.read(lb_temp,min(li_chunksize,li_streamsize))

	if li_ret < 0 then
		return -1
	end if

	li_ret = apo_tgt_stream.write(lb_temp)

	if li_ret <= 0 then
		return -1
	end if

	li_streamsize -= li_chunksize
loop

return 0
end function

public function integer of_createfromdw (powerobject apo_dw);string ls_file

ls_file = of_gettempfilename("dw",".psr")

if fileexists(ls_file) then

	if not filedelete(ls_file) then
		return -1
	end if

end if

if apo_dw.dynamic saveas(ls_file,psreport!,true) <> 1 then
	return -1
end if

if of_openfile(ls_file) <> 1 then
	filedelete(ls_file)
	return -1
end if

ib_temporary = true
return 1
end function

public subroutine of_debug_keep_temp (boolean ab_debug_keep_temp);ib_debug_keep_temp = ab_debug_keep_temp
end subroutine

private function string of_finddwoid (string as_dwoname);long li_reccount
long li_record

li_reccount = upperbound(ipo_dwlookup)
as_dwoname = lower(as_dwoname)

for li_record = 1 to li_reccount

	if ipo_dwlookup[li_record].dwo_name = as_dwoname then
		return ipo_dwlookup[li_record].dwo_id
	end if

next

return ""
end function

public function string of_gettempfilename (string as_prefix,string as_suffix);string ls_values[]
contextkeyword lpo_kw
integer li_ret

if is_tempdir = "" then
	li_ret = getcontextservice("Keyword",lpo_kw)
	lpo_kw.getcontextkeywords("TEMP",ls_values)

	if upperbound(ls_values) > 0 then
		is_tempdir = ls_values[1]
	else
		is_tempdir = "."
	end if

end if

ii_tempid ++
return (is_tempdir + "\dw2xls_" + as_prefix + string(ii_tempid) + "_" + string(handle(getapplication())) + as_suffix)
end function

private function integer of_makestorage (olestorage apo_root_storage,string as_dir);olestorage lpo_tgt_storage

lpo_tgt_storage = of_opensubstorage(as_dir,apo_root_storage,stgreadwrite!)

if isnull(lpo_tgt_storage) then
	return -1
end if

lpo_tgt_storage.close()
return 1
end function

public function integer of_nested2ds (string as_nested_id,string as_dataobject,string as_parent_band,long al_parent_row,string as_dddw_column_id[],ref datastore ads_nested);string ls_temppsr
string ls_instance_id
integer li_ret

ls_instance_id = of_finddwoid(as_dataobject)

if ls_instance_id = "" then
	return -1
end if

ls_temppsr = of_gettempfilename("nest",".psr")
li_ret = of_nested2psr(as_nested_id,ls_instance_id,as_parent_band,al_parent_row,as_dddw_column_id,ls_temppsr)

if li_ret <> 1 then
	return -1
end if

ads_nested = create datastore
ads_nested.dataobject = ls_temppsr

if ib_debug_keep_temp then
else
	filedelete(ls_temppsr)
end if

if not isvalid(ads_nested.object) then
	setnull(ads_nested)
	return -1
end if

return 1
end function

public function integer of_nested2psr (string as_nested_id,string as_nested_instance_id,string as_parent_band,long al_parent_row,string as_dddw_column_id[],string as_psr_name);olestorage lpo_tgt_storage
long li_ret = 1
long li_item
long li_column
string ls_nested_data_name

ls_nested_data_name = "datanest_" + string(al_parent_row) + "_" + as_parent_band + "_" + as_nested_id
lpo_tgt_storage = create olestorage
filedelete(as_psr_name)
li_ret = lpo_tgt_storage.open(as_psr_name,stgreadwrite!)

if li_ret <> 0 then
	return -1
end if

of_makestorage(lpo_tgt_storage,"neststg")
of_makestorage(lpo_tgt_storage,"dwstg")
li_ret = 1

if li_ret > 0 then
	li_ret = of_copystream(ipo_storage,"neststg\" + ls_nested_data_name,lpo_tgt_storage,"data")
end if

if li_ret > 0 then
	li_ret = of_copystream(ipo_storage,"dwstg\source_" + as_nested_instance_id,lpo_tgt_storage,"source")
end if

if li_ret > 0 then
	li_ret = of_copystream(ipo_storage,"dwstg\object_" + as_nested_instance_id,lpo_tgt_storage,"object")
end if

if li_ret > 0 then
	li_ret = of_copystream(ipo_storage,"dwstg\dwlookup",lpo_tgt_storage,"dwstg\dwlookup")
end if

for li_item = 1 to upperbound(ipo_dwlookup)

	if ipo_dwlookup[li_item].dwo_id = as_nested_instance_id then
	else

		if li_ret > 0 then
			li_ret = of_copystream(ipo_storage,"dwstg\source_" + ipo_dwlookup[li_item].dwo_id,lpo_tgt_storage,"dwstg\source_" + ipo_dwlookup[li_item].dwo_id)
		end if

		if li_ret > 0 then
			li_ret = of_copystream(ipo_storage,"dwstg\object_" + ipo_dwlookup[li_item].dwo_id,lpo_tgt_storage,"dwstg\object_" + ipo_dwlookup[li_item].dwo_id)
		end if

	end if

next

if li_ret > 0 then

	for li_item = 1 to upperbound(as_dddw_column_id)
		li_ret = of_copystream(ipo_storage,"neststg\datadddw_1_" + as_dddw_column_id[li_item] + "_0_" + string(al_parent_row),lpo_tgt_storage,"neststg\datadddw_0_" + as_dddw_column_id[li_item] + "_0")
	next

	li_ret = 1
end if

lpo_tgt_storage.close()
return li_ret
end function

public function integer of_openfile (string as_file);integer li_ret

ipo_storage = create olestorage
li_ret = ipo_storage.open(as_file,stgread!)

if li_ret <> 0 then
	setnull(ipo_storage)
	return -1
end if

is_file = as_file
of_parsedwlookup()
return 1
end function

private function olestream of_openstream (olestorage apo_storage,string as_name,stgreadmode apo_mode);olestream lpo_stream
integer li_ret = -1

lpo_stream = create olestream
li_ret = lpo_stream.open(apo_storage,as_name,apo_mode)

if li_ret <> 0 then
	setnull(lpo_stream)
	return lpo_stream
end if

return lpo_stream
end function

private function olestorage of_opensubstorage (string as_name,olestorage apo_parentstorage,stgreadmode apo_mode);olestorage lpo_storage
integer li_ret

lpo_storage = create olestorage
li_ret = lpo_storage.open(as_name,apo_mode,stgexclusive!,apo_parentstorage)

if li_ret <> 0 then
	setnull(lpo_storage)
	return lpo_storage
end if

return lpo_storage
end function

private function integer of_parsedwlookup ();st_dwlookup e[]
long li_reccount
long li_record
long li_pos
integer li_dw_id
blob lbb_data
blob{4} lbb_long

ipo_dwlookup = e

if ii_recsize = 0 then

	if of_setdwlookuprecsize() <> 1 then
		return -1
	end if

end if

lbb_data = of_readstream(ipo_storage,"dwstg\dwlookup")

if isnull(lbb_data) then
	return 0
end if

blobedit(lbb_long,1,long(0))
li_reccount = long(blobmid(lbb_data,1,4))

if ((li_reccount < 0) or (li_reccount > 10000)) then
	return -1
end if

for li_record = 1 to li_reccount
	ipo_dwlookup[li_record].dwo_name = lower(string(blobmid(lbb_data,5 + (li_record - 1) * ii_recsize,ii_recsize - 2)))
	blobedit(lbb_long,1,blobmid(lbb_data,5 + li_record * ii_recsize - 2,2))
	ipo_dwlookup[li_record].dwo_id = string(long(lbb_long))
next

return 1
end function

public function integer of_parsepath (string as_path,ref string as_out_dir,ref string as_out_file);long li_pos

li_pos = pos(reverse(as_path),"\")

if li_pos > 0 then
	as_out_dir = left(as_path,len(as_path) - li_pos)
	as_out_file = right(as_path,li_pos - 1)
else
	as_out_file = as_path
	as_out_dir = ""
end if

return 1
end function

private function blob of_readstream (olestorage apo_root_storage,string as_stream);long li_ret
string ls_dir = ""
string ls_file
olestorage lpo_storage
olestream lpo_stream
blob lbb_data

setnull(lpo_stream)
of_parsepath(as_stream,ls_dir,ls_file)

if ls_dir = "" then
	lpo_storage = apo_root_storage
else
	lpo_storage = of_opensubstorage(ls_dir,apo_root_storage,stgread!)
end if

if isnull(lpo_storage) then
else
	lpo_stream = of_openstream(lpo_storage,ls_file,stgread!)

	if isnull(lpo_stream) then
	else
		li_ret = lpo_stream.read(lbb_data)

		if li_ret < 0 then
		else
			return lbb_data
		end if

	end if

end if

setnull(lbb_data)
return lbb_data
end function

private function integer of_setdwlookuprecsize ();environment lenv

ii_recsize = 42 + 2
getenvironment(lenv)

choose case lenv.charset
	case charsetansi!
		ii_recsize = 42 + 2
	case charsetunicode!
		ii_recsize = 84 + 2
	case else
		return -1
end choose

return 1
end function

on n_dwr_psr.create
call super::create;

triggerevent("constructor")
end on

on n_dwr_psr.destroy
triggerevent("destructor")
call super::destroy
end on

event destructor;of_close()
return
end event

