function varargout = EEGQC(varargin)
% Last Modified by GUIDE v2.5 16-Jun-2016 14:22:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @EEGQC_OpeningFcn, ...
    'gui_OutputFcn',  @EEGQC_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before EEGQC is made visible.
function EEGQC_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% global clickcount checkcount
% clickcount=-1;
% checkcount=0;
evalin('base','clear')
evalin('base','results={};')
set(handles.icproperty,'Enable','Off');
set(handles.icscroll,'Enable','Off');
set(handles.cmpsingle,'Enable','Off');
set(handles.cmpaverage,'Enable','Off');
set(handles.comp,'Enable','Off');
set(handles.all_ele,'Enable','Off');
set(handles.interpolate,'Enable','Off');

% UIWAIT makes EEGQC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EEGQC_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes on button press in getfile.
function getfile_Callback(hObject, eventdata, handles)

global data_path filenames filepath
data_path=get(handles.data_path,'String');
[filepath filenames ]=filesearch_regexp(data_path,'^Final.*.set');

file_strr=['Find ', num2str(length(filenames)), ' data sets in your QC directory'];
set(handles.infopanel,'String',file_strr,'FontSize',20);





% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
global clickcount n filenames data_path checkcount EEG filepath

% clickcount=clickcount+1;
% if ~isequal(checkcount,clickcount)
%     disp(['It seems you did not save the results'])
%     disp(['It seems you did not save the results'])
%     disp(['It seems you did not save the results'])
%     clickcount=clickcount-1;
%     return
% end
%
% if clickcount==0
%     set(hObject,'String','Next');
% end

pop_eegplot(EEG,1,1,0); % see doc pop_eegplot





function data_path_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function data_path_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function output_path_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function output_path_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function startnum_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function startnum_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in discard.
function discard_Callback(hObject, eventdata, handles)
% --- Executes on button press in interpolate.
function interpolate_Callback(hObject, eventdata, handles)


% --- Executes on button press in savefile.
function savefile_Callback(hObject, eventdata, handles)

global checkcount EEG rej filenames n bad_indx tmp_strr1 tmp_strr21 tmp_strr22 tmp_strr3 tmp_strr4 tmp_strr5 tmp_strr6
% checkcount=checkcount+1; %not click next twice

if ~exist('EEG')
    warndlg('Load a dataset first')
    return
end

output_path=get(handles.output_path,'String')
if ~exist(output_path)
    mkdir(output_path);
end

% tmp_strr6 will be [] after last use1
if  ~exist('tmp_strr6')
    warndlg('Please updat QC information before save data set')
    return
else
    if isempty(tmp_strr6)
        warndlg('Please updat QC information before save data set')
        return
    end
end


%save infomation
tmp_result=evalin('base','results');

tmp_result(n,1:8)=deal([filenames(n),tmp_strr1, tmp_strr21,tmp_strr22, tmp_strr3, tmp_strr4, tmp_strr5, tmp_strr6])
assignin('base','results',tmp_result);
tmp_savename=filenames{n};
savename=tmp_savename(1:end-4);
save(fullfile(output_path,['Qc_info_',savename]),'tmp_result');


% save EEG set

stars=['*****************************************************'];
savenames=strcat('qc_',filenames)
EEG = eeg_checkset( EEG );

if ~isempty(rej)
    EEG = pop_rejepoch(EEG,rej,0)
    EEG = eeg_checkset( EEG );
    disp(stars);
    disp([tmp_strr1,'were removed']);
    disp(stars);
else
    disp(stars);
    disp(['No epoch was rejected']);
    disp(stars);
end




if isequal(get(handles.badlock,'Value'),1)&&isequal(get(handles.interpolate,'Value'),1);
    
    for badi=1:length(bad_indx)
        EEG = pop_interp(EEG,bad_indx(badi), 'spherical');
        EEG = eeg_checkset( EEG );
    end
    badi=[];
    tmp_s1=['Interpolated channels: ',num2str(bad_indx)];
    disp(stars)
    disp(tmp_s1);
    disp(stars)
    set(handles.infopanel,'String',tmp_s1,'FontSize',20);
else
    disp(stars);
    disp('No bandchannel');
    disp(stars);
end

components=str2num(get(handles.comp,'String'));
if get(handles.reica,'Value')==1;
    if isempty(components)
        warndlg('No components entered for removal')
        return
    else ~isempty(components)
        EEG=pop_subcomp(EEG,components,0);
        EEG = eeg_checkset( EEG );
        tmp_s2=['Removed components: ',num2str(components)];
        disp(stars);
        disp(tmp_s2);
        set(handles.infopanel,'String',tmp_s2,'FontSize',25);
        disp(stars);
    end
else
    disp(stars);
    disp('No component to remove');
    disp(stars);
end



EEG = pop_saveset( EEG, 'filename',savenames{n},'filepath',output_path);
tmp_s3=['QCed files are saved'];

disp(stars);
disp(tmp_s3);
disp(stars);
set(handles.infopanel,'String',tmp_s3,'FontSize',20);


%initialise

set(handles.badlock,'Value',0)
set(handles.reica,'Value',0)
set(handles.comment,'String','No')
set(handles.startnum,'String',n+1)
set(handles.icproperty,'Enable','Off');
set(handles.icscroll,'Enable','Off');
set(handles.cmpsingle,'Enable','Off');
set(handles.cmpaverage,'Enable','Off');
set(handles.comp,'Enable','Off');
set(handles.all_ele,'Enable','Off');
set(handles.interpolate,'Enable','Off');
clearvars -global tmp_strr1 tmp_strr21 tmp_strr22 tmp_strr3 tmp_strr4 tmp_strr5 tmp_strr6 EEG bad_indx rej


function comment_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function comment_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on selection change in all_ele.
function all_ele_Callback(hObject, eventdata, handles)
global bad_indx bad_label
badlist=get(hObject,'String');
bad_indx=get(hObject,'Value');
bad_label=badlist(bad_indx);

function all_ele_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function badchannel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reica.
function reica_Callback(hObject, eventdata, handles)
if get(handles.reica,'Value')==1
    set(handles.icproperty,'Enable','On');
    set(handles.icscroll,'Enable','On');
    set(handles.cmpsingle,'Enable','On');
    set(handles.cmpaverage,'Enable','On');
    set(handles.comp,'Enable','On');
elseif get(handles.reica,'Value')==0
    
    set(handles.icproperty,'Enable','Off');
    set(handles.icscroll,'Enable','Off');
    set(handles.cmpsingle,'Enable','Off');
    set(handles.cmpaverage,'Enable','Off');
    set(handles.comp,'Enable','Off');
end


% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
global EEG rej bad_label bad_indx tmp_strr1 tmp_strr21 tmp_strr22 tmp_strr3 tmp_strr4 tmp_strr5 tmp_strr6

try
if isempty(EEG)
    warndlg('Load a dataset first')
    return
end
catch
    warndlg('Load a dataset first')
    return
end

try
    rej=evalin('base','tmprej');
    evalin('base','clearvars -except tmprej results');
    tmp_strr1= num2str(find(rej==1));
catch
    rej=[];
    warndlg('You did not select any bad epoches')
    tmp_strr1='No';
end
strr1=['Bad epoces: ',tmp_strr1];






if get(handles.badlock,'Value')==0
    tmp_strr22='No';
    tmp_strr21='No';
    strr2={['Bad channel: ',tmp_strr21],['Indexes are: ' tmp_strr22]};
    
else
    tmp_strr21=sprintf('%s ',bad_label{:});
    tmp_strr22=sprintf('%d ',bad_indx(:));
    strr2={['Bad channel: ',tmp_strr21],['Indexes are: ' tmp_strr22]};
    
    
end

if  isequal(get(handles.badlock,'Value'),1)&&isequal(get(handles.interpolate,'Value'),1)
    tmp_strr3='Yes';
else
    
    tmp_strr3='No';
end

if get(handles.reica,'Value')==1
    tmp_strr4=get(handles.comp,'String');
else
    tmp_strr4='No';
end

select=get(handles.use1,'SelectedObject');
tmp_strr5=get(select,'String');

tmp_strr6=get(handles.comment,'String');

strr3=['Interpolate: ',tmp_strr3];
strr4=['Remove ICA: ',tmp_strr4];
strr5=['Usable: ',tmp_strr5];
strr6=['Comment: ',tmp_strr6];
strr_sep=['~~~~~~~~~~~~~~~~~~~~~~~~~~~'];
allstrr={strr1;strr_sep;strr2{1};strr2{2};strr3;strr_sep;strr4;strr_sep;strr5;strr_sep;strr6};
set(handles.infopanel,'String',allstrr,'FontSize',12);


% --- Executes on button press in badlock.
function badlock_Callback(hObject, eventdata, handles)

if get(handles.badlock,'Value')==0
    set(handles.interpolate,'Enable','Off');
    set(handles.all_ele,'Enable','Off');
else
    set(handles.interpolate,'Enable','On');
    set(handles.all_ele,'Enable','On');
    set(handles.interpolate,'Value',1);
end


% --- Executes on button press in icscroll.
function icscroll_Callback(hObject, eventdata, handles)
global EEG
pop_eegplot( EEG, 0, 1, 1);
warndlg('Do not reject epoches on IC scroll')
set(handles.infopanel,'String', 'Do not reject epoches on IC scroll','FontSize',30)

% --- Executes on button press in topoplot.
function topoplot_Callback(hObject, eventdata, handles)
global EEG
pop_topoplot(EEG);



% --- Executes on button press in icproperty.
function icproperty_Callback(hObject, eventdata, handles)
global EEG
pop_prop(EEG,0);


% --- Executes on button press in channelproper.
function channelproper_Callback(hObject, eventdata, handles)
global EEG
pop_prop(EEG,1);



function comp_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function comp_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cmpsingle.
function cmpsingle_Callback(hObject, eventdata, handles)
global EEG
components=str2num(get(handles.comp,'String'));
component_keep = setdiff_bc(1:size(EEG.icaweights,1), components);
compproj = EEG.icawinv(:, component_keep)*eeg_getdatact(EEG, 'component', component_keep, 'reshape', '2d');
compproj = reshape(compproj, size(compproj,1), EEG.pnts, EEG.trials);
eegplot( EEG.data(EEG.icachansind,:,:), 'srate', EEG.srate, 'title', 'Black = channel before rejection; red = after rejection -- eegplot()', ...
    'limits', [EEG.xmin EEG.xmax]*1000, 'data2', compproj);

% --- Executes on button press in cmpaverage.
function cmpaverage_Callback(hObject, eventdata, handles)
global EEG
components=str2num(get(handles.comp,'String'));
component_keep = setdiff_bc(1:size(EEG.icaweights,1), components);
compproj = EEG.icawinv(:, component_keep)*eeg_getdatact(EEG, 'component', component_keep, 'reshape', '2d');
compproj = reshape(compproj, size(compproj,1), EEG.pnts, EEG.trials);
tracing  = [ squeeze(mean(EEG.data(EEG.icachansind,:,:),3)) squeeze(mean(compproj,3))];
figure;
plotdata(tracing, EEG.pnts, [EEG.xmin*1000 EEG.xmax*1000 0 0], ...
    'Trial ERPs (red) with and (blue) without these components');


% --- Executes on button press in loaddata.
function loaddata_Callback(hObject, eventdata, handles)
global EEG n filenames filepath
n=str2num(get(handles.startnum,'String'));

evalin('base','clear tmprej');
ALLEEG=[];
EEG=[];
CURRENTSET=[];
EEG = pop_loadset('filename',filenames{n},'filepath',filepath{n});
EEG = eeg_checkset( EEG );
assignin('base','EEG',EEG);

work_strr={['You are working on No.', num2str(n),' subject.']; ['The file name is ', filenames{n},'.']};
set(handles.infopanel,'String',work_strr,'FontSize',20);


% --- Executes on selection change in usable.
function usable_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function usable_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

	
