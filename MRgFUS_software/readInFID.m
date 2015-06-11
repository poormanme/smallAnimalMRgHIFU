function [img,t] = readInFID(filepath)
%% Reads in FID file iteratively
% Created by M. Poorman, W. Grissom - Fall 2014
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University
%
% INPUTS:
% filepath ---- Path to file contiaing images
% 
% OUTPUTS:
% img --------- Image data set
%

fname = filepath;
keepgoing = 1;
while keepgoing
fp = fopen(fname,'r','ieee-be');
% read header, spit out np,nt,nb to console
% initialize file seek pointer to the index variable of first block
% if that variable is nonzero, read the data and display ft
% then increment seek index, and loop back

if fp ~= -1
    %% Read overall header
    nblocks   = fread(fp,1,'int32');
    ntraces   = fread(fp,1,'int32');
%     dt = ntraces*TR; % seconds, time step of images
%     t = 0:dt:(nblocks-1)*dt;
    np        = fread(fp,1,'int32');
    ebytes    = fread(fp,1,'int32');
    tbytes    = fread(fp,1,'int32');
    bbytes    = fread(fp,1,'int32');
    vers_id   = fread(fp,1,'int16');
    status    = fread(fp,1,'int16');
    nbheaders = fread(fp,1,'int32');

    s_data    = bitget(status,1);
    s_spec    = bitget(status,2);
    s_32      = bitget(status,3);
    s_float   = bitget(status,4);
    s_complex = bitget(status,5);
    s_hyper   = bitget(status,6);

    % store current position
    fpos = ftell(fp);
% 
    fclose(fp);
% 
%     %% now loop until we have read all the data
    nblocksread = 0;
%     
    while nblocksread < nblocks
        fp = fopen(fname,'r','ieee-be');
        fseek(fp,fpos,'bof');
        % read block header, check if index ~= 0
        scale     = fread(fp,1,'int16');
        bstatus   = fread(fp,1,'int16');
        index     = fread(fp,1,'int16');
        mode      = fread(fp,1,'int16');
        ctcount   = fread(fp,1,'int32');
        lpval     = fread(fp,1,'float32');
        rpval     = fread(fp,1,'float32');
        lvl       = fread(fp,1,'float32');
        tlt       = fread(fp,1,'float32');
        if index > 0
            % read the data
            %for ii = 1:ntraces
            %We have to read data every time in order to increment file pointer
            if s_float == 1
                data = fread(fp,np*ntraces,'float32');
            elseif s_32 == 1
                data = fread(fp,np*ntraces,'int32');
            else
                data = fread(fp,np*ntraces,'int16');
            end

            % keep data if this block & trace was in output list
            RE = data(1:2:np*ntraces);
            IM = data(2:2:np*ntraces);
            RE = reshape(RE,[np/2 ntraces]);
            IM = reshape(IM,[np/2 ntraces]);
            readim = RE+1i*IM;
            imdim = size(readim);

%             zeropad and FT data to reconstruct image;
            if imdim(1)<256 && imdim(2)<256
                zpad = zeros(512,512);
                zpad(256-imdim(1)/2+1:256+imdim(1)/2,256-imdim(2)/2+1:256+imdim(2)/2) = readim;
            else
                warning('Image too big for zeropadding with 256 by 256 matrix');
            end
            img = fftshift(fft2(fftshift(zpad)));
        end
        fpos = ftell(fp);
                nblocksread = nblocksread + 1;
       
    end
     fclose(fp);
end
keepgoing = 0;
end