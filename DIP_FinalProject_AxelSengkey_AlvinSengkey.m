clc
close all
clear all
pkg load image 

% --------------- MAIN WINDOW --------------- %

MainFrm = figure ('name', 'A.S. Digital Image Processing Project', 'position', [600, 300, 800, 660], 'color', [0.09, 0.09, 0.09], 'MenuBar', 'none'); 

TitleFrm = axes ( ... 
  'position', [0, 0.9, 1, 0.1], ... 
  'color',    [0.94, 0.65, 0.05], ...
  'xtick',    [], ... 
  'ytick',    [], ...  
  'xlim',     [0, 1], ... 
  'ylim',     [0, 1] );

Title = text (0.36, 0.5, 'AS Image Processing', 'fontsize', 24, 'color', [1, 1, 1]);

ImgFrm1 = axes ( ...
  'position', [0.1, 0.4, 0.3, 0.4], ... 
  'xtick',    [], ... 
  'ytick',    [], ...
  'xlim',     [0, 1], ... 
  'ylim',     [0, 1]);

ImgFrm2 = axes ( ...
  'position', [0.58, 0.4, 0.3, 0.4], ... 
  'xtick',    [], ... 
  'ytick',    [], ...
  'xlim',     [0, 1], ... 
  'ylim',     [0, 1]);

Menu_noFunc = uicontrol (MainFrm, ...
  'style',    'popupmenu', ... 
  'string',   {"Select Process","Rotate","Scale","Flip","Blur","Sharpen","Noise","Negative","Brighten","Gray Scale"}, ...
  'units',    'normalized', ...
  'visible',  'on', ...
  'position', [0.22, 0.14, 0.25, 0.05]);

ButtonSave_noFunc = uicontrol (MainFrm, ...
  'style',    'pushbutton', ... 
  'string',   'Save', ...
  'units',    'normalized', ...
  'position', [0.81, 0.02, 0.16, 0.06], ...
  'enable',   'off');

ButtonInput = uicontrol (MainFrm, ...
  'style',    'pushbutton', ... 
  'string',   'Open', ...
  'units',    'normalized', ...
  'position', [0.40, 0.25, 0.18, 0.07], ...
  'callback', { @inputImage, ImgFrm1, ImgFrm2, MainFrm, Menu_noFunc, ButtonSave_noFunc });
  
% --------------- OPEN IMAGE --------------- %

function inputImage(hObject, eventdata, ImageFrame1, ImageFrame2, MainFrame, Menu_noFunc, ButtonSave_noFunc)
  %[I, path, f] = uigetfile('C:\');
  %[I, path, f] = uigetfile('C:\Users\Acer\Pictures\');
  [I, path, f] = uigetfile();
  originalImg = imread([path I]);
  showImage(ImageFrame1,originalImg);
  set(Menu_noFunc,'visible','off')
  
  Menu = uicontrol (MainFrame, ...
    'style',    'popupmenu', ... 
    'string',   {"Select Process","Rotate","Scale","Flip","Blur","Sharpen","Noise","Negative","Brighten","Gray Scale"}, ...
    'units',    'normalized', ...
    'position', [0.22, 0.14, 0.25, 0.05], ...
    'callback', { @selection, MainFrame, ImageFrame2, originalImg });
  
  ButtonReset = uicontrol (MainFrame, ...
    'style',    'pushbutton', ... 
    'string',   'Reset', ...
    'units',    'normalized', ...
    'position', [0.02, 0.02, 0.16, 0.06], ...
    'callback', { @resetImage, ImageFrame2, originalImg });
end

% --------------- SHOW IMAGE --------------- %

function showImage (ImageFrame,I_one)
  axes(ImageFrame);
  imshow(I_one, []);
  axis image off
end

% --------------- RESET IMAGE --------------- %

function resetImage (hObject, eventdata, ImageFrame, I_two)
  axes(ImageFrame);
  imshow(I_two, []);
  axis image off
end

% --------------- PROCESS MENU --------------- %

function selection(hObject, eventdata, MainFrame, ImageFrame, I_one)
    val = get(hObject,"value");
    str = get(hObject,"string");
    
    switch(str{val})
      case "Select Process"
        p = uipanel ("title", "", "position", [0.48, 0.13, 0.355, 0.07]);
      case "Rotate"
        rotates(MainFrame, ImageFrame, I_one, 0)
        p = uipanel ("title", "", "position", [0.48, 0.13, 0.355, 0.07]);
        rotSlider = uicontrol(MainFrame,'style','slider','units','normalized','position',[0.5, 0.14, 0.31, 0.05],'min',0,'max',360,'callback',{ @sliderRot, MainFrame, ImageFrame, I_one });
      case "Scale"
        scale(MainFrame, ImageFrame, I_one, 1)
        p = uipanel ("title", "", "position", [0.48, 0.13, 0.355, 0.07]);
        scalePopup = uicontrol (MainFrame, ...
          'style',    'popupmenu', ... 
          'string',   {"100%","90%","80%","70%","60%","50%","40%","30%","20%","10%"}, ...
          'units',    'normalized', ...
          'position', [0.5, 0.14, 0.31, 0.05], ...
          'callback', { @popupScale, MainFrame, ImageFrame, I_one });
      case "Flip"
        p = uipanel ("title", "", "position", [0.48, 0.13, 0.355, 0.07]);
        ButtonFlipH = uicontrol (MainFrame, ...
          'style',    'pushbutton', ... 
          'string',   'Horizontal', ...
          'units',    'normalized', ...
          'position', [0.5, 0.14, 0.15, 0.05], ...
          'callback', { @flipH, MainFrame, ImageFrame, I_one });
        
        ButtonFlipV = uicontrol (MainFrame, ...
          'style',    'pushbutton', ... 
          'string',   'Verical', ...
          'units',    'normalized', ...
          'position', [0.66, 0.14, 0.15, 0.05], ...
          'callback', { @flipV, MainFrame, ImageFrame, I_one });        
      case "Blur"
        smoothen(MainFrame,ImageFrame, I_one, 1)
        p = uipanel ("title", "", "position", [0.48, 0.13, 0.355, 0.07]);
        blurSlider = uicontrol(MainFrame,'style','slider','units','normalized','position',[0.5, 0.14, 0.31, 0.05],'min',1,'max',20,'callback',{ @sliderBlur, MainFrame, ImageFrame, I_one });
      case "Sharpen"
        sharpen(MainFrame,ImageFrame, I_one, 1)
        p = uipanel ("title", "", "position", [0.48, 0.13, 0.355, 0.07]);
        sharpSlider = uicontrol(MainFrame,'style','slider','units','normalized','position',[0.5, 0.14, 0.31, 0.05],'min',1,'max',20,'callback',{ @sliderSharpen, MainFrame, ImageFrame, I_one });
      case "Noise"
        noise(MainFrame,ImageFrame, I_one, 0)
        p = uipanel ("title", "", "position", [0.48, 0.13, 0.355, 0.07]);
        noiseSlider = uicontrol(MainFrame,'style','slider','units','normalized','position',[0.5, 0.14, 0.31, 0.05],'min',0,'max',0.1,'callback',{ @sliderNoise, MainFrame, ImageFrame, I_one });
      case "Negative"
        negative(MainFrame,ImageFrame, I_one)
        p = uipanel ("title", "", "position", [0.48, 0.13, 0.355, 0.07]);
      case "Brighten"
        brighten(MainFrame,ImageFrame, I_one, 0)
        p = uipanel ("title", "", "position", [0.48, 0.13, 0.355, 0.07]);
        brightSlider = uicontrol(MainFrame,'style','slider','units','normalized','position',[0.5, 0.14, 0.31, 0.05],'min',-25,'max',25,'callback',{ @sliderBright, MainFrame, ImageFrame, I_one });
      case "Gray Scale"
        grayScale(MainFrame,ImageFrame, I_one)
        p = uipanel ("title", "", "position", [0.48, 0.13, 0.355, 0.07]);
    endswitch
end

% --------------- ROTATE --------------- %

function sliderRot(hObject, eventdata, MainFrame, ImageFrame, I_one)
  newValue = get(hObject,"value");
  rotates(MainFrame, ImageFrame, I_one, newValue)
  set(hObject,"value",newValue);
end

function rotates (MainFrame, ImageFrame, I_one, degree)
  I_rot = imrotate(I_one,degree,'bilinear','crop');
  I_two = I_rot;
  axes(ImageFrame);
  imshow(I_rot, []);
  axis image off
  
  ButtonSave = uicontrol (MainFrame, ...
    'style',    'pushbutton', ... 
    'string',   'Save', ...
    'units',    'normalized', ...
    'position', [0.81, 0.02, 0.16, 0.06], ...
    'enable',   'on', ...
    'callback', { @saveImage, I_two });
end

% --------------- SCALE --------------- %

function popupScale(hObject, eventdata, MainFrame, ImageFrame, I_one)
  val = get(hObject,"value");
  str = get(hObject,"string");
  
  switch(str{val})
      case "10%"
        scale(MainFrame, ImageFrame, I_one, 0.1)
      case "20%"
        scale(MainFrame, ImageFrame, I_one, 0.2)
      case "30%"
        scale(MainFrame, ImageFrame, I_one, 0.3)
      case "40%"
        scale(MainFrame, ImageFrame, I_one, 0.4)
      case "50%"
        scale(MainFrame, ImageFrame, I_one, 0.5)
      case "60%"
        scale(MainFrame, ImageFrame, I_one, 0.6)
      case "70%"
        scale(MainFrame, ImageFrame, I_one, 0.7)
      case "80%"
        scale(MainFrame, ImageFrame, I_one, 0.8)
      case "90%"
        scale(MainFrame, ImageFrame, I_one, 0.9)
      case "100%"
        scale(MainFrame, ImageFrame, I_one, 1)
  endswitch
end

function scale (MainFrame, ImageFrame, I_one, s)
  I_scal = imresize(I_one,s);
  I_two = I_scal;
  axes(ImageFrame);
  imshow(I_scal, []);
  axis image off
  
  ButtonSave = uicontrol (MainFrame, ...
    'style',    'pushbutton', ... 
    'string',   'Save', ...
    'units',    'normalized', ...
    'position', [0.81, 0.02, 0.16, 0.06], ...
    'enable',   'on', ...
    'callback', { @saveImage, I_two });
end

% --------------- FLIP --------------- %

function flipH (hObject, eventdata, MainFrame, ImageFrame, I_one)
  I_flipH = flip(I_one,2);
  I_two = I_flipH;
  axes(ImageFrame);
  imshow(I_flipH, []);
  axis image off
  
  ButtonSave = uicontrol (MainFrame, ...
    'style',    'pushbutton', ... 
    'string',   'Save', ...
    'units',    'normalized', ...
    'position', [0.81, 0.02, 0.16, 0.06], ...
    'enable',   'on', ...
    'callback', { @saveImage, I_two });
end

function flipV (hObject, eventdata, MainFrame, ImageFrame, I_one)
  I_flipV = flip(I_one,1);
  I_two = I_flipV;
  axes(ImageFrame);
  imshow(I_flipV, []);
  axis image off
  
  ButtonSave = uicontrol (MainFrame, ...
    'style',    'pushbutton', ... 
    'string',   'Save', ...
    'units',    'normalized', ...
    'position', [0.81, 0.02, 0.16, 0.06], ...
    'enable',   'on', ...
    'callback', { @saveImage, I_two });
end

% --------------- BLUR --------------- %

function sliderBlur(hObject, eventdata, MainFrame, ImageFrame, I_one)
  newValue = get(hObject,"value");
  smoothen(MainFrame, ImageFrame, I_one, newValue)
  set(hObject,"value",newValue);
end

function smoothen (MainFrame, ImageFrame, I_one, Sigma)
  I_gaussianSmooth = imsmooth(I_one,'gaussian',Sigma);
  I_two = I_gaussianSmooth;
  axes(ImageFrame);
  imshow(I_gaussianSmooth, []);
  axis image off
  
  ButtonSave = uicontrol (MainFrame, ...
    'style',    'pushbutton', ... 
    'string',   'Save', ...
    'units',    'normalized', ...
    'position', [0.81, 0.02, 0.16, 0.06], ...
    'enable',   'on', ...
    'callback', { @saveImage, I_two });
end

% --------------- SHARPEN --------------- %

function sliderSharpen(hObject, eventdata, MainFrame, ImageFrame, I_one)
  newValue = get(hObject,"value");
  sharpen(MainFrame, ImageFrame, I_one, newValue)
  set(hObject,"value",newValue);
end

function sharpen (MainFrame, ImageFrame, I_one, RA)
  I_sharpen = imsharpen(I_one,'Radius',RA,'Amount',RA);
  I_two = I_sharpen;
  axes(ImageFrame);
  imshow(I_sharpen, []);
  axis image off
  
  ButtonSave = uicontrol (MainFrame, ...
    'style',    'pushbutton', ... 
    'string',   'Save', ...
    'units',    'normalized', ...
    'position', [0.81, 0.02, 0.16, 0.06], ...
    'enable',   'on', ...
    'callback', { @saveImage, I_two });
end

% --------------- NOISE --------------- %

function sliderNoise(hObject, eventdata, MainFrame, ImageFrame, I_one)
  newValue = get(hObject,"value");
  noise(MainFrame, ImageFrame, I_one, newValue)
  set(hObject,"value",newValue);
end

function noise (MainFrame, ImageFrame, I_one, var)
  I_noise = imnoise(I_one,'gaussian',0.05,var);
  I_two = I_noise;
  axes(ImageFrame);
  imshow(I_noise, []);
  axis image off
  
  ButtonSave = uicontrol (MainFrame, ...
    'style',    'pushbutton', ... 
    'string',   'Save', ...
    'units',    'normalized', ...
    'position', [0.81, 0.02, 0.16, 0.06], ...
    'enable',   'on', ...
    'callback', { @saveImage, I_two });
end

% --------------- NEGATIVE --------------- %

function negative (MainFrame, ImageFrame, I_one)
  I_negative = 255 - I_one;
  I_two = I_negative;
  axes(ImageFrame);
  imshow(I_negative, []);
  axis image off
  
  ButtonSave = uicontrol (MainFrame, ...
    'style',    'pushbutton', ... 
    'string',   'Save', ...
    'units',    'normalized', ...
    'position', [0.81, 0.02, 0.16, 0.06], ...
    'enable',   'on', ...
    'callback', { @saveImage, I_two });
end

% --------------- BRIGHTEN --------------- %

function sliderBright(hObject, eventdata, MainFrame, ImageFrame, I_one)
  newValue = get(hObject,"value");
  brighten(MainFrame, ImageFrame, I_one, newValue)
  set(hObject,"value",newValue);
end

function brighten (MainFrame, ImageFrame, I_one, val)
  I_brighten = I_one + val*10;
  I_two = I_brighten;
  axes(ImageFrame);
  imshow(I_brighten, []);
  axis image off
  
  ButtonSave = uicontrol (MainFrame, ...
    'style',    'pushbutton', ... 
    'string',   'Save', ...
    'units',    'normalized', ...
    'position', [0.81, 0.02, 0.16, 0.06], ...
    'enable',   'on', ...
    'callback', { @saveImage, I_two });
end

% --------------- GRAYSCALE --------------- %

function grayScale (MainFrame, ImageFrame, I_one)
  I_rgbtogray = rgb2gray(I_one);
  I_two = I_rgbtogray;
  axes(ImageFrame);
  imshow(I_rgbtogray, []);
  axis image off
  
  ButtonSave = uicontrol (MainFrame, ...
    'style',    'pushbutton', ... 
    'string',   'Save', ...
    'units',    'normalized', ...
    'position', [0.81, 0.02, 0.16, 0.06], ...
    'enable',   'on', ...
    'callback', { @saveImage, I_two });
end

% --------------- SAVE IMAGE --------------- %

function saveImage(hObject, eventdata, I_two)  
  [ImgName, path] = uiputfile({'*.png';'*.jpg';'*.tiff';'*.*'});
  fullFileName = fullfile(path, ImgName);
  imwrite(I_two, fullFileName);
end

% ----------------------------------------- %

