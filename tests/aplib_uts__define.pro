function aplib_uts::init, _extra=e
    compile_opt strictarr
    
    if (~self->mguttestsuite::init(_strict_extra=e)) then return, 0
    
    self->add, /all
    
    return, 1
end

pro aplib_uts__define
    compile_opt strictarr
    
    define = { aplib_uts, inherits MGutTestSuite }
end