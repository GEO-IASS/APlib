;==============================================================================
; :: APSTACK ::
;+=============================================================================
;
; This class is an object-oriented wrapper around a basic stack.
; The undelying structure is an array.
; Values are added to the beginning and popped from the beginning.
;
; :Author:
;    Aram Panasenco (panasencoaram@gmail.com)
;
;-=============================================================================

;==============================================================================
;    APSTACK::INIT
;+=============================================================================
; :Description:
;    Initializes an apStack object.
;
; :Returns:
;    Boolean success value (1/0)
;-=============================================================================
function apStack::init
	self.nElements = 0L
	return, 1B
end


;==============================================================================
;    APSTACK::PUSH
;+=============================================================================
; :Description:
;    Pushes a value to the beginning of the stack
;
; :Params:
;    var : required
;      The value being pushed onto the stack
; :Keywords:
;    TO_END : optional, type=boolean
;      Set this keyword to push the value onto the end of the stack (pushing
;      to the beginning is the default behavior).
;
;-=============================================================================
pro apStack::push, var, TO_END=toEnd
	
	;Return to caller in case of an error
	on_error, 2
	
	if (self.nElements eq 0) then begin
		;Create the data
		self.pData = ptr_new(var)
	endif else begin
		if keyword_set(toEnd) then begin
			;Add the variable to the end of the data
			*self.pData = [*self.pData, var]
		endif else begin
			;Add the variable to the beginning of the data
			*self.pData = [var,*self.pData]
		endelse
	endelse
	
	self.nElements++
end


function apStack::read, index, ALL=all
	
	;Return to caller in case of an error
	on_error, 2
	
	;Check if there are any elements to read
	if (self.nElements eq 0) then begin
		message, "Can't read: No elements in stack."
	endif
	
	if (keyword_set(all)) then begin
		;Return all elements
		return, *self.pData
	endif else begin
		;Sanity-check the index
		if n_elements(index) ne 1 then index = 0
		if index lt 0 then index = 0
		if index gt self.nElements-1 then index = self.nElements-1
		;Return the element specified by index
		return, (*self.pData)[index]
	endelse
end


pro apStack::write, value, index
	
	;Sanity-check the index
	if n_elements(index) ne 1 then index = 0
	if index lt 0 then index = 0
	;Check for push or write
	if index gt self.nElements-1 then begin
		self -> push, value, /to_end
	endif else begin
		;Write the value to the index
		pData = *self.pData
		pData[index] = value
		*self.pData = pData
	endelse
	
end


function apStack::pop
	
	on_error, 2
	
	;Check for stack underflow
	if (self.nElements eq 0) then begin
		message, "Can't pop: No elements in stack."
	endif
	
	;Find the value of the first element in the stack
	popElement = (*self.pData)[0]
	
	if (self.nElements gt 1) then begin
		;Remove the first element from the stack
		(*self.pData) = (*self.pData)[1:self.nElements-1]
		self.nElements--
	endif else begin
		;No more elements to remove, clear the data
		self -> clear
	endelse
	
	;Return the first element
	return, popElement
end


function apStack::count
	return, self.nElements
end


pro apStack::clear
	
	;Clear the data
	ptr_free, self.pData
	
	;Default the number of elements
	self.nElements = 0
end


pro apStack::cleanup
	;Destroy the data
	ptr_free, self.pData
end


;==============================================================================
;    APDATA__DEFINE
;+=============================================================================
; :Hidden:
;
; :Description:
;    Definition procedure for the apStack class
;
;-=============================================================================
pro apStack__define
	class = { $
		apStack, $
		nElements: 0L, $
		pData: ptr_new() $
	}
end