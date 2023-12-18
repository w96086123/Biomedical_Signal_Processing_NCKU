run('eeg2.m')

a=[];
a=[a,[eegf3]];
a=[a,[eegf4]];
a=[a,[eegc3]];
a=[a,[eegc4]];
a=[a,[eegp3]];
a=[a,[eegp4]];
a=[a,[eego1]];
a=[a,[eego2]];
a=[a,[eegt3]];
a=[a,[eegt4]];

[coeff,score,latent,tsquared,explained,mu]=pca(a);

disp(coeff);
disp(explained);
temp = cov(score);
disp(temp);

figure
for i=1:10
    subplot(10,1,i);
    plot(t, score(:,i));
    axis tight;
    axis off;
    name="pc"+i;
    title(name);
end