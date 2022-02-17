function [] = e1_drawResults(img_detected_refs, best_detected_refs, img_or)

leg_str = {'1','2','3','4','5','6','7','8','9','10'};
h = gobjects(min(10,size(img_detected_refs,1)),1);
colors = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1;...
    0 0 0; 1 1 1; 0.2 0.6 0.2; 0.6 0.2 0.2];
figure
imshow(img_or), hold on
for k = 1:min(10,size(img_detected_refs,1))
    h(k) = plot([img_detected_refs(k,1) img_detected_refs(k,3)],[img_detected_refs(k,2) img_detected_refs(k,4)],'Color',colors(k,:));
end
a = legend(h,leg_str{1:length(h)});
% a.FontSize = 16;
% set(gcf,'WindowStyle','normal','PaperPositionMode','auto','Color','w');

figure
imshow(img_or), hold on
plot([best_detected_refs(1) best_detected_refs(3)],[best_detected_refs(2) best_detected_refs(4)],'r');
set(gcf,'WindowStyle','normal','PaperPositionMode','auto','Color','w');
drawnow