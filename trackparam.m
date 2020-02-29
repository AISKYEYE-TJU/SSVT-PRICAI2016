
switch (title)   
     case 'football'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,1,1]); 
     case 'car4'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,1,1]); 
     case 'car11'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,1,1]);   
     case 'davidgt'; 
        opt = struct('threhold',30, 'affsig',[0.005,0.0005,0.0005,0.005,1,1]);         
     case 'deer'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,6,6]);         
     case 'faceocc1'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,1,1]);         
     case 'faceocc2'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,1,1]);         
     case 'girl'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,3,3]);         
     case 'jumping'; 
        opt = struct('threhold',30, 'affsig',[0.005,0.0005,0.0005,0.005,10,10]);         
     case 'mountainBike'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,6,6]);         
     case 'shaking'; 
        opt = struct('threhold',30, 'affsig',[0.005,0.0005,0.0005,0.005,6,6]);         
     case 'singer1'; 
        opt = struct('threhold',40, 'affsig',[0.03,0.0005,0.0005,0.005,1,1]);         
     case 'Walking'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,4,4]);         
     case 'Walking2'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,4,4]);       
     case 'crossing'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,6,6]); 
     case 'stone'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,6,6]); 
     case 'trellis'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,6,6]); 
     case 'tiger1'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,6,6]);
     case 'motorRolling'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,6,6]);
     case 'coke'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,3,3]);
     case 'girl1'; 
        opt = struct('threhold',40, 'affsig',[0.005,0.0005,0.0005,0.005,3,3]);  
    otherwise;  error(['unknown title ' title]);
end

%%*****************************************************************%%
dataPath = [ 'Datasets\' title '\'];
