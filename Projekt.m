close all;
clear all;
clc;

%% Krok 1 : Pozyskaj informacje o sprzêcie
% Adaptor name
% Device ID
% Video format
%info = imaqhwinfo
%info = imaqhwinfo('winvideo')
%dev_info = imaqhwinfo('winvideo',1)
%dev_info.SupportedFormats;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Krok 2 : Utwórz wejœciowy obiekt akwizycji
% Step2 : Create a video input object
vidobj = videoinput('winvideo',1,'YUY2_640x480');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Krok 3 :Konfiguracja w³asnoœci obiektu (opcjonalnie)
% Step 3: Configure image acquisition object properties (Optional)
 get(vidobj);
% inspect(vidobj)
 set(vidobj,'ReturnedColorSpace','rgb');
%%
% config = triggerinfo(vidobj)
% triggerconfig(vidobj,config(2))
triggerconfig(vidobj,'manual');
set(vidobj,'FramesPerTrigger',1);
set(vidobj,'TriggerRepeat', Inf);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Krok 4: Akwizycja danych wizyjnych - obrazu
% Step 4: Acquire Image Data
start(vidobj);
disp('Zacznij wykonywac gest');
pause(0.2);
numPh=8; %liczba zdjêæ wykonanych przez kamerke
for i=1:numPh
 trigger(vidobj);
 %pause(0.1)
  photos(:,:,:,i) = getdata(vidobj,1);
 subplot(2, 4, i);
 imshow(photos(:,:,:,i));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Krok 5 : Usuniêcie obiektu z pamiêci i wyczyszczenie przestrzeni roboczej
% Step 5 : Clean Up
stop(vidobj);
delete(vidobj);
clear vidobj;

%% Krok 6 : Sprawdzanie czy piksel siê zmieni³
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

%% Krok 7 : Binaryzacja i filtracja 


seO=strel('disk',7);
seC=strel('disk',80);
figure(4)
for i=2:numPh
    filPhotos(:,:,i)=255*imopen(sensePhotos(:,:,i)==255, seO);
    filPhotos(:,:,i)=imclose(filPhotos(:,:,i), seC);

    subplot(2, 4, i);
    imshow(filPhotos(:,:,i));
end

%% Krok 8 : Analiza obrazow
for i=2:numPh
[imLb, num] = bwlabel(filPhotos(:,:,i), 8);
prop=regionprops(imLb, 'Centroid')
end
