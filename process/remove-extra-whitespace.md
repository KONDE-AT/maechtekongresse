</(rs|note|persName|placeName|ref)>[\s\n\r]+([\.,]) >> </$1>$2
(</surname>)[\r\n\s]+(</persName>) >> $1$2
(</rs>)[\r\n\s]+(</rs>) >> $1$2
(</rs>)[\r\n\s]+(<note) >> $1$2
(>)[\r\n\s]+(</rs>) >> $1$2