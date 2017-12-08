starting_depth = 36;
spacing = 1;
numb_of_label = 10;

for p = 1:5
    if p== 1
        pattern = '1x1';
    elseif p == 2
        pattern = '3x3';
    elseif p == 3
        pattern = '3x3cross';
    elseif p == 4
        pattern = 'triangle';
    else
        pattern = 'x';
    end

    root_dir = ['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\r\r_train234_ff\'];
    for i = 1:numb_of_label
        label_depth = (start_depth+(i-1)*spacing);
        folder = [root_dir int2str(label_depth) '\'];
        for j = 2:4
            folderr = [root_dir int2str(label_depth) '\' int2str(j) '\'];
            movefile([folderr '*.png'],folder);
            rmdir(folderr);
        end
    end

    root_dir = ['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\b\b_train234_ff\'];
    for i = 1:numb_of_label
        label_depth = (start_depth+(i-1)*spacing);
        folder = [root_dir int2str(label_depth) '\'];
        for j = 2:4
            folderr = [root_dir int2str(label_depth) '\' int2str(j) '\'];
            movefile([folderr '*.png'],folder);
            rmdir(folderr);
        end
    end
end
