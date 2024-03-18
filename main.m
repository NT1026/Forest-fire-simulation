function simulator()
    clc;clear;
    global n;
    global frame;

    % 產生視窗跟一些文字方塊
    screensize = get(0,'ScreenSize');
    window = figure('Name','App','Position',[screensize(3)/2-500,screensize(4)/2-300,1000,600]...
        ,'MenuBar','none','Color','w','NumberTitle','off');  
    text1 = uicontrol(window,'Style','text','String','森林尺寸(n*n)'...
        ,'Position',[50,550,100,30],'BackgroundColor',[1 1 1],'FontSize',12);
    size = uicontrol(window,'Style','edit','String',''...
        ,'Position',[50,500,100,50]);
    text2 = uicontrol(window,'Style','text','String','森林密度(%)'...
        ,'Position',[200,550,100,30],'BackgroundColor',[1 1 1],'FontSize',12);
    density = uicontrol(window,'Style','edit','String',''...
        ,'Position',[200,500,100,50]);
    run = uicontrol(window,'Style','pushbutton', 'String','run'...
        ,'Position',[600,500,50,50],'Callback',@to_get_value1);
    
    function to_get_value1(~,~)
        % 產生n*n的隨機森林 (0:無樹木，1:有樹木，2:著火，5;牆壁)
        n = str2num(get(size,'String'));
        d = str2num(get(density,'String')) / 100;
        forest = zeros(n+2,n+2);
        set_forest = rand(n+2,n+2);
        forest(set_forest <= d) = 1;
        forest(set_forest > d) = 0;
        for i = 1:n+2
            forest(1,i) = 5;
            forest(n+2,i) = 5;
            forest(i,1) = 5;
            forest(i,n+2) = 5;
        end

        % 在森林一側點火
        for i = 2:n+1
            if forest(i,2) == 1
                forest(i,2) = 2;
            end
        end
        
        % 設置空的文字方塊，用來代表森林
        for i = 1:n+2
            for j = 1:n+2
                frame(i,j) = uicontrol(window,'Style','edit','BackgroundColor',[1 1 1], ...
                    'Position',[50+(i-1)*900/(n+2),40+(j-1)*400/(n+2),900/(n+2),400/(n+2)]);
            end
        end
        
        % 以一棵樹為中心，假如周圍"八棵樹"中有其中一棵被點燃，則此棵樹被點燃
        new_forest = zeros(n+2,n+2);
        while true
            pre_forest = forest;
            for j = n+1:-1:3
                for i = n+1:-1:2
                    if forest(i,j) == 1
                        if forest(i-1,j-1) == 2 || forest(i,j-1) == 2 || ...
                           forest(i+1,j-1) == 2 || forest(i-1,j) == 2 || forest(i+1,j) == 2 ||...
                           forest(i-1,j+1) == 2 || forest(i,j+1) == 2 || forest(i+1,j+1) == 2
                            forest(i,j) = 2;
                        end
                    end
                end
            end
            
            % 根據前面的演算法，幫森林上色
            for j = 1:n+2
                for i = 1:n+2
                    switch(forest(i,j))
                        case 0
                            set(frame(i,j),'BackgroundColor',[0.65 0.65 0.65]);
                        case 1
                            set(frame(i,j),'BackgroundColor','g');
                        case 2
                            set(frame(i,j),'BackgroundColor','r');
                        case 5
                            set(frame(i,j),'BackgroundColor',[0 0 0]);
                    end
                end
            end
            pause(0.25)

            new_forest = forest;
            if pre_forest == new_forest
                break
            end
        end
    end
end