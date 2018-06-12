close all;
clear all;
clc;

%% Step : Get informations about adaptor
% Adaptor name
% Device ID
% Video format
%info = imaqhwinfo
%info = imaqhwinfo('winvideo')
%dev_info = imaqhwinfo('winvideo',1)
%dev_info.SupportedFormats;

%% Step2 : Create a video input object
vidobj = videoinput('winvideo',1,'YUY2_640x480');

%% Step 3: Configure image acquisition object properties (Optional)
 get(vidobj);
% inspect(vidobj)
 set(vidobj,'ReturnedColorSpace','rgb');
%%
% config = triggerinfo(vidobj)
% triggerconfig(vidobj,config(2))
triggerconfig(vidobj,'manual');
set(vidobj,'FramesPerTrigger',1);
set(vidobj,'TriggerRepeat', Inf);

%% Step 4: Acquire Image Data
start(vidobj);
disp('Zacznij wykonywac gest');
pause(0.2);
numPh=8; %liczba zdjec wykonanych przez kamerke
for i=1:numPh
 trigger(vidobj);
 %pause(0.1)
  photos(:,:,:,i) = getdata(vidobj,1);
 subplot(2, 4, i);
 imshow(photos(:,:,:,i));
end

%% Step 5 : Clean Up
stop(vidobj);
delete(vidobj);
clear vidobj;

%% Krok 6 : Checking wether pixel changed comparing to previous photo
for i=1:numPh
bwPhotos(:,:,i)=rgb2gray(photos(:,:,:,i));
figure(2);
subplot(2, 4, i);
imshow(bwPhotos(:,:,i));
end

sensePhotos=bwPhotos;
figure(3);
subplot(2, 4, 1);
imshow(bwPhotos(:,:,1));
for i=2:numPh
    for j=1:length(bwPhotos(:,1,1))
        for k=1:length(bwPhotos(1,:,1))
        if(bwPhotos(j,k,i)>(bwPhotos(j,k,i-1))+10 | bwPhotos(j,k,i)<(bwPhotos(j,k,i-1))-10)
        sensePhotos(j,k,i)=255;
        else
        sensePhotos(j,k,i)=bwPhotos(j,k,i);         end
        end
    end
subplot(2, 4, i);
imshow(sensePhotos(:,:,i));
end

%% Krok 7 : Binarization and filtration
seO=strel('disk',7);
seC=strel('disk',80);
figure(4)
for i=2:numPh
    filPhotos(:,:,i)=255*imopen(sensePhotos(:,:,i)==255, seO);
    filPhotos(:,:,i)=imclose(filPhotos(:,:,i), seC);

    subplot(2, 4, i);
    imshow(filPhotos(:,:,i));
end

%% Krok 8 : Image analysis
xdiff=0;
ydiff=0;
fig=0;
flag_error=0;
areaprop(:)=0;
for i=2:numPh
[imLb, num] = bwlabel(filPhotos(:,:,i), 8);
naj=1;
if(num>1) %rozpoznawanie najwiekszego obiektu gdy num>1
    for j=1:num
    fig=ismember(imLb,j);
    areaprop=regionprops(fig,'Area');
    area(j)=areaprop.Area;
    end
    for j=2:num
        if area(1)<area(2)
        naj=j;    
        end
    end
end
    if num~=0
    fig=ismember(imLb, naj);
    prop(i)=regionprops(fig, 'Centroid');
    if i>2
  	xdiff=xdiff+prop(i).Centroid(1)-prop(i-1).Centroid(1);
    ydiff=ydiff+prop(i).Centroid(2)-prop(i-1).Centroid(2);
    end
    else
      flag_error=1;
       break;
    end
end

if(xdiff<ydiff+80&&xdiff>ydiff-80) || flag_error==1
    disp('Gesture was not clear');
else
    if(abs(xdiff)>abs(ydiff))
        if(xdiff>0)
        disp('left');
        else
        disp('right');
        end
    else
        if(ydiff>0)
        disp('down');
        else
        disp('up');
        end
    end
end
