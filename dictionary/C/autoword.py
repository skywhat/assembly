#!/usr/bin/python
import sys
import urllib2
from bs4 import BeautifulSoup

word=sys.argv[1]

wordlen=10
explainh=300
synonymh=10


f1=open('word.txt','a')
f2=open('meaning.txt','a')
f3=open('synonym.txt','a')
f4=open('antonym.txt','a')

length1=len(word)
if length1<wordlen:

    page=BeautifulSoup(urllib2.urlopen("http://iciba.com/%s" % word).read())

    meaning=page.select('h4[onclick="clickCountResult(37);"]')[0].string.strip('1.').encode('utf-8')


    
    length2=len(meaning)
    if length2<explainh:


        allword=page.select('html body div div div div div div div div ul dl dd a[class="explain"]')
        synonym=allword[0].string.encode('utf-8')
        antonym=allword[-1].string.encode('utf-8')
        length3=len(synonym)
        length4=len(antonym)
        if length3<wordlen and length4<wordlen:
            
            #word.txt
            
            f1.write(word)
            f1.write('$')
            additon1=wordlen-length1-1
            
            for i in range(additon1):
                f1.write('\0')

            
            
            #meaning.txt
            
            f2.write(meaning)
            f2.write('$')
            additon2=explainh-length2-1
            for i in range(additon2):
                f2.write('\0')

            #synonym.txt
            
            f3.write(synonym)
            f3.write('$')
            additon3=synonymh-length3-1
            for i in range(additon3):
			f3.write('\0')

            #antonym.txt

            f4.write(antonym)
            f4.write('$')
            additon4=synonymh-length4-1
            for i in range(additon4):
                f4.write('\0')
            f4.close()

        
f1.close()
f2.close()
f3.close()
f4.close()






