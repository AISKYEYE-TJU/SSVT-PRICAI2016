% ========================================================================
% Set to Set Visual Tracking 1.0
% Copyright(c) 2016 P. Zhu et al. 
% All Rights Reserved.
% 
% ----------------------------------------------------------------------
% Permission to use, copy, or modify this software and its documentation
% for educational and research purposes only and without fee is here
% granted, provided that this copyright notice and the original authors'
% names appear on all copies and supporting documentation. This program
% shall not be used, rewritten, or adapted as the basis of a commercial
% software or hardware product without first obtaining permission of the
% authors. The authors make no representations about the suitability of
% this software for any purpose. It is provided "as is" without express
% or implied warranty.
% ----------------------------------------------------------------------  
% 
% Please refer to the following paper
% Zhu W, Zhu P, Hu Q, et al. Set to Set Visual Tracking[C]// 
% PRICAI 2016: Trends in Artificial Intelligence. Springer International Publishing, 2016.
% 
% bibtex
% @book{Zhu2016,
% author={Zhu, Wencheng and Zhu, Pengfei and Hu, Qinghua and Zhang, Changqing},
% title={Set to Set Visual Tracking},
% bookTitle={PRICAI 2016: Trends in Artificial Intelligence},
% year={2016},
% publisher={Springer International Publishing},
% pages={700--712},
% }
%   
% 
% 
% Contact: {zhupengfei}@tju.edu.cn
% ----------------------------------------------------------------------

clear all;
clc;
close all;
warning off;

%Data Set ,please refer to website: http://cvlab.hanyang.ac.kr/tracker_benchmark/datasets.html
title = 'deer';

%start frame
start_frame = 1;

times  = 1; %operate times; to avoid overwriting previous saved tracking result in the .mat format
res_path='results\';
fext = 'jpg';
%% parameter setting for each sequence
fprefix		= ['.\',title,'\'];
location=['./', title, '/','*.','jpg'];
img_dir = dir(location);
num = length(img_dir);% number of frames

nframes	= num-start_frame+1;		% number of frames to be tracked

rect_anno = dlmread('./deer/deer.txt');
m_boundingbox = rect_anno(1,:);
init_pos = [m_boundingbox(2)   m_boundingbox(2)+m_boundingbox(4)  m_boundingbox(2) ;
            m_boundingbox(1)   m_boundingbox(1)                   m_boundingbox(1)+m_boundingbox(3)];
opt.init_pos = double(init_pos);  %  initialization bounding box
width = m_boundingbox(3);
height = m_boundingbox(4);   

if min( 0.5*[height width]) < 25
    sz_T = 1.0 * [height width];
    if height > 80
        sz_T =  [ 0.5 *height width];  
    end
else
    sz_T = 0.5 * [height width];
end
sz_T = ceil(sz_T);
if min(sz_T>32)
    sz_T = [32 32];
end

%prepare the file name for each image
numzeros = 4;
s_frames = cell(nframes,1);
nz	= strcat('%0',num2str(numzeros),'d'); %number of zeros in the name of image
for t=1:nframes
    image_no	= start_frame + (t-1);
    id=sprintf(nz,image_no);    
    s_frames{t} = strcat(fprefix,id,'.',fext);
end

%prepare the path for saving tracking results
res_path=[res_path title '\'];
if ~exist(res_path,'dir')
    mkdir(res_path);
end

%% parameters setting for tracking
trackparam
para.lambda = [0.2,0.001,10]; 
para.angle_threshold = opt.threhold;
para.Lip	= 8;
para.Maxit	= 5;
para.nT		= 10;%number of templates for the sparse representation
para.rel_std_afnv =opt.affsig;%diviation of the sampling of particle filter
para.n_sample	= 600;		%number of particles
para.sz_T		= sz_T;
para.init_pos	= init_pos;
para.bDebug		= 0;		%debugging indicator
bShowSaveImage	= 1;       %indicator for result image show and save after tracking finished
para.s_debug_path = res_path;
threshold = 0.5;
%% main function for tracking
[tracking_res,output]  = L1TrackingBPR_APGup_CRT(s_frames, para);
disp(['fps: ' num2str(nframes/sum(output.time))])
%% Output tracking results

save([res_path title 'SST' num2str(times) '.mat'], 'tracking_res','sz_T','output');

if ~para.bDebug&bShowSaveImage
    for t = 1:nframes
        img_color	= imread(s_frames{t});
        img_color	= double(img_color);
        imshow(uint8(img_color));
        text(5,10,num2str(t+start_frame),'FontSize',18,'Color','r');
        color = [1 0 0];
        map_afnv	= tracking_res(:,t)';
        pot(t,:)=drawAffine(map_afnv, sz_T, color, 2);%draw tracking result on the figure
        drawnow
        %save tracking result image
        s_res	= s_frames{t}(1:end-4);
        s_res	= fliplr(strtok(fliplr(s_res),'/'));
        s_res	= fliplr(strtok(fliplr(s_res),'\'));
        s_res	= [res_path s_res '_SSVT.jpg'];
        saveas(gcf,s_res)
    end
end
results.res=pot;
results.type='rect';
results.len=nframes;
results.startFrame=start_frame;
[~, aveErrCenter,errCoverage, errCenter] = calcSeqErrRobust(results, rect_anno);
aveErrCoverage=sum(errCoverage)/length(errCoverage);
successNum= sum(errCoverage >=threshold);
successRate = successNum/length(errCoverage);
averagetime=nframes/sum(output.time);
fprintf('the successs rate is %f \n',successRate);
fprintf('the average center error is %f \n',aveErrCenter);
fprintf('the average time is %f \n',averagetime);