%% convert small animal MRgFUS system into format usable for Jeremy's laser fiber data

function convert2PrettyOutput(filename)

    load(filename)

    outPuts.deltaTmaps_degC = outputs.delTmaps;
    outPuts.t_seconds = outputs.t;
    outPuts.imgs = outputs.img;
    params.fieldStrength_T = imgp.B0;
    params.FOV_cm = [imgp.lro imgp.lpe];
    params.sliceThickness_mm = imgp.thk;
    params.echoTime_s = imgp.te;
    params.repetitionTime_s = imgp.tr;
    params.matrix_nonZeroPadded = [imgp.np/2 imgp.nv];
    params.matrix_zeroPadded = [size(outPuts.deltaTmaps_degC,1) size(outPuts.deltaTmaps_degC,2)];
    params.voxelSize_finalZeroPadded_cm = [params.FOV_cm(1)/params.matrix_zeroPadded(1) params.FOV_cm(1)/params.matrix_zeroPadded(1) params.sliceThickness_mm/10];

    save([filename(1:end-4),'_laserFormatted.mat'],'outPuts','params');
end