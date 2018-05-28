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
 get(vidobj)
% inspect(vidobj)
 set(vidobj,'ReturnedColorSpace','rgb')
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
for i=1:8
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
for i=1:8
bwPhotos(:,:,i)=rgb2gray(photos(:,:,:,i));
figure(2);
subplot(2, 4, i);
imshow(bwPhotos(:,:,i));
end

senseBwPhotos=bwPhotos;

figure(3);
subplot(2, 4, 1);
imshow(bwPhotos(:,:,1));
for i=2:length(bwPhotos(1,1,:))
    for j=1:length(bwPhotos(:,1,1))
        for k=1:length(bwPhotos(1,:,1))
        if(bwPhotos(j,k,i)>(bwPhotos(j,k,i-1))+10 | bwPhotos(j,k,i)<(bwPhotos(j,k,i-1))-10)
        senseBwPhotos(j,k,i)=255;
        else
        senseBwPhotos(j,k,i)=bwPhotos(j,k,i); 
        end
        end
    end
subplot(2, 4, i);
imshow(senseBwPhotos(:,:,i));
end

%Filtracja 