function charstr=zjc_readchar(fid,n)
% Matlab 的 fread 会自动按编码方式读取，可能将一个汉字读成一个char；
% 按字节读取，并根据 C 语言的习惯，字符串截止到\00
		charstr='';
		tmpstr= fread(fid,n,'uint8');
		tmpstr= tmpstr';
		tmpind= find(tmpstr==0,1,'first');
		if tmpind>1
		charstr= (tmpstr(1:tmpind-1));
		end


