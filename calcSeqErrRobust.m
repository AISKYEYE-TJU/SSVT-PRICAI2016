function [aveErrCoverage, aveErrCenter,errCoverage, errCenter] = calcSeqErrRobust(results, rect_anno)
index = rect_anno>0;
idx=(sum(index,2)==4);
seq_length = sum(idx);

rect_anno=rect_anno(idx,:);
results.res=results.res(idx,:);

centerGT = [rect_anno(:,1)+(rect_anno(:,3)-1)/2 rect_anno(:,2)+(rect_anno(:,4)-1)/2];

rectMat = zeros(seq_length, 4);
switch results.type
    case 'rect'
        rectMat = results.res;
    case 'ivtAff'
        for i = 1:seq_length
            [rect c] = calcRectCenter(results.tmplsize, results.res(i,:));
            rectMat(i,:) = rect;
            %                     center(i,:) = c;
        end
    case 'L1Aff'
        for i = 1:seq_length
            [rect c] = calcCenter_L1(results.res(i,:), results.tmplsize);
            rectMat(i,:) = rect;
        end
    case 'LK_Aff'
        for i = 1:seq_length
            [corner c] = getLKcorner(results.res(2*i-1:2*i,:), results.tmplsize);
            rectMat(i,:) = corner2rect(corner);
        end
    case '4corner'
        for i = 1:seq_length
            rectMat(i,:) = corner2rect(results.res(2*i-1:2*i,:));
        end
    case 'affine'
        for i = 1:seq_length
            rectMat(i,:) = corner2rect(results.res(2*i-1:2*i,:));
        end
    case 'SIMILARITY'
        for i = 1:seq_length
            warp_p = parameters_to_projective_matrix(results.type,results.res(i,:));
            [corner c] = getLKcorner(warp_p, results.tmplsize);
            rectMat(i,:) = corner2rect(corner);
        end
end

center = [rectMat(:,1)+(rectMat(:,3)-1)/2 rectMat(:,2)+(rectMat(:,4)-1)/2];
errCenter = sqrt(sum(((center(1:seq_length,:) - centerGT(1:seq_length,:)).^2),2));

tmp = calcRectInt(rectMat,rect_anno);

errCoverage = tmp;

aveErrCoverage = sum(errCoverage)/seq_length;

aveErrCenter = sum(errCenter)/seq_length;


