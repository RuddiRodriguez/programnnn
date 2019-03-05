function [cfpoints_loweronhill,cfpoints_upperonhill,cfpoints_lowerplus,cfpoints_upperplus,cfpc_loweronhill,cfpc_upperonhill,cfpc_lowerplus,cfpc_upperplus]=imat_prepare_cutoff(imati,X)
loweronhill=imati.cutting.loweronhill;
upperonhill=imati.cutting.upperonhill;
lowercutoff=imati.cutting.lowercutoff;
uppercutoff=imati.cutting.uppercutoff;


cfpoints_loweronhill=0;
cfpoints_upperonhill=0;
cfpoints_lowerplus=0;
cfpoints_upperplus=0;
cfpc_loweronhill=0;
cfpc_upperonhill=0;
cfpc_lowerplus=0;
cfpc_upperplus=0;


[N M]=size(X);
if imati.cutting.type.onhill==1
    cfpoints_loweronhill=sum(sum(X<loweronhill));
    cfpoints_upperonhill=sum(sum(X>upperonhill));
    cfpc_loweronhill=(cfpoints_loweronhill/(N*M)*100.0);
    cfpc_upperonhill=(cfpoints_upperonhill/(N*M)*100.0);
end
if imati.cutting.type.plus==1
    cfpoints_lowerplus=sum(sum(X<lowercutoff));
    cfpoints_upperplus=sum(sum(X>uppercutoff));
    cfpc_lowerplus=(cfpoints_lowerplus/(N*M)*100.0);
    cfpc_upperplus=(cfpoints_upperplus/(N*M)*100.0);
end

