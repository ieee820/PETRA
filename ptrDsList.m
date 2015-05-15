function ptrDsList (hMainWin)
    ptrData = guidata (hMainWin);

    pnPos = [0, ptrData.params.statusBarHeight, ...
             ptrData.params.mainWinSize(1), ...
             ptrData.params.mainWinSize(2) - ptrData.params.statusBarHeight];
                
    slAxesWidth = 150;
    slAxesHeight = 150;
    
    % Deletes the panel if already exists
    if isfield(ptrData.handles,'mainPanel') && ...
            isfield(ptrData.handles.mainPanel,'hPanel') && ...
            ishandle(ptrData.handles.mainPanel.hPanel)
        delete(ptrData.handles.mainPanel.hPanel);
    end
    
    % Creates main panel
    h.hPanel = uipanel('Parent', hMainWin, ...
            'Units','pixels', ...
            'Position', pnPos, ...
            'BorderType','none');
    bgColor = max(get(h.hPanel,'BackgroundColor') - [0.1 0.1 0.1], 0);
    set (h.hPanel,'BackgroundColor', bgColor);

    % If there are images loaded, creates the panel for images and slider
    nVols = 0;
    if isfield(ptrData,'images'), 
        nVols = numel(ptrData.images);
        volPanelWidth = slAxesWidth * 3 + 10 * 4;
        volPanelHeight = slAxesHeight + 10*4 + 18*2;
        volsPanelWidth = pnPos(3)-20;
        volsPanelHeight = 10+nVols*(volPanelHeight+10);
       
        h.volsPanel = uipanel('Parent', h.hPanel, ...
            'Units','pixels', ...
            'Position',[0 pnPos(4)-volsPanelHeight, ...
                        volsPanelWidth, volsPanelHeight], ...
            'HighlightColor',[0, 0, 0], ...
            'BackgroundColor', bgColor, ...
            'BorderType','none');
        
        h.volsPanelSlider = uicontrol(...
            'Parent', h.hPanel,...
            'Style', 'slider', ...
            'Units','pixels', ...
            'Position', [volsPanelWidth, 0, 20, pnPos(4)], ...
            'Callback', {'ptrCbList','mainSlider'}, ...
            'Enable','off', ...
            'Min', 0, ...
            'Max', 1, ...
            'SliderStep', [0.1 0.1], ...
            'Value', 1);
    end
    
    % For each image loaded
    for i=1:nVols
        posHeight = 10+(volPanelHeight+10)*(nVols-i);
                
        % Panel for an image
        h.volPanel(i).hPanel = uipanel (...
            'Parent', h.volsPanel, ...
            'Units','pixels', ...
            'Position', [(volsPanelWidth-volPanelWidth)/2, posHeight, ...
                         volPanelWidth, volPanelHeight], ...
            'BorderType','line');
        
        % Panel for an image info (name, class, etc)
        h.volPanel(i).infoPanel = uipanel (...
            'Parent', h.volPanel(i).hPanel, ...
            'Units','pixels', ...
            'Position', [0 volPanelHeight-55 volPanelWidth 55], ...
            'BorderType','line');
        
        % Txt for image number
        h.volPanel(i).nameTitTxt = uicontrol( ...
                'Parent', h.volPanel(i).infoPanel, ...
                'String', num2str(i), ...
                'Style','text', ...
                'Units','pixels', ...
                'Position',[5 30 20 18], ...
                'FontUnits','pixels', ...
                'FontName', 'Helvetica', ...
                'FontSize',12, ...
                'HorizontalAlignment','center');
            
        % Selection check box
        h.volPanel(i).selCheck = uicontrol( ...
                'Parent', h.volPanel(i).infoPanel, ...
                'Style', 'checkbox',...
                'Units', 'Pixels', ...
                'Position', [5 10 20 20], ...
                'Value', ptrData.images(i).selected, ...
                'Callback', {'ptrCbMainWindow','selectImg', i}, ...
                'String', '');
            
        % Txt for name title
        h.volPanel(i).nameTitTxt = uicontrol( ...
                'Parent', h.volPanel(i).infoPanel, ...
                'String',ptrLgGetString('listUI_NameTxt'), ...
                'Style','text', ...
                'Units','pixels', ...
                'Position',[30 30 200 18], ...
                'FontUnits','pixels', ...
                'FontName', 'Helvetica', ...
                'FontSize',12, ...
                'HorizontalAlignment','left');
                
        % Txt for name
        h.volPanel(i).nameTxt = uicontrol( ...
                'Parent', h.volPanel(i).infoPanel, ...
                'String', ptrData.images(i).fileName, ...
                'BackgroundColor',[1 1 1], ...
                'Style','text', ...
                'Units','pixels', ...
                'Position',[30 10 200 18], ...
                'FontUnits','pixels', ...
                'FontName', 'Helvetica', ...
                'FontSize',12, ...
                'HorizontalAlignment','left');
        
        % Txt for type title
        h.volPanel(i).typeTitTxt = uicontrol( ...
                'Parent', h.volPanel(i).infoPanel, ...
                'String',ptrLgGetString('listUI_TypeTxt'), ...
                'Style','text', ...
                'Units','pixels', ...
                'Position',[235 30 110 18], ...
                'FontUnits','pixels', ...
                'FontName', 'Helvetica', ...
                'FontSize',12, ...
                'HorizontalAlignment','left');
                
        % Txt for type
        h.volPanel(i).typeTxt = uicontrol( ...
                'Parent', h.volPanel(i).infoPanel, ...
                'String', ptrData.images(i).type, ...
                'BackgroundColor',[1 1 1], ...
                'Style','text', ...
                'Units','pixels', ...
                'Position',[235 10 110 18], ...
                'FontUnits','pixels', ...
                'FontName', 'Helvetica', ...
                'FontSize',12, ...
                'HorizontalAlignment','left');
        
        % Txt for class title
        h.volPanel(i).classTitTxt = uicontrol( ...
                'Parent', h.volPanel(i).infoPanel, ...
                'String',ptrLgGetString('listUI_ClassTxt'), ...
                'Style','text', ...
                'Units','pixels', ...
                'Position',[350 30 80 18], ...
                'FontUnits','pixels', ...
                'FontName', 'Helvetica', ...
                'FontSize',12, ...
                'HorizontalAlignment','left');
            
        % Txt for class
        h.volPanel(i).classTxt = uicontrol( ...
                'Parent', h.volPanel(i).infoPanel, ...
                'String', ptrData.images(i).class, ...
                'Style','text', ...
                'BackgroundColor',[1 1 1], ...
                'Units','pixels', ...
                'Position',[350 10 80 18], ...
                'FontUnits','pixels', ...
                'FontName', 'Helvetica', ...
                'FontSize',12, ...
                'HorizontalAlignment','left');


        % Classify button
        bgColor = get(h.volPanel(i).infoPanel,'BackgroundColor');
        h.volPanel(i).btnClassify = uicontrol( ...
                'Parent', h.volPanel(i).infoPanel, ...
                'Style', 'pushbutton',...
                'Units', 'Pixels', ...
                'Position', [440 10 40 40], ...
                'Callback', {'ptrCbMainWindow','imgClassify', i}, ...
                'TooltipString', ptrLgGetString('secuUI_ClassifyTip'), ...
                'CData', ptrLoadIcon(ptrData.params,'question',bgColor), ...
                'String', '');
            
        % For each slice ...
        volume = ptrData.images(i).volume;
        h.volPanel(i).sliceIdx = round(size(volume)/2);
        for j=1:3
            h.volPanel(i).slPanel(j) = uipanel (...
                'Parent', h.volPanel(i).hPanel, ...
                'Units','pixels', ...
                'Position', [10+(slAxesWidth+10)*(j-1), 10, ...
                             slAxesWidth, slAxesHeight], ...
                'BackgroundColor', ptrData.params.colormap(1,:), ...
                'HighlightColor',[0, 0, 0], ...
                'BorderType','none');

            posLeft = (volsPanelWidth-volPanelWidth)/2 + 10 + ...
                (slAxesWidth+10)*(j-1);
            h.volPanel(i).slAxes(j) = axes (...
                'Parent', h.volsPanel, ...
                'Units','pixels', ...
                'Visible','off',...
                'Position',[posLeft posHeight+10 slAxesWidth slAxesHeight], ...
                'Box','off');            
        end
    end

    % Scroll function
    set (ptrData.handles.win, 'WindowScrollWheelFcn', ...
        {'ptrCbList','scroll'});    
    
    ptrData.handles.mainPanel = h;
    guidata (hMainWin, ptrData);
    
    %Display slices
    for i=1:nVols, 
        ptrStatusBar(hMainWin,'updateProgress', i/nVols, '$main_CreatingUI');
        ptrCbList(hMainWin, [], 'drawSlices', i); 
    end
    ptrCbList(hMainWin, [], 'adjustSlider');
    
    % Disable image tools (tool bar)
    ptrPlotTools (ptrData.handles.toolbar.toolbar, [], 'enable', 'off');
    
    % Regenerate status bar
    delete (ptrData.handles.statusBar.statusBar)
    ptrStatusBar(ptrData.handles.win, 'create')    
end