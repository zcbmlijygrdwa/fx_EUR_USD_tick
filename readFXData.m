clear all;
close all;

addpath('../matlabplugins')

yearIdx = 2015;
monthIdx = 6;


[sellRaw,buyRaw] = textread(['EURUSD-' num2str(yearIdx) '-' num2mon(monthIdx) '_converted.txt'],'%f %f');

% 
% size = 60*60*96;
% sellRaw = sellRaw(1:size);
% buyRaw = buyRaw(1:size);

distrCut_arm = 3.0

midRaw = (sellRaw+buyRaw)/2.0;
midRaw_d = midRaw;
midRaw_d(2:end) = midRaw_d(2:end) - midRaw_d(1:end-1);
midRaw_d(1) = 0;

midRaw_d50 = midRaw;
midRaw_d50(51:end) = midRaw_d50(51:end) - midRaw_d50(1:end-50);
midRaw_d50(1:50) = 0;

[m_midRaw_d,s_midRaw_d] = normfit(midRaw_d50);
ml2_arm_midRaw_d = m_midRaw_d-distrCut_arm*s_midRaw_d;
mr2_arm_midRaw_d = m_midRaw_d+distrCut_arm*s_midRaw_d;

bs_diff = buyRaw - sellRaw;
[diff_max,i] = max(bs_diff)



%---------------------------------
%big-event-seeker : seek for big event and follow the trend
%question: what will indicate big event is happening?
%1) small price-MA diff, no potential energy
%2) small buy-sell diff, both buyer and seller agree the trend
%3) hight change slop, fast price change, and keep high for a while(few seconds...)
windowWidth = 3600; % Whatever you want.
kernel = ones(windowWidth,1) / windowWidth;
processed = filter(kernel, 1, midRaw);

processed(1:windowWidth) = processed(windowWidth);

windowWidth = 2; % Whatever you want.
kernel2 = ones(windowWidth,1) / windowWidth;
midRaw_d = filter(kernel2, 1, midRaw_d);


price_ma_diff = midRaw - processed;

[m_price_ma_diff,s_price_ma_diff] = normfit(price_ma_diff);
ml2_arm_price_ma_diff = m_price_ma_diff-distrCut_arm*s_price_ma_diff;
mr2_arm_price_ma_diff = m_price_ma_diff+distrCut_arm*s_price_ma_diff;


[m_bs_diff,s_bs_diff] = normfit(bs_diff);
ml2_arm_bs_diff = m_bs_diff-distrCut_arm*s_bs_diff;
mr2_arm_bs_diff = m_bs_diff+distrCut_arm*s_bs_diff;
%processed2 = processed2*5+min(midRaw);
%---------------------------------
%close all
ax1 = subplot(4,1,1);
plot(sellRaw);
hold on
plot(buyRaw);
plot(processed)
%xlim([i-300,i+300])
hold off


ax2 = subplot(4,1,2);
hold on
plot(zeros(1,length(price_ma_diff)))
plot(price_ma_diff)
plot(ones(1,length(price_ma_diff))*ml2_arm_price_ma_diff,'k')
plot(ones(1,length(price_ma_diff))*mr2_arm_price_ma_diff,'k')
hold off
title('price-MA diff')

ax3 = subplot(4,1,3);
plot(bs_diff)
hold on
plot(ones(1,length(price_ma_diff))*ml2_arm_bs_diff,'k')
plot(ones(1,length(price_ma_diff))*mr2_arm_bs_diff,'k')
hold off
title('buy-sell diff')

ax4 = subplot(4,1,4);
plot(midRaw_d50)
hold on
plot(ones(1,length(price_ma_diff))*ml2_arm_midRaw_d,'k')
plot(ones(1,length(price_ma_diff))*mr2_arm_midRaw_d,'k')
hold off
title('buy-sell diff')
title('price slop')


linkaxes([ax1,ax2,ax3,ax4],'x');