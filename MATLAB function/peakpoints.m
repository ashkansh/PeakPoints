function [cycle] = peakpoints(vector)
%peakpoints finds maximum and minimum points in a vector.
%   This code is developed to find peak points and number of cycles in
%   seismic analysis of structures. However, it can be used for any vector.
%  
% Ashkan Shahbazian, v1.1
% University of Coimbra

% peakdet function developed by Eli Billauer used in this code.
% http://www.billauer.co.il/peakdet.html

%%
% first define your vector, then use [cycle]=peakpoints(vector) in the command line;
% Example: import vector.txt to workspace and write peakpoints(vector)
%%
clear cycle;
delta=0.1; % by default
v = vector(:)'; % Just in case this wasn't a proper vector

figure (1);
subplot(2,1,1); plot(v,'-k');
axis square; xlabel('Inc #'); ylabel('Vector'); title('Finding peak points');
x = (1:length(v))';
maxtab=[]; mintab=[];
mn = Inf; mx = -Inf;
mnpos = NaN; mxpos = NaN;
lookformax=1;
for vi=1:1:length(v);
    value=v(vi);
    this=value;
if this > mx, mx = this; mxpos = x(vi); end
if this < mn, mn = this; mnpos = x(vi); end
  if lookformax
    if this < mx-delta
      maxtab = [maxtab ;mxpos mx];
      mn = this; mnpos = x(vi);
      lookformax = 0;
    end  
  else
    if this > mn+delta
      mintab = [mintab ; mnpos mn];
      mx = this; mxpos = x(vi);
      lookformax = 1;
    end
  end
end

for imin=1:1:length(mintab);
    cycle(mintab(imin,1),1)=mintab(imin,2);
end
for imax=1:1:length(maxtab);
    cycle(maxtab(imax,1),1)=maxtab(imax,2);
end
figure (1);
hold on; subplot(2,1,1); plot(mintab(:,1),mintab(:,2),'ro'); subplot(2,1,1); plot(maxtab(:,1),maxtab(:,2),'ro');
cycle(cycle==0) = [];
cycle=[0; cycle];
% cycle1=round(cycle);
figure (1);
subplot(2,1,2); plot(cycle,'-ro'); %figure (3); plot(cycle1,'--ko');
axis square; xlabel('cycle #'); ylabel('Vector'); title('cycle');
    
