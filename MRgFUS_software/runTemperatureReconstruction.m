function handle = runTemperatureReconstruction(handle)
%% This function polls the data file and reconstructs the image temperature
% Created by M. Poorman, W. Grissom - Fall 2014
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University
%
% Given inputs, displays real time data and returns variables containing
% the mean focus temperature and time vectors
%
% INPUTS:
% handle ------ structure containing all inputs and data thus far
% 
% OUTPUTS:
% handle ------ same structure with adjustments

%hard code temperature limits for hyperthermia...can adjust later i suppose
% tmax = 15; % deg C, for display
% tmin = -5; 

%zeropad fmask
ifmask = fftshift(ifft2(fftshift(handle.fmask)));
fsize = size(handle.fmask);
fzpad = zeros(512,512);
fzpad(256-fsize(1)/2+1:256+fsize(1)/2,256-fsize(2)/2+1:256+fsize(2)/2) = ifmask;
handle.fmask = abs(fftshift(fft2(fftshift(fzpad))));
handle.fmask(handle.fmask > 0.4) = 1;
handle.fmask(handle.fmask ~= 1) = 0;                    
     
cem = [];
meanCEM = [];
    fp = handle.Therm.fp;
    fp = fopen(handle.filepath,'r','ieee-be');
    % read header, spit out np,nt,nb to console
    % initialize file seek pointer to the index variable of first block
    % if that variable is nonzero, read the data and display ft
    % then increment seek index, and loop back
    
    if fp ~= -1
        %% Read overall header
        nblocks   = fread(fp,1,'int32');
        ntraces   = fread(fp,1,'int32');
%         keyboard;
        dt = ntraces*handle.tr; % seconds, time step of images
        t = 0:dt:(nblocks-1)*dt;
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
        fclose(fp);
        
        %% now loop until we have read all the data
        nblocksread = 0;
        handle.Therm.meantemp = [];
        handle.Therm.meanCEM = [];
        
        while nblocksread < nblocks
%             keyboard;
            fp = fopen(handle.filepath,'r','ieee-be');
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
                
                % Create image from data and find dimensions
                readim = RE+1i*IM;
                imdim = size(readim);
                               
                % zeropad and FT data to reconstruct image;
                zpad = zeros(512,512);
                zpad(256-imdim(1)/2+1:256+imdim(1)/2,256-imdim(2)/2+1:256+imdim(2)/2) = readim;
                img(:,:,nblocksread+1) = fftshift(fft2(fftshift(zpad)));
                        
                if nblocksread > 1
                    firstim = abs(img(:,:,1));
                    mask = abs(img(:,:,1)) > 0.01*max(firstim(:));
                    
                    % Calculate temperature from phase
                    tmap = angle(img(:,:,nblocksread+1).*conj(img(:,:,1)));
                    
                    %% Correct for field inhomogenity from heating
%                     if hasVariable(handle.driftmask) == 1
                    if exist('handle.driftmask')
                        handle = correctFieldDrift(handle);
                        tmap = handle.Therm.corrtmap;
                    end
                    tmap = tmap/(42.58*4.7*0.01*handle.te*2*pi); % Celsius
                    
                    % Plot cleaner overall tmap
                    figure(1)
                    subplot(221);
                    imagesc(tmap.*mask,[handle.Therm.tmin handle.Therm.tmax]);
                    colorbar;title 'degrees C';axis image
                    
                    % Plot temperature map in focus 
                    subplot(222);
                    imagesc(tmap.*handle.fmask,[handle.Therm.tmin handle.Therm.tmax]);
                    colorbar;title 'degrees C';axis image

                    % Calculate mean temperature in focus
%                     if hasVariable(handle.Therm.meantemp) == 1
                    if exist('handle.Therm.meantemp')
                        meantemp = handle.Therm.meantemp;
                    else
                        meantemp = [];
                    end
                    meantemp(end+1) = mean2(tmap.*handle.fmask);
                    handle.Therm.meantemp = meantemp;
                    
                    % Plot the mean focus temp over time
%                     keyboard;
                    subplot(212);hold on
                    plot(t(1:length(meantemp)),meantemp); axis([0 eps+t(length(meantemp)) handle.Therm.tmin handle.Therm.tmax]);
                    plot(t(1:length(meantemp)),handle.targT*ones(length(meantemp),1),'r'); grid on
                    xlabel 'Block Index',ylabel '\Delta ^{\circ} C'
                    handle.Therm.tmap = tmap;
                    %% Do CEM calc if chosen
                    if handle.calcCEM == 1
                        cem(:,:,end+1) = calculateDosage(handle,t(length(meantemp)));
                        CEM= cumsum(cem,3);
%                         keyboard
                        handle.Therm.meanCEM = squeeze(mean(mean(CEM.*repmat(handle.fmask,[1 1 size(CEM,3)]),1),2));
                    end             
                    
                    % update the control
                    focustemp = handle.Therm.tmap.*handle.fmask;
%                     keyboard
                    if ~exist('handle.HIFU')
                        handle.HIFU.voltage = 0;
                        handle.HIFU.ppi.nom = handle.targT;
                        handle.HIFU.ppi.igain = handle.iGain;
                        handle.HIFU.ppi.dgain = handle.dGain;
                        handle.HIFU.ppi.pgain = handle.pGain;
                        handle.HIFU.ppi.cmin = 0;
                        handle.HIFU.ppi.cmax = 0.1;
                    end
                        
                    %foobar = foobar(foobar >= 0);
%                     [handle.HIFU.voltage,handle.HIFU.ppi] = pidupdate(handle.HIFU.voltage,mean2(focustemp),handle.HIFU.ppi);
%                     if handle.HIFU.voltage > handle.maxV
%                         handle.HIFU.voltage = handle.maxV;
%                     end
                    
                    %% send resulting command to function generator
%                     handle = switchFGEN(handle);
                    
                end
                % Draw time elapsed since initial scan 
                drawnow
                title(['Block Index: ' num2str(nblocksread) '. Time: ' num2str(t(nblocksread+1)) ' seconds.']);
                % increment fpos and nblocksread
                fpos = ftell(fp);
                nblocksread = nblocksread + 1;
            end
            handle.Therm.fp = fp;
            fclose(fp);
        end
        handle.Therm.keepgoing = 0; % we should be all done now
    else
        disp('File not opened yet');
    end
    
    

