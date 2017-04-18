@echo off
set MATLAB=C:\PROGRA~1\MATLAB\R2014a
set MATLAB_ARCH=win64
set MATLAB_BIN="C:\Program Files\MATLAB\R2014a\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=callabsval_mex
set MEX_NAME=callabsval_mex
set MEX_EXT=.mexw64
call "C:\PROGRA~1\MATLAB\R2014a\sys\lcc64\lcc64\mex\lcc64opts.bat"
echo # Make settings for callabsval > callabsval_mex.mki
echo COMPILER=%COMPILER%>> callabsval_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> callabsval_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> callabsval_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> callabsval_mex.mki
echo LINKER=%LINKER%>> callabsval_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> callabsval_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> callabsval_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> callabsval_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> callabsval_mex.mki
echo BORLAND=%BORLAND%>> callabsval_mex.mki
echo OMPFLAGS= >> callabsval_mex.mki
echo OMPLINKFLAGS= >> callabsval_mex.mki
echo EMC_COMPILER=lcc64>> callabsval_mex.mki
echo EMC_CONFIG=optim>> callabsval_mex.mki
"C:\Program Files\MATLAB\R2014a\bin\win64\gmake" -B -f callabsval_mex.mk
