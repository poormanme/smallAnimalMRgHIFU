% Created by M. Poorman, W. Grissom - December 2015
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University

function output = runTempRecon(fus,algo,imgp,ppi,CEM,keepgoing,reconMode)
gamma = algo.gamma;%42.58; %MHz/T
alpha = algo.alpha;%0.01; %ppm/deg C
voltage = 0;

while keepgoing
    %---open file
    % read header, spit out np,nt,nb to console
    % initialize file seek pointer to the index variable of first block
    % if that variable is nonzero, read the data and display ft
    % then increment seek index, and loop back
    fileprops = dir(algo.dynfilepath)
    fp = fopen(algo.dynfilepath ,'r','ieee-be');

    if fp ~= -1
        % read overall header
        nblocks   = fread(fp,1,'int32');
        ntraces   = fread(fp,1,'int32');
        dt = ntraces*imgp.tr*imgp.nt; % seconds, time step of images
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

        %---now loop until we have read all the data\
        
        %-preallocate
        nblocksread = 0;
        output.meantemp = [];
        output.img = zeros(512,512,length(t));
        output.delTmaps = zeros(512,512,length(t));
        voltVals = [];
        filepropstmp = dir(algo.dynfilepath);
        curtime = clock;
        
        if strcmp(algo.driftcorr,'lookuptable')
            error('CHANGE THESE CALIBRATION FILES FOR YOUR SPECIFIC SCANNER GRADIENT SET, comment out error when done');
%             keyboard;
            if imgp.tr(1) == 0.03 && imgp.nt == 1
                load('~/buffyhome/Documents/MATLAB/Thermometry/fieldDriftCorr_TR30_Avg1_Mat128.mat');
                driftcorr = regTR30Avg1(1)*(t/60)+regTR30Avg1(2);
            elseif imgp.tr(1) == 0.015 && imgp.nt == 2
                load('~/buffyhome/Documents/MATLAB/Thermometry/fieldDriftCorr_TR15_Avg2_Mat128.mat');
                driftcorr = regTR15Avg2(1)*(t/60)+regTR15Avg2(2);
            else
                error('No look up table exists for this TR,Avgs, and scanner');
                return;
            end
        end        
        
        while nblocksread<nblocks 
            %---check that time has changed or reached end
            if (abs(filepropstmp.datenum-fileprops.datenum) > 0) || (etime(curtime,datevec(filepropstmp.date))>10)%|| (prevblock ~= nblocksread) % don't open unless file has changed
                aa= tic;
                fp = fopen(algo.dynfilepath,'r','ieee-be');
                opentime(nblocksread+1) = toc(aa);
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
                    %---read the data
                    %We have to read data every time in order to increment file pointer
                    if s_float == 1
                        data = fread(fp,np*ntraces,'float32');
                    elseif s_32 == 1
                        data = fread(fp,np*ntraces,'int32');
                    else
                        data = fread(fp,np*ntraces,'int16');
                    end

                    %---keep data if this block & trace was in output list
                    %RE(:,ii) = data(1:2:np*ntraces);
                    %IM(:,ii) = data(2:2:np*ntraces);
                    RE = data(1:2:np*ntraces);
                    IM = data(2:2:np*ntraces);
                    RE = reshape(RE,[np/2 ntraces]);
                    IM = reshape(IM,[np/2 ntraces]);
                    
                    %---ft and display data (zeropad)
%                     keyboard
                    foobar = zeros(512,512);
                    foobar(256-ntraces/2+1:256+ntraces/2,256-ntraces/2+1:256+ntraces/2) = RE + 1i*IM;
%                     keyboard
                    output.img(:,:,nblocksread+1) = fftshift(fft2(fftshift(foobar)));
                    readintime(nblocksread+1) = toc(aa);
                    figure(1);
                    tic;
                    subplot(321);imagesc(abs(output.img(:,:,nblocksread+1)));colorbar;axis image
                    set(gca, 'XTick', [], 'YTick', [])
                    title(['Block Index: ' num2str(nblocksread)]);
                    plotimg1time(nblocksread+1) = toc;
                    %---if not baseline
                    if nblocksread > 0
                        foobar = abs(output.img(:,:,1));
                        mask = foobar > 0.08*max(foobar(:));
                        tic;
                        tmap = angle(output.img(:,:,nblocksread+1).*conj(output.img(:,:,1)));
%                         figure;im(tmap)
%                         keyboard
                        %---do drift correction
                        if strcmp(algo.driftcorr,'roi')
                            phase = algo.driftroi.*(tmap(:,:));%,nblocksread+1)));
                            output.avgDriftPhase(nblocksread+1) = mean2(phase(phase~=0));
                            tmap = tmap-output.avgDriftPhase(nblocksread+1);
                        elseif strcmp(algo.driftcorr,'lookuptable')
                            tmap = tmap-driftcorr(nblocksread+1);
                        elseif strcmp(algo.driftcorr,'none');
                            warning('No drift correction applied per user specification');
                        else
                            error('Invalid drift correction selection made');
                        end
                        
                        %---convert to deg C
                        tmap = tmap/(gamma*imgp.B0/10000*alpha*imgp.te*2*pi); % Celsius
                        output.delTmaps(:,:,nblocksread+1) = tmap;
                        calcTmaptime(nblocksread+1) = toc;
%                         keyboard
                        %---visualize current dynamic temperature map
                        tic
                        subplot(322);hold on;
                        imagesc(tmap,[-1 ppi.nom+2]);colorbar;title 'degrees C';axis image;
                        rectangle('Position',algo.focusvect,'LineWidth',2,'EdgeColor','k');
                        if strcmp(algo.driftcorr,'roi')
                            rectangle('Position',algo.driftvect,'LineWidth',2,'EdgeColor','k');
                        end
                        set(gca, 'XTick', [], 'YTick', [])
                        plotimg2time(nblocksread+1) = toc;
%                         keyboard
                        foo = tmap.*algo.focusROI;
                        output.meantemp(end+1) = mean2(foo(foo>0));
%                         output.meantemp(end+1) = mean(tmap(algo.focusROI));

                        %---plot temperature evolution
                        tic;
                        axis image
                        sp312 = subplot(312);hold on
                        plot(t(1:length(output.meantemp)),output.meantemp);axis([0 eps+t(length(output.meantemp)) -5 ppi.nom+2]);
                        plot(t(1:length(output.meantemp)),ppi.nom*ones(length(output.meantemp),1),'--r');grid on
                        xlabel 'Time (s) ',ylabel '\delta ^{\circ} C'
                        title(['Block Index: ' num2str(nblocksread) '. Time: ' num2str(t(nblocksread+1)/60) ' minutes.']);
                        hold off;
                        plotimg3time(nblocksread+1) = toc;
                        %---update the PIDcontrol
%                         foobar = tmap(algo.focusROI);
%                         foobar = foobar(foobar >= 0);
%                         keyboard
                        tic;
                        [voltage,ppi] = pidUpdate(voltage,output.meantemp(end),ppi);
                        if voltage > fus.Vmax
                            voltage = fus.Vmax;
                        end
                        pidtime(nblocksread+1) = toc;
                        
                        %---if data exists do CEM Calucaltion 
                        dt = t(end)-t(end-1);
                        CEMact = calcCEM_vect(output.meantemp,dt,CEM.T0);
                        output.CEMact_tot(nblocksread+1) = sum(CEMact);
                        disp(['CEM thus far is: ',num2str(output.CEMact_tot(nblocksread+1))]);

                        if algo.quitwithCEM
                            if output.CEMact_tot(nblocksread+1) > CEM.thresh
                                disp('CEM target reached...shutting off the transducer');
                                if ~reconMode
                                    fprintf(fus.fncngen,'OUTP1 OFF;');
                                end
                                offInd = nblocksread+1;

                                voltage = 0;
                                %return;
                            end
                        end


                        %---uncomment if want test shot
    %                     if nblocksread < 6
    %                         voltage = 0;
    %                     elseif (nblocksread >= 6) && (nblocksread < 15)
    %                         voltage = fus.Vmax;
    %                     else
    %                         voltage = 0;
    %                     end

                        voltVals(end+1) = voltage*1000;
                        
                        %---display voltage curve
                        tic
                        subplot(313);hold on;
                        plot(t(1:length(voltVals)),voltVals); grid on;xlabel('Time (s)');
                        plot(t(1:length(voltVals)),fus.Vmax*1000*ones(length(voltVals),1),'--r');grid on
                        hold off;%title(['CEM = ',num2str(output.meanCEM(end))]);
                        ylabel('Driving voltage (mV)'); 
                        axis([0 eps+t(length(voltVals)) fus.Vmin*1000 fus.Vmax*1000+5])
                        plotimg4time(nblocksread+1) = toc;
                        
                        %---send resulting PID command to function generator
                        disp(['Changing voltage to: ' num2str(voltage)]);
                        
                        if ~reconMode
                            if voltage == 0
                                fprintf(fus.fncngen,'OUTP1 OFF;');
                            else
                                tic;
                                fprintf(fus.fncngen,'OUTP1 ON;');
                                cur_cmd = sprintf('SOUR1:VOLT %1.5f;',voltage);
                                fprintf(fus.fncngen,cur_cmd);
%                                 sendfgencommand(nblocksread+1) = toc;
                                
                            end
                        end
                        
                        
                    end
                    drawnow
                    fpos = ftell(fp);
                    nblocksread = nblocksread + 1;
                    
                end
                fclose(fp);
            end
            
        end
        keepgoing = 0; % we should be all done now
    end
    output.t = t;
    output.voltVals = voltVals;
    %execution.sendfgencommand = mean(sendfgencommand(2:end));
    execution.pid = mean(pidtime(2:end));
    execution.calcTmap = mean(calcTmaptime(2:end));
    execution.plottime.img1 = mean(plotimg1time);
    execution.plottime.img2 = mean(plotimg2time(2:end));
    execution.plottime.meantemp = mean(plotimg3time(2:end));
    execution.plottime.voltage = mean(plotimg4time(2:end));
    execution.readindata = mean(readintime);
    execution.openfile = mean(opentime);
    output.execution = execution;
end

