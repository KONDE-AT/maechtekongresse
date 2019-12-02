</(rs|note|persName|placeName|ref)>[\s\n\r]+([\.,]) >> </$1>$2
(</surname>)[\r\n\s]+(</persName>) >> $1$2
(</rs>)[\r\n\s]+(</rs>) >> $1$2
(</rs>)[\r\n\s]+(<note) >> $1$2
(>)[\r\n\s]+(</rs>) >> $1$2

cd data/editions/
perl -i -0777pe 's%</(rs|note|persName|placeName|ref)>\s+([\.,])%</$1>$2%gs;' *.xml 
perl -i -0777pe 's%(</surname>|</rs>)\s+(</persName>|</rs>|<note>)%$1$2%gs;' *.xml 
perl -i -0777pe 's%(>)\s+(</rs|.+Name>)%$1$2%gs;' *.xml 
perl -i -0777pe 's%(>)\s+([,\.])%$1$2%gs;' *.xml 

