clc; clear; close all
% Check for COM number connected to the arduino
% Check for the Baudrate of Arduino/Computer (also in Arduino coding)
s = serial('COM4','BaudRate', 9600, 'DataBits', 8, 'StopBits', 1); 

% open the arduino as if it were a file.
fopen(s);


figure
sensorMaxLine = line([0 1], [1 1]);
sensorMinLine = line([0 1], [-1 -1]);
sensorCurLine = line([0 1], [0 0]);
set(sensorMaxLine,'linestyle',':','color','r','linewidth',1);
set(sensorMinLine,'linestyle',':','color','b','linewidth',1);
set(sensorCurLine,'linestyle',':','color','k','linewidth',1);
sensorMinVal = [];
sensorMaxVal = [];
counter = 0;
while(1)
    counter = counter +1;
    serialData = fgetl(s);    
    if( (serialData(1) == 'q') && (counter > 1))
        fprintf('Serial port closed\n\n');
        break
    end
    sensorData = textscan(serialData,'sensor =  %d output = %d');
    
    if or (i == 1, isempty(sensorMinVal)) 
        sensorMinVal = sensorData{1};
        sensorMaxVal = sensorData{1};
        set(sensorMinLine, 'ydata', [sensorData{1} sensorData{1}] );
        set(sensorMaxLine, 'ydata', [sensorData{1} sensorData{1}] );
    end
    
    if (sensorData{1} > sensorMaxVal)
        sensorMaxVal = sensorData{1};
        set(sensorMaxLine, 'ydata', [sensorData{1} sensorData{1}] );
    end
    if (sensorData{1} < sensorMinVal)
        sensorMinVal = sensorData{1};
        set(sensorMinLine, 'ydata', [sensorData{1} sensorData{1}] );
    end
  
    set(sensorCurLine, 'ydata', [sensorData{1} sensorData{1}] );
    drawnow()
    axis([0 1 -10 1025])
    clc
    fprintf('[cur min max] - [%d %d %d]\n',sensorData{1}, sensorMinVal, sensorMaxVal);
    
end

fclose(s)