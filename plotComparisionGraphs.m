
prompt = 'press 1 for ctfs ,2 for weights , 3 for images ';
option = input(prompt,'s');
if isempty(option)
    option = '2';
end

switch option
    case '1'
        %--------------- ctfs--------------------
        y = (0:255);
        figure
        hold on
        subplot(2,2,1)
        plot(gRed, y, 'r-');
        xlabel('log Exposure X');
        ylabel('Pixel Value Z');
        
        subplot(2,2,2)
        plot(gGreen, y, 'g-');
        xlabel('log Exposure X');
        ylabel('Pixel Value Z');
        
        subplot(2,2,3)
        plot(gBlue, y, 'b-');
        xlabel('log Exposure X');
        ylabel('Pixel Value Z');
        
        subplot(2,2,4)
        plot(gLuminance, y, 'r-');
        xlabel('log Exposure X');
        ylabel('Pixel Value Z');
        hold off
        
        figure
        hold on
        plot(gRed, y, 'r-', gGreen,y , 'g-', gBlue, y, 'b-',gLuminance,y,'y-');
        xlabel('log Exposure X');
        ylabel('Pixel Value Z');
        hold off
        
        %------gluminance in double(pixels) ----------
        m2=double(linspace(0,1,256));
        figure
        hold on
        plot(transpose(m2),gLuminance,'r-');
        ylabel('log Exposure z');
        xlabel('Pixel Value x');
        hold off
        
        
    case '2'
        %---------------weights-----------------
              %------weight cam-----
        figure
        hold on
        m2=double(linspace(0,1,256));
        plot(transpose(m2),weights,'r-');
        hfline=refline(0,1);
        hfline.Color ='b';
        ylabel('cam weight w');
        xlabel('Pixel Value x');
        hold off
           
              %-------weight y--------
        figure
        hold on
        m2=double(linspace(0,1,256));
        plot(transpose(m2),weightY,'r-');
        hfline=refline(0,1);
        hfline.Color='b';
        ylabel('log Exposure z');
        xlabel('Pixel Value x');
        hold off
        
        
    case '3'
        %---------------images------------------
        figure
        subplot(1,2,1);
        imshow(ldrGlobal);
        title('Reinhard global operator');
        subplot(1,2,2);
        imshow(ldrLocal);
        title('Reinhard local operator');
        fprintf('Finished!\n');
        
        
    otherwise
        error(['Invalid option string -- ', option]);
end


