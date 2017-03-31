;==============================================================================
; :: _UT ::
;+=============================================================================
;
; This class is a collection of tests for 
;
; :Author:
;    Aram Panasenco: panasencoaram@gmail.com
;-=============================================================================

function _ut::init, _EXTRA=extra
    ok = self -> MGutTestCase::init(_extra=extra)
    if not ok then return, 0
    return, 1
end

function _ut::test_
    compile_opt idl2
    @error_is_pass
    
    assert, 0, 'Yay assertion failed!'
    
    return, 0
end

pro _ut__define
    class = { _ut, INHERITS MGutTestCase }
end
