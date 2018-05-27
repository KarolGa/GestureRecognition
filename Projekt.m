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
 inspect(vidobj)
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
for i=1:9
 trigger(vidobj);
 pause(0.1)
 im = getdata(vidobj,1);
 photos(:,:,:,i)=im;
 figure,imshow(photos(:,:,:,i));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Krok 5 : Usuniêcie obiektu z pamiêci i wyczyszczenie przestrzeni roboczej
% Step 5 : Clean Up
stop(vidobj),
delete(vidobj),
clear vidobj;
