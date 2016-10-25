;==============================================================================
; :: APDATA ::
;+=============================================================================
;
; This class is a basic data container meant to be used instead of bothering
; with pointers or the clunky IDLitData class
;
; :Author:
;    Aram Panasenco (panasencoaram@gmail.com)
;
;-=============================================================================


;==============================================================================
;    APDATA::INIT
;+=============================================================================
; :Description:
;    Initializes an apData object .
;
; :Params:
;    data : optional
;      The data to store in the object
;
; :Returns:
;    Boolean success value (1/0)
;-=============================================================================
function apData::init, data
	self -> setData, data
	return, 1B
end


;==============================================================================
;    APDATA::HASDATA
;+=============================================================================
; :Description:
;    Checks if the data object has data
;-=============================================================================
function apData::hasData
	if (ptr_valid(self.data)) then begin
		return, 1B
	endif else begin
		return, 0B
	endelse
end


;==============================================================================
;    APDATA::GETDATA
;+=============================================================================
; :Description:
;    Returns the data stored in the data object.
;
; :Returns:
;    Data stored in the object
;-=============================================================================
function apData::getData, SUCCESS=success
	if (ptr_valid(self.data)) then begin
		success = 1B
		return, *(self.data)
	endif else begin
		success = 0B
		return, 0
	endelse
end


;==============================================================================
;    APDATA::SETDATA
;+=============================================================================
; :Description:
;    Sets the data to be stored in the data object.
;
; :Params:
;    data : required
;      The data to store in the object
;-=============================================================================
pro apData::setData, data, SUCCESS=success
	;Do nothing if the data is undefined
	if (n_elements(data) eq 0) then begin
		success = 0B
		return
	endif
	
	if (ptr_valid(self.data)) then begin
		*(self.data) = data
	endif else begin
		self.data = ptr_new(data)
	endelse
	success = 1B
end


;------------------------------------------------------------------------------
;    APDATA::DUPLICATE
;+=============================================================================
; :Description:
;    Duplicates the object with identical data, but a different object
;    reference.
;-============================================================================
function apData::duplicate, SUCCESS=success
	return, obj_new('apData',self -> getData())
end

;==============================================================================
;    APDATA::DESTROYDATA
;+=============================================================================
; :Description:
;    Destroys the data stored in the data object.
;-=============================================================================
pro apData::destroyData, SUCCESS=success
	ptr_free, self.data
	success = 1B
end


;==============================================================================
;    APDATA::CLEANUP
;+=============================================================================
; :Private:
;
; :Description:
;    Free the data pointer
;-=============================================================================
pro apData::cleanup
	self -> destroyData
end


;==============================================================================
;    APDATA__DEFINE
;+=============================================================================
; :Hidden:
;
; :Description:
;    Definition procedure for the apData class
;
;-=============================================================================
pro apdata__define
	class = { $
		apData, $
		data: ptr_new() $
	}
end