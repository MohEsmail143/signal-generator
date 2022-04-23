clearvars;
close all;
clc;

disp('*Welcome to General Signal Generator*');
disp('Please input the following:');
f_s = input('Sampling frequency of signal: ');
timeStart = input('Start of time scale: ');
timeEnd = input('End of time scale: ');
while timeEnd < timeStart
    fprintf('Please enter number larger than %0.2f:\n', timeStart);
    timeEnd = input('End of time scale: ');
end
noOfBreakPoints = input('Number of break points: ');
breakPointPos=zeros(1,noOfBreakPoints);
for i=1:noOfBreakPoints
    fprintf('Break Point No.%d at t= ', i);
    breakPointPos(1,i) = input('');
end
timeDiv= [timeStart breakPointPos timeEnd];
timeDiv= sort(timeDiv);

y_tot=[];
for i=1:(noOfBreakPoints+1)
    fprintf('\nEnter the specifications of the signal at the region from t= %0.2f : %0.2f\n', timeDiv(1,i), timeDiv(1,i+1));
    fprintf('Choose signal type:\na.DC signal\nb.Ramp signal\nc.General order polynomial\nd.Exponential signal\ne.Sinusoidal signal\n\n');
    signalType=input('Signal type>> ','s');
    switch signalType
        case 'a'
            disp('*DC signal*');
            amp=input('Amplitude= ');
            y= amp.*ones(1,(timeDiv(1,i+1)-timeDiv(1,i))*f_s);
        case 'b'
            disp('*Ramp signal*');
            slope=input('Slope= ');
            intercept=input('Intercept= ');
            t= linspace(timeDiv(1,i), timeDiv(1,i+1), (timeDiv(1,i+1)-timeDiv(1,i))*f_s);
            y= slope.*t+intercept;
        case 'c'
            disp('*General order polynomial*');
            order= input('Order of polynomial= ');
            coeff= zeros(1,order+1);
            for j=1:order+1
                fprintf('Coeff. of x^%d= ', order-j+1);
                coeff(1,j)= input('');
            end
            t= linspace(timeDiv(1,i), timeDiv(1,i+1), (timeDiv(1,i+1)-timeDiv(1,i))*f_s);
            y= zeros(1,length(t));
            for j=1:length(t)
                y(1,j)= polyval(coeff,t(1,j));
            end
        case 'd'
            disp('*Exponential signal*');
            amp=input('Amplitude= ');
            expon=input('Exponent= ');
            t=linspace(timeDiv(1,i), timeDiv(1,i+1), (timeDiv(1,i+1)-timeDiv(1,i))*f_s);
            y= amp*exp(expon*t);
        case 'e'
            disp('*Sinusoidal signal*');
            amp=input('Amplitude= ');
            freq=input('Frequency= ');
            phase=input('Phase= ');
            t= linspace(timeDiv(1,i), timeDiv(1,i+1), (timeDiv(1,i+1)-timeDiv(1,i))*f_s);
            y= amp*sin(2*pi*freq*(t-phase));
    end
    y_tot= [y_tot y];
end

subplot(1,2,1);
t_tot= linspace(timeStart, timeEnd, length(y_tot));
plot(t_tot,y_tot);
xlabel('t');
ylabel('y_{original}(t)');
grid on;

t_new= t_tot;
y_new= y_tot;
fprintf('\nDo you want to perform any operation on the signal?\n');
fprintf('Choose operation type:\na.Amplitude scaling\nb.Time reversal\nc.Time shift\nd.Expanding the signal\ne.Compressing the signal\nf.None\n\n');
operationType=input('Operation type>> ','s');
while operationType~='f'
    switch operationType
        case 'a'
            disp('*Amplitude scaling*');
            ampFactor= input('Amplification factor= ');
            y_new= ampFactor * y_new;
            subplot(1,2,2);
            plot(t_new,y_new);
            xlabel('t');
            ylabel('y_{modified}(t)');
            grid on;
        case 'b'
            disp('*Time reversal*');
            t_new= fliplr(-t_new);
            y_new= fliplr(y_new);
            subplot(1,2,2);
            plot(t_new,y_new);
            xlabel('t');
            ylabel('y_{modified}(t)');
            grid on;
        case 'c'
            disp('*Time shift*');
            offset= input('Offset= ');
            t_new= t_new + offset;
            subplot(1,2,2);
            plot(t_new,y_new);
            xlabel('t');
            ylabel('y_{modified}(t)');
            grid on;
        case 'd'
            disp('*Expanding the signal*');
            expFactor= input('Expansion factor= ');
            t_new = t_new * expFactor;
            subplot(1,2,2);
            plot(t_new,y_new);
            xlabel('t');
            ylabel('y_{modified}(t)');
            grid on;
        case 'e'
            disp('*Compressing the signal*');
            compFactor= input('Compression factor= ');
            t_new = t_new * (1/compFactor);
            subplot(1,2,2);
            plot(t_new,y_new);
            xlabel('t');
            ylabel('y_{modified}(t)');
            grid on;
        case 'f'
            disp('*None*');
    end
    operationType=input('Operation type>> ','s');
end
