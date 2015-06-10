function BW=MyBwthin(bw)
se1=[0,0,0;0,1,0;1,1,1];
se2=[0,0,0;1,1,0;1,1,0];
se3=[1,0,0;1,1,0;1,0,0];
se4=[1,1,0;1,1,0;0,0,0];
se5=[1,1,1;0,1,0;0,0,0];
se6=[0,1,1;0,1,1;0,0,0];
se7=[0,0,1;0,1,1;0,0,1];
se8=[0,0,0;0,1,1;0,1,1];

SE1=[1,1,1;0,0,0;0,0,0];
SE2=[0,1,1;0,0,1;0,0,0];
SE3=[0,0,1;0,0,1;0,0,1];
SE4=[0,0,0;0,0,1;0,1,1];
SE5=[0,0,0;0,0,0;1,1,1];
SE6=[0,0,0;1,0,0;1,1,0];
SE7=[1,0,0;1,0,0;1,0,0];
SE8=[1,1,0;1,0,0;0,0,0];

bw_pre=bw;
while true
    bw_pos=bw_pre;
    temp=bwhitmiss(bw_pos,se1,SE1);
    bw_pos(find(temp==1))=0;
    temp=bwhitmiss(bw_pos,se2,SE2);
    bw_pos(find(temp==1))=0;
    temp=bwhitmiss(bw_pos,se3,SE3);
    bw_pos(find(temp==1))=0;
    temp=bwhitmiss(bw_pos,se4,SE4);
    bw_pos(find(temp==1))=0;
    temp=bwhitmiss(bw_pos,se5,SE5);
    bw_pos(find(temp==1))=0;
    temp=bwhitmiss(bw_pos,se6,SE6);
    bw_pos(find(temp==1))=0;
    temp=bwhitmiss(bw_pos,se7,SE7);
    bw_pos(find(temp==1))=0;
    temp=bwhitmiss(bw_pos,se8,SE8);
    bw_pos(find(temp==1))=0;
    if(isequal(bw_pos,bw_pre))
        break;
    end
    bw_pre=bw_pos;
end
BW=bw_pos;
end



