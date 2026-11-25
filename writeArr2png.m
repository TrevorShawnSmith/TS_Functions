function writeArr2png(arr, filename)
    %Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% writeArr2png(arr, filename)
% Use to write an 2D/3D array to an image stack. 
% If 3D, assume 3D is the iterator. 

arguments
    arr double
    filename = 'animatedGif'
end

sz_Z = size(arr,3); 

maxArr = max(arr,[],'all'); 
minArr = min(arr,[], 'all'); 
if minArr < 0 
    u_arr = int8(256/(maxArr-minArr)*(arr) ); %-minArr)); 
else
    u_arr = uint8(256/maxArr * arr);  
end

maxV = max(arr); 

fig = figure; 
for zz = 1:sz_Z
    imagesc(u_arr(:,:,zz)); 
    colormap parula; 
    if minArr > 0 
        clim([0, 255]);
    else
        clim([-128, 127]); 
        1; 
    end
    frame = getframe(fig); 
    im{zz} = frame2im(frame); 
end
close; 

[fdir] = uigetdir("", 'select output directory'); 


for zz = 1:sz_Z
    [A,map] = rgb2ind(im{zz}, 256); 
    ffilename = fullfile(fdir, strcat(filename, num2str(sprintf('%03d', zz)), '.png')); 
    imwrite(A,map,ffilename); 
end


end