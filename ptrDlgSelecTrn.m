
function trnFile = ptrDlgSelecTrn(imgTypes, pathTrn, sizeWin)
    trnFile = 0;
    if nargin<3, sizeWin = [400,500]; end
    winWidth = sizeWin(1);      % Window width
    winHeight = sizeWin(2);     % Window height

    f = figure('Name', ptrLgGetString('selecTrn_Title'), ...
        'NumberTitle', 'off', ...
        'visible','off',...
        'WindowStyle','modal', ...
        'Position', [1 1 winWidth winHeight], ...
        'MenuBar', 'none', ...
        'Resize', 'off', ...
        'UserData', 0);

    ptrCenterWindow(f);

    pan = uipanel('Parent',f, 'BorderType', 'none',...
                  'Units','pixels','Position',[1 1 winWidth winHeight]);


    h.textCombo = uicontrol('Parent', pan, ...
                  'String', ptrLgGetString('selecTrn_Timg'), ...
                  'Style', 'text', ...
                  'Units', 'pixels', ...
                  'Position', [15 winHeight-30 winWidth-30 15], ...
                  'FontUnits','pixels', ...
                  'FontName', 'Helvetica', ...
                  'FontSize',12, ...
                  'HorizontalAlignment','left');
              
    h.comboTypeImg = uicontrol('Parent', pan, ...
                  'String', imgTypes(:,2), ...
                  'Style', 'popupmenu', ...
                  'Value', 1, ...
                  'Units', 'pixels', ...
                  'Position', [15 winHeight-60 winWidth-30 25], ...
                  'FontUnits','pixels', ...
                  'FontName', 'Helvetica', ...
                  'FontSize',12, ...
                  'HorizontalAlignment','left', ...
                  'Callback', @(hObject, event) updateTrnList(f)); 
              
    h.textListTrn = uicontrol('Parent', pan, ...
                  'String', ptrLgGetString('selecTrn_Trn'), ...
                  'Style', 'text', ...
                  'Units', 'pixels', ...
                  'Position', [15 winHeight-85 winWidth-30 15], ...
                  'FontUnits','pixels', ...
                  'FontName', 'Helvetica', ...
                  'FontSize',12, ...
                  'HorizontalAlignment','left');
              
    h.lsBoxTrn = uicontrol('Parent', pan, ...
                  'String', [], ...
                  'Value', 1, ...
                  'Style', 'listbox', ...
                  'Units', 'pixels', ...
                  'Position', [15 285 winWidth-30 winHeight-95-285], ...
                  'FontUnits','pixels', ...
                  'FontName', 'Helvetica', ...
                  'FontSize',12, ...
                  'HorizontalAlignment','left',...
                  'Callback', @(hObject,event) selecItem(f));
              
    h.textListInfo = uicontrol('Parent', pan, ...
                  'String', ptrLgGetString('selecTrn_Details'), ...
                  'Style', 'text', ...
                  'Units', 'pixels', ...
                  'Position', [15 260 winWidth-30 15], ...
                  'FontUnits','pixels', ...
                  'FontName', 'Helvetica', ...
                  'FontSize',12, ...
                  'HorizontalAlignment','left');
              
    h.lsBoxInfo = uicontrol('Parent', pan, ...
                  'String', [], ...
                  'Value', [], ...
                  'Max', 10, ...
                  'Style', 'listbox', ...
                  'Enable', 'inactive', ...
                  'Units', 'pixels', ...
                  'Position', [15 50 winWidth-30 200], ...
                  'FontUnits','pixels', ...
                  'FontName', 'Helvetica', ...
                  'FontSize',12, ...
                  'HorizontalAlignment','left');
              
    h.btnOk = uicontrol('Parent',pan, ...
                  'String', ptrLgGetString('all_OkBtn'),...
                  'Units','pixels', ...
                  'Position', [15 10 (winWidth-40)/2 30], ...
                  'FontUnits', 'pixels', ...
                  'FontName', 'Helvetica', ...
                  'FontSize', 11, ...
                  'FontWeight', 'bold',...
                  'Callback', @(hObject,event) returnSelection(f));
              
    h.btnCancel = uicontrol('Parent',pan, ...
                  'String', ptrLgGetString('all_CancelBtn'),...
                  'Units','pixels', ...
                  'Position', [5+winWidth/2 10 (winWidth-40)/2 30], ...
                  'FontUnits', 'pixels', ...
                  'FontName', 'Helvetica', ...
                  'FontSize', 11, ...
                  'FontWeight', 'bold',...
                  'Callback', 'uiresume(gcbf)');
              
    h.imgTypes = imgTypes;
    h.pathTrn = pathTrn;
    guidata(f,h);
    updateTrnList(f);
    updateTrnInfo(f);

    set(f,'Visible','on');
    drawnow;
    uicontrol(h.comboTypeImg);
    uiwait(f);
    if ~ishandle(f), return; end
    if get(f,'UserData') == 1
        h = guidata(f);
        if isfield(h,'trnFiles') && ~isempty(h.trnFiles)
            trnFile = h.trnFiles{get(h.lsBoxTrn,'Value')};
        end
    end
    close(f); 
end


function updateTrnList (f)
    h = guidata(f);
    type = h.imgTypes{get(h.comboTypeImg,'Value'),1};
    
    trnNames = {}; trnFiles = {}; trnInfos = {}; k = 0;
    lis = dir ([h.pathTrn filesep '*.trn']);
    for i=1:numel(lis)
        trn = load([h.pathTrn filesep lis(i).name],'-mat','info');
        if trn.info.tipoImgs == type
            k = k + 1;
            trnNames{k} = trn.info.descrip;
            trnFiles{k} = [h.pathTrn filesep lis(i).name];
            trnInfos{k} = trn.info;
        end
        clear trn;
    end
    set (h.lsBoxTrn,'String',trnNames);
    set (h.lsBoxTrn,'Value',1);
    
    h.trnNames = trnNames;
    h.trnFiles = trnFiles;
    h.trnInfos = trnInfos;
    guidata(f, h);
    updateTrnInfo (f);
end


function updateTrnInfo (f)
    h = guidata(f);
    trn = get(h.lsBoxTrn,'Value');
    if isempty(h.trnInfos)
        t = [];
    else
        info = h.trnInfos{trn};
        ubi = h.trnFiles{trn};
        idxType = [h.imgTypes{:,1}]==info.tipoImgs;
        typeName = h.imgTypes{idxType,2};
        prefix = '<HTML><b>';
        sufix = '</b>';
        t = {[prefix ptrLgGetString('infoTrn_Name')   ': ' sufix info.descrip], ...
            [prefix ptrLgGetString('infoTrn_Method') ': ' sufix info.met_name], ...
            [prefix ptrLgGetString('infoTrn_Date')   ': ' sufix info.date], ...
            [prefix ptrLgGetString('infoTrn_Dir')    ': ' sufix ubi], '', ...
            [prefix '<u>' ptrLgGetString('infoTrn_Images') sufix], ...
            [prefix ptrLgGetString('infoTrn_Mod')    ': ' sufix typeName], ...
            [prefix ptrLgGetString('infoTrn_Number') ': ' sufix num2str(info.nImgs)], ...
            [prefix ptrLgGetString('infoTrn_OSize')  ': ' sufix num2str(info.tamaImgsOri)], ...
            [prefix ptrLgGetString('infoTrn_RSize')  ': ' sufix num2str(info.tamaImgsRed)], ...
            [prefix ptrLgGetString('infoTrn_IntTh')  ': ' sufix num2str(round(info.umbral)), ...
             ptrLgGetString('infoTrn_IntThSuf')]};
    end
    
    set (h.lsBoxInfo, 'String', t);
end


function selecItem (f)
    action = get (f, 'SelectionType');
    switch action
        case 'normal'
            updateTrnInfo(f);
        case 'open'
            returnSelection(f);
    end
end

function returnSelection (f)
    h = guidata(f);
    ls = get(h.lsBoxTrn,'String');
    if ~isempty(ls)
        set(f,'UserData',1);
        uiresume(f);
    end
end
    


              
