%--egg
fs=44100;
t=0:1/fs:0.5;
e3_2=key(52, 2, fs); %表示2分音符的e3
a3_2=key(57, 2, fs);
c4_2=key(60, 2, fs);
e4_2=key(52, 2, fs);
g3_2=key(55, 2, fs);
d4_2=key(62, 2, fs);
e4_2=key(64, 2, fs);
g4_2=key(67, 2, fs);

e4_4=key(52, 4, fs);
g3_4=key(55, 4, fs);
a3_4=key(57, 4, fs);
b3_4=key(59, 4, fs);
c4_4=key(60, 4, fs);
d4_4=key(62, 4, fs);
e4_4=key(64, 4, fs);
f4_4=key(65, 4, fs);
g4_4=key(67, 4, fs);
a4_4=key(69, 4, fs);

e3_8=key(52, 8, fs);
g3_8=key(55, 8, fs);
a3_8=key(57, 8, fs);
b3_8=key(59, 8, fs);
c4_8=key(60, 8, fs);
d4_8=key(62, 8, fs);
e4_8=key(64, 8, fs);
f4_8=key(65, 8, fs);
g4_8=key(67, 8, fs);
a4_8=key(69, 8, fs);
b4_8=key(71, 8, fs);

part1=[c4_8 c4_8 c4_4 e4_4 d4_4 d4_8 d4_4 c4_4 c4_8];
part2=[d4_4 d4_4 c4_8 a3_8 a3_2];
part3=[b3_8 b3_8 b3_4 c4_8 d4_8 d4_4];
part4=[b3_4 a3_8 g3_4 e3_8 e3_2 e3_2];
part5=[e4_8 d4_8 e4_4 d4_8 d4_8 d4_4 d4_8 c4_8 c4_2 d4_4 a3_4 a3_8 a3_8 d4_8 c4_8 c4_2];
part6=[d4_4 a3_8 g3_4 g3_8 e3_2 e3_2];
part7=[g4_4 g4_8 d4_8 d4_4 e4_4 g4_4 g4_8 d4_8 d4_4 c4_4 a3_2 a3_2];
part8=[d4_4 d4_8 a3_8 a3_4 e4_4 d4_4 d4_8 c4_8 c4_4];
part9=[c4_8 c4_8 c4_4 g3_8 c4_8 c4_4 g4_4 f4_4 e4_4 d4_4 d4_8 c4_8 c4_2 c4_4];
part10=[c4_8 e4_8 g4_8 a4_4 g4_8 a4_4 g4_4 g4_8 a4_4];
para1=[part1 part2 part3 part4];
para2=[part5 part3 part6];
para3=[part7 part8 c4_4 g3_2 g3_2];
para4=[part7 part8 c4_8 d4_8 d4_2 d4_2];
para5=[part9 part10 g4_8 e4_8 e4_8 d4_4 e4_8 e4_2];
para6=[part9 part10 g4_4 e4_8 g4_4 g4_8 g4_2];
legend=[para1 para2 para3 para4 para5 para6];
sound(legend,fs)


