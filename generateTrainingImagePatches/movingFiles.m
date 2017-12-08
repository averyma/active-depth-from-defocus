root_dir = 'F:\DfD\ScreenCap\20170811ScreenCap\r\r_train234_raw_415to500\';
starting_depth = 41.5;
spacing = 0.5;

for i = 1:18
    label_depth = (start_depth+(i-1)*spacing)*10;
    folder = [root_dir int2str(label_depth) '\'];
    for j = 2:4
        folderr = [root_dir int2str(label_depth) '\' int2str(j) '\'];
        movefile([folderr '*.png'],folder);
        rmdir(folderr);
    end
end

root_dir = 'F:\DfD\ScreenCap\20170811ScreenCap\b\b_train234_raw_415to500\';
for i = 1:18
    label_depth = (start_depth+(i-1)*spacing)*10;
    folder = [root_dir int2str(label_depth) '\'];
    for j = 2:4
        folderr = [root_dir int2str(label_depth) '\' int2str(j) '\'];
        movefile([folderr '*.png'],folder);
        rmdir(folderr);
    end
end