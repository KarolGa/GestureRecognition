
close all;
clear all;
clc;

<<<<<<< HEAD
%% Step : Get informations about adaptor
=======
%% Krok 1 : Pozyskaj informacje o sprz?cie
>>>>>>> be306e30159b73dda3a0ceb5486bae34607385b6
% Adaptor name
% Device ID
% Video format
%info = imaqhwinfo
%info = imaqhwinfo('winvideo')
%dev_info = imaqhwinfo('winvideo',1)
%dev_info.SupportedFormats;
<<<<<<< HEAD

%% Step2 : Create a video input object
vidobj = videoinput('winvideo',1,'YUY2_640x480');

%% Step 3: Configure image acquisition object properties (Optional)
=======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Krok 2 : Utw?rz wej?ciowy obiekt akwizycji
% Step2 : Create a video input object
vidobj = videoinput('winvideo',1,'YUY2_640x480');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Krok 3 :Konfiguracja w?asno?ci obiektu (opcjonalnie)
% Step 3: Configure image acquisition object properties (Optional)
>>>>>>> be306e30159b73dda3a0ceb5486bae34607385b6
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
<<<<<<< HEAD
numPh=8; %liczba zdjec wykonanych przez kamerke
=======
numPh=8; %liczba zdj?? wykonanych przez kamerke
>>>>>>> be306e30159b73dda3a0ceb5486bae34607385b6
for i=1:numPh
 trigger(vidobj);
 %pause(0.1)
  photos(:,:,:,i) = getdata(vidobj,1);
 subplot(2, 4, i);
 imshow(photos(:,:,:,i));
end
<<<<<<< HEAD

%% Step 5 : Clean Up
=======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Krok 5 : Usuni?cie obiektu z pami?ci i wyczyszczenie przestrzeni roboczej
% Step 5 : Clean Up
>>>>>>> be306e30159b73dda3a0ceb5486bae34607385b6
stop(vidobj);
delete(vidobj);
clear vidobj;

<<<<<<< HEAD
%% Krok 6 : Checking wether pixel changed comparing to previous photo
=======
%% Krok 6 : Sprawdzanie czy piksel si? zmieni?
>>>>>>> be306e30159b73dda3a0ceb5486bae34607385b6
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

<<<<<<< HEAD
%% Krok 8 : Image analysis
xdiff=0;
ydiff=0;
flag_error=0;
areaprop(:)=0;
for i=2:numPh
[imLb, num] = bwlabel(filPhotos(:,:,i), 8);

naj=1;
if(num>1) %rozpoznawanie najwiekszego obiektu gdy num>1
    for j=1:num
    fig2=ismember(imLb,j);
    areaprop=regionprops(fig2,'Area')
    area(j)=areaprop.Area;
    end
    for j=2:num
        if area(1)<area(2)
        naj=j;    
        end
    end
=======
%% Krok 8 : Analiza obrazow
gesture_x=[];
gesture_y=[];
flag_error=0;
for i=2:numPh
[imLb, num] = bwlabel(filPhotos(:,:,i), 8);
if num ~= 1
    disp('gest nierozpoznany');
    flag_error=1;
    break;
else    
    %miejsce dla rozpoznawania najwiekszego obiektu gdy num>1
  %  for i=1:num
%fig = ismember(imLb, i);

prop(i)=regionprops(imLb, 'Centroid')
    if i>2
     if (prop(i).Centroid(1)>(prop(i-1).Centroid(1))) 
       gesture_x(i)=1;
     else
       gesture_x(i)=-1;
       end
         if (prop(i).Centroid(2)>(prop(i-1).Centroid(2))) 
              gesture_y(i)=1;
         else
             gesture_y(i)=-1; 
         end
     
    end
    if i == numPh
      xdiff=abs(prop(i).Centroid(1)-(prop(2).Centroid(1)));
      ydiff=abs(prop(i).Centroid(2)-(prop(2).Centroid(2)));
    end
end
end
%%
if flag_error ~=1
  if (sum(gesture_x)>0 && xdiff>ydiff)
   disp('gesture_1, hand> left');
  end
        if (sum(gesture_x)<0 && xdiff>ydiff)
         disp('gesture_2, hand> right');
        end
               if (sum(gesture_y)<0 && xdiff<ydiff)
                disp('gesture_3, hand> up');
               end
                    if (sum(gesture_y)>0 && xdiff<ydiff)
                      disp('gesture_4, hand> down');
                    end
>>>>>>> be306e30159b73dda3a0ceb5486bae34607385b6
end

    fig=ismember(imLb, naj);
    prop(i)=regionprops(fig, 'Centroid');
    if i>2
  	xdiff=xdiff+prop(i).Centroid(1)-prop(i-1).Centroid(1);
    ydiff=ydiff+prop(i).Centroid(2)-prop(i-1).Centroid(2);
    end
end

if(xdiff<ydiff+80&&xdiff>ydiff-80)
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