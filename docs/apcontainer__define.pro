;==============================================================================
; :: APDICTIONARY ::
;+=============================================================================
;
; This class is essentially a dictionary class that allows for very quick
; field value setting. 
;
; :Author:
;    Aram Panasenco (panasencoaram@gmail.com)
;
;-=============================================================================


;==============================================================================
;    APDICTIONARY::INIT
;+=============================================================================
;
;  Initializes an apDictionary object.
;
; :Examples:
;    IDL> mydict = obj_new('apDictionary', strkey='hi', intkey=-3, objkey=obj_new())
;
; :Returns:
;    Boolean success value (1/0)
;
; :Keywords:
;    _EXTRA : required
;      Keywords of the format FIELDNAME=VALUE. These define the initial class
;      structure.
;
;-=============================================================================
function apDictionary::init, _EXTRA=initStruct
	self.pContainer = ptr_new(/allocate_heap)
	self -> add, _extra=initStruct
	return, 1B
end


;==============================================================================
;    APDICTIONARY::ADD
;+=============================================================================
;
;  Adds (multiple) field names and values.
;
; :Keywords:
;    _EXTRA : required
;      Keywords of the format FIELDNAME=VALUE. The field names and values to
;      add to the structure. If some of the fieldnames are already defined in
;      the structure, they are overwritten.
;    SUCCESS : optional, type=boolean
;      Optional variable to store the success boolean flag.
;
;-=============================================================================
pro apDictionary::add, _extra=addStruct, SUCCESS=successBool
	
	;Check if any field values were passed
	if (n_elements(addStruct) eq 0) then begin
		successBool = 0B
		return
	endif
	
	;Check if the container is not empty
	if (n_elements(*self.pContainer) ne 0) then begin
		;Get the names of the fields being added and the already existing fields
		addNames = tag_names(addStruct)
		curNames = tag_names(*self.pContainer)
		;Remove all fields where the names are duplicate
		for i=0, n_elements(addNames)-1 do begin
			dupIndex = (where(curNames eq addNames))[0]
			if (dupIndex ne -1) then self -> _remove, dupIndex
		endfor
		;Check if the container didn't get entirely deleted in the removal process
		if (n_elements(*self.pContainer) ne 0) then begin
			*self.pContainer = create_struct(*self.pContainer, addStruct)
		endif else begin
			*self.pContainer = addStruct
		endelse
	endif else begin
		*self.pContainer = addStruct
	endelse
	
	successBool = 1B
	return
	
end


;==============================================================================
;    APDICTIONARY::_REMOVE
;+=============================================================================
;
;  Removes (multiple) field names from the container.
;
; :Private:
;
; :Params:
;    indices : required
;      An array of indices of the container field names to be removed.
;
; :Keywords:
;    SUCCESS : optional, type=boolean
;      Optional variable to store the success boolean flag.
;
;-=============================================================================
pro apDictionary::_remove, indices, SUCCESS=successBool
	
	successBool = 0B
	if (n_elements(indices) eq 0 or n_elements(*self.pContainer) eq 0) then return
	
	;Get the number of elements and the tag names of the internal container
	nContainer = n_tags(*self.pContainer)
	tContainer = tag_names(*self.pContainer)
	
	;Create a new container structure from scratch, not including the specified indices
	for i=0, nContainer-1 do begin
		if ((where(indices eq i))[0] eq -1) then begin
			if (n_elements(newContainer) ne 0) then begin
				newContainer = create_struct(tContainer[i],(*self.pContainer).(i),newContainer)
			endif else begin
				newContainer = create_struct(tContainer[i],(*self.pContainer).(i))
			endelse
		endif
	endfor
	
	if (n_elements(newContainer) ne 0) then begin
		;Set the new container
		*self.pContainer = newContainer
	endif else begin
		;Set the container to an empty pointer
		self.pContainer = ptr_new(/allocate_heap)
	endelse
	
	;Set the success boolean to true and return
	successBool = 1B
	return
	
end


;==============================================================================
;    APDICTIONARY::SET
;+=============================================================================
;
;  Sets (multiple) field values.
;
; :Keywords:
;    _EXTRA : required
;      Keywords of the format FIELDNAME=VALUE. The field names have to
;      correspond to those of the class structure (not case-sensitive).
;    SUCCESS : optional, type=boolean
;      Optional variable to store the success boolean flag.
;
;-=============================================================================
pro apDictionary::set, _extra=fieldStruct, SUCCESS=successBool
	
	;Define the successBool to be 0B (false) by default
	successBool = 0B
	
	;Check if no field values were passed or no container exists
	if (n_elements(fieldStruct) eq 0 or n_elements(*self.pContainer) eq 0) then return
	
	;Get the names of the fields being set
	fieldArray = tag_names(fieldStruct)
	
	;Loop through the field names in the field structure
	for fieldIndex=0, n_elements(fieldArray)-1 do begin
		
		fieldName = fieldArray[fieldIndex]
		
		;Get the index of the matching field in the container structure
		matchArray = strcmp(tag_names(*self.pContainer), fieldName, /fold_case)
		containerIndex = (where(matchArray eq 1))[0]
		
		if (containerIndex eq -1) then begin
			;No match, start the next iteration
			continue
		endif
		
		;Set the field
		(*self.pContainer).(containerIndex) = fieldStruct.(fieldIndex)
		successBool = 1B
		
	endfor
	
	;If none of the values have been set, successBool will be 0B
	;If any of the values have been set, successBool will be 1B
	return
	
end


;==============================================================================
;    APDICTIONARY::GET
;+=============================================================================
;
; Retrieves a field value.
;
; :Returns:
;    The value of the field.
;
; :Keywords:
;    _EXTRA : required
;      Keyword of the format /FIELDNAME. The field name has to
;      correspond to the name of a field in the class structure
;      (not case-sensitive).
;    SUCCESS : optional, type=boolean
;      Optional variable to store the success boolean flag.
;
;-=============================================================================
function apDictionary::get, _extra=fieldStruct, SUCCESS=successBool
	
	;Define the successBool to be 0B (false) by default
	successBool = 0B
	;Value to be returned if the get is unsuccessful
	NULL_RETURN_VALUE = -1
	
	;Check if more/less than one field name was passed or no container exists
	if (n_elements(fieldStruct) ne 1 or n_elements(*self.pContainer) eq 0) then $
	 return, NULL_RETURN_VALUE
	
	;Get the name of the field being retirved
	fieldName = (tag_names(fieldStruct))[0]
	
	;Get the index of the matching field in the class structure
	matchArray = strcmp(tag_names(*self.pContainer), fieldName, /fold_case)
	containerIndex = (where(matchArray eq 1))[0]
	
	;If no match, return unsuccessfully
	if (containerIndex eq -1) then return, NULL_RETURN_VALUE
	
	successBool = 1B
	return, (*self.pContainer).(containerIndex)
	
end


;==============================================================================
;    APDICTIONARY::DUPLICATE
;+=============================================================================
;
;    Creates a duplicate of the container
;
; :Returns:
;    A new container object identical to this one.
;
; :Keywords:
;    SUCCESS : optional, type=boolean
;      Optional variable to store the success boolean flag.
;
;-=============================================================================
function apDictionary::duplicate, SUCCESS=successBool
	dupObject = obj_new('apDictionary', _extra=(*self.pContainer))
	successBool = obj_valid(dupObject)
	return, dupObject
end


;==============================================================================
;    APDICTIONARY::CLEANUP
;+=============================================================================
; :Hidden:
;
; :Description:
;    Cleanup procedure for the apDictionary class
;
;-=============================================================================
pro apDictionary::cleanup
	;Free the internal data pointer
	ptr_free, self.pContainer
end


;==============================================================================
;    APDICTIONARY__DEFINE
;+=============================================================================
; :Hidden:
;
; :Description:
;    Definition procedure for the apDictionary class.
;
;-=============================================================================
pro apDictionary__define
	class = { $
		apDictionary, $
		pContainer: ptr_new() $
	}
end