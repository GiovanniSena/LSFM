function [ SXp, CXp ] = tr_correctXTPS( motorHandles, DX, B )
%%  TR_CORRECTXTPS Calculates the correct movement for Sx and Cx to maintain root in fov and in TPS
%   The DeltaX calculated by the tracker cannot be applied directly to the
%   cuvette because the TPS moves slightly with the cuvette. Instead, for a
%   certain DX calculated, the following movements must occur:
%   - Sx' = Sx + GX
%   - Cx' = Cx + B*GX
%   where GX is calculated as GX= DX/(1+B)
%   and where B is the linear coefficient that tells me how much the TPS is
%   moved when the cuvette is moved in X. B is estimated from data.
%   See LSFM documentation for further details.
 
%   Get motor handles
    SX = HW_getPos(motorHandles(1));
    CX = HW_getPos(motorHandles(4));

%   Find correct positions
    GX= DX/(1+B);
    SXp= SX+ GX;
    CXp= CX+ (GX*B);
    
%   Move motors to correct positions
    HW_moveAbsolute(motorHandles(1), SXp);
    HW_moveAbsolute(motorHandles(4), CXp);
    fprintf('ADJUSTING IN X. DELTA= %2.4f; Sx= %2.4f; Cx= %2.4f; Cxp= %2.4f; Sxp= %2.4f\n', DX, SX, CX, SXp, CXp);
end

